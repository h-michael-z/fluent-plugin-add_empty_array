$:.push File.expand_path('../lib', __FILE__)
require 'fluent/plugin/add_empty_array/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-add_empty_array"
  spec.version       = Fluent::ParseCookie::VERSION
  spec.authors       = ["Hirokazu Hata"]
  spec.email         = ["h.hata.ai.t@gmail.com"]
  spec.summary       = %q{Fluentd plugin to add empty array}
  spec.description   = %q{
                            We can't add record has nil value which target repeated mode column to google bigquery.
                            So this plugin add empty array if record has nil value or don't have key and value which target repeated mode column.
                          }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "timecop"
end
