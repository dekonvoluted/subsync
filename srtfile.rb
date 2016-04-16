# SRT file containing subtitles
class SRTFile

    # Initialize with file path
    def initialize filePath
        raise ArgumentError, "File not found: #{filePath}" unless File.readable? filePath

        @path = File.realpath filePath
    end
end

