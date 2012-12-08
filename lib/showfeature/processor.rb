$:.unshift File.join(File.dirname(__FILE__), '..')
require 'showfeature'
require 'mime/types'

module ShowFeature
  
  # The main processor class is in charge of the parsing of tv show filename
  class Processor
    
    attr_reader :name, :team, :episode, :season, :raw_name, :parsed
    
    # Pattern used for the parsing process
    PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
    
    ## 
    # Creates a new Processor instance for +raw_name+ parsing
    # 
    # An ArgumentError is raised if +raw_name+'s mime type does not
    # match the type of a video file
    def initialize(raw_name)
      raise ShowFeature::ArgumentError, "#{raw_name} does not match a video or subtitle file type" unless
        [:video_file_type?, :subtitles_file_type?].any? {|f| ShowFeature::Processor.send f,raw_name }
      @raw_name = raw_name
      @parsed = false
    end
    
    ##
    # Parses the tv show filename looking for relevant element
    def parse
      proc = Proc.new do |position, proc|
        tmp = @raw_name[PATTERN,position]
        tmp.nil? ? nil : proc.call(tmp)
      end
      @name = proc.call(1, lambda{|x| x.downcase.gsub('.',' ')})
      @season = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,1].to_i})
      @episode = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,2].to_i})
      @team = proc.call(3, lambda{|x| x.downcase})
      @parsed = true
    end

    ##
    # Checks if the tv show filename has already been parsed
    def parsed?
      @parsed
    end

    ##
    # Returns hash filled with all parsed element
    def to_hsh
      hash = Hash.new
      hash.merge!( { :name =>@name, 
                    :season => @season,
                    :episode => @episode,
                    :team => @team } ) unless [@name,@season,@episode, @team].all? {|x| x.eql?nil}
      hash
    end
    
    ##
    # Checks if +str+'s mime type matches a video file type
    def self.video_file_type?(str)
      MIME::Types.of(str).any? do |x| x.to_s =~/^video/ end
    end

    ##
    # Checks if the mime type of the current processed show matches a video file type
    def video_file_type?
      MIME::Types.of(@raw_name).any? do |x| x.to_s =~/^video/ end
    end
    
    ##
    # Checks if +str+'s mime type matches a subtitles file type
    def self.subtitles_file_type?(str)
      (str =~ /\.(srt|sub)$/) ? true : false
    end

    ##
    # Checks if the mime type of the current processed show matches a subtitles file type
    def subtitles_file_type?
      (@raw_name =~ /\.(srt|sub)$/) ? true : false
    end
    
    def replace(arg)
      raise ShowFeature::TypeError, 'argument must be of type String or Hash' unless 
        [String, Hash].any?{|type| arg.kind_of? type}
      raise ShowFeature::NotParsedError, 'showfeature cannot complete replace if show is not parsed' unless parsed?
      if arg.kind_of? String
        if video_file_type?
          @raw_name = arg if ShowFeature::Processor.video_file_type?(arg)
        elsif subtitle_file_type?
          @raw_name = arg if ShowFeature::Processor.subtitles_file_type?(arg)
        end
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
