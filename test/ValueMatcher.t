#!/usr/bin/env lua
-- vim: set filetype=lua:
package.path = package.path..';src/?.lua'
require 'Test.More'

local vm = require 'test/mock/ValueMatcher'

plan(3)
ok(vm.matches({1,2,3}, {1,2,3}), 'Simple values.')
nok(vm.matches({1,2,3}, {1,2}), 'Detects length mismatch.')
nok(vm.matches({1,2,3}, {1,2,'3'}), 'Detects type mismatch.')
