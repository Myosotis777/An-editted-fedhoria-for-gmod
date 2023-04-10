MODULE.Model = "models/police.mdl"
MODULE.BoneList = 
{
	"ValveBiped.Bip01_Pelvis",
	--"ValveBiped.Bip01_Spine2",
	--"ValveBiped.Bip01_Head1", 
	--"ValveBiped.Bip01_R_Upperarm",
	--"ValveBiped.Bip01_R_Forearm",
	--"ValveBiped.Bip01_R_Hand",
	--"ValveBiped.Bip01_L_Upperarm",
	--"ValveBiped.Bip01_L_Forearm",
	--"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot"
}

-- local nRagdollS_deathexpression_enable = CreateConVar("sv_npcdeath_enable", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "enable or not.")
-- local nRagdollSpeedMultiplier = CreateConVar("sv_ents_speed", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Speed multiplier of npc corpse ragdolls.")
-- local nRagdollWeightMultiplier = CreateConVar("sv_ents_weight", "1", {FCVAR_REPLICATED, FCVAR_ARCHIVE}, "Weight multiplier of npc corpse ragdolls.")
-- local nRagdollPhysicMultiplier = CreateConVar("sv_ent_physic","1",{FCVAR_REPLICATED, FCVAR_ARCHIVE},"Enable the multiplier or not")
local Tmin=CreateConVar("sv_npcdeath_Tmin","0.7",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "npc闭眼的最小值")
local Tmax=CreateConVar("sv_npcdeath_Tmax","0.95",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "npc闭眼的最大值")
local EUmin=CreateConVar("sv_npcdeath_EUmin","0.3",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "eyes up min")
local EUmax=CreateConVar("sv_npcdeath_EUmax","0.45",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "eyes up max")
local AHmin=CreateConVar("sv_npcdeath_AHmin","0.1",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "MOUTH OPEN MIN")
local AHmax=CreateConVar("sv_npcdeath_AHmax","0.2",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "MOUTH OPEN MAX")
local SAmin=CreateConVar("sv_npcdeath_SAmin","0.3",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "SAD MIN")
local SAmax=CreateConVar("sv_npcdeath_SAmax","0.6",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "SAD MAX")
local fedhoria_facial=CreateConVar("sv_fedhoria_facial","1",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "fedhoria_facial")
local facial_duaration=CreateConVar("sv_fedhoria_facial_duaration","7",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "fedhoria_facial")
local random_scale=CreateConVar("sv_fedhoria_facial_random","0.25",{FCVAR_REPLICATED, FCVAR_ARCHIVE}, "fedhoria_facial_random")
local math_Clamp = math.Clamp
local stumble_time = 7

function MODULE:Init(a)
	self:ResetSequence(self:LookupSequence("Choked_Barnacle"))
    --self:ResetSequence(self:LookupSequence("death_02"))
	self.LastCollide = 0
	
	stumble_time = a
	self.closeeye_st_add = 0
	self.closeeye_st_f = 0
	self.closeeye_ed_add = facial_duaration:GetFloat()

end

function MODULE:Think()
    local rds = random_scale:GetFloat()
	local st = self.closeeye_ed_add
	
	local f = CurTime() - self.Created - self.closeeye_st_add
	local ent = self:GetTarget()
	
	if ent.overkilled then
		if self.closeeye_st_f == 0 then
			self.closeeye_st_f = f / st
			self.closeeye_st_add = CurTime() - self.Created 
			self.closeeye_ed_add = 1 - f / st
			f = 0
		end
		if f > 0.6 then
			ent.overkilled2 = 1
		end
	end	
	if facial_duaration:GetFloat()==0 then
	   f = 0.99
	end
	f = f / st 
	if f>1 then f=1.00001 end	
	f = f*(1-self.closeeye_st_f)+self.closeeye_st_f
	
	if f>1 then f=1.00001 end	
	
	if fedhoria_facial:GetBool() && f<=1.0000001 then
      if f<=0.3 then	
	    T=math.Rand(Tmin:GetFloat()+(Tmax:GetFloat()-Tmin:GetFloat())*f*((1-rds)^f),Tmax:GetFloat()) 
	    EU=math.Rand(EUmin:GetFloat()+(EUmax:GetFloat()-EUmin:GetFloat())*f,EUmax:GetFloat()) 
	    AH=math.Rand(AHmin:GetFloat(),AHmax:GetFloat()) 
	    SA=math.Rand(SAmin:GetFloat()+(SAmax:GetFloat()-SAmin:GetFloat())*f,SAmax:GetFloat())
	  end
	local UP=0
	 -- for i = 0,  ent:GetFlexNum()  do
		    -- ent:SetFlexWeight( i ,0)
	 -- end
	 for i=0, ent:GetFlexNum()  do
	     
	 
			if ent:GetFlexName(i) == "blink" then
			   ent:SetFlexWeight( i , T *f)
			elseif ent:GetFlexName(i) == "Blink" then
			   ent:SetFlexWeight( i , T *f) 
			elseif ent:GetFlexName(i) == "eye_blink" then
			   ent:SetFlexWeight( i , T *f)
			elseif ent:GetFlexName(i) == "Eyes_blink" then
			   ent:SetFlexWeight( i , T *f)   
			elseif ent:GetFlexName(i) == "eyelid_down_1" then
			   ent:SetFlexWeight( i , T *f)  
			elseif ent:GetFlexName(i) == "eyelid_down_r" then
			   ent:SetFlexWeight( i , T *f) 
			   --for Hibiki
			elseif ent:GetFlexName(i) == "EC" then
			   ent:SetFlexWeight( i , 0.5 )  
			elseif ent:GetFlexName(i) == "multi_EC" then
			   ent:SetFlexWeight( i , 0.5 )   
			elseif ent:GetFlexName(i) == "Mouth Fool" then
			   ent:SetFlexWeight( i , -0.2 )   
			   --for AD
			elseif ent:GetFlexName(i) == "Eyes_left" then
			   ent:SetFlexWeight( i , T *f*0.6)    
			elseif ent:GetFlexName(i) == "Eyes_right" then
			   ent:SetFlexWeight( i , T *f*0.6)   
			elseif ent:GetFlexName(i) == "Eyes_serious" then
			   ent:SetFlexWeight( i , f*0.5)    
            elseif ent:GetFlexName(i) == "Tooth_hide" then
			   ent:SetFlexWeight( i , AH)   
			elseif ent:GetFlexName(i) == "Mounth_agh" then
			   ent:SetFlexWeight( i , AH) 
			elseif ent:GetFlexName(i) == "Mounth_o" then
			   ent:SetFlexWeight( i , AH)   
			elseif ent:GetFlexName(i) == "Mounth_sad" then
			   ent:SetFlexWeight( i , SA/3) 
               --for AK74M
			elseif ent:GetFlexName(i) == "Eyes_wink_r" then
			   ent:SetFlexWeight( i , T) 
			elseif ent:GetFlexName(i) == "Eyes_wink_right" then
			   ent:SetFlexWeight( i , T *f)    
			elseif ent:GetFlexName(i) == "Eyes_wink_l" then
			   ent:SetFlexWeight( i , T *f)  
			elseif ent:GetFlexName(i) == "Eyes_wink_left" then
			   ent:SetFlexWeight( i , T *f)    
			   --for W
			elseif ent:GetFlexName(i) == "eyeclose1" then
			   ent:SetFlexWeight( i , T *f)

			   
			elseif ent:GetFlexName(i) == "a" then
			   ent:SetFlexWeight( i , AH )
			elseif ent:GetFlexName(i) == "u" then
			   ent:SetFlexWeight( i , 0.2 ) 
			elseif ent:GetFlexName(i) == "mouth_u" then
			   ent:SetFlexWeight( i , 0.1 )  
			elseif ent:GetFlexName(i) == "mouth-u" then
			   ent:SetFlexWeight( i , 0.1 )  
			elseif ent:GetFlexName(i) == "mouth-frown" then
			   ent:SetFlexWeight( i , SA/3 ) 
			elseif ent:GetFlexName(i) == "mouth-frown 2" then
			   ent:SetFlexWeight( i , SA/3 )   
			elseif ent:GetFlexName(i) == "mouth_frown_sharp" then
			   ent:SetFlexWeight( i , SA/3 )    
			elseif ent:GetFlexName(i) == "jaw_drop" then
			   ent:SetFlexWeight( i , AH )
			elseif ent:GetFlexName(i) == "jaw-drop" then
			   ent:SetFlexWeight( i , AH )   
			elseif ent:GetFlexName(i) == "A" then
			   ent:SetFlexWeight( i , AH )
			elseif ent:GetFlexName(i) == "ah" then
			   ent:SetFlexWeight( i , AH )
			elseif ent:GetFlexName(i) == "Ah" then
			   ent:SetFlexWeight( i , 0.1 )
			elseif ent:GetFlexName(i) == "Ah2" then
			   ent:SetFlexWeight( i , AH )   
			elseif ent:GetFlexName(i) == "mouth_a" then
			   ent:SetFlexWeight( i , AH ) 
			elseif ent:GetFlexName(i) == "mouth a" then
			   ent:SetFlexWeight( i , AH )   
			elseif ent:GetFlexName(i) == "mouth-a" then 
			   ent:SetFlexWeight( i , AH ) 
			elseif ent:GetFlexName(i) == "Lips part" then 
			   ent:SetFlexWeight( i , AH )    
			--for reimu
			elseif ent:GetFlexName(i) == "right_puckerer" then 
			   ent:SetFlexWeight( i , 0.25 ) 
			elseif ent:GetFlexName(i) == "left_puckerer" then 
			   ent:SetFlexWeight( i , 0.25 ) 
			elseif ent:GetFlexName(i) == "right_stretcher" then 
			   ent:SetFlexWeight( i , 0.15 )   
			elseif ent:GetFlexName(i) == "left_stretcher" then 
			   ent:SetFlexWeight( i , 0.15 ) 
			elseif ent:GetFlexName(i) == "left_funneler" then 
			   ent:SetFlexWeight( i , 0.15)   
			elseif ent:GetFlexName(i) == "right_funneler" then 
			   ent:SetFlexWeight( i , 0.15)  
			elseif ent:GetFlexName(i) == "right_part" then 
			   ent:SetFlexWeight( i , 0.15)   
			elseif ent:GetFlexName(i) == "left_part" then 
			   ent:SetFlexWeight( i , 0.15)   
			elseif ent:GetFlexName(i) == "mouth_sideways" then 
			   ent:SetFlexWeight( i , 0.5 )  
			elseif ent:GetFlexName(i) == "jaw_sideways" then 
			   ent:SetFlexWeight( i , 0.5 )    
			--for amiaomiao
 			elseif ent:GetFlexName(i) == "chin_raiser" then 
			   ent:SetFlexWeight( i , SA/2.5 )   
			elseif ent:GetFlexName(i) == "o" then
			   ent:SetFlexWeight( i , 0.15 ) 
			elseif ent:GetFlexName(i) == "O" then
			   ent:SetFlexWeight( i , 0.15 ) 
			elseif ent:GetFlexName(i) == "kuchiO" then
			   ent:SetFlexWeight( i , 0.20 )   
 			elseif ent:GetFlexName(i) == "Oh" then
			   ent:SetFlexWeight( i , 0.15 )  
			elseif ent:GetFlexName(i) == "mouth-o" then
			   ent:SetFlexWeight( i , 0.15 )
			elseif ent:GetFlexName(i) == "Mouth o" then
			   ent:SetFlexWeight( i , 0.15 )  
			elseif ent:GetFlexName(i) == "Mouth_o" then
			   ent:SetFlexWeight( i , 0.15 )   
			elseif ent:GetFlexName(i) == "mouth_o" then
			   ent:SetFlexWeight( i , 0.15 )   
			elseif ent:GetFlexName(i) == "o1" then
			   ent:SetFlexWeight( i , 0.15 ) 
			   
			elseif ent:GetFlexName(i) == "Eyes Up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "Eye Up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "Eye up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eyes_up" then
			   ent:SetFlexWeight( i , EU *f)
			   UP=1
			elseif ent:GetFlexName(i) == "eye_up" then
			   ent:SetFlexWeight( i , EU *f)  
			   UP=1
			elseif ent:GetFlexName(i) == "eye_left_up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eye_right_up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eye_up_l" then
			   ent:SetFlexWeight( i , EU *f)
			   UP=1
			elseif ent:GetFlexName(i) == "eye_up_r" then
			   ent:SetFlexWeight( i , EU *f)
			   UP=1
			elseif ent:GetFlexName(i) == "eye_look_up" then
			   ent:SetFlexWeight( i , EU *f)
			   UP=1
			elseif ent:GetFlexName(i) == "eyes_look_up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eyes-look-up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eye-look-up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1   
			elseif ent:GetFlexName(i) == "eye look up" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1
			elseif ent:GetFlexName(i) == "eyes_updown" then
			   ent:SetFlexWeight( i , EU *f) 
			   UP=1   
			elseif ent:GetFlexName(i) == "eyes look up" then
			   ent:SetFlexWeight( i , EU *f)   
			   UP=1
			   --for karin
			elseif ent:GetFlexName(i) == "LookUp" then
			       ent:SetFlexWeight( i , EU *f*3)   
			   -- UP=1   
			elseif ent:GetFlexName(i) == "sad" then
			   ent:SetFlexWeight( i , SA )
			elseif ent:GetFlexName(i) == "Sad" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "Sadness" then
			   ent:SetFlexWeight( i , SA )
            elseif ent:GetFlexName(i) == "sadness" then
			   ent:SetFlexWeight( i , SA )			   
			elseif ent:GetFlexName(i) == "mouth_sad" then
			   ent:SetFlexWeight( i , SA )
			elseif ent:GetFlexName(i) == "Mouth_sad" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "mouth sad" then
			   ent:SetFlexWeight( i , SA ) 
			elseif ent:GetFlexName(i) == "mouth sad open" then
			   ent:SetFlexWeight( i , SA )  
			elseif ent:GetFlexName(i) == "mouthsad" then
			   ent:SetFlexWeight( i , SA )    
			elseif ent:GetFlexName(i) == "disappointed" then
			   ent:SetFlexWeight( i , SA )
			elseif ent:GetFlexName(i) == "right_corner_depressor" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "left_corner_depressor" then
			   ent:SetFlexWeight( i , SA ) 
			elseif ent:GetFlexName(i) == "Triangle_1" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "jaw_clencher" then
			   ent:SetFlexWeight( i , -0.7 )   
			elseif ent:GetFlexName(i) == "presser" then
			   ent:SetFlexWeight( i , 0.1 )
			elseif ent:GetFlexName(i) == "Presser" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "mouth_smile" then
			   ent:SetFlexWeight( i , -0.15 )  
			elseif ent:GetFlexName(i) == "mouth-smile" then
			   ent:SetFlexWeight( i , -0.15 )   
			elseif ent:GetFlexName(i) == "mouth_smile2" then
			   ent:SetFlexWeight( i , -0.15 ) 
			elseif ent:GetFlexName(i) == "Mouth Smile" then
			   ent:SetFlexWeight( i , -SA/1.5 )   
			elseif ent:GetFlexName(i) == "mouth_unhappy_open" then
			   ent:SetFlexWeight( i , 0.25 )    
			elseif ent:GetFlexName(i) == "Smile" then
			   ent:SetFlexWeight( i , -0.15 )
			elseif ent:GetFlexName(i) == "smile" and i~=0 then
			   ent:SetFlexWeight( i , -0.15 )
			elseif ent:GetFlexName(i) == "right_inner_raiser" then
			   ent:SetFlexWeight( i , SA )
			elseif ent:GetFlexName(i) == "left_inner_raiser" then
			   ent:SetFlexWeight( i , SA )   
			elseif ent:GetFlexName(i) == "eyebrows_worried" then
			   ent:SetFlexWeight( i , 0.6 )
			elseif ent:GetFlexName(i) == "brows_arc_down" then
			   ent:SetFlexWeight( i , 0.7 ) 
			elseif ent:GetFlexName(i) == "brows_sad" then
			   ent:SetFlexWeight( i , 0.7 )
			elseif ent:GetFlexName(i) == "Eyebrows_Serious" then
			   ent:SetFlexWeight( i , 0.7 )   
			elseif ent:GetFlexName(i) == "Brows Worried 2" then
			   ent:SetFlexWeight( i , 0.7 )  
			elseif ent:GetFlexName(i) == "Tears" then
			   ent:SetFlexWeight( i , 1 ) 
			elseif ent:GetFlexName(i) == "tear" then
			   ent:SetFlexWeight( i , 1 )   
			elseif ent:GetFlexName(i) == "misc_tear" then
			   ent:SetFlexWeight( i , 1 ) 
			elseif ent:GetFlexName(i) == "Cry" then
			   ent:SetFlexWeight( i , 1 )    
			
			end
		end	
		
		//Eyeposition
		local V=Vector(0,0,0)
		local A=Angle(0,0,0.25)
		if  UP==0 then
		 for ii= 0 , ent:GetBoneCount() do
		    if ent:GetBoneName(ii)=='eye_L' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))  
			elseif ent:GetBoneName(ii)=='eye_R' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))   
			elseif ent:GetBoneName(ii)=='eye_l' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.25,0,0))  
			elseif ent:GetBoneName(ii)=='eye_r' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.25,0,0))    
			elseif ent:GetBoneName(ii)=='Eye_R' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0)) 
			elseif ent:GetBoneName(ii)=='Eye_r' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))    
			elseif ent:GetBoneName(ii)=='Eye_L' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0)) 
			elseif ent:GetBoneName(ii)=='Eye_l' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))    
			elseif ent:GetBoneName(ii)=='ValveBiped.Bip01_Eye_L' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))
			elseif ent:GetBoneName(ii)=='ValveBiped.Bip01_L_Eye' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f*1.5,0,0))    
			elseif ent:GetBoneName(ii)=='ValveBiped.Bip01_Eye_R' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0)) 
			elseif ent:GetBoneName(ii)=='ValveBiped.Bip01_R_Eye' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f*1.5,0,0))   
			elseif ent:GetBoneName(ii)=='RightEyeReturn' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))  
			elseif ent:GetBoneName(ii)=='LeftEyeReturn' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))   
			elseif ent:GetBoneName(ii)=='EyeReturn_R' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))  
			elseif ent:GetBoneName(ii)=='EyeReturn_L' then
			   ent:ManipulateBonePosition(ii,Vector(EU*f/1.5,0,0))    
			end
			
		 end	  
		end
		
		
	end
	if f>0.7 then
		if(self.lt and IsValid(self.lt)) then
		self.lt:Killed()
		self.lt = null
		end
	end
	
