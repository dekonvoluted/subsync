require_relative "subtitle"

# SRT file containing subtitles
class SRTFile

    # Initialize with file path
    def initialize filePath
        raise ArgumentError, "File not found: #{filePath}" unless File.readable? filePath

        @path = File.realpath filePath

        # Read the contents
        @contents = Array.new
        File.open @path do | file |
            @contents = file.readlines
        end

        # Parse the contents
        @subtitles = Array.new
        subtitle = Subtitle.new
        @contents.each do | line |
            if line.empty?
                @subtitles.push subtitle unless subtitle.empty?
            end

            subtitle.add line
        end
    end
end

