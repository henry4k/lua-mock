--- @classmod Spy
--- Wraps a function and records the calls.
-- For each call the arguments and return values are saved.


local ValueMatcher = require 'test.mock.ValueMatcher'


local Spy = {}
Spy.__index = Spy


function Spy:__call( ... )
    local returnValues = { self.wrappedFn(...) }
    local call = {
        arguments = {...},
        returnValues = returnValues
    }
    table.insert(self.calls, call)
    return table.unpack(returnValues)
end

function Spy:reset()
    self.calls = {}
    return self
end

--- Test if the spy was called exactly `count` times.
function Spy:assertCallCount( count )
    if #self.calls ~= count then
        error('Should be called '..count..' times, but was called '..#self.calls..' times.', 2)
    end
    return self
end

function Spy:_getSelectedCalls( query, level )
    level = level or 1
    local selectedCalls = {}

    if query.atIndex then
        local call = self.calls[query.atIndex]
        if call then
            table.insert(selectedCalls, call)
        else
            error('No call at index '..query.atIndex..'.  Recorded only '..#self.calls..' calls.', level+1)
        end
    end

    -- Use wildcard as default:
    if not query.atIndex then
        selectedCalls = self.calls
    end

    if not #selectedCalls then
        error('No calls selected.', level+1)
    end

    return selectedCalls
end

local argumentMismatchedMessage = 'Argument %d of call %d mismatched:  %s'
local returnValueMismatchedMessage = 'Return value %d of call %d mismatched:  %s'

--- Test if some calls match specific properties.
--
-- Specify a set of calls to test, by adding:
-- - 'atIndex': Test only the call at the given index.
-- - nothing: Acts as a wildcard and will select all calls.
--
-- Specify a set of call attributes to test, by adding:
-- - 'arguments': A list of value matchers, that is compared to the actual arguments.
-- - 'returnValues': A list of value matchers, that is compared to the actual return values.
function Spy:assertCallMatches( query, level )
    level = level or 1

    local selectedCalls = self:_getSelectedCalls(query, level+1)

    for callIndex, call in ipairs(selectedCalls) do
        if query.arguments then
            local matches, mismatchedIndex, mismatchReason =
                ValueMatcher.matches(call.arguments, query.arguments)
            if not matches then
                error(argumentMismatchedMessage:format(mismatchedIndex,
                                                       callIndex,
                                                       mismatchReason),
                      level+1)
            end
        end

        if query.returnValues then
            local matches, mismatchedIndex, mismatchReason =
                ValueMatcher.matches(call.returnValues, query.returnValues)
            if not matches then
                error(returnValueMismatchedMessage:format(mismatchedIndex,
                                                          callIndex,
                                                          mismatchReason),
                      level+1)
            end
        end
    end

    return self
end

--- Test if at least one call match specific properties.
-- Acts like #Spy:assertCallMatches, but succeeds if at least one
-- call matches.
function Spy:assertAnyCallMatches( query, level )
    level = level or 1

    local selectedCalls = self:_getSelectedCalls(query, level+1)

    local oneMatched = false
    for _, call in ipairs(selectedCalls) do
        local argumentsMatch = true
        if query.arguments then
            argumentsMatch = ValueMatcher.matches(call.arguments, query.arguments)
        end

        local returnValuesMatch = true
        if query.returnValues then
            returnValuesMatch = ValueMatcher.matches(call.returnValues, query.returnValues)
        end

        if argumentsMatch and returnValuesMatch then
            oneMatched = true
            break
        end
    end

    if not oneMatched then
        error('No call matched.', level+1)
    end

    return self
end


return function( wrappedFn )
    local self = setmetatable({ wrappedFn = wrappedFn }, Spy)
    self:reset()
    return self
end
