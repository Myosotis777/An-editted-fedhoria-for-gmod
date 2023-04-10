AddCSLuaFile('autorun/client/fedh_menu.lua')
include("fedhoria/modules.lua")
--include("firstperson_death.lua")
local enabled 	= CreateConVar("fedhoria_enabled", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local players 	= CreateConVar("fedhoria_players", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local npcs 		= CreateConVar("fedhoria_npcs", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local noc 		= CreateConVar("fedhoria_ragdoll_nocollide", 1, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))
local Removetime=CreateConVar("sv_playerragdoll_remove","20",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "RAG REMOVE")
local RagdollsCollideWithPlayers = CreateConVar("sv_playerragdolls_collide_players", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Whether player corpses should collide with players or not.")
local RagdollComplex=CreateConVar("sv_playerragdolls_complex", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Corpses more than 1")
--local RagdollBloodPool=CreateConVar("sv_playerragdolls_bloodpool", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Corpses Blood Pool")
--local RagdollUrine=CreateConVar("sv_playerragdolls_urine", "0", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Corpses Urine")
local fd_firstperson= CreateClientConVar("fd_firstperson", "0", true, false, "Enter the ragdolls point of view when dead")
local Death_FOV=CreateConVar("fed_fov","50",{FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Fedhoria death FOV")
local Death_FOV_duration=CreateConVar("fed_fov_duration","2",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Fedhoria_death FOV time")
local Death_cam=CreateConVar("special_cam","1",bit.bor(FCVAR_REPLICATED, FCVAR_ARCHIVE), "Fedhoria_death Cam Type")
local AllowBloodVar = CreateConVar("fd_blood", "1", FCVAR_ARCHIVE,"")
local BloodThresholdVar = CreateConVar("fd_blood_threshold", "500", FCVAR_ARCHIVE,"")
util.AddNetworkString("Fedhoria_Ragdoll")
util.AddNetworkString("ragdeath_client")
local function OnPlyRagdollCollide(collider, colData )	
	if AllowBloodVar:GetBool() then
		if colData.Speed < BloodThresholdVar:GetFloat() then return end
		local pos = colData.HitPos
		local norm = colData.OurOldVelocity:GetNormalized()
		util.Decal("Blood",pos,pos + colData.HitNormal * 20)
	end
end
local function SetAllNpcHealth(cls,h)
	local npcs = list.GetForEdit( "NPC")
	for k, v in pairs( npcs ) do
		if v["Class"] == cls then
			if h>0 then
				if not v["OldHealth"] then
					v["OldHealth"]=v["Health"] or ""
					print(v["OldHealth"])
				end
				v["Health"]=""..h
			else
				--if v["OldHealth"] then 
				if v["OldHealth"]=="" then
					v["Health"]= nil
				else
					v["Health"]= v["OldHealth"]
				end
					
				--end
			end
		end
	end
end

local lockhealth	= CreateConVar("fedhoria_citizen_health", 0, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

cvars.AddChangeCallback("fedhoria_citizen_health", function(_, _, new)
	SetAllNpcHealth("npc_citizen",lockhealth:GetFloat())
end)

timer.Simple( 1, function() SetAllNpcHealth("npc_citizen",lockhealth:GetFloat()) end )

function printnpctype(mdlpath)
	local npcs = list.GetForEdit( "NPC")
	
	for k, v in pairs( npcs ) do
		if v["Class"]=="npc_citizen" and v["Model"]==mdlpath then print(k) end
	end
end



local last_dmgpos = {}

hook.Add("CreateEntityRagdoll", "Fedhoria", function(ent, ragdoll)
	if (!enabled:GetBool() or !npcs:GetBool()) then return end
	
	local class = ent:GetClass()
	if(class=="npc_citizen") then 
		ragdoll.citizen = 1 
		--printnpctype(ent:GetModel())
	end
	if(class=="npc_metropolice") then ragdoll.combine = 1 end
	if(class=="npc_combine_s") then ragdoll.combine = 1 end
	
	local dmgpos = last_dmgpos[ent]

	local phys_bone, lpos

	if dmgpos then
		phys_bone = ragdoll:GetClosestPhysBone(dmgpos)
		if phys_bone then
			local phys = ragdoll:GetPhysicsObjectNum(phys_bone)
			lpos = phys:WorldToLocal(dmgpos)
		end
	end
	
	if noc:GetBool() then
		ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
    //finger
	
		for ii= 0 , ragdoll:GetBoneCount() do
		    if ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger01' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger02' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger1' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger11' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger12' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,5),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger2' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger21' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger22' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger3' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-5-math.Rand(0,5),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger31' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger32' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger4' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,10),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger41' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger42' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))  

			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger01' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger02' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger1' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger11' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger12' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,5),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger2' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger21' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger22' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,5),0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger3' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,5),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger31' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger32' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,10),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger4' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,10),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger41' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger42' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-25-math.Rand(0,5),0))    
			end
			
		end
	timer.Simple(0, function()
		if !IsValid(ragdoll) then return end	
		fedhoria.StartModule(ragdoll, "stumble_legs", phys_bone, lpos)
		last_dmgpos[ent] = nil		
	end)
end)

hook.Add("EntityTakeDamage", "Fedhoria", function(ent, dmginfo)
	if (!enabled:GetBool() or !npcs:GetBool() or ent:IsNPC()) then return end
	if (ent:IsRagdoll() and ent.infotarget) then
	
		if ent.overkilled then ent.overkilled=ent.overkilled+1 end
	
		if !IsValid(ent.infotarget) then
			--ent.infotarget = nil
			ent.overkilled = ent.overkilled or 1
		elseif dmginfo:IsBulletDamage() then
    		dmginfo:SetDamage(1)
			ent.infotarget:TakeDamageInfo(dmginfo)
			if ent.infotarget:Health()<=0 then 
				--ent.infotarget = nil
				ent.overkilled = ent.overkilled or 1
			end
		end
	end

	
	if (!ent:IsNPC() or dmginfo:GetDamage() < ent:Health()) then return end

	last_dmgpos[ent] = dmginfo:GetDamagePosition()
end)

local once = true

--RagMod/TTT support
hook.Add("OnEntityCreated", "Fedhoria", function(ent)
	--If RagMod isn't installed remove this hook
	if once then
		once = nil
		if (!RMA_Ragdolize and !CORPSE) then
			hook.Remove("OnEntityCreated", "Fedhoria")
			return
		end
		--these hooks fucks shit up
		if RMA_Ragdolize then
			hook.Remove( "PlayerDeath", "RM_PlayerDies")
			hook.Add( "PostPlayerDeath", "RemoveRagdoll", function(ply)
				if IsValid(ply.RM_Ragdoll) then
					SafeRemoveEntity(ply:GetRagdollEntity())
					ply:SpectateEntity(ply.RM_Ragdoll)
				end
			end)
		end
	end
	if (!enabled:GetBool() or !players:GetBool() or !ent:IsRagdoll()) then return end
	timer.Simple(0, function()
		if !IsValid(ent) then return end
		if CORPSE then
			local ply = ent:GetDTEntity(CORPSE.dti.ENT_PLAYER)
			if (IsValid(ply) and ply:IsPlayer()) then
				fedhoria.StartModule(ent, "stumble_legs")
				return
			end
		end
		for _, ply in ipairs(player.GetAll()) do
			if (ply.RM_IsRagdoll and ply.RM_Ragdoll == ent) then
				fedhoria.StartModule(ent, "stumble_legs")
				return
			end
		end
	end)
end)

local PLAYER = FindMetaTable("Player")

--local oldCreateRagdoll = PLAYER.CreateRagdoll

local dolls = {}
local pps = {}
local countt= 1 
local function CreateEntityRagdoll(self,ragdoll)
    if type(self)!="Player" or (!enabled:GetBool())then return end
    if not RagdollComplex:GetBool()  then //如果设定玩家布娃娃可以多于一个，则不会去删掉存在的玩家布娃娃。
	       SafeRemoveEntity(dolls[self])
    end
    
	SafeRemoveEntity(pps[self])
    self.UsesRealisticBlood = true
	
	ragdoll = ents.Create("prop_ragdoll")
	ragdoll.player=1
	ragdoll.UsesRealisticBlood = true
	self.UsesRealisticBlood = true
	self:SetBloodColor(0)
	--print(self:GetBloodColor())
	ragdoll:SetModel(self:GetModel())
	ragdoll:SetPos(self:GetPos())
	-- if own.ZippyGoreMod3_LastDMGINFO then
       -- rag:ZippyGoreMod3_DamageRagdoll( own.ZippyGoreMod3_LastDMGINFO )
    -- end
	--ragdoll.ZippyGoreMod3_Ragdoll= true
	--ragdoll.ZippyGoreMod3_PhysBoneHPs = true
	ragdoll:SetAngles(self:GetAngles())
	ragdoll:Spawn()
    ragdoll:SetOwner(self)
	ragdoll:SetSkin(self:GetSkin())
	ragdoll:SetName(self:GetName().."'s ragdoll")  -- 
	ragdoll.Fedindex="Fed_player_corpse"
	ragdoll.CanConstrain = true
	ragdoll.GravGunPunt = true
	ragdoll.PhysgunDisabled = false
	ragdoll.countnum=ragdoll:EntIndex()
	--print(ragdoll:GetName())
    local pp=ents.Create("prop_dynamic")
	pp:SetModel("models/hunter/plates/plate.mdl")
	pp:SetRenderMode(10)
	pp:SetCollisionGroup(1)
	pp:SetMoveType(MOVETYPE_NONE)
    pp:SetNotSolid(true)
	pp:SetParent(ragdoll,-1)

	pp:SetPos(self:GetPos()*Vector(1,1,1)+Vector(0,0,30))
	--pp:Fire("setparentattachmentmaintainoffset", "head", 1)
	--pp:SetAngles(self:GetAngles()*0.2)
	--pp:CreateBoneFollowers(ragdoll)
	--pp:UpdateBoneFollowers()
	pp:Spawn()
	pps[self]=pp
	for i = 0, self:GetNumBodyGroups() - 1 do
		ragdoll:SetBodygroup(i, self:GetBodygroup(i))
	end

	for i = 0, ragdoll:GetPhysicsObjectCount()-1 do
		local phys = ragdoll:GetPhysicsObjectNum(i)
		local bone = ragdoll:TranslatePhysBoneToBone(i)
		local matrix = self:GetBoneMatrix(bone)
		local pos, ang = matrix:GetTranslation(), matrix:GetAngles()--self:GetBonePosition(bone)
		phys:SetPos(pos)
		phys:SetAngles(ang)
		phys:SetVelocity(self:GetVelocity())
	end
    --ragdoll.FOV=45
	if not GetConVar("fd_firstperson"):GetBool() then
	if not Death_cam:GetBool() then
	self:SpectateEntity(ragdoll)
	self:SetFOV(Death_FOV:GetFloat(),Death_FOV_duration:GetFloat(),pp)
	self:Spectate(5) 
	pp:Remove()
	else 
	--self:SpectateEntity(ragdoll)
	--self:Spectate(5) 
	pp:Remove()
	end
	else
	--self:SpectateEntity(ragdoll)
	--self:Spectate(5)
	pp:Remove()
	--self:Spectate(0) 
	
	end
	if (Removetime:GetInt()>0 && ragdoll:IsValid()) then
     timer.Simple(Removetime:GetInt(),function()
	 if ragdoll:IsValid() then
	 ragdoll:Remove() 
	 end
	 end)
    end
    if not RagdollsCollideWithPlayers:GetBool() then
		ragdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	end
	-- timer.Simple(0.05, function()
				-- if not IsValid(ragdoll) then return end
				-- local boneid = 0
				
				
				
				-- if RagdollBloodPool:GetBool() then
				-- if self.bloodpool_lastdmgbone then	
				-- --print(self:GetBloodColor())
				-- CreateBloodPoolForRagdoll(ragdoll, self.bloodpool_lastdmgbone, self.bloodpool_lastdmglpos, 0)				
			    -- end 
				-- end
				-- if RagdollUrine:GetBool() then
				
				-- CreateUrineForRagdoll(ragdoll, boneid1, pos3,BLOOD_COLOR_YELLOW, 1) 
				-- end
	-- end)
	
	//finger
		for ii= 0 , ragdoll:GetBoneCount() do
		    if ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger01' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger02' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger1' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger11' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger12' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,5),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger2' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger21' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger22' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger3' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger31' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger32' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger4' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,10),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger41' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_L_Finger42' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))  

			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger0' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger01' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger02' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,0,0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger1' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger11' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-10-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger12' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-15-math.Rand(0,5),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger2' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-3,0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger21' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger22' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,5),0))  
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger3' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,5),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger31' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,5),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger32' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-20-math.Rand(0,10),0))
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger4' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-25-math.Rand(0,10),0))   
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger41' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-30-math.Rand(0,10),0))    
			elseif ragdoll:GetBoneName(ii)=='ValveBiped.Bip01_R_Finger42' then
			   ragdoll:ManipulateBoneAngles(ii,Angle(0,-25-math.Rand(0,5),0))    
			end
			
		end
	dolls[self] = ragdoll
	LocalRagdoll = ragdoll
	rag=ragdoll
    ragdoll:AddCallback( "PhysicsCollide", OnPlyRagdollCollide)
    

    net.Start("Fedhoria_Ragdoll")
    net.WriteInt(ragdoll:EntIndex(),32)
	net.WriteEntity(ragdoll:GetOwner())
	--print(ragdoll:EntIndex())
    net.Broadcast()	
    net.Start("ragdeath_client")
		net.WriteInt(rag:EntIndex(),32)
		--net.WriteInt(rag:GetOwner():EntIndex(),32)
	net.Broadcast()
    timer.Simple(1,function()
	ragdoll:SetOwner(NULL)
	end)
