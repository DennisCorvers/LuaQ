package.path = package.path .. ";./?.lua"

local Enumerable = require("src.enumerable")
local assert = require("tests.assert")
local assertEqual = assert.equals
local test = require("tests.test")


test("aliases reference their canonical functions", function()
    assertEqual(Enumerable.from, Enumerable.create)
    assertEqual(Enumerable.select, Enumerable.map)
    assertEqual(Enumerable.selectMany, Enumerable.flatMap)
    assertEqual(Enumerable.distinct, Enumerable.unique)
    assertEqual(Enumerable.except, Enumerable.difference)
    assertEqual(Enumerable.order, Enumerable.sort)
    assertEqual(Enumerable.orderDecending, Enumerable.sortDescending)
    assertEqual(Enumerable.orderBy, Enumerable.sortBy)
    assertEqual(Enumerable.orderByDecending, Enumerable.sortByDescending)
    assertEqual(Enumerable.each, Enumerable.foreach)
    assertEqual(Enumerable.for_each, Enumerable.foreach)
    assertEqual(Enumerable.length, Enumerable.count)
    assertEqual(Enumerable.countBy, Enumerable.count)
    assertEqual(Enumerable.lengthBy, Enumerable.count)
    assertEqual(Enumerable.has, Enumerable.contains)
    assertEqual(Enumerable.fold, Enumerable.aggregate)
    assertEqual(Enumerable.reduce, Enumerable.aggregate)
    assertEqual(Enumerable.toDictionary, Enumerable.toMap)
    assertEqual(Enumerable.toMultimap, Enumerable.toLookup)
end)
