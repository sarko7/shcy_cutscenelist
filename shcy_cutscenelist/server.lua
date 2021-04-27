RegisterNetEvent('shcy_cutscenelist:addCutsceneToFav')
AddEventHandler('shcy_cutscenelist:addCutsceneToFav', function(displayName, cutsceneName, x, y, z)
    local _src = source
    local ident = GetPlayerIdentifier(_src, 1)
    MySQL.Async.execute("INSERT INTO cutscenes_fav (license, cLabel, cName, x, y, z) VALUES (@a, @b, @c, @d, @e, @f)", {
        ['@a'] = ident,
        ['@b'] = displayName,
        ['@c'] = cutsceneName,
        ['@d'] = x,
        ['@e'] = y,
        ['@f'] = z
    }, function()
        print("C'est envoyé mon chef")
    end)
end)

RegisterNetEvent('shcy_cutscenelist:getFavOfPlayer')
AddEventHandler('shcy_cutscenelist:getFavOfPlayer', function()
    local _src = source
    local ident = GetPlayerIdentifier(_src, 1)

    MySQL.Async.fetchAll("SELECT * FROM cutscenes_fav WHERE license = @a", {
        ['@a'] = ident
    }, function(result)
        TriggerClientEvent('shcy_cutscenelist:getFavListFromServer', _src, result)
    end)
end)

RegisterNetEvent('shcy_cutscenelist:removeFav')
AddEventHandler('shcy_cutscenelist:removeFav', function(cutsceneName)
    local _src = source
    local ident = GetPlayerIdentifier(_src, 1)
    MySQL.Async.execute("DELETE FROM cutscenes_fav WHERE license = @a AND cName = @b", {
        ['@a'] = ident,
        ['@b'] = cutsceneName
    })
end)