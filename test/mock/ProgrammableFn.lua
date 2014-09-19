local ArgumentMatcher = require 'test/mock/ArgumentMatcher'


local ProgrammableFn =
{
    mt = {},
    prototype = {}
}
ProgrammableFn.mt.__index = ProgrammableFn.prototype
setmetatable(ProgrammableFn.prototype, ProgrammableFn.prototype)
setmetatable(ProgrammableFn, ProgrammableFn)


function ProgrammableFn:__call()
    return self:new()
end

function ProgrammableFn:new()
    local instance = {
        behaviours = {}
    }
    return setmetatable(instance, self.mt)
end

function ProgrammableFn.mt:__call( ... )
    local behaviour = self:findMatchingBehaviour({...})
    if not behaviour then
        error('No matching behaviour for call.', 2)
    end
    return table.unpack(behaviour.returns)
end

function ProgrammableFn.prototype:findMatchingBehaviour( args )
    for _,behaviour in ipairs(self.behaviours) do
        if ArgumentMatcher.matches(args, behaviour) then
            return behaviour
        end
    end
    return nil
end

function ProgrammableFn.prototype:whenCalledWith( behaviour )
    if not behaviour.returns then
        behaviour.returns = {}
    end
    table.insert(self.behaviours, behaviour)
end

function ProgrammableFn.prototype:reset()
    self.behaviours = {}
end


return ProgrammableFn
