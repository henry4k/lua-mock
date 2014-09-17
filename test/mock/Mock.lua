local ProgrammableFn = require 'test/mock/ProgrammableFn'
local Spy = require 'test/mock/Spy'


local Mock =
{
    mt = {}
}
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

function Mock.mt:__call( ... )
    return self.spy(...)
end

function Mock.mt:__index( key )
    return self.programmable[key] or self.spy[key]
end

return Mock
