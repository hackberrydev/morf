require_relative "lib/morf/version"

Gem::Specification.new do |spec|
  spec.name          = "morf"
  spec.version       = Morf::VERSION
  spec.authors       = ["Nebojsa Stricevic"]
  spec.email         = ["strika@hackberry.dev"]

  spec.summary       = "An experiment in morphogenesis"
  spec.description   = "An experiment in morphogenesis."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir['lib/**/*.rb']
  end

  spec.required_ruby_version = ">= 2.5"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 5.0"
end
