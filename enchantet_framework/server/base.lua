exports('getFunctions', function() -- encf = exports['enchantet_framework']:getFunctions()
	return encf
end)


local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = encf.player(source)
    deferrals.defer()
    Wait(0)
    deferrals.update("Loading")
    if not player:id() then
        print('player didnt exist [CREATING]') 
        player:create() 
    end
    while not player:id() do
        Wait(10)
    end
    print('PLAYERID: '..player:id())
    if not player:banned() then
        if player:allowlisted() or not Config.allowlisted then
            deferrals.done()
        else
            deferrals.done("You not allowlisted on this server ID: "..player:id())
        end
    else
        deferrals.done("You are banned ID: "..player:id())
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)