local ArgumentMatcher = require 'test/mock/ArgumentMatcher'


local Spy =
{
    mt = {},
    prototype = {}
}
Spy.mt.__index = Spy.prototype
setmetatable(Spy.prototype, Spy.prototype)


function Spy:new( wrappedFn )
    local instance = {
        wrappedFn = wrappedFn,
        calls = {},
        selectedCall = 1
    }
    return setmetatable(instance, self.mt)
end

function Spy.mt:__call( ... )
    table.insert(self.calls, {...})
    return self.wrappedFn(...)
end

function Spy.prototype:reset()
    self.calls = {}
    self.selectedCall = 1
end

function Spy.prototype:assertCallCount( count )
    assert(#self.calls == count,
           'Should be called '..count..' times, but was called '..#self.calls..' times.')
end

function Spy.prototype:assertCalledWith( ... )
    self:assertCallCount(self.selectedCall)
    local call = self.calls[self.selectedCall]
    ArgumentMatcher.assertMatch(call, {...})
    self.selectedCall = self.selectedCall + 1
end


return Spy
