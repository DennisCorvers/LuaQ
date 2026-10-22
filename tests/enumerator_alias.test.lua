package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local test = require("tests.test")


test("aliases reference their canonical functions", function()
    assertEqual(Enumerator3.from, Enumerator3.create)
    assertEqual(Enumerator3.select, Enumerator3.map)
    assertEqual(Enumerator3.selectMany, Enumerator3.flatMap)
    assertEqual(Enumerator3.distinct, Enumerator3.unique)
    assertEqual(Enumerator3.except, Enumerator3.difference)
    assertEqual(Enumerator3.order, Enumerator3.sort)
    assertEqual(Enumerator3.orderDecending, Enumerator3.sortDescending)
    assertEqual(Enumerator3.orderBy, Enumerator3.sortBy)
    assertEqual(Enumerator3.orderByDecending, Enumerator3.sortByDescending)
    assertEqual(Enumerator3.each, Enumerator3.foreach)
    assertEqual(Enumerator3.for_each, Enumerator3.foreach)
    assertEqual(Enumerator3.length, Enumerator3.count)
    assertEqual(Enumerator3.countBy, Enumerator3.count)
    assertEqual(Enumerator3.lengthBy, Enumerator3.count)
    assertEqual(Enumerator3.has, Enumerator3.contains)
    assertEqual(Enumerator3.fold, Enumerator3.aggregate)
    assertEqual(Enumerator3.reduce, Enumerator3.aggregate)
    assertEqual(Enumerator3.toDictionary, Enumerator3.toMap)
    assertEqual(Enumerator3.toMultimap, Enumerator3.toLookup)
end)