--countt=countt+1;
    --rag:RealisticBlood_Setup()
	--local dmgapply=ragdoll.ZippyGoreMod3_LastDMGINFO
	
	-- timer.Simple(0.5, function()  
    -- local dmgnn=DamageInfo()
	-- local pos1, ang1 = ragdoll:GetBonePosition(self.bloodpool_lastdmgbone)
	          -- dmgnn:SetDamage(1)
			  -- dmgnn:SetDamageType(268435456)
			  -- --dmgnn:SetAttacker(dmgapply:GetAttacker())
			  
			  -- dmgnn:SetDamagePosition(pos1)	
			 -- --print(self.bloodpool_physicbone)
	-- ragdoll:GetPhysicsObjectNum(2):TakeDamage(1)
	-- end)
	
end
-- hook.Add("EntityTakeDamage", "BloodPool_&Gib_TakeDamage", function(self, dmginfo)
			-- if (!self:IsPlayer())  then return end

			-- local phys_bone = dmginfo:GetHitPhysBone(self)

			-- if phys_bone then
				-- local bone = self:TranslatePhysBoneToBone(phys_bone)
                -- self.ZippyGoreMod3_LastDMGINFO = dmginfo
				-- self.bloodpool_lastdmgbone = bone
                -- self.bloodpool_physicbone = phys_bone
				-- self.bloodpool_lastdmglpos = WorldToLocal(dmginfo:GetDamagePosition(), angle_zero, self:GetBonePosition(bone))
			-- end
	-- end)
