package.path = package.path .. ";./?.lua"

local LuaQ = require("src.enumerable")
local assert = require("tests.assert")
local assertSequence = assert.sequenceEquals
local test = require("tests.test")

test("GitHub README boss-loot example", function()
    local encounters = {
        {
            boss = "Zamorak",
            result = "kill",
            drops = {
                { item = "Chaos Roar ability codex", value = 18000000 },
                { item = "Onyx", value = 100000 },
            },
        },
        {
            boss = "Rasial",
            result = "kill",
            drops = {
                { item = "Soulbound lantern", value = 42000000 },
                { item = "Spirit weed seed", value = 5000 },
            },
        },
        {
            boss = "Zamorak",
            result = "kill",
            drops = {
                { item = "Bow of the Last Guardian", value = 65000000 },
            },
        },
        {
            boss = "Rasial",
            result = "attempt",
            drops = {},
        },
    }

    local lootSummary = LuaQ.from(encounters)
        :where(function(run) return run.result == "kill" end)
        :flatMap(function(run)
            return LuaQ.from(run.drops)
                :where(function(drop) return drop.value >= 1000000 end)
                :map(function(drop)
                    return { boss = run.boss, item = drop.item, value = drop.value }
                end)
        end)
        :groupByResult(
            function(drop) return drop.boss end,
            nil,
            function(boss, drops)
                return {
                    boss = boss,
                    valuableDropCount = #drops,
                    totalValue = LuaQ.from(drops):sum(function(drop) return drop.value end),
                }
            end
        )
        :sortByDescending(function(summary) return summary.totalValue end)

    local bosses = {}
    local valuableDropCounts = {}
    local totalValues = {}
    lootSummary:foreach(function(summary)
        table.insert(bosses, summary.boss)
        table.insert(valuableDropCounts, summary.valuableDropCount)
        table.insert(totalValues, summary.totalValue)
    end)

    assertSequence(bosses, { "Zamorak", "Rasial" })
    assertSequence(valuableDropCounts, { 2, 1 })
    assertSequence(totalValues, { 83000000, 42000000 })
end)
