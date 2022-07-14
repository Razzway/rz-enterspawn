local ESX, isMenuOpen, connect, loading, FirstSpawn, PlayerLoaded = nil, false, false, 0.0, true, false
TriggerEvent(_Config.getESX, function(obj) ESX = obj end)

local camera = {
    [1] = {pos = {-1598.49, 2116.57, 80.56}, rot = -230.0},
    [2] = {pos = {701.47, 1031.08, 330.57}, rot = 0.0},
    [3] = {pos = {-462.49, 1215.36, 342.14}, rot = 190.0},
    [4] = {pos = {3333.91, 5148.46, 27.29}, rot = -110.0}
}

local chance = math.random(1, 4)
local selectedCamera = camera[chance]

local connectMenu = RageUI.CreateMenu("Connexion", "Sélection du personnage")
connectMenu.Closable = false
connectMenu.Closed = function()
    isMenuOpen = false
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true
end)

function getPlayerInfo()
    dataPlayer = {}
    ESX.TriggerServerCallback('rz-core:getPlayerData', function(data)
        dataPlayer = data
    end)
end

AddEventHandler('playerSpawned', function()
    CreateThread(function()
        while (not (PlayerLoaded)) do Wait(10) end
        if (FirstSpawn) then
            ESX.TriggerServerCallback(_Config.skinEvent..':getPlayerSkin', function(skin, jobSkin)
                if skin ~= nil then
                    TriggerEvent(_Config.skinchangerEvent..':loadSkin', skin)
                    startAnim()
                end
            end)
            FirstSpawn = false
        end
    end)
end)

function openConnectMenu()
    if (isMenuOpen) then
        return
    end
    isMenuOpen = true
    RageUI.Visible(connectMenu, true)
    getPlayerInfo()
    CreateThread(function()
        while (isMenuOpen) do
            Wait(0)
            RageUI.IsVisible(connectMenu, function()
                for i = 1, #(dataPlayer), 1 do
                    local playerSex;
                    if (dataPlayer[i].sex) == "m" then playerSex = "Homme" else playerSex = "Femme" end
                    RageUI.Line()
                    RageUI.Info("Vos informations", {
                        ("Nom : %s"):format(dataPlayer[i].lastname), ("Prénom : %s"):format(dataPlayer[i].firstname),
                        ("Taille : %s"):format(dataPlayer[i].height), ("Né le : ~p~%s~s~"):format(dataPlayer[i].dateofbirth),
                        ("Job : ~y~%s~s~"):format(dataPlayer[i].job)
                    }, {
                        ("Sexe : %s"):format(playerSex),
                        ("Cash : ~g~%s~s~"):format(dataPlayer[i].cash), ("Non déclaré : ~r~%s~s~"):format(dataPlayer[i].black),
                        ("Banque : ~b~%s~s~"):format(dataPlayer[i].bank), ("Organisation : ~o~%s~s~"):format(dataPlayer[i].job2)
                    })
                    RageUI.Button(("%s %s"):format(dataPlayer[i].firstname, dataPlayer[i].lastname), "Nous vous souhaitons un bon retour parmi nous ! Merci d'appuyez sur la touche entrer pour charger vos données.", {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "→"}, true, {
                        onSelected = function()
                            connect = true
                        end
                    })
                    if (connect) then
                        RageUI.PercentagePanel(loading, "Chargement de vos données... ~b~"..math.floor(loading*100).."%", "", "", {})
                        if (loading) < 1.0 then
                            loading = loading + 0.002
                        else
                            loading = 0
                        end
                        if loading >= 1.0 then
                            valid()
                        end
                    end
                end
            end)
        end
    end)
end

function startAnim()
    DoScreenFadeOut(1500)
    Wait(1500)
    FreezeEntityPosition(PlayerPedId(), true)
    SetEntityVisible(PlayerPedId(), false, 0)
    NetworkOverrideClockTime(20, 0, 0)
    connectCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", false)
    SetCamActive(connectCam, true)
    SetCamCoord(connectCam, selectedCamera.pos[1], selectedCamera.pos[2], selectedCamera.pos[3])
    ShakeCam(connectCam, "HAND_SHAKE", 0.2)
    SetCamRot(connectCam, -0, -0, selectedCamera.rot)
    SetCamActive(connectCam, true)
    RenderScriptCams(1, 0, 500, false, false)
    RenderScriptCams(true, false, 2000, true, true)
    DisplayRadar(false)
    openConnectMenu()
end

function valid()
    DoScreenFadeOut(1500)
    Wait(2000)
    RenderScriptCams(false, false, 0, true, true)
    Wait(1000)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityVisible(PlayerPedId(), true, 0)
    RageUI.CloseAll()
    isMenuOpen = false
    DoScreenFadeIn(2000)
    DestroyAllCams(true)
    ESX.ShowNotification("~b~Connexion au vocal établie.")
    ESX.ShowNotification("~b~Vous avez été replacé à votre ancienne position.")
    DisplayRadar(true)
end
