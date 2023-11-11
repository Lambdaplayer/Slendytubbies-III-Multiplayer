local EffectData = EffectData
local IsFirstTimePredicted = IsFirstTimePredicted
local isfunction = isfunction
local random = math.random
local RandomPairs = RandomPairs
local Rand = math.Rand
local ipairs = ipairs
local Effect = util.Effect
local CurTime = CurTime
local string_find = string.find
local string_Explode = string.Explode
-----------------CONVARS--------------------
CreateLambdaConvar( "lambdaplayers_st3_balanceweps", 0, true, false, false, "If the ST3 Weapons Should allowd to use the OG stats instead of vanilla? [The Damage are not Instakill]", 0, 1, { type = "Bool", name = "Rebalance Weapons", category = "[Lambda ST3]Weapons Stuff" } )
----------------STUFF ---------------------
LAMBDA_ST3 = LAMBDA_ST3 or {}


function LAMBDA_ST3:GetEntityHeadBone( ent )
    for hboxSet = 0, ( ent:GetHitboxSetCount() - 1 ) do
        for hitbox = 0, ( ent:GetHitBoxCount( hboxSet ) - 1 ) do
            if ent:GetHitBoxHitGroup( hitbox, hboxSet ) != HITGROUP_HEAD then continue end
            return ( ent:GetHitBoxBone( hitbox, hboxSet ) )
        end
    end

    return ( ent:LookupBone( "ValveBiped.Bip01_Head1" ) )
end

function LAMBDA_ST3:IsValidCharacter( ent, alive )
    if alive == nil then alive = true end
    return ( ( ent:IsPlayer() or ent.IsLambdaPlayer ) and ( !alive or ent:Alive() ) or ( ent:IsNPC() or ent:IsNextBot() ) and ( !alive or ent:Health() > 0 ) )
end

function LAMBDA_ST3:RemapClamped( value, inMin, inMax, outMin, outMax )
    if inMin == inMax then return ( value >= inMax and outMax or outMin ) end
    local clampedValue = ( ( value - inMin ) / ( inMax - inMin ) )
    clampedValue = Clamp( clampedValue, 0, 1 )
    return ( outMin + ( outMax - outMin ) * clampedValue )
end


function LAMBDA_ST3:TranslateRandomization( string )
    local hasstar = string_find( string, "*" )

    if hasstar then
        local exp = string_Explode( "*", string )
        local firsthalf = exp[ 1 ]
        local num = exp[ 2 ]
        local secondhalf = exp[ 3 ]
        return ( firsthalf .. random( num ) .. secondhalf )
    else
        return string
    end
end

function LAMBDA_ST3:DefaultRangedWeaponFire( self, wepent, target, weapondata, callback, disabletbl )
	local bullettbl = {}
    if self.l_Clip <= 0 then self:ReloadWeapon() return end
    
    disabletbl = disabletbl or {}
    
    if !disabletbl.cooldown then 
        local cooldown = weapondata.rateoffire or Rand( weapondata.rateoffiremin, weapondata.rateoffiremax )
        self.l_WeaponUseCooldown = CurTime() + cooldown
    end

    if !disabletbl.sound then 
        wepent:EmitSound( LAMBDA_ST3:TranslateRandomization( weapondata.attacksnd ), 80, random( 98, 102 ), 1, CHAN_WEAPON ) 
    end
    
    if !disabletbl.muzzleflash then 
        self:HandleMuzzleFlash( weapondata.muzzleflash, weapondata.muzzleoffpos, weapondata.muzzleoffang ) 
    end
    
    if !disabletbl.shell then 
        self:HandleShellEject( weapondata.shelleject, weapondata.shelloffpos, weapondata.shelloffang ) 
    end

    if !disabletbl.anim then
        self:RemoveGesture( weapondata.attackanim )
        self:AddGesture( weapondata.attackanim )
    end

    if !disabletbl.clipdrain then 
        self.l_Clip = self.l_Clip - 1 
    end

    if !disabletbl.damage then
        bullettbl.Attacker = self
        bullettbl.Damage = weapondata.damage
		bullettbl.Callback = callback
        bullettbl.Force = weapondata.damage
        bullettbl.HullSize = 5
        bullettbl.Num = weapondata.bulletcount or 1
        bullettbl.TracerName = weapondata.tracername or "Tracer"
        bullettbl.Dir = IsValid(target) and ( target:WorldSpaceCenter() - wepent:GetPos() ):GetNormalized() or ( target - wepent:GetPos() ):GetNormalized()
        bullettbl.Src = wepent:GetPos()
        bullettbl.Spread = Vector( weapondata.spread, weapondata.spread, 0 )
        bullettbl.IgnoreEntity = self

        wepent:FireBullets( bullettbl )
    end    
