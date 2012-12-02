$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

module ShowFeature
  TypeError = Class.new (TypeError)
  NotParsedError = Class.new (StandardError)
end
