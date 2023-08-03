encf.error = function(CFunction, errors)
    local file = io.open("ERRORS.txt", "a")
    file:write("\n["..os.date().."] Function: "..CFunction.." Error: "..errors)
    file:close()
end