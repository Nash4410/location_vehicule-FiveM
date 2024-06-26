local Cooldown = false
local cfg_location = {
    {vehicule = "faggio3", prix = 300, vehicule = "Faggio", couleur_texte = "~y~", ped = "a_m_y_smartcaspat_01", blips = 134, couleur = 5, size = 0.8, pos_ped = {x = -1261.06, y = -577.95, z = 27.58, h = 255.507}, spawn = {x = -1255.97, y = -580.0, z = 27.59, h = 253.814}, taille_place = 0.7},
    {vehicule = "scorcher", prix = 120, vehicule = "Scorcher", couleur_texte = "~y~", ped = "a_m_y_runner_02", blips = 134, couleur = 5, size = 0.8, pos_ped = {x = -1109.63, y = -1694.18, z = 3.56, h = 303.749}, spawn = {x = -1110.25, y = -1698.53, z = 3.07, h = 34.477}, taille_place = 0.6},
    {vehicule = "seashark", prix = 450, vehicule = "Jetski", couleur_texte = "~y~", ped = "csb_chin_goon", blips = 134, couleur = 5, size = 0.8, pos_ped = {x = -190.82, y = 790.5, z = 197.11, h = 103.956}, spawn = {x = -186.77, y = 791.33, z = 196.32, h = 145.053}, taille_place = 1.4},
    {vehicule = "sanchez", prix = 500, vehicule = "Sanchez", couleur_texte = "~y~", ped = "csb_maude", blips = 134, couleur = 5, size = 0.8, pos_ped = {x = 119.25, y = 6626.72, z = 30.96, h = 230.1505}, spawn = {x = 123.91, y = 6625.0, z = 31.29, h = 135.181}, taille_place = 0.8},
}  

Citizen.CreateThread(function()

    for _,b in pairs(cfg_location) do
        local blip = AddBlipForCoord(b.pos_ped.x, b.pos_ped.y, b.pos_ped.z)
        SetBlipSprite(blip, b.blips)
        SetBlipColour(blip, b.couleur)
        SetBlipScale(blip, b.size)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString("Location")
        EndTextCommandSetBlipName(blip)
    end

    for _,v in pairs(cfg_location) do
        local hash = GetHashKey(v.ped)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Wait(20)
        end
        ped = CreatePed("Ped", v.ped, v.pos_ped.x, v.pos_ped.y, v.pos_ped.z, v.pos_ped.h, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
    end
    
    while true do
        local Timer = 750
        for _,k in pairs(cfg_location) do

            local pedId = PlayerPedId()
            local plyCoords = GetEntityCoords(pedId, false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, k.pos_ped.x, k.pos_ped.y, k.pos_ped.z)
            local spawn_dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, k.spawn.x, k.spawn.y, k.spawn.z)

            if dist <= 2.4 and not IsDead then
                DrawText3D(k.pos_ped.x, k.pos_ped.y, k.pos_ped.z + 2.1, "Appuyez sur "..k.couleur_texte.."E~s~ pour louer un(e) "..k.vehicule.."\n~g~"..k.prix.."$")
                if IsControlJustPressed(1,51) then
                    if not Cooldown then
                        if not IsPedInAnyVehicle(pedId, false) then
                            local checkvehicle = GetClosestVehicle(k.spawn.x, k.spawn.y, k.spawn.z, k.taille_place, 0, 71)
                            local vehicleModel = GetEntityModel(checkvehicle)

                            if not DoesEntityExist(checkvehicle) then
                                TriggerServerEvent('location:payment', k.vehicule,k.prix,k.spawn.x,k.spawn.y,k.spawn.z,k.spawn.h)
                                Cooldown = true
                                Citizen.SetTimeout(30000, function()
                                    Cooldown = false
                                end)
                            else

                                if(vehicleModel == GetHashKey(k.vehicule))then
                                ESX.ShowNotification("~r~Un véhicule de location est déjà présent sur la place")
                                else
                                    DeleteEntity(checkvehicle)
                                    Wait(300)
                                    TriggerServerEvent('location:payment', k.vehicule,k.prix,k.spawn.x,k.spawn.y,k.spawn.z,k.spawn.h)
                                    Cooldown = true
                                    Citizen.SetTimeout(30000, function()
                                        Cooldown = false
                                    end)
                                end
                            end
                        else 
                            ESX.ShowNotification("~r~Vous ne pouvez pas faire de location en étant dans un véhicule")
                        end
                    else
                        ESX.ShowNotification("~r~Vous devez patienter entre chaque location")
                    end
                end   
                Timer = 3
            end
            if IsPedInAnyVehicle(pedId, false) and spawn_dist <= k.taille_place then
                Timer = 3
                local vehicle = GetVehiclePedIsIn(pedId, false)
                local vehicleModel = GetEntityModel(vehicle)
                if(vehicleModel ~= GetHashKey(k.vehicule))then
                    ESX.ShowNotification("~r~Attention, vous êtes sur une place réservée aux locations")
                end
            end
        end
        Citizen.Wait(Timer)
    end
end)