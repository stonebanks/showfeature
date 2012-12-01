$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'minitest/spec'
require 'minitest/autorun'
require 'showfeature'
require 'erb'

def create_a_show
  t = ([('a'..'z'),(0..9)].map{|i| i.to_a}).flatten
  r = (Array.new(t)<<['(',')','.']).flatten
  name = (0..30).map{r.sample}.join
  team = (0..4).map {t.sample}.join
  nb = ERB.new (['s<%="%02d"%season %>e<%="%02d"%episode%>',
        '<%="%01d"%season %><%="%02d"%episode%>',
        '<%="%02d"%season %>x<%="%02d"%episode%>',
        '<%="%01d"%season %>X<%="%02d"%episode%>'].sample)
  season  = (1..99).map{|s| s}.sample
  episode = (1..99).map{|s| s}.sample
  show = name+"."+ nb.result(binding) + ".hdtv-"+team+[".avi",".mp4",".mkv"].sample
  show
end

describe ShowFeature do
  before do 
    @show = create_a_show
   end
 
  it "can be created with no arguments" do 
    ShowFeature.new.must_be_instance_of ShowFeature
  end

  it "can be created with a string argument" do 
    ShowFeature.new(@show).raw_name.must_equal @show
  end

  describe "when asked to be hashed" do 
    before do 
      @sf = ShowFeature.new(@show)
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
      @sf = ShowFeature.new(@show)
      @sf.parse
    end
    it "must retrieve the element" do 
      #assert_block do 
        [:name, :team].
          each {|stuff| 
                  @show.sub(@sf.send(stuff).gsub(' ','.'),'')
                }
      end
    end
  end

  describe "when asked to replace an element" do 
    before do 
      @sf = ShowFeature.new(@show)
    end
    it "must replace raw_name by default when a string is passed" do 
      @sf.parse
      @sf.replace("foo.s01e01.hdtv-bar.mp4").raw_name.must_equal "foo.s01e01.hdtv-bar.mp4"
    end
    it "must replace the wanted attributes" do 
      @sf.parse
      @sf.replace(name: "foo", season: '01', episode: 1, team: "bar").raw_name.must_match /foo.*01.?01.*bar/
    end
    it "must raised if not parsed yet" do 
      @sf.replace(:name => "foo").must_raise ShowFeature::NotParsedError
    end
    it "must raised if the given argument is not of type String or Hash" do
      @sf.replace([]).must_raise ShowFeature::TypeError
    end
  end
 
  describe "when asked if it is a video file" do
    before do 
      @sf = ShowFeature.new(@show)
    end
    it "must be true or false" do 
      assert_block do 
        [TrueClass,FalseClass].any? {|elt| @sf.video_file?.instance_of? elt}
      end
    end
  end

end
