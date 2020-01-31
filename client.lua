local pc_ui = nil
local cam_ui = nil
local scale
local building_index
local dx,dy,dz

local UI_SHOWN = 0
local UI_HIDDEN = 1
local UIState = UI_SHOWN

function CreatePcUI()
    local screenX,screenY = GetScreenSize()
    scale = (screenX-200)/1920
    pc_ui = CreateWebUI( ((screenX-(screenX*scale))/2), ((screenY-(screenY*scale))/2),0,0,5,60)
    LoadWebFile(pc_ui,"http://asset/"..GetPackageName().."/security/ui/html/pc.html")
    SetWebAlignment(pc_ui,0,0)
    SetWebAnchors(pc_ui,0.0,0.0,1.0,1.0)
    SetWebVisibility(pc_ui,WEB_HIDDEN)
end

function CreateCamUI()
    local screenX,screenY = GetScreenSize()
    cam_ui = CreateWebUI( 0,0,0,0,5,60)
    LoadWebFile(cam_ui,"http://asset/"..GetPackageName().."/security/ui/html/overlay.html")
    SetWebAlignment(cam_ui,0,0)
    SetWebAnchors(cam_ui,0.0,0.0,1.0,1.0)
    SetWebVisibility(cam_ui,WEB_HIDDEN)
end

function DisplayPcUI()
    CreatePcUI()
    SetInputMode(INPUT_UI)
    ShowMouseCursor(true)
end

function DisplayCamUI()
    CreateCamUI()
end

function ChangeHUDVisibility()
    if UIState == UI_SHOWN then
        UIState = UI_HIDDEN
        ShowChat(false)
        ShowHealthHUD(false)
        ShowWeaponHUD(false)
    else
        UIState = UI_SHOWN
        ShowChat(true)
        ShowHealthHUD(true)
        ShowWeaponHUD(true)
    end
end

AddEvent("DestroyPcUI", function ()
    if pc_ui == nil then return end
    DestroyWebUI(pc_ui)
    SetInputMode(INPUT_GAME)
    ShowMouseCursor(false)
    pc_ui = nil
end)

AddEvent("DestroyCamUI", function ()
    if cam_ui == nil then return end
    DestroyWebUI(cam_ui)
    SetInputMode(INPUT_GAME)
    ShowMouseCursor(false)
    ChangeHUDVisibility()
    cam_ui = nil
end)

AddEvent("OnKeyPress", function(key)
    if key ~= "B" then return end
    if pc_ui ~= nil then return end
    DisplayPcUI()
end)

AddEvent("OnKeyPress", function(key)
    if key ~= "X" then return end
    if cam_ui ~= nil then
        CallEvent("DestroyCamUI")
        ResetPlayer()
        DisplayPcUI()
    end
end)

AddEvent("OnWebLoadComplete", function(web)
    if web ~= pc_ui then return end
    ExecuteWebJS(pc_ui, "changeScale("..scale..")")
    SetWebVisibility(pc_ui, WEB_VISIBLE)
    CallRemoteEvent("GetBuildingDatas",player)
end)

AddEvent("DisplayCamView",function (camId)
    CallRemoteEvent("DisplayCamera",tonumber(camId),building_index)
    SetWebVisibility(pc_ui, WEB_HIDDEN)
    DisplayCamUI()
    ChangeHUDVisibility()
    SetWebVisibility(cam_ui,WEB_VISIBLE)
end)

AddRemoteEvent("SetMonitorPcDatas",function (jsonDatas,index)
    ExecuteWebJS(pc_ui,"setBuildingDatas("..jsonDatas..")")
    building_index = index
    dx,dy,dz = GetPlayerLocation()
    SetInputMode(INPUT_GAME)
end)

AddRemoteEvent("CameraLocation", function (x,y,z)
    GetPlayerActor(GetPlayerId()):SetActorEnableCollision(false) --SetActorScale3D(FVector(0.01, 0.01, 0.01))
    GetPlayerActor(GetPlayerId()):SetActorScale3D(FVector(0.01, 0.01, 0.01))
    SetIgnoreMoveInput(true)
end)

AddRemoteEvent("DoorWayPoint",function(door)
    dx,dy,dz = GetDoorLocation(door)
    CreateWaypoint(tonumber(dx), tonumber(dy), tonumber(dz), tostring(door))
end)

function ResetPlayer()
    AddPlayerChat("| "..dx.." "..dy.." "..dz.." |")
    CallRemoteEvent("ResetPlayer",dx,dy,dz)
    GetPlayerActor(GetPlayerId()):SetActorEnableCollision(true) --SetActorScale3D(FVector(0.01, 0.01, 0.01))
    GetPlayerActor(GetPlayerId()):SetActorScale3D(FVector(1,1,1))
    SetIgnoreMoveInput(false)
end

AddRemoteEvent("WorldToScreenPly", function ()
    WorldToScreen(186639,194048,6820)
end)





