local ProgrammableFn = require 'test/mock/ProgrammableFn'
local Spy = require 'test/mock/Spy'


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

function Mock.prototype:whenCalledWith( behaviour )
    self.programmable:whenCalledWith(behaviour)
end

function Mock.mt:__call( ... )
    return self.spy(...)
end

function Mock.prototype:reset()
    self.spy:reset()
    self.programmable:reset()
end

function Mock.prototype:assertCallCount( count )
    self.spy:assertCallCount(count)
end

function Mock.prototype:assertCalledWith( ... )
    self.spy.assertCalledWith(...)
end


return Mock
