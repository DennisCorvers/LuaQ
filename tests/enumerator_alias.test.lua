package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("select alias", function()
    local values = Enumerator3.create({ 1, 2 })
        :select(function(value) return value * 2 end)
    assertSequence(values, { 2, 4 })
end)

test("selectMany alias", function()
    local values = Enumerator3.create({ 1, 2 })
        :selectMany(function(value) return { value, value + 10 } end)
    assertSequence(values, { 1, 11, 2, 12 })
end)

test("distinct alias", function()
    local values = Enumerator3.create({ 1, 1, 2 })
        :distinct()
    assertSequence(values, { 1, 2 })
end)

test("except alias", function()
    local values = Enumerator3.create({ 1, 2, 3 })
        :except({ 2 })
    assertSequence(values, { 1, 3 })
end)

test("order alias", function()
    local values = Enumerator3.create({ 3, 1, 2 })
        :order()
    assertSequence(values, { 1, 2, 3 })
end)

test("orderDecending alias", function()
    local values = Enumerator3.create({ 1, 3, 2 })
        :orderDecending()
    assertSequence(values, { 3, 2, 1 })
end)

test("orderBy alias", function()
    local values = Enumerator3.create({ { n = 2 }, { n = 1 } })
        :orderBy(function(item) return item.n end)
        :map(function(item) return item.n end)
    assertSequence(values, { 1, 2 })
end)

test("orderByDecending alias", function()
    local values = Enumerator3.create({ { n = 1 }, { n = 2 } })
        :orderByDecending(function(item) return item.n end)
        :map(function(item) return item.n end)
    assertSequence(values, { 2, 1 })
end)

test("each alias", function()
    local total = 0
    Enumerator3.each({ 1, 2 }, function(value) total = total + value end)
    assertEqual(total, 3)
end)

test("for_each alias", function()
    local total = 0
    Enumerator3.for_each({ 3, 4 }, function(value) total = total + value end)
    assertEqual(total, 7)
end)

test("length alias", function()
    assertEqual(Enumerator3.length({ 1, 2, 3 }), 3)
end)

test("lengthBy alias", function()
    assertEqual(Enumerator3.lengthBy({ 1, 2, 3, 4 },
        function(value) return value > 2 end), 2)
end)

test("has alias", function()
    assertEqual(Enumerator3.has({ 1, 2, 3 }, 2), true)
    assertEqual(Enumerator3.has({ 1, 2, 3 }, 9), false)
end)

test("fold alias", function()
    assertEqual(Enumerator3.fold({ 1, 2, 3 },
        function(total, value) return total + value end, 0), 6)
end)

test("reduce alias", function()
    assertEqual(Enumerator3.reduce({ 2, 3, 4 },
        function(total, value) return total * value end), 24)
end)