end

function LAMBDA_ST3:DefaultMeleeWeaponUse( self, wepent, target, weapondata, disabletbl )

    disabletbl = disabletbl or {}

    if !disabletbl.cooldown then 
        local cooldown = weapondata.rateoffire or Rand( weapondata.rateoffiremin, weapondata.rateoffiremax )
        self.l_WeaponUseCooldown = CurTime() + cooldown
    end
    
    if !disabletbl.sound then 
        wepent:EmitSound( LAMBDA_ST3:TranslateRandomization( weapondata.attacksnd ), 75, random( 98, 102 ), 1, CHAN_WEAPON ) 
        target:EmitSound( LAMBDA_ST3:TranslateRandomization( weapondata.hitsnd ), 70 )
    end
    
    if !disabletbl.anim then
        self:RemoveGesture( weapondata.attackanim )
        self:AddGesture( weapondata.attackanim )
    end

    if !disabletbl.damage then
        local dmg = DamageInfo() 
        dmg:SetDamage( weapondata.damage )
        dmg:SetAttacker( self )
        dmg:SetInflictor( wepent )
        dmg:SetDamageType( DMG_CLUB )
        dmg:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * weapondata.damage )

        target:TakeDamageInfo( dmg )
    end
end

function LAMBDA_ST3:GetBoneTransformation( ent, index )
    local matrix = ent:GetBoneMatrix( index )
    if ismatrix( matrix ) then
        return matrix:GetTranslation(), matrix:GetAngles()
    end
    return ent:GetBonePosition( index )
end

function LAMBDA_ST3:IsUnderwater( self )
	return IsValid(self) and (self.IsLambdaPlayer and self:GetWaterLevel() >= 2) or self:WaterLevel() >= 2
end

function LAMBDA_ST3:ProjectileAim( ent, target, aimPerc )
	local ent = LambdaIsValid(ent) and ent:WorldSpaceCenter() or ent
	local target = LambdaIsValid(target) and target:WorldSpaceCenter() or target
	
	local fireDir = ( target - ent ):Angle()
	local angleTable = fireDir:ToTable()
	local inacc = 1000-aimPerc*10
	
	return Angle( 
		angleTable[1]+(math.random(-inacc,inacc)/100),
		angleTable[2]+(math.random(-inacc,inacc)/100),
		angleTable[3]+(math.random(-inacc,inacc)/100)
		)
end

function LAMBDA_ST3:SpawnPickUp( self, pickUpType, spawnRate )
	self:LookTo( self:GetPos(), spawnRate )
					
	local entity = LambdaSpawn_SENT( self, pickUpType, self:Trace( self:GetPos()+VectorRand( -32, 32 ), self:GetAttachmentPoint( "eyes" ).Pos ) )
	if !IsValid( entity ) then return end

	entity.LambdaOwner = self
	entity.IsLambdaSpawned = true

	self:DebugPrint( "spawned a Entity ", pickUpType )

	self:ContributeEntToLimit( entity, "Entity" )
	table.insert( self.l_SpawnedEntities, 1, entity )
end
-----
