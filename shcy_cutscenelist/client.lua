local cutscenesListMenu = RageUI.CreateMenu("", "CUTSCENES LIST")
local favListMenu = RageUI.CreateSubMenu(cutscenesListMenu, "", "FAVORITE CUTSCENES LIST")
local cutscenesListSubMenu = RageUI.CreateSubMenu(cutscenesListMenu, "", "CUTSCENES ACTIONS")
local cutscenesCoordsMenu = RageUI.CreateSubMenu(cutscenesListSubMenu, "", "CUTSCENES POSITION")
local addToFavMenu = RageUI.CreateSubMenu(cutscenesListSubMenu, "", "CUTSCENES ADD FAVORITE")
local cutscenesCoordsMenu2 = RageUI.CreateSubMenu(addToFavMenu, "", "CUTSCENES POSITION")
local actualCutscene, favCutscenes, playerClone
local canStart, isAlreadyInFav = false, false
local x, y, z = 0, 0, 0
local cutsceneDisplayName = "Set a name"

cutscenesListMenu.Closed = function() menuOpen = false end
cutscenesListSubMenu.Closed = function() actualCutscene = nil end

makeMenu = function()
    Citizen.CreateThread(function()
        while menuOpen do
            RageUI.IsVisible(cutscenesListMenu, function()
                RageUI.Button("Favourites", nil, {RightLabel = "→"}, true, {onSelected = function()  end}, favListMenu)
                RageUI.Separator("↓ List ↓")
                for k,v in pairs(Config.CutscenesList) do
                    RageUI.Button(v, nil, {RightLabel = "→"}, true, {onSelected = function() actualCutscene = v for k2,v2 in pairs(favCutscenes) do if v2.cName == v then isAlreadyInFav = true end end  end}, cutscenesListSubMenu)
                end
            end, function() end)

            RageUI.IsVisible(favListMenu, function()
                if #favCutscenes > 0 then
                    for k,v in pairs(favCutscenes) do
                        RageUI.Button(v.cLabel, v.cName, {RightLabel = "→"}, true, {onSelected = function() x = v.x y = v.y z = v.z canStart = true actualCutscene = v.cName for k,v in pairs(favCutscenes) do if v.cName == actualCutscene then isAlreadyInFav = true end end end}, cutscenesListSubMenu)
                    end
                else
                    RageUI.Separator("→ No cutscene in favorites ←")
                end
            end, function() end)

            RageUI.IsVisible(cutscenesListSubMenu, function()
                RageUI.Separator("→ X = "..(x+0.0).." | Y = "..(y+0.0).." | Z = "..(z+0.0).." ←")
                RageUI.Separator("↓ Cutscene config ↓")
                RageUI.Button("Set coords of the cutscene", nil, {RightLabel = "→"}, true, {onSelected = function() end}, cutscenesCoordsMenu)
                if x ~= 0 or y ~= 0 or z ~= 0 then
                    RageUI.Button("~r~Reset coords of the cutscene", nil, {RightLabel = "→"}, true, {onSelected = function() x = 0 y = 0 z = 0 end})
                end
                RageUI.Separator("↓ Actions ↓")
                if isAlreadyInFav then
                    RageUI.Button("~r~Remove from favourites", nil, {RightLabel = "→"}, true, {onSelected = function() isAlreadyInFav = false TriggerServerEvent("shcy_cutscenelist:removeFav", actualCutscene) deleteInTable(actualCutscene) end})
                else
                    RageUI.Button("Add to favourites", nil, {RightLabel = "→"}, true, {}, addToFavMenu)
                end
                RageUI.Button("Play", nil, {RightLabel = "→"}, canStart, {onSelected = function() cutseneStart(actualCutscene) end})
                if IsCutscenePlaying() then
                    RageUI.Button("Stop", nil, {RightLabel = "→"}, true, {onSelected = function() StopCutsceneImmediately() end})
                end
            end, function() end)

            RageUI.IsVisible(cutscenesCoordsMenu, function()
                RageUI.Button("X Position", nil, {RightLabel = x+0.00}, true, {onSelected = function() x = KeyboardInput("Set the approximatively X position of the cutscene", "", 10) end})
                RageUI.Button("Y Position", nil, {RightLabel = y+0.00}, true, {onSelected = function() y = KeyboardInput("Set the approximatively Y position of the cutscene", "", 10) end})
                RageUI.Button("Z Position", nil, {RightLabel = z+0.00}, true, {onSelected = function() z = KeyboardInput("Set the approximatively Z position of the cutscene", "", 10) end})
                RageUI.Button("Validate", nil, {RightLabel = "→"}, true, {onSelected = function() canStart = true end}, cutscenesListSubMenu)
            end, function() end)

            RageUI.IsVisible(cutscenesCoordsMenu2, function()
                RageUI.Button("X Position", nil, {RightLabel = x+0.00}, true, {onSelected = function() x = KeyboardInput("Set the approximatively X position of the cutscene", "", 10) end})
                RageUI.Button("Y Position", nil, {RightLabel = y+0.00}, true, {onSelected = function() y = KeyboardInput("Set the approximatively Y position of the cutscene", "", 10) end})
                RageUI.Button("Z Position", nil, {RightLabel = z+0.00}, true, {onSelected = function() z = KeyboardInput("Set the approximatively Z position of the cutscene", "", 10) end})
                RageUI.Button("Validate", nil, {RightLabel = "→"}, true, {onSelected = function()  end}, addToFavMenu)
            end, function() end)

            RageUI.IsVisible(addToFavMenu, function()
                RageUI.Button("Name to display", "Default is: "..actualCutscene, {RightLabel = cutsceneDisplayName}, true, {onSelected = function() cutsceneDisplayName = KeyboardInput("Set the name to display", "", 50) end})
                RageUI.Button("Set coords of the cutscene", nil, {RightLabel = "→"}, true, {onSelected = function() end}, cutscenesCoordsMenu2)
                RageUI.Button("Validate", nil, {RightLabel = "→"}, true, {onSelected = function() TriggerServerEvent('shcy_cutscenelist:addCutsceneToFav', cutsceneDisplayName, actualCutscene, x, y, z) cutsceneDisplayName = "Set a Name" x, y, z = 0, 0, 0 isAlreadyInFav = true TriggerServerEvent('shcy_cutscenelist:getFavOfPlayer') end}, cutscenesListSubMenu)
            end, function() end)

            Citizen.Wait(1)
        end
    end)
