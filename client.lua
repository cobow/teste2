local ESX = exports.es_extended:getSharedObject()
local isWearing = false
local isCagouleOn = false

-- Mettre la cagoule
RegisterNetEvent("Kaito:nalozNa", function()
    local playerPed = PlayerPedId()
    if isCagouleOn then
        TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.CagouleAlready)
        return
    end

    lib.progressBar({
        duration = 3500,
        label = 'Enfilage de la cagoule...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            combat = true,
            mouse = false,
            car = true
        }
    })

    SetPedComponentVariation(playerPed, 1, Kaito.Cagoule.male["mask_1"], Kaito.Cagoule.male["mask_2"], 2)
    isCagouleOn = true
    isWearing = true
    TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.CagouleMise)

    -- Ã‰cran noir simulÃ© + dÃ©sactivation partielle
CreateThread(function()
    while isCagouleOn do
        if IsPedAPlayer(PlayerPedId()) then
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 255)

            -- Bloquer les contrÃ´les sauf mouvement
            DisableControlAction(0, 25, true)  -- Aim
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 75, true)  -- Exit vehicle
            DisableControlAction(0, 199, true) -- Pause menu
            DisableControlAction(0, 20, true)  -- Z
            DisableControlAction(0, 37, true)  -- TAB
            DisableControlAction(0, 200, true) -- ESC
            DisableControlAction(0, 322, true)
        end
        Wait(0)
    end
end)

end)

-- Retirer la cagoule
RegisterNetEvent("Kaito:zdejmijc", function()
    local playerPed = PlayerPedId()
    if not isCagouleOn then
        TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.CagouleAlreadyRetirer)
        return
    end

    lib.progressBar({
        duration = 3000,
        label = 'Retrait de la cagoule...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            combat = true,
            mouse = false,
            car = true
        }
    })

    SetPedComponentVariation(playerPed, 1, Kaito.SansCagoule.male["mask_1"], Kaito.SansCagoule.male["mask_2"], 2)
    isCagouleOn = false
    isWearing = false
    TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.MessageYouRetireCagoule)
end)

-- Effet bonus (utilisÃ© dans server.lua)
RegisterNetEvent("sadomaso", function()
    DoScreenFadeOut(500)
    Wait(1000)
    DoScreenFadeIn(1000)
end)

-- Commande pour mettre une cagoule Ã  une personne proche
RegisterCommand("putcagoule", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance <= Kaito.DistanceMaxPourCagoule then
        TriggerServerEvent("Kaito:sendclosest", GetPlayerServerId(player))
        Wait(100)
        TriggerServerEvent("Kaito:closest")
    else
        TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.Proximiter)
    end
end)

-- Commande pour retirer la cagoule Ã  une personne proche
RegisterCommand("removecagoule", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if player ~= -1 and distance <= Kaito.DistanceMaxPourCagoule then
        TriggerServerEvent("Kaito:sendclosest", GetPlayerServerId(player))
        Wait(100)
        TriggerServerEvent("Kaito:zdejmij")
    else
        TriggerEvent(Kaito.TriggerNotif, Kaito.Notifications.Proximiter)
    end
end)

-- FONCTION : Interaction ox_target pour mettre une cagoule
local function putCagouleOnPlayer(entity)
    local playerId = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(playerId)

    if serverId then
        TriggerServerEvent("Kaito:sendclosest", serverId)
        Wait(100)
        TriggerServerEvent("Kaito:closest")
    end
end

-- FONCTION : Interaction ox_target pour retirer la cagoule
local function removeCagouleFromPlayer(entity)
    local playerId = NetworkGetPlayerIndexFromPed(entity)
    local serverId = GetPlayerServerId(playerId)

    if serverId then
        TriggerServerEvent("Kaito:sendclosest", serverId)
        Wait(100)
        TriggerServerEvent("Kaito:zdejmij")
    end
end

-- Enregistrement de l'option ox_target
exports('AddCagouleTarget', function()
    exports.ox_target:addGlobalPlayer({
        {
            icon = Kaito.IconMettreCagoule or 'fa-solid fa-mask',
            label = 'Mettre une cagoule',
            distance = 2.0,
            canInteract = function(entity)
                return true
            end,
            onSelect = function(data)
                putCagouleOnPlayer(data.entity)
            end
        },
        {
            icon = Kaito.IconRetirerCagoule or 'fa-solid fa-mask',
            label = 'Retirer la cagoule',
            distance = 2.0,
            canInteract = function(entity)
                return true
            end,
            onSelect = function(data)
                removeCagouleFromPlayer(data.entity)
            end
        }
    })
end)

-- Initialisation automatique
CreateThread(function()
    exports.KaitoCagoule:AddCagouleTarget()
end)
