maxDistance = 200000



Mairie = {
    name = "Mairie",
    cameras = {
        {name="cam1",x = 184056.640625,y = 191137.84375, z = 7077.0434570313},
        {name="cam2",x = 185818.640625,y=191219.25,z =7093.6474609375},
        {name="cam3",x = 185808.0625,y=192819.734375,z =7093.221679687},
        {name="cam4",x = 186839.125,y=193903.578125,z =6962.982421875}
        },
    pc = {186639,194048,6820}
}

Buildings = {Mairie}


function drawSphere()
    for _, building in pairs(Buildings) do
        for _,camera in pairs(building.cameras) do
            print("|> "..camera.name.." created")
            CreateObject(337, camera.x, camera.y, camera.z) -- Debug only
            AddCommand(camera.name, function (player)
                plySetCameraLocation(player,camera.x,camera.y,camera.z)
            end)
        end
    end
end

function GetNearestMonitoringPc(player)
    local px,py,pz = GetPlayerLocation(player)
    for k, building in pairs(Buildings) do
        local distance = GetDistance3D(px, py, pz, building.pc[1],building.pc[2],building.pc[3])
        if distance < maxDistance then
            CallRemoteEvent(player, "SetMonitorPcDatas",json_encode(building),k)
            return
        end
    end
end

AddRemoteEvent("GetBuildingDatas", function(player)
    GetNearestMonitoringPc(player)
end)

function plySetCameraLocation(player,x,y,z)
    SetPlayerLocation(player, x, y, z)
    CallRemoteEvent(player,"CameraLocation",x,y,z+175)
end

AddRemoteEvent("DisplayCamera", function (player,camId,buildingId)
    local cx,cy,cz = Buildings[buildingId].cameras[camId].x,Buildings[buildingId].cameras[camId].y,Buildings[buildingId].cameras[camId].z
    plySetCameraLocation(player,cx,cy,cz)
end)

AddRemoteEvent("ResetPlayer",function (player,x,y,z)
    print(x,y,z)
    SetPlayerLocation(player, tonumber(x), tonumber(y), tonumber(z))
end)


AddEvent("OnPackageStart", function()
    drawSphere()
end)


AddCommand("test", function (player)
    CallRemoteEvent(player, "WorldToScreenPly")
end)

-- Doors

Jail = {
    models = {15,16},
    name = "Block-C",
    cells = {}, --init later
    center = {-179595.515,75116.906,2216.872},
    radius = 50000
}

Doors={Jail}

AddCommand("jd", function (player)
    SetDoors(player)
end)



function SetDoors(player)
    local doors = GetAllDoors()
    for _, door in pairs(doors) do
        if GetDoorModel(door) == 15 or GetDoorModel(door) == 16 then
            print(door)
            CallRemoteEvent(player,"DoorWayPoint",door)
        end
    end
end






