#!/usr/bin/env lua
-- vim: set filetype=lua:
package.path = 'src/?.lua;'..package.path
require 'Test.More'

local vm = require 'test.mock.ValueMatcher'

plan(9)
ok(vm.matches({1,2,3}, {1,2,3}), 'Simple values.')
nok(vm.matches({1,2,3}, {1,2}), 'Detects length mismatch.')
nok(vm.matches({1,2,3}, {1,2,'3'}), 'Detects type mismatch.')
ok(vm.matches({1}, {vm.any}), 'Matches any value.')
ok(vm.matches({1}, {vm.anyNumber}), 'Matches any number.')
nok(vm.matches({'1'}, {vm.anyNumber}), 'Strings are not numbers.')
ok(vm.matches({1}, {vm.notNil}), 'Matches not nil.')
ok(vm.matches({false}, {vm.notNil}), 'False is not nil.')
nok(vm.matches({1, nil, 3}, {1, vm.notNil, 3}), 'Nil does not match not nil.')
