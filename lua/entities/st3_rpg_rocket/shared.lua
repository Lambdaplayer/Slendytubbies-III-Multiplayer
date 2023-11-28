 ENT.Type 			= "anim"  
 ENT.PrintName		= "Slendytubbies 3 Rocket"
 ENT.Category       = "Lambda Slendytubbies III"  
 ENT.Author			= "Generic Default"  
 ENT.Contact			= ""  
 ENT.Purpose			= "Boom"  
 ENT.Instructions		= "LAUNCH"  
 
ENT.Spawnable			= true
ENT.AdminOnly = true 
ENT.DoNotDuplicate = true 
ENT.DisableDuplicator = true

if CLIENT then
    killicon.Add( "st3_rpg_rocket", "lambdaplayers/killicons/icon_st3_rpg", Color( 255, 80, 0, 255 ) )
end

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize() 
self.CanTool = false  

self.flightvector = self.Entity:GetForward() * ((100*100)/400)
self.timeleft = CurTime() + 100

self.Owner = self:GetOwner()
self.Entity:SetModel( "models/lambdaplayers/weapons/st3/items/st3_cohete.mdl" )
self.Entity:PhysicsInit( SOLID_BBOX )      -- Make us work with physics,  	
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )   --after all, gmod is a physics  	
self.Entity:SetSolid( SOLID_NONE )        -- CHEESECAKE!    >:3        
self:SetCollisionGroup(COLLISION_GROUP_NONE)
self.Entity:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/rocketlauncherfire.wav") -- Same as below
self.Entity:SetNWBool("smoke", true)
end   

 function ENT:Think()
	
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	
		if self.timeleft < CurTime() then
		self.Entity:Remove()				
		end

	Table	={} 			//Table name is table name
	Table[1]	=self.Owner 		//The person holding the gat
	Table[2]	=self.Entity 		//The cap

	local trace = {}
		trace.start = self.Entity:GetPos()
		trace.endpos = self.Entity:GetPos() + self.flightvector
		trace.filter = Table
	local tr = util.TraceLine( trace )
	

			if tr.HitSky then
			self.Entity:Remove()
			self.Entity:SetNWBool("smoke", false)
			--podria ponerle el codigo para que detenga el sonido pero nah me gusta mas como esta--
			return true
			end
	
				if tr.Hit then
					if not IsValid(self.Owner) then
						self.Entity:Remove()
						return
					end
					util.BlastDamage(self.Entity, self.Owner, tr.HitPos, 250, 350)
					local effectdata = EffectData()
					effectdata:SetOrigin(tr.HitPos)			// Where is hits
					effectdata:SetNormal(tr.HitNormal)		// Direction of particles
					effectdata:SetEntity(self.Entity)		// Who done it?
					effectdata:SetScale(1)			// Size of explosion
					effectdata:SetRadius(tr.MatType)		// What texture it hits
					effectdata:SetMagnitude(18)			// Length of explosion trails
					util.Effect( "st3explosion", effectdata )
					util.Decal("Empty", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
					self.Entity:SetNWBool("smoke", false)
					self.Entity:StopSound( "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/rocketlauncherfire.wav" )
					self.Entity:Remove()	
				end
	
	self.Entity:SetPos(self.Entity:GetPos() + self.flightvector)
	self.flightvector = self.flightvector - self.flightvector/((100*100)/400) + self.Entity:GetForward()*2 + Vector(math.Rand(-0.0,0.0), math.Rand(-0.0,0.0),math.Rand(-0.0,0.0)) + Vector(0,0,-0.0)
	self.Entity:SetAngles(self.flightvector:Angle() + Angle(0,0,0))
	self.Entity:NextThink( CurTime() )
	return true
end
 
end

if CLIENT then
 
 function ENT:Draw()        
 self.Entity:DrawModel()       // Draw the model.   
 end
 
   function ENT:Initialize()
	pos = self:GetPos()
	self.emitter = ParticleEmitter( pos )
 end
 
 function ENT:Think()
	if (self.Entity:GetNWBool("smoke")) then
	pos = self:GetPos()
		for i=0, (10) do
			local particle = self.emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_humo", pos + (self:GetForward() * -100 * i))
			if (particle) then
				particle:SetVelocity((self:GetForward() * 100) )
				particle:SetDieTime( math.Rand( 0.5, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 5, 8 ) )
				particle:SetEndAlpha( 0, 0 )
				particle:SetStartSize( math.Rand( 20, 20 ) )
				particle:SetEndSize( math.Rand( 20, 0 ) )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-1, 1) )
				particle:SetColor( 255 , 255 , 255 ) 
 				particle:SetAirResistance( 1000 ) 
 				particle:SetGravity( Vector( 100, 0, 0 ) ) 	
			end
		
		end
		
		for i=0, (10) do
			local particle2 = self.emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_humo", pos + (self:GetForward() * -100 * i))
			if (particle2) then
				particle2:SetVelocity((self:GetForward() * 100) )
				particle2:SetDieTime( math.Rand( 0.3, 0.3 ) )
				particle2:SetStartAlpha( math.Rand( 16, 24 ) )
				particle2:SetEndAlpha( 0, 0 )
				particle2:SetStartSize( math.Rand( 20, 20 ) )
				particle2:SetEndSize( math.Rand( 20, 0 ) )
				particle2:SetRoll( math.Rand(0, 360) )
				particle2:SetRollDelta( math.Rand(-1, 1) )
				particle2:SetColor( 255 , 140 , 0 ) 
 				particle2:SetAirResistance( 1000 ) 
 				particle2:SetGravity( Vector( 100, 0, 0 ) ) 	
			end
		
		end
		
	end
end
end