ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = ""
ENT.Author = "Esc"
ENT.Contact = "x"
ENT.Information		= ""
ENT.Category		= ""

ENT.Spawnable = false
ENT.AdminSpawnable = false


ENT.AutomaticFrameAdvance = true

 function ENT:PhysicsCollide( data, physobj )
end
 
 

function ENT:PhysicsUpdate( physobj )
end
  
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
self.AutomaticFrameAdvance = bUsingAnim
end


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Body")
	self:NetworkVar("Int", 0, "TargetBone")
	self:NetworkVar("Vector", 0, "LPos")
	self:NetworkVar("Angle", 0, "LAng")
end