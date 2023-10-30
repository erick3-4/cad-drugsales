local Framework = {}

if Config.Framework == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()
    local PlayerData = QBCore.Functions.GetPlayerData()

    function Framework:Notify(text)
        return QBCore.Functions.Notify(text)
    end

    function Framework:GetCurrentJob()
        return PlayerData.job
    end

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        PlayerData = val
    end)

    if Config.Inventory ~= 'ox' then
        function Framework:GetItemLabel(item)
            return QBCore.Shared.Items[item]['label'] or 'Unknown'
        end
    end
    if Config.Inventory == 'oldqb' then
        function Framework:GetItemCount(item)
            local amount = 0
            for _, v in pairs(PlayerData.items) do
                if v.name == item then
                    amount = v.amount
                    break
                end
            end
            return amount
        end
    end
end

if Config.Framework == 'esx' then
    local ESX = exports.es_extended:getSharedObject()

    function Framework:Notify(text)
        ESX.ShowNotification(text, 'success', 3000)
    end

    function Framework:GetCurrentJob()
        local playerData = ESX.GetPlayerData()
        return playerData.job
    end
end

if Config.Inventory == 'ox' then
    local items = exports.ox_inventory:Items()

    function Framework:GetItemLabel(item)
        return items[item].label or 'Unknown'
    end

    function Framework:GetItemCount(item)
		return exports.ox_inventory:Search('count', item)
    end
end

if Config.Inventory == 'qb' then
    function Framework:GetItemCount(item)
        return exports['qb-Inventory']:HasItem(item)
    end
end

if Config.Target == 'ox' then
    function Framework:AddGlobalPed(options)
        exports.ox_target:addGlobalPed(options)
    end

    function Framework:AddGlobalVehicle(options)
        exports.ox_target:addGlobalVehicle(options)
    end

    function Framework:RemoveGlobalPed(optionNames)
        exports.ox_target:removeGlobalPed(optionNames)
    end

    function Framework:RemoveGlobalVehicle(optionNames)
        exports.ox_target:removeGlobalVehicle(optionNames)
    end
end

if Config.Target == 'qb' then
    function Framework:AddGlobalPed(options)
        exports['qb-target']:AddGlobalPed({
            options = options,
            distance = 4,
        })
    end

    function Framework:AddGlobalVehicle(options)
        exports['qb-target']:AddGlobalVehicle({
			options = options,
			distance = 4,
		})
    end

    function Framework:RemoveGlobalPed(optionNames)
        exports['qb-target']:RemoveGlobalPed(optionNames)
    end

    function Framework:RemoveGlobalVehicle(optionNames)
        exports['qb-target']:RemoveGlobalVehicle(optionNames)
    end
end

if Config.Radial == 'qb' then
    function Framework:AddRadial()
        exports['qb-radialmenu']:AddOption({
            id = 'caddrugsales',
            title = 'Corner Selling',
            icon = 'cannabis',
            type = 'client',
            event = 'cad-drugsales:toggleselling',
            shouldClose = true
        })
    end
end

if Config.Radial == 'ox' then
    function Framework:AddRadial()
        lib.addRadialItem({
            id = 'caddrugsales',
            label = 'Corner Selling',
            icon = 'cannabis',
            event = 'cad-drugsales:toggleselling'
        })
    end
end

if Config.Dispatch == 'ps' then
    function Framework:PoliceAlert()
        exports['ps-dispatch']:DrugSale()
    end
end

if Config.Dispatch == 'qb' then
    function Framework:PoliceAlert()
        TriggerServerEvent('police:server:policeAlert', 'Drug sale in progress')
    end
end

function Framework:GetSellItems(zone)
    if Config.SellAnywhere then
        return Config.SellItems
    else
        return zone.items
    end
end

return Framework