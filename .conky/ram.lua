function conky_ram_used_total()
    local mem = tonumber(conky_parse('${memperc}')) * 38.6
    local swap = tonumber(conky_parse('${swapperc}')) * 25.4
    return math.floor((mem + swap)) / 100
end
