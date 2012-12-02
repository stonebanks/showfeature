$:.unshift File.join(File.dirname(__FILE__), '..')
require 'showfeature'
require 'mime/types'

module ShowFeature
  
  # The parser class is the one in charge of 
  class Parser
    #attr_accessor
    attr_reader :id, :name, :team, :episode, :season, :raw_name, :parsed

    PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
    
    
    def initialize(str = "")
      @raw_name = str
      @parsed = false
    end
    
    def parse
      proc = Proc.new do |position, proc|
        tmp = @raw_name[PATTERN,position]
        tmp.nil? ? nil : proc.call(tmp)
      end
      @name = proc.call(1, lambda{|x| x.downcase.tr_s('.',' ')})
      @season = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,1].to_i})
      @episode = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,2].to_i})
      @team = proc.call(3, lambda{|x| x.downcase})
      @parsed = true
    end

    def parsed?
      @parsed
    end

    def to_hsh
      hash = Hash.new
      hash.merge( { :name =>@name, 
                    :season => @season,
                    :episode => @episode,
                    :team => @team } ) unless [@name,@season,@episode, @team].all? {|x| x.eql?nil}
      hash
    end
    
    def video_file?
      MIME::Types.of(@raw_name).any? do |x| x.to_s =~/^video/ end
    end
    
    def replace(arg)
      raise ShowFeature::TypeError, 'argument must be of type String or Hash' unless 
        [String, Hash].any?{|type| arg.kind_of? type}
      raise ShowFeature::NotParsedError, 'showfeature cannot complete replace if show is not parsed' unless parsed?
      if arg.kind_of? String
        @raw_name = arg
      else
        hash = {
          :name =>@name, 
          :season => @season, 
          :episode => @episode, 
          :team => @team }.merge(arg) {|k,v1,v2| k.eql?(:episode) ? "%02d"%v2 : v2}
        hash.each do |key, value|
          @raw_name.sub! self.send("#{key}").gsub(' ','.'), value
          instance_variable_set("@#{key}", value)
        end
      end
    end
  end
end