-- local DMGINFO = FindMetaTable("CTakeDamageInfo")//from GibSplat

-- local COLL_CACHE = {}

-- local vec_max = Vector(1, 1, 1)
-- local vec_min = -vec_max

-- function DMGINFO:GetHitPhysBone(ent)
	-- local mdl = ent:GetModel()

	-- local colls = COLL_CACHE[mdl]
	-- if !colls then
		-- colls = CreatePhysCollidesFromModel(mdl)
		-- COLL_CACHE[mdl] = colls
	-- end

	-- local dmgpos = self:GetDamagePosition()

	-- local dmgdir = self:GetDamageForce()
	-- dmgdir:Normalize()

	-- local ray_start = dmgpos - dmgdir * 50
	-- local ray_end = dmgpos + dmgdir * 50

	-- for phys_bone, coll in pairs(colls) do
		-- phys_bone = phys_bone - 1
		-- local bone = ent:TranslatePhysBoneToBone(phys_bone)
		-- local pos, ang = ent:GetBonePosition(bone)
		
		-- if coll:TraceBox(pos, ang, ray_start, ray_end, vec_min, vec_max) then
			-- return phys_bone
		-- end
	-- end
-- end

local ppas={}
hook.Add("PlayerSpawn", "FPDM_Spawn", function(ply)
   self=ply
   SafeRemoveEntity(pps[self])
   ply:SetViewEntity(ply)
 --  ply:SetShouldServerRagdoll(enabled:GetBool())

end) 


