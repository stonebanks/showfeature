require File.expand_path('../lib/showfeature/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = "showfeature"
  spec.summary = "Find distinguishable features of a downloaded tv show filename (name,episode,season...)"
  spec.author = "Allan Seymour"
  spec.require_paths = ['lib']
  spec.files = `git ls-files`
end
