#!/usr/bin/env ruby

# Resync subtitles

require_relative "srtfile"

require "optparse"

if __FILE__ == $0
    optparse = OptionParser.new do | opts |
        opts.banner = "Usage: #{$0} [OPTIONS] [SRTFILE] [SRTFILE] ..."
    end

    optparse.parse!

    ARGV.each do | path |
        SRTFile.new path
    end
end

exit 0

