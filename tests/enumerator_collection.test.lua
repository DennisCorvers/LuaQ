package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("toSet", function()
    local result = Enumerator3.toSet({ "a", "bb", "ccc" }, function(value) return #value end)
    assertEqual(result[1], true)
    assertEqual(result[2], true)
    assertEqual(result[3], true)
end)

test("toTable", function()
    assertSequence(Enumerator3.toTable(Enumerator3.create({ 3, 4, 5 })), { 3, 4, 5 })
end)

test("toLookup", function()
    local result = Enumerator3.toLookup({ "a", "bb", "c" },
        function(value) return #value end)
    assertSequence(result[1], { "a", "c" })
    assertSequence(result[2], { "bb" })
end)

test("toDictionary", function()
    local result = Enumerator3.toDictionary({ "a", "bb" },
        function(value) return #value end,
        function(value) return value:upper() end)
    assertEqual(result[1], "A")
    assertEqual(result[2], "BB")
end)

test("deepCopy", function()
    local source = { nested = { value = 1 } }
    local copy = Enumerator3.deepCopy(source)
    copy.nested.value = 2
    assertEqual(source.nested.value, 1)
    assertEqual(copy.nested.value, 2)
end)
