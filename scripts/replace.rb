require 'epath'

def replace(file, search, replace)
  c = Path(file).read
  rx = Regexp.new(search)
  if c =~ rx
    File.open(file, "w") do |io|
      io << c.gsub(rx, replace)
    end
  end
end


search, by = ARGV
Dir["**/*.rb"].each{|file| replace(file, search, by)}
Dir["**/*.yml"].each{|file| replace(file, search, by)}
Dir["**/*.gvm"].each{|file| replace(file, search, by)}
Dir["**/*.cmd"].each{|file| replace(file, search, by)}
Dir["**/*.stdout"].each{|file| replace(file, search, by)}
