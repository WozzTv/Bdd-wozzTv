---------------------------------------------------------------------
                --[[SCRIPT MADE BY : ALEXMIHAI04]]--
               --[[DO NOT SELL OR COPY THIS SCRIPT]]--
                   --[[github.com/ItsAlexYTB]]--
        --[[ENJOY THE SCRIPT , DO NOT MAKE 1000 NPCS :))))) ]]
---------------------------------------------------------------------

--[[EXPLANATION [EN]: 

-1,2,3 : Coordonates
-4 : Name for the drawtext
-5 : Ped heading
-6 : Ped hash
-7: Ped model

]]--

--[[DO NOT TOUCH IF YOU DON'T KNOW WHAT YOU DO]]--

--[[EXPLANATION [RO]
-1,2,3 : sunt coordonatele de la npc
-4 : Numele care apare deasupra npc-ului
-5 : Heading (partea in care sta orientat)
-6 : Hash de la ped , se poate lua de pe net
-7 : Modelul de la ped , asemenea , il gasiti pe net


]]--

local coordonate = {
    {1242.43,-491.71,68.71,"",258.32,0x9760192E,"cs_bankman"},
    {-276.75,303.51,89.72,"",356.39,0xE497BBEF,"s_m_y_dealer_01"},
    {482.24,204.62,103.74,"",241.72,0xE497BBEF,"s_m_y_dealer_01"},
    {2738.33,1471.974,23.50145,"",253.1420135498,0x2EFEAFD5,"s_m_m_chemsec_01"},
    {1026.913,-3101.379,-39.99987,"",81.817283630371,0x5746CD96,"ig_bestmen"}
}

Citizen.CreateThread(function()

    for _,v in pairs(coordonate) do
      RequestModel(GetHashKey(v[7]))
      while not HasModelLoaded(GetHashKey(v[7])) do
        Wait(1)
      end
  
      RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
      end
      ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
      SetEntityHeading(ped, v[5])
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      TaskPlayAnim(ped,"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        Citizen.Wait(0)
        for _,v in pairs(coordonate) do
            x = v[1]
            y = v[2]
            z = v[3]
            if(Vdist(pos.x, pos.y, pos.z, x, y, z) < 20.0)then
                DrawText3D(x,y,z+2.10, "~g~"..v[4], 1.2, 1)
                DrawText3D(x,y,z+1.95, "~w~", 1.0, 1)
            end
        end
    end
end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

--[[ENJOY]]--