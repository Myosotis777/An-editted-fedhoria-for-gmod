
if SERVER then return end
local fd_firstperson= CreateClientConVar("fd_firstperson", "0", true, false, "Enter the ragdolls point of view when dead")
CreateClientConVar("fd_firstperson_nearclip", "1", true, false, "Higher values work better with masks", 0.01, 5)
CreateClientConVar("fd_firstperson_force", "0", true, false, "Always go into first person even when the model isn't supported")
local Death_cam=CreateConVar("special_cam","1",bit.bor(FCVAR_ARCHIVE), "Fedhoria_death Cam Type")
local Death_Camera_Distance=CreateClientConVar("fed_camera_distance","50",{FCVAR_ARCHIVE}, "Fedhoria death damera distance")
local Fed_znear=CreateClientConVar("fed_z_near","0.3",{FCVAR_ARCHIVE}, "Fedhoria death damera znear")
local function PopulateSBXToolMenu(pnl)
    pnl:CheckBox("Enabled", "fedhoria_enabled")
    pnl:ControlHelp("Enable or disable the addon.")

    pnl:CheckBox("Players", "fedhoria_players")
    pnl:ControlHelp("Enable or disable effect for players.")

    pnl:CheckBox("NPCs", "fedhoria_npcs")
    pnl:ControlHelp("Enable or disable effect for NPCs.")
    
	pnl:CheckBox("Facial Effect", "sv_fedhoria_facial")
    pnl:ControlHelp("Enable or disable effect for Facial.")
	
	pnl:CheckBox("fd_firstperson", "fd_firstperson")
    pnl:ControlHelp("First Person Death.")
	
	pnl:NumSlider("Facial Time", "sv_fedhoria_facial_duaration",0,30,3)
    pnl:ControlHelp("表情变化的持续时间，注意要小于die time.")
	
	pnl:NumSlider("Random_scale", "sv_fedhoria_facial_random", 0, 1, 3)
    pnl:ControlHelp("表情变化的随机性，会在最大值和最小值之间选择随机数，随机性越小则最后的结果越倾向于最大值（可能会导致眼皮嘴巴抽风，建议保持0.3不变）")
	
	pnl:NumSlider("Death_FOV", "fed_fov",0,100,3)
    pnl:ControlHelp("渐进式死亡视角的镜头FOV，如果不改变就调成0，注意不要调的太小")
	
	pnl:NumSlider("Death_FOV_time", "fed_fov_duration",0,10,3)
    pnl:ControlHelp("渐进式死亡视角拉近所需要的时间，以防过大的fov变化导致您的视力出现问题")
	
	
	pnl:NumSlider("fed_camera_distance", "fed_camera_distance",-100,100,3)
    pnl:ControlHelp("非渐进式死亡视角的镜头距离，如果不改变就调成0，注意不要调的太大")
	
	pnl:NumSlider("Znear", "fed_z_near",0,30,3)
    pnl:ControlHelp("非渐进式死亡视角的贴地程度，如果不改变就调成0，注意不要调的太大")
	
	pnl:CheckBox("RagdollsCollideWithPlayers", "sv_playerragdolls_collide_players")
    pnl:ControlHelp("Enable or disable Ragdoll Collide With Players.")
	
	pnl:CheckBox("Ragdolls More Than 1", "sv_playerragdolls_complex")
    pnl:ControlHelp("Enable or disable Ragdoll Collide With Players.")
	
	pnl:NumSlider("Remove Timer", "sv_playerragdoll_remove",0,300,3)
    pnl:ControlHelp("Enable or disable Ragdoll Remove.")
	
    pnl:NumSlider("Stumble time", "fedhoria_stumble_time", 0, 10, 3)
    pnl:ControlHelp("How long the ragdoll should stumble for.")
	pnl:ControlHelp("Note: Recommended value 7")

    pnl:NumSlider("Die time", "fedhoria_dietime", 0, 100, 3)
    pnl:ControlHelp("How long before the ragdoll dies after drowning/being still for too long.")
	pnl:ControlHelp("Note: Recommended value 7")

    pnl:NumSlider("Wound grab chance", "fedhoria_woundgrab_chance", 0, 1, 3)
    pnl:ControlHelp("The chance the ragdoll will grab it's wound when shot.")

    pnl:NumSlider("Wound grab time", "fedhoria_woundgrab_time", 0, 10, 3)
    pnl:ControlHelp("How long the ragdoll should hold its wound.")
	
	pnl:NumSlider("Citizen overkill hit", "fedhoria_overkill_citizen_hit", 0, 10, 0)
	pnl:ControlHelp("How many hits to overkill an npc_citizen. 0 = do not spawn dummy target.")
	pnl:ControlHelp("Note: Upon taken this hit number, the overkill still lasts for at least 1 secound for 6 hit or 1.8 secound.")
	
	pnl:NumSlider("Combine overkill hit", "fedhoria_overkill_combine_hit", 0, 10, 0)
	pnl:ControlHelp("How many hits to overkill an npc_combine_s.")
	
	pnl:NumSlider("Player overkill hit", "fedhoria_overkill_player_hit", 0, 10, 0)
	pnl:ControlHelp("How many hits to overkill an player.")
	
	pnl:NumSlider("Citizen health", "fedhoria_citizen_health", 0, 100, 0)
	pnl:ControlHelp("Set all spawn_menu's npc_citizen health to the given value. 0 = default")
	pnl:ControlHelp("Note: Recommended value 5")

	pnl:CheckBox("Ragdoll no collide", "fedhoria_ragdoll_nocollide")
    pnl:ControlHelp("Ragdolls only collide to world and bullets.")
	
	
	
