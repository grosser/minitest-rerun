require "minitest/rerun/version"

module Minitest::Rerun
  class << self
    ASCII_COLORS = {:red => 31, :cyan => 36}

    def rerun_command(msg)
      info = msg.to_s.split("\n")[1]
      location_part = info[/ \[((.*?):\d+)\]:/]
      location = $1
      file = $2
      if location
        name = info.sub(location_part, "")
        colorize(:red, "ruby #{test_file(file)} -n '#{name}' ") + colorize(:cyan, "# #{relativize(location)}")
      end
    end

    private

    def colorize(color, string)
      if $stdout.tty?
        "\e[#{ASCII_COLORS[color]}m#{string}\e[0m"
      else
        string
      end
    end

    def relativize(location)
      location.sub(/^\.\//, "").sub("#{Dir.pwd}/", "")
    end

    def test_file(location)
      tests_run = $0.split(" ").select { |f| File.exist?(f) }
      location = tests_run.first if tests_run.size == 1
      relativize(location)
    end
  end

  module M4
    def status(*args)
      if report.any?
        rerun = report.map { |msg| Minitest::Rerun.rerun_command(msg) }
        puts rerun
        puts
      end
      super
    end
  end

  module M5
    def summary(*args)
      failed = results.reject { |r| r.skipped? && !options[:verbose] }

      if failed.any?
        rerun = failed.map { |msg| Minitest::Rerun.rerun_command(msg) }
        rerun.join("\n") + "\n\n" + super
      else
        super
      end
    end
  end
end

if defined?(MiniTest::Unit::VERSION) && MiniTest::Unit::VERSION < "5.0"
  MiniTest::Unit.send(:prepend, Minitest::Rerun::M4)
else
  Minitest::SummaryReporter.send(:prepend, Minitest::Rerun::M5)
end
