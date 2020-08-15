ESX = nil
local PlayerData = {}
isWorking = false
local npcs = {}
local blipLocs = {}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job 
end)
Citizen.CreateThread(function()
    local blips = Config.blipLocations
    -- radar_michael_family
    -- 78
    for k in pairs(blips) do
        local blip = AddBlipForCoord(blips[k].x, blips[k].y, blips[k].z)
        SetBlipSprite(blip, 78)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, 51) -- salmon (orange-like)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Mama John's")
        EndTextCommandSetBlipName(blip)
    end
end)
Citizen.CreateThread(function()
    local coords = Config.pizzaPlaceLocations
    for k in pairs(coords) do
        npc = CreatePed(4, 0xA1435105, coords[k].x, coords[k].y, coords[k].z, coords[k].h, false, true)
        SetEntityHeading(npc, coords[k].h)
	    SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        Citizen.Wait(500)
        FreezeEntityPosition(npc, true)
    end
end)
Citizen.CreateThread(function()
    local coords = Config.mopedLocations
    for k in pairs(coords) do
        vehiclehash = GetHashKey(Config.mopedVehicle)
        RequestModel(vehiclehash)
        CreateVehicle(vehiclehash, coords[k].x, coords[k].y, coords[k].z, coords[k].h, 1, 0)
    end
end)


Citizen.CreateThread(function()
    local coords = Config.workLocations
    while true do
        for k in pairs(coords) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, coords[k].x, coords[k].y, coords[k].z)
            if dist <= 1 then
                if isWorking then
                    YMDrawText3D(coords[k].x, coords[k].y, coords[k].z, "Press ~y~[E]~w~ to ~y~deliver a pizza~w~, or press ~y~[Q]~w~ to ~y~end your shift")
                    if IsControlJustReleased(1, 44) then
                        isWorking = false
                        TriggerEvent('esx:showNotification', 'You ~g~ended your shift~w~.')
                        TriggerServerEvent('esx_pizzajob:removeInventoryItem', 'pizza', 1)
                        TriggerServerEvent('esx_pizzajob:setOnDuty', false)
                        for i, blip in pairs(blipLocs) do
                            RemoveBlip(blip)
                        end
                        for i, npc in pairs(npcs) do
                            SetEntityAsNoLongerNeeded(npc)
                        end
                    end
                else
                    YMDrawText3D(coords[k].x, coords[k].y, coords[k].z, "Press ~y~[E]~w~ to ~y~start working.")
                end
                if IsControlJustPressed(1, 38) then
                    TriggerEvent('esx_pizzajob:startWork')
                end
            end
        end
        Citizen.Wait(0)
    end
end)
Citizen.CreateThread(function()
    while true do
        if Config.buyPizza then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local coords = Config.pizzaPlaceLocations
            for k in pairs(coords) do
                local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, coords[k].x, coords[k].y, coords[k].z)
                if dist <= 2 then
                    YMDrawText3D(coords[k].x, coords[k].y, coords[k].z, "Press ~y~[E]~w~ to ~y~buy a pizza~w~ for $10")
                    if IsControlJustReleased(1, 38) then
                        if ESX.PlayerData.money > 10 then
                            if isWorking then
                                TriggerEvent('esx:showNotification', "~r~You can't buy pizza while you're working!")
                            else
                                TriggerServerEvent('esx_pizzajob:addInventoryItem', 'pizza', 1)
                            end
                        else
                            TriggerEvent('esx:showNotification', "~r~You don't have enough money!")
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)
RegisterNetEvent('esx_pizzajob:startWork')
AddEventHandler('esx_pizzajob:startWork', function()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'pizzaJob' then
        isWorking = true
        TriggerServerEvent('esx_pizzajob:setOnDuty', true)
        if ESX.PlayerData.job.grade_name == 'deliveryDriver' and not isGoingToLocation then
            for i, npc in pairs(npcs) do
                SetEntityAsNoLongerNeeded(npc)
            end
            TriggerServerEvent('esx_pizzajob:addInventoryItem', 'pizza', 1)
            local coords = Config.deliverLocations
            local numOfLocations = 0
            for k in pairs(coords) do
                numOfLocations = numOfLocations + 1
            end
            for i, blip in pairs(blipLocs) do
                RemoveBlip(blip)
            end
            local location = math.random(numOfLocations)
            location = coords[location]
            local blip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipSprite(blip, 130)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.75)
            SetBlipColour(blip, 36)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Delivery Location")
            EndTextCommandSetBlipName(blip)
            table.insert(blipLocs, blip)
            local head = math.random(100, 200)
            local npc = CreatePed(4, 0xA1435105, location.x + 2, location.y, location.z, head, false, true)
            SetEntityHeading(head)
	        SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            Citizen.Wait(3000)
            FreezeEntityPosition(npc, true)
            local isGoingToLocation = true
            while isGoingToLocation do
                Citizen.Wait(0)
                local playerCoords = GetEntityCoords(PlayerPedId())
                local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, location.x, location.y, location.z)
                if dist <= 3 then
                    YMDrawText3D(location.x, location.y, location.z, "Press ~y~[E]~w~ to ~y~make the delivery")
                    if IsControlJustReleased(1, 38) then
                        tip = math.random(15)
                        isGoingToLocation = false
                        TriggerServerEvent('esx_pizzajob:payMoney', math.floor(tip))
                        TriggerServerEvent('esx_pizzajob:removeInventoryItem', 'pizza', 1)
                        TriggerEvent('esx:showNotification', 'You were tipped ~g~$'..math.floor(tip))
                        TriggerEvent('esx:showNotification', 'Delivery ~g~finished~w~. Head back to the pizzeria.')
                        RemoveBlip(blip)
                    end
                end
            end
        else
            if isGoingToLocation then
                TriggerEvent('esx:showNotification', '~r~You are already delivering a pizza!')
            end
        end
    else
        TriggerEvent('esx:showNotification', '~r~You do not work at Mama Johns!')
    end
end)
function YMDrawText3D(x,y,z, text) local onScreen,_x,_y=World3dToScreen2d(x,y,z) local px,py,pz=table.unpack(GetGameplayCamCoords()) SetTextScale(0.35, 0.35) SetTextFont(4) SetTextProportional(1) SetTextColour(255, 255, 255, 215) SetTextEntry("STRING") SetTextCentre(1) AddTextComponentString(text) DrawText(_x,_y) local factor = (string.len(text)) / 370 DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68) end