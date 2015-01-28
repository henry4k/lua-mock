#!/usr/bin/env lua
-- vim: set filetype=lua:
package.path = package.path..';src/?.lua'
require 'Test.More'

local Spy = require 'test.mock.Spy'


add = Spy(function( a, b ) return a+b end)


plan(13)

lives_ok('add:assertCallCount(0)',
             'assertCallCount(0) succeeds before spy was called.')

error_like('add:assertCallCount(1)', '.+',
               'assertCallCount(1) fails without actual calls.')

error_like('add:assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}}', '.+',
               'assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}} fails without actual calls.')

is(add(1,2), 3, 'add(1,2) is 3')
is(add(2,3), 5, 'add(2,3) is 5')
is(add(3,4), 7, 'add(3,4) is 7')

lives_ok('add:assertCallCount(3)',
             'assertCallCount(3) succeeds after spy was called 3 times.')

lives_ok('add:assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}}',
             'assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}} succeeds after spy was called that way.')

error_like('add:assertCallMatches{atIndex=2, arguments={1, 2}, returneValues={3}}', '.+',
               'assertCallMatches{atIndex=2, arguments={3, 4}, returneValues=7}} fails because its out of order.')

lives_ok('add:assertAnyCallMatches{arguments={3, 4}, returned={7}}',
             'assertAnyCallMatches{arguments={3, 4}, returned={7}} succeeds.')

add:reset()

lives_ok('add:assertCallCount(0)',
             'assertCallCount(0) succeeds after spy was reset.')

error_like('add:assertCallCount(1)', '.+',
               'assertCallCount(1) fails after spy was reset.')

error_like('add:assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}}', '.+',
               'assertCallMatches{atIndex=1, arguments={1, 2}, returneValues={3}} fails after spy was reset.')
