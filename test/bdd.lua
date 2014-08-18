local testBuilder = require 'Test.Builder'.new()


local bdd =
{
    descriptions = {}
}

function bdd.addDescription( description )
   table.insert(bdd.descriptions, description)
end

function bdd.runTests()
    local testCount = 0
    for _,description in ipairs(bdd.descriptions) do
        testCount = testCount + #description.behaviours
    end
    testBuilder:plan(testCount)

    for _,description in ipairs(bdd.descriptions) do
        description:_runTests()
    end

    bdd.descriptions = {}
end

return bdd