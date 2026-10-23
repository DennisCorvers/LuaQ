package.path = package.path .. ";./?.lua"

local LuaQ = require("src.enumerable")
local assert = require("tests.assert")
local assertSequence = assert.sequenceEquals
local test = require("tests.test")

test("GitHub README advanced boss-loot example", function()
    local drops = {
        { boss = "Zamorak", item = "Chaos Roar ability codex", value = 18000000 },
        { boss = "Zamorak", item = "Onyx", value = 100000 },
        { boss = "Rasial", item = "Soulbound lantern", value = 42000000 },
        { boss = "Zamorak", item = "Bow of the Last Guardian", value = 65000000 },
        { boss = "Rasial", item = "Spirit weed seed", value = 5000 },
    }

    local bossTotals = LuaQ.from(drops)
        :where(function(drop) return drop.value >= 1000000 end)
        :groupByResult(
            function(drop) return drop.boss end,
            function(drop) return drop.value end,
            function(boss, values)
                return {
                    boss = boss,
                    valuableDropCount = #values,
                    totalValue = LuaQ.sum(values),
                }
            end
        )
        :sortByDescending(function(summary) return summary.totalValue end)

    local bosses = {}
    local valuableDropCounts = {}
    local totalValues = {}
    bossTotals:foreach(function(summary)
        table.insert(bosses, summary.boss)
        table.insert(valuableDropCounts, summary.valuableDropCount)
        table.insert(totalValues, summary.totalValue)
    end)

    assertSequence(bosses, { "Zamorak", "Rasial" })
    assertSequence(valuableDropCounts, { 2, 1 })
    assertSequence(totalValues, { 83000000, 42000000 })
end)
