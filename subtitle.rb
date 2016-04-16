# A single subtitle dialog
class Subtitle

    # Global counter of subtitles
    @@order = 0

    # Initialize with no data
    def initialize
        @@order += 1
        @order = @@order
        @contents = Array.new
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

