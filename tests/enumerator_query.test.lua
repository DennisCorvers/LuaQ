package.path = package.path .. ";./?.lua"

local Enumerator3 = require("src.enumerator")
local assert = require("tests.assert")
local assertEqual = assert.equals
local assertSequence = assert.sequenceEquals
local test = require("tests.test")


test("elementAt uses a 1-based index", function()
    local values = Enumerator3.create({ "first", "second", "third" })
    assertEqual(values:elementAt(1), "first")
end)

test("elementAt returns an item at a later index", function()
    local values = Enumerator3.create({ "first", "second", "third" })
    assertEqual(values:elementAt(3), "third")
end)

test("elementAt supports custom iterators", function()
    local source = { "first", "second", "third" }
    local function nextValue(items, index)
        index = index + 1
        if items[index] ~= nil then
            return index, items[index]
        end
    end
    local values = Enumerator3.createFrom(source, function(items)
        return nextValue, items, 0
    end)

    assertEqual(values:elementAt(2), "second")
end)

test("elementAt errors when the index is out of range", function()
    local values = Enumerator3.create({ "first", "second" })
    local succeeded = pcall(function()
        values:elementAt(3)
    end)

    assertEqual(succeeded, false)
end)

test("elementAtOrDefault returns an item in range", function()
    local values = Enumerator3.create({ "first", "second" })
    assertEqual(values:elementAtOrDefault(2, "fallback"), "second")
end)

test("elementAtOrDefault returns the default out of range", function()
    local values = Enumerator3.create({ "first", "second" })
    assertEqual(values:elementAtOrDefault(3, "fallback"), "fallback")
end)

test("single returns the only item", function()
    local values = Enumerator3.create({ "only" })
    assertEqual(values:single(), "only")
end)

test("single returns the only matching item", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:single(function(value) return value == 2 end), 2)
end)

test("single errors when there are no matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local succeeded = pcall(function()
        values:single(function(value) return value > 3 end)
    end)

    assertEqual(succeeded, false)
end)

test("single errors when there are multiple matches", function()
    local values = Enumerator3.create({ 2, 4, 6 })
    local succeeded = pcall(function()
        values:single(function(value) return value % 2 == 0 end)
    end)

    assertEqual(succeeded, false)
end)

test("singleOrDefault returns the default when there are no matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:singleOrDefault(function(value) return value > 3 end, "default"), "default")
end)

test("singleOrDefault errors when there are multiple matches", function()
    local values = Enumerator3.create({ 2, 4, 6 })
    local succeeded = pcall(function()
        values:singleOrDefault(function(value) return value % 2 == 0 end, "default")
    end)

    assertEqual(succeeded, false)
end)

test("indexOf finds an item", function()
    local values = Enumerator3.create({ 3, 5, 7 })
    assertEqual(values:indexOf(5), 2)
end)

test("indexOf returns -1 when the item is missing", function()
    local values = Enumerator3.create({ 3, 5, 7 })
    assertEqual(values:indexOf(9), -1)
end)

test("indexOf uses a comparer", function()
    local values = Enumerator3.create({ { id = 3 }, { id = 5 }, { id = 7 } })
    local index = values:indexOf({ id = 5 }, function(left, right)
        return left.id == right.id
    end)

    assertEqual(index, 2)
end)

test("contains finds an item", function()
    local values = Enumerator3.create({ 3, 5, 7 })
    assertEqual(values:contains(5), true)
end)

test("contains returns false when the item is missing", function()
    local values = Enumerator3.create({ 3, 5, 7 })
    assertEqual(values:contains(9), false)
end)

test("contains uses a comparer", function()
    local values = Enumerator3.create({ { id = 3 }, { id = 5 }, { id = 7 } })
    local contains = values:contains({ id = 5 }, function(left, right)
        return left.id == right.id
    end)

    assertEqual(contains, true)
end)

test("sequenceEquals returns true for equal sequences", function()
    local values = Enumerator3.create({ 1, 2 })
    assertEqual(values:sequenceEquals({ 1, 2 }), true)
end)

test("sequenceEquals returns false for different values", function()
    local values = Enumerator3.create({ 1, 2 })
    assertEqual(values:sequenceEquals({ 1, 3 }), false)
end)

test("sequenceEquals returns false for different lengths", function()
    local values = Enumerator3.create({ 1, 2 })
    assertEqual(values:sequenceEquals({ 1, 2, 3 }), false)
end)

test("sequenceEquals uses a comparer", function()
    local values = Enumerator3.create({ { id = 1 }, { id = 2 } })
    local equalsById = values:sequenceEquals({ { id = 1 }, { id = 2 } }, function(left, right)
        return left.id == right.id
    end)

    assertEqual(equalsById, true)
end)

test("firstOrDefault returns the first value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:firstOrDefault(), 1)
end)

