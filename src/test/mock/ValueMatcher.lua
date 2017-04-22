--- @module ValueMatcher

local valueMismatchMessage =
    'did not match:\n'..
    '     was: %s\n'..
    'expected: %s'

local valueCountMismatchMessage =
    'mismatch:\n'..
    '     was: %d\n'..
    'expected: %d'


--- A matcher is used to determine if a value statisfies some condition.
-- The test function is called with the value that shall be tested.
-- The function returns `true` if the condition is statisfied.
-- Otherwise the function shall return `false` and an error message that
-- describes the problem.
local function createMatcher( testFn )
    return {
        isMatcher = true,
        match = testFn
    }
end

local function createEqualityMatcher( matchedValue )
    return createMatcher(function( value )
        if value == matchedValue then
            return true
        else
            return false, valueMismatchMessage:format(tostring(value),
                                                      tostring(matchedValue))
        end
    end)
end

local function createTableMatcher( matchedTable )
    return createMatcher(function( value )
        if value == matchedTable then
            return true
        elseif type(value) == 'table' then
            -- TODO
            return false, 'Can\'t recursively match tables at the moment.'
        else
            return false, valueMismatchMessage:format(tostring(value),
                                                      tostring(matchedTable))
        end
    end)
end

--- Test a single value.
-- Will automatically create a matcher if `matchedValue` is not one.
-- Like a matcher it returns `true` if the condition is statisfied or `false`
-- with an error message if the condition is not statisfied.
local function matchValue( value, matchedValue )
    local matcher

    if type(matchedValue) == 'table' then
        if matchedValue.isMatcher then
            matcher = matchedValue
        else
            matcher = createTableMatcher(matchedValue)
        end
    else
        matcher = createEqualityMatcher(matchedValue)
    end

    return matcher.match(value)
end


--- Tests multiple values.
-- Like a #matchValue it returns `true` if all values matched or `false` with
-- the according index and an error message if a value did not match.
local function matchValues( values, matchedValues )
    typeName = typeName or 'Value'

    if #values ~= #matchedValues then
        return false, valueCountMismatchMessage:format(#values,
                                                       #matchedValues)
    end

    for i,matchedValue in ipairs(matchedValues) do
        local value = values[i]
        local matched, message = matchValue(value, matchedValue)
        if not matched then
            return false, i, message
        end
    end

    return true
end



local ValueMatcher = {}

--- Tests if the values match `matchedValues`.
--
-- @param value
--
-- @param matchedValues
-- A list that consists of regular values or matchers.
--
-- @return
-- `true` if all values match or `false` if at least one don't.
-- Also returns the value index and a reason when failing.
function ValueMatcher.matches( value, matchedValues )
    return matchValues(value, matchedValues)
end

--- Matches any value.
ValueMatcher.any = createMatcher(function( value )
    return true
end)

--- Matches any value but nil.
ValueMatcher.notNil = createMatcher(function( value )
    if value == nil then
        return false, 'was nil.'
    else
        return true
    end
end)

--- Matches a specific value type.
ValueMatcher.matchType = function( typeName )
    return createMatcher(function( value )
        if type(value) == typeName then
            return true
        else
            return false, ('was not a %s, but a %s.'):format(typeName, type(value))
        end
    end)
end

--- Matches a boolean value.
ValueMatcher.anyBoolean  = ValueMatcher.matchType('boolean')

--- Matches a number.
ValueMatcher.anyNumber   = ValueMatcher.matchType('number')

--- Matches a string.
ValueMatcher.anyString   = ValueMatcher.matchType('string')

--- Matches a table.
ValueMatcher.anyTable    = ValueMatcher.matchType('table')

--- Matches a function.
ValueMatcher.anyFunction = ValueMatcher.matchType('function')

--- Matches a thread.
ValueMatcher.anyThread   = ValueMatcher.matchType('thread')

--- Matches a user data.
ValueMatcher.anyUserData = ValueMatcher.matchType('userdata')


return ValueMatcher
