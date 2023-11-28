
					//Sound,Impact

					// 1        2       3      4      5
					//Dirt, Concrete, Metal, Glass, Flesh

					// 1     2     3      4      5      6      7      8         9
					//Dust, Dirt, Sand, Metal, Smoke, Wood,  Glass, Blood, YellowBlood
local mats={				
	[MAT_ALIENFLESH]		={5,9},
	[MAT_ANTLION]			={5,9},
	[MAT_BLOODYFLESH]		={5,8},
	[45]				={5,8},	// Metrocop heads are a source glitch, they have no enumeration
	[MAT_CLIP]			={3,5},
	[MAT_COMPUTER]			={4,5},
	[MAT_FLESH]			={5,8},
	[MAT_GRATE]			={3,4},
	[MAT_METAL]			={3,4},
	[MAT_PLASTIC]			={2,5},
	[MAT_SLOSH]			={5,5},
	[MAT_VENT]			={3,4},
	[MAT_FOLIAGE]			={1,5},
	[MAT_TILE]			={2,5},
	[MAT_CONCRETE]			={2,1},
	[MAT_DIRT]			={1,2},
	--[85]			={1,2},
	[MAT_SAND]			={1,3},
	[MAT_WOOD]			={2,6},
	[MAT_GLASS]			={4,7},
}

function EFFECT:Init(data)
self.Entity 		= data:GetEntity()		// Entity determines what is creating the dynamic light			//

self.Pos 		= data:GetOrigin()		// Origin determines the global position of the effect			//

self.Scale 		= data:GetScale()		// Scale determines how large the effect is				//
self.Radius 		= data:GetRadius() or 1		// Radius determines what type of effect to create, default is Concrete	//

self.DirVec 		= data:GetNormal()		// Normal determines the direction of impact for the effect		//
self.PenVec 		= data:GetStart()		// PenVec determines the direction of the round for penetrations	//
self.Particles 		= data:GetMagnitude()		// Particles determines how many puffs to make, primarily for "trails"	//
self.Angle 		= self.DirVec:Angle()		// Angle is the angle of impact from Normal				//
self.DebrizzlemyNizzle 	= 10+data:GetScale()		// Debrizzle my Nizzle is how many "trails" to make			//
self.Size 		= 5*self.Scale			// Size is exclusively for the explosion "trails" size			//

self.Emitter 		= ParticleEmitter( self.Pos )	// Emitter must be there so you don't get an error			//

	

			/*if self.Scale<1.2 then
			sound.Play( "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/barrelexploding.wav", self.Pos)
			end*/


	self.Mat=math.ceil(self.Radius)

	foundTheMat = false
	for k, v in pairs(mats) do 
		if k == self.Mat then
			foundTheMat = true
			continue
		end
	end
	if not (foundTheMat) then self.Mat = 84 end
	--THERE! I FIXED IT!

	if     mats[self.Mat][2]==1 then	self:Dust()	
	elseif mats[self.Mat][2]==2 then	self:Dirt()
	elseif mats[self.Mat][2]==3 then	self:Sand()
	elseif mats[self.Mat][2]==4 then	self:Metal()
	elseif mats[self.Mat][2]==5 then	self:Smoke()
	elseif mats[self.Mat][2]==6 then	self:Wood()
	elseif mats[self.Mat][2]==7 then	self:Glass()
	elseif mats[self.Mat][2]==8 then	self:Blood()
	elseif mats[self.Mat][2]==9 then	self:YellowBlood()
	else 					self:Smoke()
	end

end
 
 function EFFECT:Dust()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_humo", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

 end
 
function EFFECT:Dirt()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

 end

 function EFFECT:Sand()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

 end

 function EFFECT:Metal()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end


 function EFFECT:Smoke()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end

 function EFFECT:Wood()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end
		
