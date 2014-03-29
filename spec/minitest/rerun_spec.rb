require "spec_helper"

describe Minitest::Rerun do
  def sh(command)
    Bundler.with_clean_env { `#{command}` }
  end

  def it_works!(kind)
    output = sh("bundle exec ruby #{kind}.rb").sub(Dir.pwd, '-PWD-')
    output.should include File.read("expected_#{kind}.txt")

    command = output[/^ruby .*/]
    sh("bundle exec #{command} 2>&1").should =~ /^1 (test|run)/
  end

  it "has a VERSION" do
    Minitest::Rerun::VERSION.should =~ /^[\.\da-z]+$/
  end

  versions = Dir["spec/fixtures/m*"].product ["test", "spec"]

  versions.each do |dir, kind|
    it "prints correct paths for #{dir} and #{kind}" do
      Dir.chdir(dir) { it_works!(kind) }
    end
  end

  it "uses current file when running 1 file to avoid invalid location parsing" do
    Dir.chdir "spec/fixtures/invalid_location" do
      it_works!("test")
    end
  end
end