end

if engine.ActiveGamemode() == "sandbox" then
    hook.Add("AddToolMenuCategories", "FedhoriaCategory", function() 
        spawnmenu.AddToolCategory("Utilities", "Fedhoria", "Fedhoria")
    end)

    hook.Add("PopulateToolMenu", "FedhoriaMenuSettings", function() 
        spawnmenu.AddToolMenuOption("Utilities", "Fedhoria", "FedhoriaSettings", "Settings", "", "", function(pnl)
            pnl:ClearControls()
            PopulateSBXToolMenu(pnl)
        end)
    end)
end


--util.AddNetworkString("RagdollVariable")

hook.Add( "CalcView", "Fedhoria_edited", function( ply, pos, angles, fov )
    --print(ply:Nick())
	if not (GetConVar("fedhoria_enabled"):GetBool() and GetConVar("fedhoria_players"):GetBool()) then return end

	net.Receive("Fedhoria_Ragdoll", function()
    local  countt = net.ReadInt(32)
	local  owner = net.ReadEntity()
	       countn=countt
		   ownerp=owner
	       --print(countn)
    end)


	
	
    if (ply:Alive() ) or not Death_cam:GetBool() then  return end
	
	local ragdoll
	allragdoll=ents.FindByClass("prop_ragdoll")
	for dir,x in pairs (allragdoll) do
	--print(countn)--and (x:GetOwner() == ply)
	    if  (countn==x:EntIndex() and ownerp == ply) then --&& x.DeathInfo == ply:Nick()  x:EntIndex() == countt and 
		
		ragdoll=x
		break
	    end
	end
	
	--local rd = util.TraceLine({start=ragdoll:GetPos(),endpos=ragdoll:GetPos()-angles:Forward()*105,filter={ragdoll,LocalPlayer()}})
	
	
--    net.Start("RagdollVariable")
    
	--ragdoll=ply:GetObserverTarget()
    
     if fd_firstperson:GetBool() and IsValid(ragdoll) then --and ragdoll.DeathInfo == ply:GetName().."'s ragdoll" 
	 local head={
	       Pos = ragdoll:EyePos(),
           Ang = ragdoll:EyeAngles()
	       }
	      
	       head = ragdoll:GetAttachment( ragdoll:LookupAttachment( "eyes" ) )
		   
	      -- headPos = ragdoll:GetBonePosition(ragdoll:LookupBone("ValveBiped.Bip01_Head"))
          -- headAng = ragdoll:GetBoneMatrix(ragdoll:LookupBone("ValveBiped.Bip01_Head")):GetAngles()
        --PrintMessage(HUD_PRINTTALK)
        -- 设置玩家的位置和角度
        local view = {
              
              angles = head.Ang,
			  origin = head.Pos +head.Ang:Forward()*1 ,--微调摄像头的位置
              fov = fov,
              drawviewer = true,
			  znear = GetConVar("fd_firstperson_nearclip"):GetFloat(),
			  zfar=3000
              }
			  
	        return view
	 else
	   local rd = util.TraceLine({start=ragdoll:GetPos(),endpos=ragdoll:GetPos()-angles:Forward()*75,filter={ragdoll,LocalPlayer()}})
       local view={origin=ragdoll:GetPos()-angles:Forward()*(100*rd.Fraction)+angles:Forward()*Death_Camera_Distance:GetFloat()-Vector(0,0,0.1)*Fed_znear:GetFloat(),angles=angles,fov=fov,znear=Fed_znear} 
	   return view
     end  
	
end)
