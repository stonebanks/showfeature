require File.expand_path('../lib/showfeature/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = "showfeature"
  spec.version= ShowFeature::VERSION
  spec.summary = "Find distinguishable features in a tv show filename as it was downloaded (e.g. <name>.S<season>E<episode>.hdtv-<team>.avi)"
  spec.author = "Allan Seymour"
  spec.require_paths = ['lib']
  spec.files = `git ls-files`
end
