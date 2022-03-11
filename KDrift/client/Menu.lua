Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

  local driftlip = AddBlipForCoord(DriftCFG.PosMenu)
  SetBlipSprite(driftlip, 545)
  SetBlipColour(driftlip, 63)
  SetBlipScale(driftlip, 0.60)
  SetBlipAsShortRange(driftlip, true)
  SetBlipSprite(driftlipradius,1)
  SetBlipColour(driftlipradius,1)
  SetBlipAlpha(driftlipradius,75)
  BeginTextCommandSetBlipName('STRING')
  AddTextComponentString("Drift")
  EndTextCommandSetBlipName(driftlip)

  local hash = GetHashKey(DriftCFG.Ped)
  while not HasModelLoaded(hash) do
  RequestModel(hash)
    Wait(20)
  end
  ped = CreatePed("PED_TYPE_CIVFEMALE", DriftCFG.Ped, DriftCFG.PosMenu.x, DriftCFG.PosMenu.y, DriftCFG.PosMenu.z-1, DriftCFG.h, false, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  FreezeEntityPosition(ped, true)
  SetEntityInvincible(Ped, true)
end)

local open = false 
local KrnaDrift = RageUI.CreateMenu('~u~DRIFT', ' ')
KrnaDrift.Display.Header = true 
KrnaDrift.Closed = function()
  RageUI.Visible(KrnaDrift, false)
  open = false
end

function OpenMenuDrift()
  if open then 
    open = false
    RageUI.Visible(KrnaDrift, false)
    return
  else
    open = true 
    RageUI.Visible(KrnaDrift, true)
    CreateThread(function()
      while open do 
        RageUI.IsVisible(KrnaDrift,function() 

          RageUI.Separator('Bienvenue ~r~'..GetPlayerName(PlayerId())..'~s~ au Circuit~y~ '..DriftCFG.NomBase, 18)
          RageUI.Separator("")
          RageUI.Separator("~b~Attention : Séance de dix minutes")
          RageUI.Separator("~h~Toute sortie du véhicule sera définitive !")

          RageUI.Separator("~r~↓ Voiture Disponible ↓")

          for i = 1, #DriftCFG.DriftCar do
            local v = DriftCFG.DriftCar[i]

              RageUI.Button("~h~→ "..v.nom, nil, {RightLabel = "~g~"..v.prix.." $"}, true , {
                onSelected = function()
                  TriggerServerEvent('Krna:PayDrift', v.prix)
                  local model = GetHashKey(v.car)
                  RequestModel(model)
                  while not HasModelLoaded(model) do Wait(10) end
                  local Driftveh = CreateVehicle(model, v.spawn, v.h, true, false)
                  SetVehicleNumberPlateText(Driftveh, "Drift"..math.random(50, 999))
                  SetVehicleFixed(Driftveh)                      
                  TaskWarpPedIntoVehicle(PlayerPedId(),  Driftveh,  -1)
                  SetVehRadioStation(Driftveh, 0)
                  KrnaDrift.Closed()
                  Drift10min(v.car, Driftveh)
                  end
                })

          end


        end)
      Wait(0)
      end
    end)
  end
end

Citizen.CreateThread(function()
  while true do
    local wait = 750
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, DriftCFG.PosMenu)

    if dist < 4.0 then
      wait = 0
      DrawMarker(22, DriftCFG.PosMenu, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, true, p19, true)  
      Visual.Subtitle("Appuyez sur ~r~[E]~s~ pour vous inscrire au ~r~Drift ", 1)
      if IsControlJustPressed(1,51) then
        OpenMenuDrift()
      end
    end
  Citizen.Wait(wait)
  end
end)


function Drift10min(car)
  local car = GetHashKey(car)
  local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)

  RequestModel(car)
  while not HasModelLoaded(car) do
      RequestModel(car)
      Citizen.Wait(0)
  end
ESX.ShowNotification("<C>Drift ~y~"..DriftCFG.NomBase.."\n~s~Vous avez ~r~ 10 Minutes de Drift.")
local timer = 600
local breakable = false
breakable = false
while not breakable do
  Wait(1000)
  timer = timer - 1
  while IsPedInAnyVehicle(PlayerPedId()) == false do
    Wait(10)
    DeleteEntity(veh)
    ESX.ShowNotification("<C>Drift ~y~"..DriftCFG.NomBase.."\n~r~Vous avez quittez votre Voiture, la séance est terminé.")
    breakable = true
    break
  end
  if timer == 300 then
    ESX.ShowNotification("<C>>Drift ~y~"..DriftCFG.NomBase.."\n~r~Il ne vous reste plus que 5 Minutes.")
  end
  if timer == 60 then
    ESX.ShowNotification("<C>>Drift ~y~"..DriftCFG.NomBase.."\n~r~Il ne vous reste plus que 1 Minutes.")
  end
  if timer <= 0 then
    local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
    DeleteEntity(veh)
    ESX.ShowNotification("<C>Drift ~y~"..DriftCFG.NomBase.."\n~r~Vous avez terminé la période de Drift.")
    breakable = true
    break
  end
end
end
