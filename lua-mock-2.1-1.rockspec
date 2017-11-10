package = 'lua-mock'
version = '2.1-1'
source = {
    url = 'git://github.com/henry4k/lua-mock',
    tag = 'v2.1-1'
}
description = {
    summary = 'Provides mocking utilities.',
    license = 'UNLICENCE',
    homepage = 'https://github.com/henry4k/lua-mock',
    maintainer = 'Henry Kielmann'
}
dependencies = {
    'lua >= 5.2'
}
build = {
    type = 'builtin',
    modules = {
        ['test.mock.ValueMatcher']    = 'src/test/mock/ValueMatcher.lua',
        ['test.mock.Mock']            = 'src/test/mock/Mock.lua',
        ['test.mock.ProgrammableFn']  = 'src/test/mock/ProgrammableFn.lua',
        ['test.mock.Spy']             = 'src/test/mock/Spy.lua'
    }
}