end

 function EFFECT:Blood()
 
 --Efectos de impacto personalizados por que si--
 
		for i=0, 5*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(900)*self.Scale )
		Smoke:SetDieTime( math.Rand( 0.5 , 0.77 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 340 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 160,12,6 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end

 function EFFECT:Flesh()
 
 --Efectos de impacto personalizados por que si--
 
		for i=0, 5*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(900)*self.Scale )
		Smoke:SetDieTime( math.Rand( 0.5 , 0.77 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 340 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 160,12,6 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end

 function EFFECT:YellowBlood()
 
--Efectos de impacto personalizados por que si--

		for i=0, 5*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(100)*self.Scale )
		Smoke:SetDieTime( math.Rand( 0.6 , 0.97 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 20.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 340 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 160,120,6 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end
 
 function EFFECT:Glass()

		for i=0, 4*self.Scale do		// Efecto de humo similar al de Slendytubbies III.
		local Smoke = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_smoke", self.Pos )
		if (Smoke) then
		Smoke:SetVelocity( VectorRand():GetNormalized()*math.random(200)*self.Scale )
		Smoke:SetDieTime( math.Rand( 1.4 , 2.1 ) )
		Smoke:SetStartAlpha( 255 )
		Smoke:SetEndAlpha( 0 )
		Smoke:SetStartSize( 19.5*self.Scale )
		Smoke:SetEndSize( 290*self.Scale )
		Smoke:SetRoll( math.Rand(10, -10) )
		Smoke:SetRollDelta( math.Rand(-0.1, 0.1) )			
		Smoke:SetAirResistance( 1200 ) 			 
		Smoke:SetGravity( Vector( math.Rand(-10, 10) * self.Scale, math.Rand(-10, -10) * self.Scale, math.Rand(-10, -0) ) ) 					
		Smoke:SetColor( 180,180,180 )
		end
		end

		for i=1,5 do 				// Primer Destello
		local Flash = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash) then
		Flash:SetVelocity( self.DirVec*100 )
		Flash:SetAirResistance( 200 )
		Flash:SetDieTime( 0.16 )
		Flash:SetStartAlpha( 255 )
		Flash:SetEndAlpha( 0 )
		Flash:SetStartSize( self.Scale*125 )
		Flash:SetEndSize( 0 )
		Flash:SetRoll( math.Rand(180,480) )
		Flash:SetRollDelta( math.Rand(-1,1) )
		Flash:SetColor(255,255,255)	
		end
		end

		for i= 0,2 do 				// Segundo Destello
		local Flash2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_explosion", self.Pos )
		if (Flash2) then
		Flash2:SetVelocity( self.DirVec*100 )
		Flash2:SetAirResistance( 200 )
		Flash2:SetDieTime( 0.166 )
		Flash2:SetStartAlpha( 255 )
		Flash2:SetEndAlpha( 0 )
		Flash2:SetStartSize( self.Scale*110 )
		Flash2:SetEndSize( 0 )
		Flash2:SetRoll( math.Rand(180,480) )
		Flash2:SetRollDelta( math.Rand(-1,1) )
		Flash2:SetColor(255,0,0)	
		end
		end
		
		for i=1,5 do 				// Tercer Destello
		local Flash3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_destello2", self.Pos )
		if (Flash3) then
		Flash3:SetVelocity( self.DirVec*100 )
		Flash3:SetAirResistance( 200 )
		Flash3:SetDieTime( 0.13 )
		Flash3:SetStartAlpha( 115 )
		Flash3:SetEndAlpha( 30 )
		Flash3:SetStartSize( self.Scale*128 )
		Flash3:SetEndSize( 128 )
		Flash3:SetRoll( math.Rand(180,480) )
		Flash3:SetRollDelta( math.Rand(-1,1) )
		Flash3:SetColor(243,112, 0)	
		end
		end
		
		for i=0, 555*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III.
		local Chispas = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas) then
		Chispas:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas:SetDieTime( math.Rand( 0 , 0.5 ) )
		Chispas:SetStartAlpha( 250 )
		Chispas:SetEndAlpha( 250 )
		Chispas:SetStartSize( 3.33*self.Scale )
		Chispas:SetEndSize( 4.73*self.Scale )
		Chispas:SetRoll( math.Rand(52, -52) )
		Chispas:SetRollDelta( math.Rand(-2, 2) )			
		Chispas:SetAirResistance( 0.3 ) 			 
		Chispas:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas:SetColor( 224,182,92 )
		end
		end
		
		for i=0, 355*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas2 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas2) then
		Chispas2:SetVelocity( VectorRand():GetNormalized()*math.random(330)*self.Scale )
		Chispas2:SetDieTime( math.Rand( 0 , 0.7 ) )
		Chispas2:SetStartAlpha( 250 )
		Chispas2:SetEndAlpha( 250 )
		Chispas2:SetStartSize( 3.35*self.Scale )
		Chispas2:SetEndSize( 4.75*self.Scale )
		Chispas2:SetRoll( math.Rand(52, -52) )
		Chispas2:SetRollDelta( math.Rand(-2, 2) )			
		Chispas2:SetAirResistance( 0.2 ) 			 
		Chispas2:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 							
		Chispas2:SetColor( 154,91,44 )
		end
		end

		for i=0, 305*self.Scale do		// Estos son los puntitos que salen despues de una explosion en Slendytubbies III..
		local Chispas3 = self.Emitter:Add( "lambdaplayers/effects/w_a_l_t/st3_effects/st3_chispas", self.Pos )
		if (Chispas3) then
		Chispas3:SetVelocity( VectorRand():GetNormalized()*math.random(340)*self.Scale )
		Chispas3:SetDieTime( math.Rand( 0 , 0.9 ) )
		Chispas3:SetStartAlpha( 255 )
		Chispas3:SetEndAlpha( 255 )
		Chispas3:SetStartSize( 4.47*self.Scale )
		Chispas3:SetEndSize( 5.57*self.Scale )
		Chispas3:SetRoll( math.Rand(52, -52) )
		Chispas3:SetRollDelta( math.Rand(-2, 2) )			
		Chispas3:SetAirResistance( 0.1 ) 			 
		Chispas3:SetGravity( Vector( math.Rand(-180, 180) * self.Scale, math.Rand(-150, 150) * self.Scale, math.Rand(-150, 150) ) ) 					
		Chispas3:SetColor( 120,20,3 )
		end
		end

end

function EFFECT:Think( )
return false
end


function EFFECT:Render()

end