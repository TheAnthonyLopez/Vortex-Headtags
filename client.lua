local headtag = "~c~None"
local gangtag = "~c~None"
local showTags = {}

RegisterCommand("headtag", function()
    local availableTags = {}
    for _, tag in ipairs(Config.Tags) do
        if IsPlayerAceAllowed(PlayerId(), tag.ace) then
            table.insert(availableTags, tag.headtag)
        end
    end
    if #availableTags == 0 then
        lib.notify({title = 'Headtag', description = 'You do not have access to any headtags.', type = 'error'})
        return
    end
    local selection = lib.inputDialog("Select Headtag", { {type = "select", label = "Headtag", options = availableTags} })
    if selection then
        headtag = availableTags[selection[1]]
        lib.notify({title = 'Headtag', description = 'Headtag enabled!', type = 'success'})
    end
end)

RegisterCommand("gangtag", function()
    local availableTags = {}
    for _, tag in ipairs(Config.Tags) do
        if IsPlayerAceAllowed(PlayerId(), tag.ace) then
            table.insert(availableTags, tag.gangtag)
        end
    end
    if #availableTags == 0 then
        lib.notify({title = 'Gangtag', description = 'You do not have access to any gangtags.', type = 'error'})
        return
    end
    local selection = lib.inputDialog("Select Gangtag", { {type = "select", label = "Gangtag", options = availableTags} })
    if selection then
        gangtag = availableTags[selection[1]]
        lib.notify({title = 'Gangtag', description = 'Gangtag enabled!', type = 'success'})
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for _, player in ipairs(GetActivePlayers()) do
            if player ~= PlayerId() then
                local ped = GetPlayerPed(player)
                if #(GetEntityCoords(ped) - coords) < 20.0 then
                    DrawText3D(GetEntityCoords(ped) + vector3(0, 0, 1.2), headtag)
                    DrawText3D(GetEntityCoords(ped) + vector3(0, 0, 1.0), gangtag)
                end
            end
        end

        DrawHUDTag("Headtag", headtag, 0.85, 0.1)
        DrawHUDTag("Gangtag", gangtag, 0.85, 0.14)
    end
end)

function DrawHUDTag(title, tag, x, y)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.3, 0.3)
    SetTextColour(255, 153, 51, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(string.format("%s: %s", title, tag))
    DrawText(x, y)
end

function DrawText3D(coords, text)
    local x, y, z = table.unpack(coords)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = #(p - coords)

    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0, 0.3 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
