local ArgumentMatcher = require 'test/mock/ArgumentMatcher'


local ProgrammableFn =
{
    mt = {},
    prototype = {}
}
ProgrammableFn.mt.__index = ProgrammableFn.prototype
setmetatable(ProgrammableFn.prototype, ProgrammableFn.prototype)


function ProgrammableFn:new()
    local instance = {
        behaviours = {}
    }
    return setmetatable(instance, self.mt)
end

function ProgrammableFn.mt:__call( ... )
    local behaviour = self:findMatchingBehaviour({...})
    assert(behaviour, 'No matching behaviour for call.')
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


return ProgrammableFn