end

function MODULE:PhysicsCollide(ent, data)
	if (data.HitEntity == ent) then
		return
	end
	
	if (data.HitNormal.z > -0.6) then return end

	local cur_time = CurTime()

	if (cur_time - self.LastCollide < 0.5) then
		--self.StartDie = self.StartDie or CurTime()
	else
		--self.StartDie = nil
	end
	
	self.LastCollide = CurTime()
end

local die_time = CreateConVar("fedhoria_dietime", 5, bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

function MODULE:PhysicsSimulate(phys, dt)
	local f = self.StartDie and 1 - (CurTime() - self.StartDie) / die_time:GetFloat() or 1

	--if we have been still for too long we are dead x_x
	if (f < 0) then
		self:Remove()
		return false
	end

	local target = self:GetTarget()
	
	local phys_bone = phys:GetID()

	if (phys_bone == 0) then
		local vel = phys:GetVelocity()

		local pbr = math_Clamp(vel.z / -600, 0.5, 1.5)
		self:SetPlaybackRate(pbr)

		local pos = phys:GetPos()

		self.last_pos = self.last_pos or pos

		local offset = (pos - self.last_pos) / dt

		self.last_pos = pos
        --关于水
		if (target:WaterLevel() > 0) then
		    --self:AddEFlags(536870912)
			self:PhysicsInit(0)
			local physi = self:GetPhysicsObject()
	         if physi:IsValid() then
		      physi:SetMass(physi:GetMass() * 50)
	         end	
			local plyveln = self:GetVelocity()	
		for i = 0, self:GetPhysicsObjectCount() - 1 do
			local bone = self:GetPhysicsObjectNum(i)
			
			if bone and bone:IsValid() then
				local bonepos, boneang = self:GetBonePosition(self:TranslatePhysBoneToBone(i))
				
				bone:SetPos(bonepos)
				bone:SetAngles(boneang)
				bone:SetVelocity(plyveln * 0.000001)
				self:SetVelocity(plyveln * 0.000001)
				
			end
		end
			self.StartDie = self.StartDie or CurTime()			
			self:SetPlaybackRate(f)
		else		
			if (offset:LengthSqr() < 900) then
				self.StartDie = self.StartDie or CurTime()
				return false
			else
				self.StartDie = nil
			end
		end
		
		return false
	end

	local delta = CurTime() - self.LastCollide
	if (delta < 0.2) then 
		return false 
	elseif (delta < 1.2) then
		return true, delta - 0.2
	end
	

	return true, f
end