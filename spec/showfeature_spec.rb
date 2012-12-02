$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/spec'
require 'minitest/autorun'
require 'showfeature'
require 'erb'

Output = Struct.new(:name, :episode, :season, :team, :raw_name)
#include ShowFeature
def create_a_show
  t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
  r = (Array.new(t)<<['(',')','.']).flatten
  output = Output.new
  output.name = (0..30).map{r.sample}.join
  output.team = (0..4).map {t.sample}.join
  nb = ERB.new (['s<%="%02d"%output.season %>e<%="%02d"%output.episode%>',
        '<%="%01d"%output.season %><%="%02d"%output.episode%>',
        '<%="%02d"%output.season %>x<%="%02d"%output.episode%>',
        '<%="%01d"%output.season %>X<%="%02d"%output.episode%>'].sample)
  output.season  = (1..99).map{|s| s}.sample.to_s
  output.episode = (1..99).map{|s| s}.sample.to_s
  output.raw_name = output.name+"."+ nb.result(binding) + ".hdtv-"+output.team+[".avi",".mp4",".mkv"].sample
  output
end




describe ShowFeature::Parser do
  before do
    @output = create_a_show
    @show = @output.raw_name
   end
 
  it "can be created with no arguments" do 
    ShowFeature::Parser.new.must_be_instance_of ShowFeature::Parser
  end

  it "can be created with a string argument" do 
    ShowFeature::Parser.new(@show).raw_name.must_equal @show
  end

  describe "when asked to be hashed" do 
    before do 
      @sf = ShowFeature::Parser.new(@show)
    end
    it "must returns an hash" do 
      @sf.parse
      @sf.to_hsh.must_be_instance_of Hash
    end
    it "must returns an empty hash if showfeature is not parsed yet" do
      @sf.to_hsh.must_be_empty
    end
  end
 
  describe "when asked to parse the show name" do 
    before do 
      @sf = ShowFeature::Parser.new(@show)
      @sf.parse
    end
    it "must retrieve the element" do 
      assert_block do 
        [:name, :episode, :team, :raw_name].
          all? {|stuff| 
          @output.send(stuff).eql? @sf.send(stuff).gsub(' ','.')
        }
        @output.season.to_i.must_equal @sf.season.to_i
      end
    end
  end

  describe "when asked if parsed" do
    before do
      @sf = ShowFeature::Parser.new(@show)
    end
    it "must return true if parsed" do
      @sf.parsed?.wont_equal true
      @sf.parse
      @sf.parsed?.must_equal true
    end
  end

  describe "when asked to replace an element" do 
    before do 
      @sf = ShowFeature::Parser.new(@show)
    end
    it "must replace raw_name by default when a string is passed" do 
      @sf.parse
      @sf.replace("foo.s01e01.hdtv-bar.mp4")
      @sf.raw_name.must_equal "foo.s01e01.hdtv-bar.mp4"
    end
    it "must replace the wanted attributes" do 
      @sf.parse
      @sf.replace(name: "foo", season: '01', episode: 1, team: "bar")
      @sf.raw_name.must_match /foo.*01.?01.*bar/
    end
    it "must raised if not parsed yet" do 
      result = lambda{ @sf.replace(:name => "foo")}
      result.must_raise ShowFeature::NotParsedError
      error = result.call rescue $!
      error.message.must_equal 'showfeature cannot complete replace if show is not parsed'
    end
    it "must raised if the given argument is not of type String or Hash" do
      result = lambda{ @sf.replace([])}
      result.must_raise ShowFeature::TypeError
      error = result.call rescue $!
      error.message.must_equal 'argument must be of type String or Hash'
    end
  end
 
  describe "when asked if it is a video file" do
    before do 
      @sf = ShowFeature::Parser.new(@show)
    end
    it "must be true or false" do 
      assert_block do 
        [TrueClass,FalseClass].any? {|elt| @sf.video_file?.instance_of? elt}
      end
    end
  end

end
