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

test("where with index", function()
    local values = Enumerator3.create({ 0, 30, 20, 15, 90, 85, 40, 75 })
        :where(function(value, index) return value <= index * 10 end)
    assertSequence(values, { 0, 20, 15, 40, 75 })
end)

test("map", function()
    local values = Enumerator3.create({ 1, 2, 3, 4 })
        :map(function(value) return value * value end)
    assertSequence(values, { 1, 4, 9, 16 })
end)

test("map with index", function()
    local values = Enumerator3.create({ 1, 3, 5, 7 })
        :map(function(value, index) return value * index end)
    assertSequence(values, { 1, 6, 15, 28 })
end)

test("flatMap", function()
    local values = Enumerator3.create({
        {
            name = "Ada",
            skills = {
                { name = "Magic", level = 80 },
                { name = "Runecrafting", level = 65 },
            },
        },
        {
            name = "Bryn",
            skills = {
                { name = "Mining", level = 72 },
            },
        },
    }):flatMap(function(player) return player.skills end)
    assertSequence(values:map(function(skill) return skill.name end), {
        "Magic",
        "Runecrafting",
        "Mining",
    })
end)

test("flatMap with index", function()
    local values = Enumerator3.create({
        { name = "Ada", skills = { "Magic", "Runecrafting" } },
        { name = "Bryn", skills = { "Mining", "Smithing" } },
    }):flatMap(function(player, index)
        return {
            { player = player.name, skill = player.skills[1], playerIndex = index },
            { player = player.name, skill = player.skills[2], playerIndex = index },
        }
    end):map(function(skill)
        return skill.player .. ":" .. skill.skill .. ":" .. skill.playerIndex
    end)
    assertSequence(values, {
        "Ada:Magic:1",
        "Ada:Runecrafting:1",
        "Bryn:Mining:2",
        "Bryn:Smithing:2",
    })
end)

test("concat", function()
    local values = Enumerator3.create({ 1, 2 })
        :concat({ 3, 4 })
    assertSequence(values, { 1, 2, 3, 4 })
end)

test("concat enumerator", function()
    local otherValues = Enumerator3.create({ 3, 4 })
    local values = Enumerator3.create({ 1, 2 })
        :concat(otherValues)
    assertSequence(values, { 1, 2, 3, 4 })
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
