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

        # Chomp each content line
        @contents.map! &:chomp

        # Drop leading BOM for UTF-8 files
        @contents[ 0 ].gsub! /^\xef\xbb\xbf/, ''

        # Parse the contents
        @subtitles = Array.new
        textblock = Array.new
        @contents.each do | line |

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

    # Delay subtitles by step
    def delay milliseconds

        # Do nothing with zero delay
        return if milliseconds == 0.0

        # Apply delay to all subtitles
        @subtitles.each do | subtitle |
            subtitle.delay milliseconds
        end
    end

    # Stretch subtitles by factor
    def stretch scale

        # Do nothing with unity stretch
        return if scale == 1.0

        # Avoid invalid stretch factors
        raise ArgumentError, "Stretch factor must be positive" if scale <= 0.0

        # Apply stretch to all subtitles
        @subtitles.each do | subtitle |
            subtitle.stretch scale
        end
    end

    # Write out subtitles
    def dump filePath

        # Write each subtitle
        File.open( filePath, 'w' ) do | file |
            @subtitles.each do | subtitle |
                file.puts subtitle
                file.puts
            end
        end
    end
end

