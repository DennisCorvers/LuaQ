package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("select alias", function()
    local source = Enumerator3.create({ 1, 2 })
    local values = source:select(function(value) return value * 2 end)

    assertSequence(values, { 2, 4 })
end)

test("selectMany alias", function()
    local source = Enumerator3.create({ 1, 2 })
    local values = source:selectMany(function(value) return { value, value + 10 } end)

    assertSequence(values, { 1, 11, 2, 12 })
end)

test("distinct alias", function()
    local source = Enumerator3.create({ 1, 1, 2 })
    local values = source:distinct()

    assertSequence(values, { 1, 2 })
end)

test("except alias", function()
    local source = Enumerator3.create({ 1, 2, 3 })
    local values = source:except({ 2 })

    assertSequence(values, { 1, 3 })
end)

test("order alias", function()
    local source = Enumerator3.create({ 3, 1, 2 })
    local values = source:order()

    assertSequence(values, { 1, 2, 3 })
end)

test("orderDecending alias", function()
    local source = Enumerator3.create({ 1, 3, 2 })
    local values = source:orderDecending()

    assertSequence(values, { 3, 2, 1 })
end)

test("orderBy alias", function()
    local source = Enumerator3.create({ { n = 2 }, { n = 1 } })
    local values = source:orderBy(function(item) return item.n end)
        :map(function(item) return item.n end)

    assertSequence(values, { 1, 2 })
end)

test("orderByDecending alias", function()
    local source = Enumerator3.create({ { n = 1 }, { n = 2 } })
    local values = source:orderByDecending(function(item) return item.n end)
        :map(function(item) return item.n end)

    assertSequence(values, { 2, 1 })
end)

test("each alias", function()
    local total = 0
    local values = Enumerator3.create({ 1, 2 })
    values:each(function(value) total = total + value end)

    assertEqual(total, 3)
end)

test("for_each alias", function()
    local total = 0
    local values = Enumerator3.create({ 3, 4 })
    values:for_each(function(value) total = total + value end)

    assertEqual(total, 7)
end)

test("length alias", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local length = values:length()

    assertEqual(length, 3)
end)

test("lengthBy alias", function()
    local values = Enumerator3.create({ 1, 2, 3, 4 })
    local length = values:lengthBy(function(value) return value > 2 end)

    assertEqual(length, 2)
end)

test("has alias finds a value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local hasValue = values:has(2)

    assertEqual(hasValue, true)
end)

test("has alias returns false for a missing value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local hasValue = values:has(9)

    assertEqual(hasValue, false)
end)

test("fold alias", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local result = values:fold(function(total, value) return total + value end, 0)

    assertEqual(result, 6)
end)

test("reduce alias", function()
    local values = Enumerator3.create({ 2, 3, 4 })
    local result = values:reduce(function(total, value) return total * value end)

    assertEqual(result, 24)
end)
