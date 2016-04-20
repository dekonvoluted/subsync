#!/usr/bin/env ruby

# Resync subtitles

require_relative "srtfile"

require "optparse"

options = Hash.new
options[ :delay ] = 0.0
options[ :stretch ] = 1.0

ARGV.push "-h" if ARGV.empty?

if __FILE__ == $0
    optparse = OptionParser.new do | opts |
        opts.banner = "Usage: #{$0} [OPTIONS] [SRTFILE] [SRTFILE] ..."

        opts.on( "-d DELAY", "--delay DELAY", "Delay subtitles by DELAY ms" ) do | value |
            options[ :delay ] = value.to_f
        end

        opts.on( "-s FACTOR", "--stretch FACTOR", "Stretch subtitles by FACTOR" ) do | value |
            options[ :stretch ] = value.to_f
        end
    end

    optparse.parse!

    ARGV.each do | path |
        SRTFile.new path
    end
end

exit 0

