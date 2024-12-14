local webhook = ""
local playerDisconnected = false  


RegisterCommand("combat", function(source, args, rawcmd)
    TriggerClientEvent("combatlog:show", source)
    if not playerDisconnected then
        TriggerClientEvent("ox_lib:notify", source, {
            title = "CombatLog",
            description = "Žádný hráč se neodpojil ve tvém okolí",
            type = "inform"
        })
    end
end)


AddEventHandler("playerDropped", function(reason)
    local source = source
    local crds = GetEntityCoords(GetPlayerPed(source))
    local id = source
    local identifier = ""
    if Config.UseSteam then
        identifier = GetPlayerIdentifier(source, 0)
    else
        identifier = GetPlayerIdentifier(source, 1)
    end


    TriggerClientEvent("combatlog", -1, id, crds, identifier, reason)

    if Config.LogSystem then
        SendLog(id, crds, identifier, reason)
    end


    playerDisconnected = true
end)





function SendLog(id, crds, identifier, reason)
    local name = GetPlayerName(id)
    local date = os.date('*t')


    print("id:"..id)
    print("X: "..crds.x..", Y: "..crds.y..", Z: "..crds.z)
    print("identifier:"..identifier)
    print("reason:"..reason)


    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local formattedDate = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')


    local embeds = {
        {
            ["title"] = "Player Disconnected",
            ["type"] = "rich",
            ["color"] = 4777493,  
            ["fields"] = {
                {
                    ["name"] = "Identifier",
                    ["value"] = identifier,
                    ["inline"] = true,
                },
                {
                    ["name"] = "Nickname",
                    ["value"] = name,
                    ["inline"] = true,
                },
                {
                    ["name"] = "Player's ID",
                    ["value"] = id,
                    ["inline"] = true,
                },
                {
                    ["name"] = "Coordinates",
                    ["value"] = "X: "..crds.x..", Y: "..crds.y..", Z: "..crds.z,
                    ["inline"] = true,
                },
                {
                    ["name"] = "Reason",
                    ["value"] = reason,
                    ["inline"] = true,
                },
            },
            ["footer"] = {
                ["icon_url"] = "https://forum.fivem.net/uploads/default/original/4X/7/5/e/75ef9fcabc1abea8fce0ebd0236a4132710fcb2e.png",
                ["text"] = "Sent: " .. formattedDate,
            },
        }
    }


    PerformHttpRequest(Config.Webhook, function(err, text, headers)
        if err == 200 then
            print("Webhook message sent successfully.")
        else
            print("Error sending webhook message: " .. err)
        end
    end, 'POST', json.encode({ username = Config.LogBotName, embeds = embeds }), { ['Content-Type'] = 'application/json' })
end