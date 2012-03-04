$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-vm'
require_relative 'fixtures/vm'

def capture_io
  stdout, stderr = $stdout, $stderr
  $stdout, $stderr = StringIO.new, StringIO.new
  yield
  [$stdout.string, $stderr.string]
ensure
  $stdout, $stderr = stdout, stderr
end

def fixtures
  Path.dir/:fixtures
end

def measure
  t1 = Time.now
  yield
  t2 = Time.now
  puts "It took #{(t2-t1)} ms."
end
