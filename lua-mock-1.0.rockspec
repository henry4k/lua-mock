package = 'mock'
version = '1.0'
source = {
   module = 'https://github.com/henry4k/lua-mock.git',
   branch = '1.0'
}
description = {
   summary = 'Provides mocking utilities.',
   license = 'UNLICENCE'
}
dependencies = {
   'lua >= 5.1'
}
build = {
    type = 'builtin',
    modules = {
        ['test.mock.ArgumentMatcher'] = 'test/mock/ArgumentMatcher.lua',
        ['test.mock.Mock']            = 'test/mock/Mock.lua',
        ['test.mock.ProgrammableFn']  = 'test/mock/ProgrammableFn.lua',
        ['test.mock.Spy']             = 'test/mock/Spy.lua'
    }
}
