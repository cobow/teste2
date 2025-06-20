local ESX = exports.es_extended:getSharedObject()

RegisterServerEvent("Kaito:closest")
AddEventHandler("Kaito:closest", function()
    local player = ESX.GetPlayerFromId(source)
    local item = player.getInventoryItem(Kaito.NomItemCagoule)
    local itemCount = item.count
    local playerName = GetPlayerName(source)
    
    if itemCount >= 1 then
        local targetName = GetPlayerName(najblizszy)
        player.removeInventoryItem(Kaito.NomItemCagoule, 1)
        TriggerClientEvent("Kaito:nalozNa", najblizszy)
        
        local logData = {
            author = {
                name = KaitoLogs.DescriptionLogs,
                icon_url = KaitoLogs.IconLogs
            },
            color = KaitoLogs.CouleurLogs,
            title = "KaitoCagoule",
            description = string.format("Le joueur %s [ID %s] a mis une cagoule sur %s [ID : %s]", playerName, source, targetName, najblizszy),
            footer = {
                text = string.format("📅 %s", os.date("%d/%m/%Y | %X")),
                icon_url = nil
            }
        }

        PerformHttpRequest(KaitoLogs.LogsCagouleMise, function() end, "POST", json.encode({
            username = KaitoLogs.NameLogs,
            embeds = { logData },
            avatar_url = KaitoLogs.IconLogs
        }), { ["Content-Type"] = "application/json" })
    else
        TriggerClientEvent(Kaito.TriggerNotif, source, Kaito.Notifications.MessagePasDeCagoule)
    end
end)

RegisterServerEvent("Kaito:sendclosest")
AddEventHandler("Kaito:sendclosest", function(targetPlayer)
    najblizszy = targetPlayer
end)

RegisterServerEvent("Kaito:zdejmij")
AddEventHandler("Kaito:zdejmij", function()
    local player = ESX.GetPlayerFromId(source)
    local playerName = GetPlayerName(source)
    local targetName = GetPlayerName(najblizszy)

    player.addInventoryItem(Kaito.NomItemCagoule, 1)
    TriggerClientEvent("Kaito:zdejmijc", najblizszy)
    TriggerClientEvent("sadomaso", najblizszy)

    local logData = {
        author = {
            name = KaitoLogs.DescriptionLogs,
            icon_url = KaitoLogs.IconLogs
        },
        color = KaitoLogs.CouleurLogs,
        title = "KaitoCagoule",
        description = string.format("Le joueur %s [ID : %s] a retiré la cagoule de %s [ID : %s]", playerName, source, targetName, najblizszy),
        footer = {
            text = string.format("📅 %s", os.date("%d/%m/%Y | %X")),
            icon_url = nil
        }
    }

    PerformHttpRequest(KaitoLogs.LogsCagouleRetirer, function() end, "POST", json.encode({
        username = KaitoLogs.NameLogs,
        embeds = { logData },
        avatar_url = KaitoLogs.IconLogs
    }), { ["Content-Type"] = "application/json" })
end)

RegisterServerEvent('ox_inventory:useItem')
AddEventHandler('ox_inventory:useItem', function(item)
    if item.name == 'sacp' then
        local src = source
        local xPlayer = ESX.GetPlayerFromId(src)

        local invItem = xPlayer.getInventoryItem('sacp')
        if invItem and invItem.count > 0 then
            xPlayer.removeInventoryItem('sacp', 1)
            TriggerClientEvent("Kaito:nalozNa", src)
        else
            TriggerClientEvent(Kaito.TriggerNotif, src, {
                title = 'Erreur',
                description = 'Tu n\'as pas de cagoule !',
                type = 'error',
                position = 'top-center'
            })
        end
    end
end)

