## ShowFeature ##

A library to find the relevant features in a tv show filename   
(e.g. [name].S[season]E[episode].hdtv-[team].avi)

# Usage

```ruby
require 'showfeature'
sf = ShowFeature::Processor.new('foo.125.x264-bar.mkv')
sf.parse
puts sf.to_hsh # prints {:name=>"foo", :season=>"01", :episode=>"05", :team=>"bar"}
```

**Author :** Allan Seymour  
**Version :** 0.1.2         
**Release Date :** December 06, 2012             
**Copyright :** MIT License        

