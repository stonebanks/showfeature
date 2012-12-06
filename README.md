# ShowFeature

A library to find the relevant features in a tv show filename   
(e.g. [name].S[season]E[episode].hdtv-[team].avi)

# Usage

### Example 1

```ruby
require 'showfeature'
sf = ShowFeature::Processor.new('foo.125.x264-bar.mkv')
sf.parse
puts sf.to_hsh # prints {:name=>"foo", :season=>"01", :episode=>"05", :team=>"bar"}
```

### Example 2

```ruby
require 'showfeature'
require 'fileutils'
include ShowFeature
def file_elements in_directory, to_directory = File.expand_path(".")
  FileUtils.chdir in_directory do 
    Dir.glob('*').each do |file|
      # if file is a video or a subtitles file
      if [:video_file_type?,:subtitles_file_type?].any?{|mth| Processor.send(mth,file)}
        sf = Processor.new (file)
        sf.parse
        unless sf.to_hsh.empty?
          # create a directory whose name is built with the name of the tv show
          show_dir = File.join to_directory, sf.name.gsub(' ','_'), sf.season
          FileUtils.mkdir_p show_dir unless Dir.exists? show_dir
          # mv 
          FileUtils.mv sf.raw_name, File.join(show_dir,sf.raw_name), :verbose => true
        end
      end
    end
  end
end

system "tree"

# Produces:
# .
# |-- foobar.101.x264-raboof.avi
# |-- foo.s01e01.hdtv-bar.mp4
# |-- foo.s01e02.hdtv-bar.mp4
# `-- foo.s01e02.hdtv-bar.srt
#
# 0 directories, 4 files

file_elements File.expand_path('~/Vidéos'), File.expand_path('~/Vidéos')

system "tree"

# Produces:
# .
# |-- foo
# |   `-- 01
# |       |-- foo.s01e01.hdtv-bar.mp4
# |       |-- foo.s01e02.hdtv-bar.mp4
# |       `-- foo.s01e02.hdtv-bar.srt
# `-- foobar
#     `-- 01
#         `-- foobar.101.x264-raboof.avi

# 4 directories, 4 files
```

**Author :** Allan Seymour  
**Version :** 0.1.2         
**Release Date :** December 06, 2012             
**Copyright :** MIT License        

