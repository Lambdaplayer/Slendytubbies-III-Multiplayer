AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName		= "Slendytubbies 3 Grenade[Improved]"
ENT.Category        = "Lambda Slendytubbies III"
ENT.Author			= ""
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Draw()
self.Entity:DrawModel()
end

function ENT:Initialize()
if SERVER then
ParticleEffectAttach( "pipebombtrail_red", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
self.Entity:SetModel( "models/lambdaplayers/weapons/st3/w_grenade.mdl" )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Owner = self.Entity.Owner
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )

local phys = self.Entity:GetPhysicsObject()
	
if (phys:IsValid()) then
    phys:Wake()
end
end
self.ExplodeTimer = CurTime() + 2
end

function ENT:Think()
if SERVER and self.ExplodeTimer <= CurTime() then
self.Entity:Remove()
end
end

function ENT:PhysicsCollide( data )
if SERVER and data.Speed > 150 then
self.Entity:EmitSound(Sound("lambdaplayers/weapons/SlendytubbiesSFX's/grenade/grenade_impact"..math.random(1,3)..'.wav', 90))
end
end

function ENT:OnRemove()
if SERVER then
local effectdata = EffectData()
effectdata:SetOrigin( self.Entity:GetPos() )
util.Effect( "cball_explode", effectdata )

ParticleEffect("ExplosionCore_MidAir", self:GetPos(), self:GetAngles())
self.Entity:EmitSound( "LambdaST3.TF2Explode", 100, nil, nil, CHAN_STATIC )
end
util.BlastDamage( self, self.Owner, self:GetPos(), 384, 98 )
end