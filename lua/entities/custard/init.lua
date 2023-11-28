AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.foodModel = "models/custard/custard.mdl"

function ENT:Use(activator)
	activator:SetHealth(activator:Health()+20)
	self.Entity:Remove()
	activator:EmitSound("player/pl_scout_dodge_can_drink_fast.wav", 50, 100)

end