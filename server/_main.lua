ESX = nil TriggerEvent(_Config.getESX, function(obj) ESX = obj end)

ESX.RegisterServerCallback('rz-core:getPlayerData', function(source, cb)
    if (source) then
        local xPlayer = ESX.GetPlayerFromId(source)
        local playerCash, playerDirtyCash, playerBank
        local PlayerTable = {}
        if (xPlayer) then
            if (not (_Config.useCalif)) then
                playerCash = xPlayer.getMoney()
                playerDirtyCash = xPlayer.getAccount('black_money').money
                playerBank = xPlayer.getAccount('bank').money
            else
                playerCash = xPlayer.getAccount("cash").money
                playerDirtyCash = xPlayer.getAccount("dirtycash").money
                playerBank = xPlayer.getAccount("bank").money
            end
            if (_Config.SQLWrapperType) == 1 then
                MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                    ['@identifier'] = xPlayer.identifier
                }, function(result)
                    for _,playerInfo in pairs(result) do
                        PlayerTable[#PlayerTable+1] = {
                            firstname = playerInfo.firstname,
                            lastname = playerInfo.lastname,
                            dateofbirth = playerInfo.dateofbirth,
                            job = xPlayer.job.label,
                            job2 = xPlayer.job2.label,
                            cash = playerCash,
                            black = playerDirtyCash,
                            bank = playerBank,
                            sex = playerInfo.sex,
                            height = playerInfo.height
                        }
                    end
                    cb(PlayerTable)
                end)
            elseif (_Config.SQLWrapperType) == 2 then
                MySQL.query('SELECT * FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
                    for _,playerInfo in pairs(result) do
                        PlayerTable[#PlayerTable+1] = {
                            firstname = playerInfo.firstname,
                            lastname = playerInfo.lastname,
                            dateofbirth = playerInfo.dateofbirth,
                            job = xPlayer.job.label,
                            job2 = xPlayer.job2.label,
                            cash = playerCash,
                            black = playerDirtyCash,
                            bank = playerBank,
                            sex = playerInfo.sex,
                            height = playerInfo.height
                        }
                    end
                    cb(PlayerTable)
                end)
            else
                print("[Error] Failed to retrieve SQLWrapperType.")
            end
        else
            print("[Error] Failed to retrieve player.")
        end
    else
        print("[Error] Failed to retrieve source.")
    end
end)