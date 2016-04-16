# A single subtitle dialog
class Subtitle

    # Global counter of subtitles
    @@count = 0

    # Initialize with no data
    def initialize block
        @@count += 1
        @index = @@count
        @contents = Array.new
        @contents += block
    end

    # Add a line to subtitle
    def add line
        @contents.push line
    end

    # Is this subtitle empty?
    def empty?
        return @contents.empty?
    end
end

