#!/usr/bin/env ruby

# Resync subtitles

require_relative "srtfile"

require "fileutils"
require "optparse"

options = Hash.new
options[ :delay ] = 0.0
options[ :stretch ] = 1.0
options[ :originalSuffix ] = "old"

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

        opts.on( "-o SUFFIX", "--original SUFFIX", "Suffix to name original file(s)" ) do | suffix |
            options[ :originalSuffix ] = suffix
        end
    end

    optparse.parse!

    ARGV.each do | path |
        srtFile = SRTFile.new path
        srtFile.delay options[ :delay ]
        srtFile.stretch options[ :stretch ]
        FileUtils.move path, "#{File.basename path, ".srt"}-#{options[ :originalSuffix ]}.srt"
        srtFile.write path
    end
end

exit 0

