local assert = {}

function assert.equals(actual, expected, message)
    if actual ~= expected then
        error((message or "values differ") .. ": expected " .. tostring(expected) ..
            ", got " .. tostring(actual), 2)
    end
end

function assert.sequenceEquals(actual, expected)
    local nextValue, state, index
    if type(actual.ipairs) == "function" then
        nextValue, state, index = actual:ipairs()
    else
        nextValue, state, index = ipairs(actual)
    end

    for position, expectedValue in ipairs(expected) do
        local actualIndex, actualValue = nextValue(state, index)
        assert.equals(actualIndex ~= nil, true, "sequence ended at item " .. position)
        assert.equals(actualValue, expectedValue, "sequence item " .. position)
        index = actualIndex
    end

    local actualIndex = nextValue(state, index)
    assert.equals(actualIndex, nil, "sequence has extra items")
end

return assert