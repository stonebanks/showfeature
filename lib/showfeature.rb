module ShowFeature
  ROOT = File.expand_path(File.dirname(__FILE__))
  Dir.glob(File.join(ROOT, "showfeature",'*.rb')).
    each  do |file|
    require file
  end
end
