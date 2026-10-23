package.path = package.path .. ";./?.lua"

dofile("tests/enumerable_transform.test.lua")
dofile("tests/enumerable_query.test.lua")
dofile("tests/enumerable_collection.test.lua")
dofile("tests/enumerable_alias.test.lua")
dofile("tests/enumerable_github.test.lua")
