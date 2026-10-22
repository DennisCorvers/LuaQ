package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")

local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")

test("Enumerator3.new", function()
    local function nextValue(items, index)
        index = index + 1
        if items[index] ~= nil then
            return index, items[index]
        end
    end

    local values = Enumerator3.new(nextValue, 0, function() return { 4, 5 } end)
    assertSequence(values, { 4, 5 })
end)

test("Enumerator3.create", function()
    local values = Enumerator3.create({ 2, 4, 6 })
    assertSequence(values, { 2, 4, 6 })
end)

test("Enumerator3.createFrom", function()
    local values = Enumerator3.createFrom({ 7, 8 }, function(source) return ipairs(source) end)
    assertSequence(values, { 7, 8 })
end)

test("where", function()
    local values = Enumerator3.create({ 1, 2, 3, 4 })
        :where(function(value) return value % 2 == 0 end)
    assertSequence(values, { 2, 4 })
end)

test("map", function()
    local values = Enumerator3.create({ 2, 3 })
        :map(function(value, position) return value * position end)
    assertSequence(values, { 2, 6 })
end)

test("flatMap", function()
    local values = Enumerator3.create({ 2, 3 })
        :flatMap(function(value) return { value, value * 10 } end)
    assertSequence(values, { 2, 20, 3, 30 })
end)

test("concat", function()
    local values = Enumerator3.create({ 1, 2 })
        :concat({ 3, 4 })
    assertSequence(values, { 1, 2, 3, 4 })
end)

test("append", function()
    local values = Enumerator3.create({ 1, 2 })
        :append(3)
    assertSequence(values, { 1, 2, 3 })
end)

test("prepend", function()
    local values = Enumerator3.create({ 2, 3 })
        :prepend(1)
    assertSequence(values, { 1, 2, 3 })
end)

test("unique", function()
    local values = Enumerator3.create({ 1, 1, 2, 3, 2 })
        :unique()
    assertSequence(values, { 1, 2, 3 })
end)

test("difference", function()
    local values = Enumerator3.create({ 1, 2, 2, 3 })
        :difference({ 2 })
    assertSequence(values, { 1, 3 })
end)

test("union", function()
    local values = Enumerator3.create({ 1, 2, 2 })
        :union({ 2, 3 })
    assertSequence(values, { 1, 2, 3 })
end)

test("intersect", function()
    local values = Enumerator3.create({ 1, 2, 2, 3 })
        :intersect({ 2, 2, 3 })
    assertSequence(values, { 2, 3 })
end)

test("zip", function()
    local values = Enumerator3.create({ 1, 2, 3 })
        :zip({ 10, 20 }, function(left, right) return left + right end)
    assertSequence(values, { 11, 22 })
end)

test("groupBy", function()
    local groups = {}
    for key, values in Enumerator3.create({ 1, 2, 3, 4 })
        :groupBy(function(value) return value % 2 == 0 and "even" or "odd" end)
        :pairs() do
        groups[key] = values
    end
    assertSequence(groups.even, { 2, 4 })
    assertSequence(groups.odd, { 1, 3 })
end)

test("groupByResult", function()
    local totals = {}
    for key, total in Enumerator3.create({ 1, 2, 3, 4 })
        :groupByResult(
            function(value) return value % 2 == 0 and "even" or "odd" end,
            function(value) return value end,
            function(_, values) return Enumerator3.sum(values) end
        )
        :pairs() do
        totals[key] = total
    end
    assertEqual(totals.even, 6)
    assertEqual(totals.odd, 4)
end)

test("sort", function()
    local values = Enumerator3.create({ 3, 1, 2 })
        :sort()
    assertSequence(values, { 1, 2, 3 })
end)

test("sortDescending", function()
    local values = Enumerator3.create({ 1, 3, 2 })
        :sortDescending()
    assertSequence(values, { 3, 2, 1 })
end)

test("sortBy", function()
    local values = Enumerator3.create({ { n = 3 }, { n = 1 }, { n = 2 } })
        :sortBy(function(item) return item.n end)
        :map(function(item) return item.n end)
    assertSequence(values, { 1, 2, 3 })
end)

test("sortByDescending", function()
    local values = Enumerator3.create({ { n = 1 }, { n = 3 }, { n = 2 } })
        :sortByDescending(function(item) return item.n end)
        :map(function(item) return item.n end)
    assertSequence(values, { 3, 2, 1 })
end)

test("thenBy", function()
    local values = Enumerator3.create({
        { group = 1, name = "b" },
        { group = 1, name = "a" },
        { group = 2, name = "c" },
    }):sortBy(function(item) return item.group end)
        :thenBy(function(item) return item.name end)
        :map(function(item) return item.name end)
    assertSequence(values, { "a", "b", "c" })
end)

test("thenByDecending", function()
    local values = Enumerator3.create({
        { group = 1, score = 2 },
        { group = 1, score = 3 },
        { group = 2, score = 1 },
    }):sortBy(function(item) return item.group end)
        :thenByDecending(function(item) return item.score end)
        :map(function(item) return item.score end)
    assertSequence(values, { 3, 2, 1 })
end)

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
