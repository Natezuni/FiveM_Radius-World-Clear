RegisterCommand('radiusclear', function(source, args, raw)
    if args[1] then
        local radius = tonumber(args[1])

        if not radius then
            TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Invalid radius provided")

            return
        end

        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local vehicles = GetAllVehicles()
        local peds = GetAllPeds()
        local objects = GetAllObjects()

        local count = 0

        -- Function to calculate distance
        local function getDistance(x1, y1, z1, x2, y2, z2)
            return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
        end

        -- Clear vehicles
        for _, vehicle in pairs(vehicles) do

            local vehCoords = GetEntityCoords(vehicle)
            local distance = getDistance(playerCoords.x, playerCoords.y, playerCoords.z, vehCoords.x, vehCoords.y, vehCoords.z)

            if distance <= radius then
                local isOccupied = false
                for _, player in ipairs(GetPlayers()) do
                    if GetVehiclePedIsIn(GetPlayerPed(player), false) == vehicle then
                        isOccupied = true
                        break
                    end
                end

                if not isOccupied then
                    DeleteEntity(vehicle)
                    count = count + 1
                end
            end
        end

        -- Clear peds
        for _, ped in pairs(peds) do
            local pedCoords = GetEntityCoords(ped)
            local distance = getDistance(playerCoords.x, playerCoords.y, playerCoords.z, pedCoords.x, pedCoords.y, pedCoords.z)
            if distance <= radius then
                DeleteEntity(ped)
                count = count + 1
            end
        end

        -- Clear objects
        for _, obj in pairs(objects) do
            local objCoords = GetEntityCoords(obj)
            local distance = getDistance(playerCoords.x, playerCoords.y, playerCoords.z, objCoords.x, objCoords.y, objCoords.z)
            if distance <= radius then
                DeleteEntity(obj)
                count = count + 1
            end
        end

        TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Cleard ".. count .. " entities")
    end
end, true)
