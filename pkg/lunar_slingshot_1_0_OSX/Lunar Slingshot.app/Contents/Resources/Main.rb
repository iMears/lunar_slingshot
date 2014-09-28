# This is a workaround since the .app does not run rubygems properly.
GEM_REQUIRE_PATHS = ["bundler-1.7.3/lib", "gosu-0.8.3//Users/max/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/extensions/x86_64-darwin-13/2.1.0-static/gosu-0.8.3", "gosu-0.8.3/lib"]

GEM_REQUIRE_PATHS.each do |path|
  $LOAD_PATH.unshift File.expand_path(File.join("../vendor/gems", path), __FILE__)
end

# Directory the .app is inside.
OSX_EXECUTABLE_FOLDER = File.expand_path("../../..", __FILE__)

# Really hacky fudge-fix for something oddly missing in the .app.
class Encoding
  BINARY = UTF_8 = UTF_7 = UTF_16BE = UTF_16LE = UTF_32BE = UTF_32LE = US_ASCII = Encoding.list.first
end

Dir.chdir 'application'
load 'lunar_slingshot.rb'
