local shelloffpos = Vector( 10, 0, 3 )
local shelloffang = Angle( 0, -90, 0 )
local callbackTbl = { cooldown = true }
local Rand = math.Rand
local ipairs = ipairs
local Effect = util.Effect
local CurTime = CurTime
local string_find = string.find
local Rand = math.Rand
local random = math.random
local Rand = math.Rand
------CRIT--------
local critCallbackTbl = { damage = true, cooldown = true }
local critBullet = {
    Damage = 100,
    Force = 100,
    Spread = Vector( 0, 0, 0 ),
    TracerName = "st3_snipertracer",
    HullSize = 5
}

local MLGShot = CreateLambdaConvar("lambdaplayers_st3_allowmlgshot", 0, true, false, true, "Allows the LambdaPlayers to hit critical shots with the M40A3, making room for those MLG gamer moments", 0, 1, { type = "Bool", name = "M40A3 - Sniper Crit", category = "[Lambda ST3]Weapons Stuff" } )

local scopedCallbackTbl = { damage = true, cooldown = true }
local scopedBullet = {
    Damage = 56,
    Force = 100,
    Spread = Vector( 0, 0, 0 ),
    TracerName = "st3_ogtracer",
    HullSize = 5
}

------M40A1 Sniper Rifle-------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_m40a3_sniper = {
		model = "models/lambdaplayers/weapons/st3/w_st3_m40a3.mdl",
		bonemerge = true,
		holdtype = "ar2",
		prettyname = "M40A3",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_m40a3",
        ------------------
        islethal = true,
		keepdistance = 1500,
		attackrange = 3000,
        speedmultiplier = 1.04,
        -------------------
		clip = 5,
        damage = 35, --no 90?
        spread = 0.05,
        tracername = "st3_ogtracer", --the bullet tracer
        muzzleflash = 1,
        shelleject = false,
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_fire.wav",
        --------------------
        reloadtime = 3.0,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 0.66,
        reloadsounds = { 
            { 0.3, "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_reload_start.wav" },
            { 0.5, "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_reload_insert.wav" },
            { 0.7, "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_reload_insert.wav" },
            { 1.0, "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_reload_insert.wav" },
            { 1.5, "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_reload_end.wav" }
        },
        --------------------------------
        headshotsfx = "player/headshot1.wav",

        callback = function( wepent, target )
        end,

        OnDeploy = function( self, wepent )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav", 70 )
            wepent.IsScopedIn = false
        end,

        OnAttack = function( lambda, wepent, target )
            if LAMBDA_ST3:IsUnderwater(lambda) then wepent:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
            local wepdata = table.Copy(_LAMBDAPLAYERSWEAPONS["st_m40a3_sniper"])

            if math.random(30) == 1 and GetConVar("lambdaplayers_st3_allowmlgshot"):GetBool() then

                critBullet.Attacker = lambda
                critBullet.IgnoreEntity = lambda
                critBullet.Src = wepent:GetPos()
                critBullet.Dir = ( target:WorldSpaceCenter() - critBullet.Src ):GetNormalized()

                target:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/bsmod/headshotdie" .. random( 1, 3 ) .. ".wav", nil, nil, 70 )
                ParticleEffect("crit_text", target:EyePos() + (target:EyeAngles():Right() * 1) + (target:EyeAngles():Up() * 8) + (target:EyeAngles():Forward()*1), target:EyeAngles() )-- Requieres TF2 Content mounted
                target:EmitSound("player/crit_hit"..math.Round(math.Rand(2,5))..".wav")   --Requieres TF2 Content Mounted
                wepent:FireBullets( critBullet )

                return ( critCallbackTbl )
            end

            local scopedIn = wepent.IsScopedIn
            lambda.l_WeaponUseCooldown = CurTime() + ( scopedIn and Rand( 2.5, 3.5 ) or Rand( 1.25, 1.66 ) )

            lambda:SimpleTimer( 0.6, function()
                local layerID = lambda:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                lambda:SetLayerCycle(layerID, 0.5)
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_boltback.wav" )
                lambda:HandleShellEject( "RifleShellEject", shelloffpos, shelloffang ) 
            end )
            lambda:SimpleTimer( 1.0, function() 
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/m40a3/st3_m40a3_boltforward.wav" )
            end )

            if !scopedIn then
                scopedBullet.Attacker = lambda
                scopedBullet.IgnoreEntity = lambda
                scopedBullet.Src = wepent:GetPos()
                scopedBullet.Dir = ( target:WorldSpaceCenter() - scopedBullet.Src ):GetNormalized()
                wepent:FireBullets( scopedBullet )
            end

            return ( scopedIn and callbackTbl or scopedCallbackTbl )
        end,

        OnThink = function( lambda, wepent, isdead )
            local ene = lambda:GetEnemy()
            local curScoped = wepent.IsScopedIn

            local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
			if balanceAdjustment:GetBool() then
                _LAMBDAPLAYERSWEAPONS["st_m40a3_sniper"].damage = 35
				_LAMBDAPLAYERSWEAPONS["st_m40a3_sniper"].spread = 0.05
			else
				_LAMBDAPLAYERSWEAPONS["st_m40a3_sniper"].spread = 0.1
                _LAMBDAPLAYERSWEAPONS["st_m40a3_sniper"].damage = 87
			end

            wepent.IsScopedIn = ( !isdead and LambdaIsValid( ene ) and lambda:GetState() == "Combat" and !lambda:IsInRange( ene, 512 ) and lambda:CanSee( ene ) )
            if wepent.IsScopedIn != curScoped then
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/zoom.wav" ) --Aim Sounds
            end

            lambda.l_HoldType = ( wepent.IsScopedIn and "rpg" or "ar2" )
            lambda.l_WeaponSpeedMultiplier = ( wepent.IsScopedIn and 0.66 or 1.04 )

            return Rand( 0.25, 0.5 )
        end,

        OnReload = function( self, wepent )
            if self.l_Clip > 3 then return true end
        end
	}
} )