package.path = package.path .. ";./?.lua"

dofile("tests/enumerator_transform.test.lua")
dofile("tests/enumerator_query.test.lua")
dofile("tests/enumerator_collection.test.lua")
dofile("tests/enumerator_alias.test.lua")
