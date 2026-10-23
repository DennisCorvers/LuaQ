# LuaQ

LuaQ is a reusable Lua library for working with iterables through a fluent
Enumerable API.

## Usage

```lua
local LuaQ = require("src.enumerable")

local result = LuaQ.from({ 1, 2, 3, 4 })
    :where(function(value) return value % 2 == 0 end)
    :map(function(value) return value * 10 end)
    :toTable()
```

## Tests

Run the test suite from the repository root with Lua:

```powershell
lua tests\enumerable_test.lua
```
