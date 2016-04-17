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

        validate
    end

    # Add a line to subtitle
    def add line
        @contents.push line

        validate
    end

    # Verify the block is a subtitle block
    def validate

        # Empty block is valid
        return if @contents.empty?

        # First line should be an input index
        @inputIndex = @contents.at( 0 ).to_i
        raise ArgumentError, "Invalid index: #{@contents.at 0}" unless @inputIndex.to_s == @contents.at( 0 )
        return if @contents.size == 1

        # Second line should be a time code
        timeCode = @contents.at( 1 ).scan( /^(\d+):(\d+):(\d{2}),(\d{3}) --> (\d+):(\d+):(\d{2}),(\d{3})$/ )
        raise ArgumentError, "Invalid timecode: #{@contents.at 1}" unless timeCode.size == 1
        timeCode = timeCode.at 0
        raise ArgumentError, "Invalid timecode: #{@contents.at 1}" unless timeCode.size == 8
        @startTime = Time.new( 0, 1, 1, timeCode.at( 0 ).to_i, timeCode.at( 1 ).to_i, timeCode.at( 2 ).to_f + ( 0.001 * timeCode.at( 3 ).to_f ) )
        @endTime = Time.new( 0, 1, 1, timeCode.at( 4 ).to_i, timeCode.at( 5 ).to_i, timeCode.at( 6 ).to_f + ( 0.001 * timeCode.at( 7 ).to_f ) )
        return if @contents.size == 2

        # Remaining lines are plain text
        @dialog = @contents[ 2..-1 ]
    end

    # Is this subtitle empty?
    def empty?
        return @contents.empty?
    end
end

