local ValueMatcher = require 'test/mock/ValueMatcher'


--- Wraps a function and records the calls.
-- For each call the arguments and return values are saved.
local Spy =
{
    mt = {},
    prototype = {}
}
Spy.mt.__index = Spy.prototype
setmetatable(Spy.prototype, Spy.prototype)
setmetatable(Spy, Spy)


function Spy:__call( wrappedFn )
    return self:new(wrappedFn)
end

function Spy:new( wrappedFn )
    local instance = setmetatable({ wrappedFn = wrappedFn }, self.mt)
    instance:reset()
    return instance
end

function Spy.mt:__call( ... )
    local returnValues = { self.wrappedFn(...) }
    local call = {
        arguments = {...},
        returnValues = returnValues
    }
    table.insert(self.calls, call)
    return table.unpack(returnValues)
end

function Spy.prototype:reset()
    self.calls = {}
end

function Spy.prototype:assertCallCount( count )
    if #self.calls ~= count then
        error('Should be called '..count..' times, but was called '..#self.calls..' times.', 2)
    end
    return self
end

function Spy.prototype:getSelectedCalls_( query, level )
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

function Spy.prototype:assertCallMatches( query, level )
    level = level or 1

    local selectedCalls = self:getSelectedCalls_(query, level+1)

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

function Spy.prototype:assertAnyCallMatches( query, level )
    level = level or 1

    local selectedCalls = self:getSelectedCalls_(query, level+1)

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


return Spy
