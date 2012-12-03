## ShowFeature ##

A library to find distinguishable features in a tv show filename as it
was downloaded   
(e.g. [name].S[season]E[episode].hdtv-[team].avi)

# Usage

```ruby
require 'showfeature'
sf = ShowFeature::Processor.new('foo.125.x264-bar.mkv')
sf.parse
puts sf.to_hsh
```

**Author :** Allan Seymour  
**Version :** 0.0.1         
**Release Date :** December 03, 2012             
**Copyright :** MIT License        

