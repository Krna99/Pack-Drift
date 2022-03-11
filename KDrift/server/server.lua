TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("Krna:PayDrift")
AddEventHandler("Krna:PayDrift", function(prix)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeMoney(prix)
    TriggerClientEvent('esx:showNotification', source, '<C>Drift ~y~KrnaBase\n~s~Vous avez payé ~g~'..prix..' $ ~s~pour le Drift')
end)