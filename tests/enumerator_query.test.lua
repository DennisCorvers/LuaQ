package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("indexOf", function()
    assertEqual(Enumerator3.indexOf({ 3, 5, 7 }, 5), 2)
    assertEqual(Enumerator3.indexOf({ 3, 5, 7 }, 9), -1)
end)

test("contains", function()
    assertEqual(Enumerator3.contains({ 3, 5, 7 }, 5), true)
    assertEqual(Enumerator3.contains({ 3, 5, 7 }, 9), false)
end)

test("sequenceEquals", function()
    assertEqual(Enumerator3.sequenceEquals({ 1, 2 }, { 1, 2 }), true)
    assertEqual(Enumerator3.sequenceEquals({ 1, 2 }, { 1, 3 }), false)
    assertEqual(Enumerator3.sequenceEquals({ 1, 2 }, { 1, 2, 3 }), false)
end)

test("firstOrDefault", function()
    assertEqual(Enumerator3.firstOrDefault({ 1, 2, 3 }), 1)
    assertEqual(Enumerator3.firstOrDefault({ 1, 2, 3 },
        function(value) return value > 1 end), 2)
    assertEqual(Enumerator3.firstOrDefault({}, nil, "empty"), "empty")
end)

test("first", function()
    assertEqual(Enumerator3.first({ 1, 2, 3 }), 1)
    assertEqual(Enumerator3.first({ 1, 2, 3 },
        function(value) return value > 1 end), 2)
end)

test("lastOrDefault", function()
    assertEqual(Enumerator3.lastOrDefault({ 1, 2, 3 }), 3)
    assertEqual(Enumerator3.lastOrDefault({ 1, 2, 3 },
        function(value) return value < 3 end), 2)
    assertEqual(Enumerator3.lastOrDefault({}, nil, "empty"), "empty")
end)

test("last", function()
    assertEqual(Enumerator3.last({ 1, 2, 3 }), 3)
    assertEqual(Enumerator3.last({ 1, 2, 3 },
        function(value) return value < 3 end), 2)
end)

test("count", function()
    assertEqual(Enumerator3.count({ 1, 2, 3 }), 3)
    assertEqual(Enumerator3.count({}), 0)
end)

test("countBy", function()
    assertEqual(Enumerator3.countBy({ 1, 2, 3, 4 },
        function(value) return value % 2 == 0 end), 2)
end)

test("all", function()
    assertEqual(Enumerator3.all({ 2, 4, 6 }, function(value) return value % 2 == 0 end), true)
    assertEqual(Enumerator3.all({ 2, 3, 6 }, function(value) return value % 2 == 0 end), false)
end)

test("any", function()
    assertEqual(Enumerator3.any({ 1, 2, 3 }), true)
    assertEqual(Enumerator3.any({}), false)
    assertEqual(Enumerator3.any({ 1, 2, 3 }, function(value) return value == 2 end), true)
end)

test("foreach", function()
    local total = 0
    Enumerator3.foreach({ 1, 2, 3 }, function(value) total = total + value end)
    assertEqual(total, 6)
end)

test("ipairs", function()
    local values = {}
    for index, value in Enumerator3.ipairs(Enumerator3.create({ 4, 5 })) do
        values[index] = value
    end
    assertSequence(values, { 4, 5 })
end)

test("pairs", function()
    local values = {}
    for key, value in Enumerator3.pairs(Enumerator3.create({ 4, 5 })) do
        values[key] = value
    end
    assertEqual(values[1], 4)
    assertEqual(values[2], 5)
end)

test("aggregate", function()
    local result = Enumerator3.aggregate({ 2, 3, 4 },
        function(total, value) return total + value end, 1)
    assertEqual(result, 10)
end)

test("max", function()
    assertEqual(Enumerator3.max({ 2, 8, 4 }), 8)
end)

test("maxBy", function()
    local values = { { score = 2 }, { score = 9 }, { score = 4 } }
    assertEqual(Enumerator3.maxBy(values, function(item) return item.score end), values[2])
end)

test("min", function()
    assertEqual(Enumerator3.min({ 2, 8, 4 }), 2)
end)

test("minBy", function()
    local values = { { score = 2 }, { score = 9 }, { score = 4 } }
    assertEqual(Enumerator3.minBy(values, function(item) return item.score end), values[1])
end)

test("sum", function()
    assertEqual(Enumerator3.sum({ 2, 3, 4 }), 9)
end)
