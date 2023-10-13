local shelloffpos = Vector( 10, 0, 3 )
local shelloffang = Angle( 0, -90, 0 )
local callbackTbl = { cooldown = true }
local Rand = math.Rand

local scopedCallbackTbl = { damage = true, cooldown = true }
local scopedBullet = {
    Damage = 71,
    Force = 65,
    Spread = Vector( 0.15, 0.15, 0 ),
    TracerName = "st3_ogtracer", 
    HullSize = 5
}

------M40A1 Sniper Rifle-------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_blazer_sniper = {
		model = "models/lambdaplayers/weapons/w_st3_blaser.mdl",
		bonemerge = true,
		holdtype = "ar2",
		prettyname = "Blazer",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_blaser", --gived its own kill icon
        ------------------
        islethal = true,
		keepdistance = 1500,
		attackrange = 3000,
        speedmultiplier = 1.04,
        -------------------
		clip = 5,
        damage = 45, --no 90?
        spread = 0.05,
        tracername = "st3_ogtracer", --the bullet tracer
        muzzleflash = 1,
        shelleject = false,
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/Blazer/st3_blazer.wav",
        --------------------
        reloadtime = 3.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 0.66,
        reloadsounds = { 
            { 0.3, "lambdaplayers/weapons/SlendytubbiesSFX's/MP/st3_mp.wav" },
        },
        ----------CLIENT-SIDES & SERVER-SIDES CODE---------------
        OnDeploy = function( self, wepent )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav", 70 )
            wepent.IsScopedIn = false
        end,
        ------------------------------------------
        OnAttack = function( self, wepent, target )
            if LAMBDA_ST3:IsUnderwater(self) then wepent:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end

            local scopedIn = wepent.IsScopedIn
            self.l_WeaponUseCooldown = CurTime() + ( scopedIn and Rand( 3.0, 4.0 ) or Rand( 1.66, 2.0 ) )

            self:SimpleTimer( 0.6, function() 
                wepent:EmitSound( "Weapon_AWP.Bolt" )
                self:HandleShellEject( "RifleShellEject", shelloffpos, shelloffang ) 
            end )
            self:SimpleTimer( 1.0, function() 
                wepent:EmitSound( "Weapon_AWP.Bolt" )
            end )

            if !scopedIn then
                scopedBullet.Attacker = self
                scopedBullet.IgnoreEntity = self
                scopedBullet.Src = wepent:GetPos()
                scopedBullet.Dir = ( target:WorldSpaceCenter() - scopedBullet.Src ):GetNormalized()
                wepent:FireBullets( scopedBullet )
            end

            return ( scopedIn and callbackTbl or scopedCallbackTbl )
        end,

        OnThink = function( self, wepent, isdead )
            local ene = self:GetEnemy()
            local curScoped = wepent.IsScopedIn

            wepent.IsScopedIn = ( !isdead and LambdaIsValid( ene ) and self:GetState() == "Combat" and !self:IsInRange( ene, 512 ) and self:CanSee( ene ) )
            if wepent.IsScopedIn != curScoped then
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/draw_default.wav" ) --this sound is from tf2 so yeah
            end

            self.l_HoldType = ( wepent.IsScopedIn and "rpg" or "ar2" )
            self.l_WeaponSpeedMultiplier = ( wepent.IsScopedIn and 0.66 or 1.04 )

            return Rand( 0.25, 0.5 )
        end,

        OnReload = function( self, wepent )
            if self.l_Clip > 3 then return true end
        end
	}
} )