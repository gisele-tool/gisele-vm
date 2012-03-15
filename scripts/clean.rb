require 'epath'
Path.pwd.glob("**/.DS_Store").each do |f|
  f.unlink
end