local oldGetRagdollEntity = PLAYER.GetRagdollEntity

local function GetRagdollEntity(self)
	return dolls[self] or NULL
end

if enabled:GetBool() then
	PLAYER.CreateRagdoll = CreateEntityRagdoll
	PLAYER.GetRagdollEntity = GetRagdollEntity
end

cvars.AddChangeCallback("fedhoria_enabled", function(name, old, new)
	if (new == "1") then
		if players:GetBool() then
		    
			PLAYER.CreateRagdoll = CreateEntityRagdoll
			PLAYER.GetRagdollEntity = GetRagdollEntity
		end
	else
		--PLAYER.CreateRagdoll = oldCreateRagdoll
		--PLAYER.GetRagdollEntity = oldGetRagdollEntity
	end
end)

cvars.AddChangeCallback("fedhoria_players", function(name, old, new)
	if (new == "1") then
		if enabled:GetBool() then
			if (debug.getinfo(PLAYER.CreateRagdoll).short_src == "[C]") then
				PLAYER.CreateRagdoll = CreateEntityRagdoll
				PLAYER.GetRagdollEntity = GetRagdollEntity
			end
		end
	else
		--PLAYER.CreateRagdoll = oldCreateRagdoll
		--PLAYER.GetRagdollEntity = oldGetRagdollEntity
	end
end)
local Feddmginfo={}

