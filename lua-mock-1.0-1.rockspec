package = 'lua-mock'
version = '1.0-1'
source = {
    url = 'https://github.com/henry4k/lua-mock/archive/v1.0-1.tar.gz'
}
description = {
    summary = 'Provides mocking utilities.',
    license = 'UNLICENCE',
    homepage = 'https://github.com/henry4k/lua-mock',
    maintainer = 'Henry Kielmann'
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
