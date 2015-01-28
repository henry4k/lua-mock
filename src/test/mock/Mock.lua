local ProgrammableFn = require 'test.mock.ProgrammableFn'
local Spy = require 'test.mock.Spy'


--- Combination of Spy and ProgrammableFn.
-- See #Spy and #ProgrammableFn for details.
local Mock =
{
    mt = {},
    prototype = {}
}
Mock.mt.__index = Mock.prototype
setmetatable(Mock.prototype, Mock.prototype)
setmetatable(Mock, Mock)


function Mock:__call()
    return self:new()
end

function Mock:new()
    local programmable = ProgrammableFn:new()
    local spy = Spy:new(programmable)
    local instance = {
        programmable = programmable,
        spy = spy
    }
    return setmetatable(instance, self.mt)
end

function Mock.prototype:canBeCalled( behaviour )
    self.programmable:canBeCalled(behaviour)
    return self
end

function Mock.mt:__call( ... )
    return self.spy(...)
end

function Mock.prototype:reset()
    self.spy:reset()
    self.programmable:reset()
    return self
end

function Mock.prototype:assertCallCount( count )
    self.spy:assertCallCount(count)
    return self
end

function Mock.prototype:assertCallMatches( query )
    self.spy.assertCallMatches(query)
    return self
end

function Mock.prototype:assertAnyCallMatches( query )
    self.spy.assertAnyCallMatches(query)
    return self
end


return Mock