hook.Add("PostPlayerDeath", "Fedhoria", function(ply)
	if (!enabled:GetBool() or !players:GetBool()) then return end
	timer.Simple(0, function()
		if !IsValid(ply) then return end
		local ragdoll = ply:GetRagdollEntity()
		if (IsValid(ragdoll) and ragdoll:IsRagdoll()) then
			fedhoria.StartModule(ragdoll, "stumble_legs")

		end
	end)
end)




-- hook.Add("CreateEntityRagdoll","RagDeath_Ragdoll",function(owner, rag)
    -- --print(owner)
	-- if type(owner) != "Player" then return end
	-- -- Send the ragdolls entity index to its owner player
	-- local index = rag:EntIndex()
	-- net.Start("ragdeath_client")
		-- net.WriteInt(rag:EntIndex(),32)
		-- net.WriteInt(owner:EntIndex(),32)
	-- net.Broadcast()


	




	-- -- Remove owner (Otherwise owning player won't collide with the ragdoll)
    -- rag:SetOwner(NULL )

	-- -- Enable tool interactions
	-- rag.CanConstrain = true
	-- rag.GravGunPunt = true
	-- rag.PhysgunDisabled = false

	-- -- Add callback for blood decals
	-- rag:AddCallback( "PhysicsCollide", OnRagdollCollide)

-- end)
local NPC =
{
	Name = "Npc Info Target",
	Class = "npc_info_target",
	Health = "10",
	KeyValues = { citizentype = 4 },
	Model = "",
	Category = "Dummy"
}
list.Set( "NPC", "npc_info_target", NPC )

local NPC =
{
	Name = "Npc Info Target Enemy",
	Class = "npc_info_target_e",
	Health = "10",
	Model = "",
	KeyValues = { citizentype = 4 },
	Category = "Dummy"
}
list.Set( "NPC", "npc_info_target_e", NPC )



