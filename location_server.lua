RegisterNetEvent('location:payment')
AddEventHandler('location:payment', function(vehicule, prix, x, y, z, h)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xMoney = xPlayer.getMoney()

    if xMoney >= prix then
        TriggerClientEvent('esx:showNotification', source, "~g~Vous avez payé "..prix.. "$ pour une location")
        xPlayer.removeMoney(prix)
        local location = CreateVehicle(vehicule, x, y, z, h, true, false)
        SetPedIntoVehicle(source, location , -1)
    else
        TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d'argent")
    end
end)