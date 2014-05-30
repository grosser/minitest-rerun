require "minitest/rerun/version"

module Minitest::Rerun
  class << self
    ASCII_COLORS = {:red => 31, :cyan => 36}

    def rerun_command(msg)
      info = msg.to_s.split("\n")[1]
      location_part = info[/ \[((.*?):\d+)\]:/]
      location = $1
      file = $2
      name = if location_part
        info.sub(location_part, "")
      else
        info.sub(/:$/, "")
      end

      # in minitest 5 we know file/line even for errors
      if !location && msg.respond_to?(:name)
        method = msg.method(msg.name)
        file, line = method.source_location
        location = "#{file}:#{line}"
      end

      file = test_file(file)
      line = colorize(:red, "ruby #{file || "unknown"} -n '#{name.gsub(%{'}, %{'"'"'})}' ")
      line << colorize(:cyan, "# #{relativize(location)}") if location
      line
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
      relativize(location) if location
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
