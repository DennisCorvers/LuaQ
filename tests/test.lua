return function(name, run)
    local ok, message = pcall(run)
    if not ok then
        error(name .. ": " .. tostring(message), 0)
    end
    print("ok - " .. name)
end