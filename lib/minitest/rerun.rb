require "minitest/rerun/version"

module Minitest::Rerun
  class << self
    def rerun_command(msg)
      info = msg.to_s.split("\n")[1]
      location = info[/ \[(.*?):\d+\]:/]
      name = info.sub(location, "")
      "ruby #{test_file($1)} -n '#{name}'"
    end

    private

    def test_file(location)
      tests_run = $0.split(" ").select { |f| File.exist?(f) }
      location = tests_run.first if tests_run.size == 1
      location.sub(/^\.\//, "").sub("#{Dir.pwd}/", "")
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
