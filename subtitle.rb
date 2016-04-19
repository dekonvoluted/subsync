# A single subtitle dialog
class Subtitle

    # Index can be rewritten directly
    attr_accessor :index

    # Time codes can be read
    attr_reader :start
    attr_reader :stop

    # Initialize subtitle with text block
    def initialize textblock

        # No newlines allowed
        return if textblock.any? &:empty?

        # Read index from the first line
        @index = textblock.at( 0 ).to_i
        raise ArgumentError, "Invalid index: #{textblock.at 0}" unless @index.to_s == textblock.at( 0 )

        # Read time code from second line
        timeCodeLine = textblock.at( 1 ).scan /^(.*) --> (.*)$/
        raise ArgumentError, "Invalid timecode: #{textblock.at 1}" unless timeCodeLine.size == 1

        startTimeCode, stopTimeCode = timeCodeLine.flatten
        startHour, startMinute, startSecond, startMillisecond = startTimeCode.scan( /(\d+):(\d{2}):(\d{2})(?:,(\d{3}))?/ ).flatten
        stopHour, stopMinute, stopSecond, stopMillisecond = stopTimeCode.scan( /(\d+):(\d{2}):(\d{2})(?:,(\d{3}))?/ ).flatten
        startMillisecond = 0.0 if startMillisecond.nil?
        stopMillisecond = 0.0 if stopMillisecond.nil?

        @start = Time.new( 0, 1, 1, startHour.to_i, startMinute.to_i, startSecond.to_f + ( 0.001 * startMillisecond.to_f ) )
        @stop = Time.new( 0, 1, 1, stopHour.to_i, stopMinute.to_i, stopSecond.to_f + ( 0.001 * stopMillisecond.to_f ) )
        raise ArgumentError, "Invalid timecode: #{textblock.at 1}" if @start > @stop

        # Record rest of the text block as dialog lines
        @dialog = textblock[ 2 .. -1 ]
    end

    # An invalid or discardable subtitle is "empty"
    def empty?

        # Index must be present
        return true if @index.nil?

        # Start and stop should not be exactly the same
        return true if @start == @stop

        # Dialog should be present
        return true if @dialog.nil?

        # Valid subtitle
        return false
    end

    # Write subtitle in proper format
    def to_s

        # First line is the index
        subtitle = "#{@index}\n"

        # Second line is the time code
        subtitle += "#{@start.strftime "%H:%M:%S,%L"} --> #{@stop.strftime "%H:%M:%S,%L"}\n"

        # Remaining lines are dialog lines
        subtitle += @dialog.join "\n"

        return subtitle
    end
end
