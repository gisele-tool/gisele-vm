$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gisele-vm'
require_relative 'fixtures/vm'
require_relative 'fixtures/ts'

def capture_io
  stdout, stderr = $stdout, $stderr
  $stdout, $stderr = StringIO.new, StringIO.new
  yield
  [$stdout.string, $stderr.string]
ensure
  $stdout, $stderr = stdout, stderr
end

def fixtures_path
  Path.dir/:fixtures
end
