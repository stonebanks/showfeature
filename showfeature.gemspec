require File.expand_path('../lib/showfeature/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = "showfeature"
  spec.version= ShowFeature::VERSION
  spec.summary = 'This library allows to find the relevant features in a tv show filename (e.g. [name].S[season]E[episode].hdtv-[team].avi)'
  spec.description = "This library allows to find the relevant features in a tv show filename (e.g. [name].S[season]E[episode].hdtv-[team].avi)"
  spec.homepage = "https://github.com/stonebanks/showfeature/"
  spec.author = "Allan Seymour"
  spec.email = "banks.the.megalithic.stone@gmail.com"
  spec.require_paths = ['lib']
  spec.files = `git ls-files`.split("\n")
  spec.required_ruby_version = '>= 1.9.1'
  spec.test_files = `git ls-files -- spec `.split("\n")
  spec.license = 'MIT'
  spec.has_rdoc = true
end
