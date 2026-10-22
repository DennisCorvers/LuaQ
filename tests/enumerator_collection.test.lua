package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("toSet uses original values as keys without a selector", function()
    local values = Enumerator3.create({ "a", "bb", "a" })
    local result = values:toSet()

    assertEqual(result.a, true)
    assertEqual(result.bb, true)
    assertEqual(Enumerator3.count(result), 2)
end)

test("toSet selects keys from complex objects", function()
    local players = Enumerator3.create({
        { name = "Ada",  role = "mage" },
        { name = "Bryn", role = "ranger" },
        { name = "Cato", role = "mage" },
    })
    local roles = players:toSet(function(player) return player.role end)

    assertEqual(roles.mage, true)
    assertEqual(roles.ranger, true)
    assertEqual(Enumerator3.count(roles), 2)
end)

test("toTable", function()
    local values = Enumerator3.create({ 3, 4, 5 })
        :toTable();

    assertSequence(values, { 3, 4, 5 })
end)

test("toLookup groups complex objects and retains values", function()
    local players = {
        { name = "Ada",  role = "mage" },
        { name = "Bryn", role = "ranger" },
        { name = "Cato", role = "mage" },
    }
    local lookup = Enumerator3.create(players)
        :toLookup(function(player) return player.role end)

    assertSequence(lookup.mage, { players[1], players[3] })
end)

test("toLookup applies an element selector within each group", function()
    local players = {
        { name = "Ada",  role = "mage" },
        { name = "Bryn", role = "ranger" },
        { name = "Cato", role = "mage" },
    }
    local lookup = Enumerator3.create(players)
        :toLookup(
            function(player) return player.role end,
            function(player) return player.name end
        )

    assertSequence(lookup.mage, { "Ada", "Cato" })
end)

test("toLookup preserves false keys and element values", function()
    local lookup = Enumerator3.create({ "first", "second" })
        :toLookup(function() return false end, function() return false end)

    assertSequence(lookup[false], { false, false })
end)

test("toDictionary retains source keys and values without selectors", function()
    local players = {
        { name = "Ada" },
        { name = "Bryn" },
    }
    local dictionary = Enumerator3.create(players):toMap()

    assertEqual(dictionary[1], players[1])
end)

test("toDictionary selects keys and values from complex objects", function()
    local players = {
        { id = 1, name = "Ada" },
        { id = 2, name = "Bryn" },
        { id = 1, name = "Cato" },
    }
    local dictionary = Enumerator3.create(players)
        :toMap(
            function(player) return player.id end,
            function(player) return player.name end
        )

    assertEqual(dictionary[2], "Bryn")
end)

test("toDictionary overwrites values for duplicate selected keys", function()
    local players = {
        { id = 1, name = "Ada" },
        { id = 1, name = "Cato" },
    }
    local dictionary = Enumerator3.create(players)
        :toMap(
            function(player) return player.id end,
            function(player) return player.name end
        )

    assertEqual(dictionary[1], "Cato")
end)

test("deepCopy does not share nested tables", function()
    local source = { nested = { value = 1 } }
    local copy = Enumerator3.deepCopy(source)
    copy.nested.value = 2

    assertEqual(source.nested.value, 1)
end)
