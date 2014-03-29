name = "minitest-rerun"
require "./lib/#{name.gsub("-","/")}/version"

Gem::Specification.new name, Minitest::Rerun::VERSION do |s|
  s.summary = "Print copy pasteable rerun snippets after failed runs"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.license = "MIT"
  s.add_runtime_dependency "minitest"
  s.required_ruby_version = '>= 2.0.0'
  cert = File.expand_path("~/.ssh/gem-private-key-grosser.pem")
  if File.exist?(cert)
    s.signing_key = cert
    s.cert_chain = ["gem-public_cert.pem"]
  end
end
