package = 'lua-mock'
version = '2.0'
source = {
    url = 'https://github.com/henry4k/lua-mock/archive/v2.0.tar.gz'
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
        ['test.mock.ArgumentMatcher'] = 'src/test/mock/ArgumentMatcher.lua',
        ['test.mock.Mock']            = 'src/test/mock/Mock.lua',
        ['test.mock.ProgrammableFn']  = 'src/test/mock/ProgrammableFn.lua',
        ['test.mock.Spy']             = 'src/test/mock/Spy.lua'
    }
}
