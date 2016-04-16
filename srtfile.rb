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
        textblock = Array.new
        @contents.each do | line |
            line.chomp!

            # Read text blocks till newlines are found
            if line.empty?

                # Record text block as a subtitle
                subtitle = Subtitle.new textblock
                @subtitles.push subtitle unless subtitle.empty?

                # Prepare to read next block
                textblock = Array.new
            else

                # Continue reading text block
                textblock.push line
            end
        end
    end
end