end

cutseneStart = function(cutsceneName)
    local plyrId = PlayerPedId()
    local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)

        RequestCutscene(cutsceneName, 8) 
    
        while not (HasCutsceneLoaded()) do
            Wait(0)
        end

    SetBlockingOfNonTemporaryEvents(playerClone, true)
    SetEntityVisible(playerClone, false, false)
    SetEntityInvincible(playerClone, true)
    SetEntityCollision(playerClone, false, false)
    FreezeEntityPosition(playerClone, true)
    SetPedHelmet(playerClone, false)
    RemovePedHelmet(playerClone, true)

    SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
    RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)

    SetCutsceneEntityStreamingFlags('MP_2', 0, 1)
    RegisterEntityForCutscene(plyrId, 'MP_2', 3, GetEntityModel(plyrId), 64)

    SetCutsceneEntityStreamingFlags('MP_3', 0, 1)
    RegisterEntityForCutscene(plyrId, 'MP_3', 3, GetEntityModel(plyrId), 64)

    SetCutsceneEntityStreamingFlags('MP_4', 0, 1)
    RegisterEntityForCutscene(plyrId, 'MP_4', 3, GetEntityModel(plyrId), 64)
    
    RequestCollisionAtCoord(x, y, z)

    Wait(10)
    StartCutscene(0)
    Wait(10)
    ClonePedToTarget(playerClone, plyrId)
    Wait(10)
    DeleteEntity(playerClone)
    playerClone = nil
end

deleteInTable = function(cutscene)
    for k,v in pairs(favCutscenes) do
        if v.cName == actualCutscene then
            table.remove(favCutscenes, k)
            return
        end
    end
end

function notif(msg)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
        if RageUI.Visible(cutscenesCoordsMenu) then
            return result
        elseif RageUI.Visible(cutscenesCoordsMenu2) then
            return tonumber(result)
        else
            return result
        end
	else
		Citizen.Wait(500)
		blockinput = false
        if RageUI.Visible(addToFavMenu) then
		    return "Set a name"
        elseif RageUI.Visible(cutscenesCoordsMenu) then
            return 0
        else
            return 0
        end
	end
end

RegisterNetEvent('shcy_cutscenelist:getFavListFromServer')
AddEventHandler('shcy_cutscenelist:getFavListFromServer', function(favList)
    favCutscenes = favList
end)

RegisterCommand("cutscenesList", function(src, args, raw)
    menuOpen = true
    makeMenu()
    TriggerServerEvent('shcy_cutscenelist:getFavOfPlayer')
    RageUI.Visible(cutscenesListMenu, not RageUI.Visible(cutscenesListMenu))
end, false)