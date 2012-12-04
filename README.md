## ShowFeature ##

A library to find distinguishable features in a tv show filename as it
was downloaded   
(e.g. [name].S[season]E[episode].hdtv-[team].avi)

# Usage

```ruby
require 'showfeature'
sf = ShowFeature::Processor.new('foo.125.x264-bar.mkv')
sf.parse
puts sf.to_hsh # prints {:name=>"foo", :season=>"01", :episode=>"05", :team=>"bar"}
```

**Author :** Allan Seymour  
**Version :** 0.1.1         
**Release Date :** December 04, 2012             
**Copyright :** MIT License        

