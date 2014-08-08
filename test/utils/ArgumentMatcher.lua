local argumentMismatchMessage =
    'Argument %d did not match:\n'..
    '     was: %s\n'..
    'expected: %s'

local argumentCountMismatchMessage =
    'Argument count mismatch:\n'..
    '     was: %d\n'..
    'expected: %d'

local function testMatch( args, matchers )
    for i,matcher in ipairs(matchers) do
        if matcher ~= args[i] then
            -- TODO: Add support for tables and matchers
            return false, argumentMismatchMessage:format(i,
                                                         tostring(args[i]),
                                                         tostring(matcher))
        end
    end

    if #matchers ~= #args then
        return false, argumentCountMismatchMessage:format(#args, #matchers)
    else
        return true
    end
end



local ArgumentMatcher = {}

function ArgumentMatcher.matches( args, matchers )
    local matches = testMatch(args, matchers)
    return matches
end

function ArgumentMatcher.assertMatch( args, matchers )
    local matches, errorMessage = testMatch(args, matchers)
    if not matches then
        error(errorMessage)
    end
end

return ArgumentMatcher