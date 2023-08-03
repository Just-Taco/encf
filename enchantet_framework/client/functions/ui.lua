encf.menu = function()
    local ui = {}

    function ui:open(menu)
        SetNuiFocus(
            true --[[ boolean ]], 
            true --[[ boolean ]]
        )
        SendNUIMessage({
            open = 'menu',
            functions = menu
        })
    end

    function ui:openInput(header, event)
        SetNuiFocus(
            true --[[ boolean ]], 
            true --[[ boolean ]]
        )
        SendNUIMessage({
            open = 'input',
            header = header,
            event = event
        })
    end

    function ui:close()
        SetNuiFocus(
            false --[[ boolean ]], 
            false --[[ boolean ]]
        )
        SendNUIMessage({
            open = false,
        })
    end

    return ui
end

RegisterNUICallback('CallEvent', function(data)
    if not data.args and data.type == 'menu' then
        TriggerEvent(data.event)    
    elseif data.type == 'menu' and data.args then
        TriggerEvent(data.event, data.args) 
    elseif data.type == 'input' and data.input then
        TriggerEvent(data.event, data.input) 
    end
end)

RegisterNUICallback('Close', function(data)
    local menu = encf.menu()
    menu:close()
end)