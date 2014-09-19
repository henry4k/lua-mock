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
    local instance = {
        wrappedFn = wrappedFn,
        calls = {},
        selectedCall = 1
    }
    return setmetatable(instance, self.mt)
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
    self.selectedCall = 1
end

function Spy.prototype:assertCallCount( count )
    if #self.calls ~= count then
        error('Should be called '..count..' times, but was called '..#self.calls..' times.', 2)
    end
end

function Spy.prototype:assertCall( callMatcher )
    self:assertCallCount(self.selectedCall)
    local call = self.calls[self.selectedCall]
    ValueMatcher.assertMatch(call.arguments, callMatcher, 'Argument', 2)
    ValueMatcher.assertMatch(call.returnValues, callMatcher.returned, 'Return value', 2)
    self.selectedCall = self.selectedCall + 1
end


return Spy
