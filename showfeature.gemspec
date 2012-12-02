require File.expand_path('../lib/showfeature/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = "showfeature"
  spec.version= ShowFeature::VERSION
  spec.summary = "Find distinguishable features in a tv show filename as it was downloaded (e.g. <name>.S<season>E<episode>.hdtv-<team>.avi)"
  spec.author = "Allan Seymour"
  sepc.email = "banks.the.megalithic.stone@gmail.com"
  spec.require_paths = ['lib']
  spec.files = `git ls-files`
  spec.required_ruby_version = '>= 1.9.1'
end
