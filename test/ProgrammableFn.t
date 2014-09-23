#!/usr/bin/env lua
-- vim: set filetype=lua:
package.path = package.path..';src/?.lua'
require 'Test.More'

local ProgrammableFn = require 'test/mock/ProgrammableFn'


fn = ProgrammableFn()


plan(4)

error_like('fn(1,2)', '.+',
           'fn(1,2) fails without any programmed behaviours.')

fn:canBeCalled{with={1,2}, thenReturn={3}}
fn:canBeCalled{with={2,3}, thenReturn={5}}
fn:canBeCalled{with={3,4}, thenReturn={7}}

is(fn(2,3), 5, 'Behaviour for fn(2,3) matches and returns 5.')

error_like('fn(0,0)', '.+',
           'fn(0,0) fails without because it does not match any behaviour.')

fn:reset()

error_like('fn(2,3)', '.+',
           'fn(2,3) fails after resetting the function.')
