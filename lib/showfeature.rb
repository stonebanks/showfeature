# This file is part of Subito.

# Subito is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Subito is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Subito.  If not, see <http://www.gnu.org/licenses/>.

$:.unshift File.join(File.dirname(__FILE__), '..')
#require 'showfeature'

#module ShowFeature
# An instance of this class contains the default elements featuring a show
# His name, season, episode, team and id
#
# @since 0.2.0
class ShowFeature
  #attr_accessor
  attr_accessor :id, :name, :team, :episode, :season, :raw_name
  PATTERN = /(^[\w\.\(\)]+)\.(\d{3}|s?\d{1,2}[ex]?\d{2})\..*-(.*)\.[\d\w]{3}$/i
  
  
  def initialize(str = "")
    self.raw_name = str
  end
  
  def parse
    proc = Proc.new do |position, proc|
      tmp = self.raw_name[PATTERN,position]
      tmp.nil? ? nil : proc.call(tmp)
    end
    self.name = proc.call(1, lambda{|x| x.downcase.tr_s('.',' ')})
    self.season = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,1].to_i})
    self.episode = proc.call(2, lambda{|x| "%02d" % x[/(\d+).?(\d{2}$)/,2].to_i})
    self.team = proc.call(3, lambda{|x| x.downcase})
  end

  def to_hsh
    hash = Hash.new
    hash.merge( { :name =>self.name, 
                  :season => self.season,
                  :episode => self.episode,
                  :team => self.team } ) unless [self.name,self.season,self.episode, self.team].all? {|x| x.eql?nil}
    hash
  end
  
  def video_file?
    MIME::Types.of(self.raw_name).any? do |x| x.to_s =~/^video/ end
  end
  
  def replace(arg)
    begin
      if arg.kind_of? String
        self.raw_name = arg
      else
        hash = {:name =>nil, :season => nil, :episode => nil, :team => nil }.merge(arg)
        hash.keys.each do |key|
          self.raw_name.sub(self.send("#{key}"), hash[key])
          self.send("#{key}=",hash[key])
        end
      end
    rescue TypeError
      raise ShowFeature::TypeError
    end
  end
end
#end
