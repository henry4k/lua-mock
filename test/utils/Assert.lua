local notEqualMessage =
        '%s:\n'..
        '     was: %s\n'..
        'expected: %s'


local Assert = {}

function Assert.equals( actual, expected, message )
    if actual ~= expected then
        local message = notEqualMessage:format(message,
                                               tostring(actual),
                                               tostring(expected))
        error(message, 2)
    end
end

return Assert