test("firstOrDefault returns the first matching value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:firstOrDefault(function(value) return value > 1 end), 2)
end)

test("firstOrDefault returns the default for an empty sequence", function()
    local values = Enumerator3.create({})
    assertEqual(values:firstOrDefault(nil, "default value"), "default value")
end)

test("first returns the first value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:first(), 1)
end)

test("first returns the first matching value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:first(function(value) return value > 1 end), 2)
end)

test("first errors when no value matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local succeeded = pcall(function()
        values:first(function(value) return value > 3 end)
    end)

    assertEqual(succeeded, false)
end)

test("lastOrDefault returns the last value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:lastOrDefault(), 3)
end)

test("lastOrDefault returns the last matching value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:lastOrDefault(function(value) return value < 3 end), 2)
end)

test("lastOrDefault returns the default for an empty sequence", function()
    local values = Enumerator3.create({})
    assertEqual(values:lastOrDefault(nil, "default value"), "default value")
end)

test("last returns the last value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:last(), 3)
end)

test("last returns the last matching value", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:last(function(value) return value < 3 end), 2)
end)

test("last errors when no value matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    local succeeded = pcall(function()
        values:last(function(value) return value > 3 end)
    end)

    assertEqual(succeeded, false)
end)

test("count returns the number of values", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:count(), 3)
end)

test("count returns zero for an empty sequence", function()
    local values = Enumerator3.create({})
    assertEqual(values:count(), 0)
end)

test("count counts values matching a predicate", function()
    local values = Enumerator3.create({ 1, 2, 3, 4 })
    local evenCount = values:count(function(value) return value % 2 == 0 end)

    assertEqual(evenCount, 2)
end)

test("all returns true when every value matches", function()
    local values = Enumerator3.create({ 2, 4, 6 })
    assertEqual(values:all(function(value) return value % 2 == 0 end), true)
end)

test("all returns false when a value does not match", function()
    local values = Enumerator3.create({ 2, 3, 6 })
    assertEqual(values:all(function(value) return value % 2 == 0 end), false)
end)

test("any returns true for a non-empty sequence", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:any(), true)
end)

test("any returns false for an empty sequence", function()
    local values = Enumerator3.create({})
    assertEqual(values:any(), false)
end)

test("any returns true when a value matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:any(function(value) return value == 2 end), true)
end)

test("any returns false when no value matches", function()
    local values = Enumerator3.create({ 1, 2, 3 })
    assertEqual(values:any(function(value) return value == 4 end), false)
end)

test("foreach", function()
    local total = 0
    local values = Enumerator3.create({ 1, 2, 3 })
    values:foreach(function(value) total = total + value end)

    assertEqual(total, 6)
end)

test("aggregate", function()
    local values = Enumerator3.create({ 2, 3, 4 })
    local result = values:aggregate(function(total, value) return total + value end)

    assertEqual(result, 9)
end)

test("aggregate using a seed", function()
    local values = Enumerator3.create({ 2, 3, 4 })
    local result = values:aggregate(function(total, value) return total + value end, 1)

    assertEqual(result, 10)
end)

test("aggregate using the result selector", function()
    local values = Enumerator3.create({ 2, 3, 4 })
    local result = values:aggregate(
        function(total, value) return total + value end,
        nil,
        function(total) return "total: " .. total end
    )

    assertEqual(result, "total: 9")
end)

test("max", function()
    local values = Enumerator3.create({ 2, 8, 4 })
    local maximum = values:max()

    assertEqual(maximum, 8)
end)

test("max with selector returns the matching item", function()
    local values = { { score = 2 }, { score = 9 }, { score = 4 } }
    local maximum = Enumerator3.create(values):max(function(item) return item.score end)

    assertEqual(maximum, values[2])
end)

test("min", function()
    local values = Enumerator3.create({ 2, 8, 4 })
    local minimum = values:min()

    assertEqual(minimum, 2)
end)

test("min with selector returns the matching item", function()
    local values = { { score = 2 }, { score = 9 }, { score = 4 } }
    local minimum = Enumerator3.create(values):min(function(item) return item.score end)

    assertEqual(minimum, values[1])
end)

test("sum", function()
    local values = Enumerator3.create({ 2, 3, 4 })
    local sum = values:sum()

    assertEqual(sum, 9)
end)

test("sum with selector", function()
    local values = Enumerator3.create({
        { score = 2 },
        { score = 3 },
        { score = 4 },
    })
    local sum = values:sum(function(item) return item.score end)

    assertEqual(sum, 9)
end)

test("sum errors for non-numeric strings", function()
    local values = Enumerator3.create({ "two", "three" })
    local succeeded = pcall(function()
        values:sum()
    end)

    assertEqual(succeeded, false)
end)

test("sum returns zero for an empty sequence", function()
    local values = Enumerator3.create({})
    assertEqual(values:sum(), 0)
end)
