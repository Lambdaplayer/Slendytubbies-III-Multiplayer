---MK18-----
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_mk16 = {
		model = "models/lambdaplayers/weapons/st3/w_st3_mk16.mdl",
		bonemerge = true,
		holdtype = {
            idle = ACT_HL2MP_IDLE_AR2,
            run = ACT_HL2MP_RUN_AR2,
            walk = ACT_HL2MP_WALK_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouchIdle = ACT_HL2MP_IDLE_CROUCH_AR2,
            crouchWalk = ACT_HL2MP_WALK_CROUCH_AR2,
            swimIdle = ACT_HL2MP_SWIM_IDLE_AR2,
            swimMove = ACT_HL2MP_SWIM_AR2
        },
		prettyname = "MK18",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_mk16",
        -----------------
        islethal = true,
		keepdistance = 500,
		attackrange = 2000,
        speedmultiplier = 0.884,
        ------------------
		clip = 15,
        damage = 16,
        spread = 0.125, 
        rateoffire = 0.20, --The Most Accurated rate of Fire
        tracername = "st3_ogtracer",
        muzzleflash = 1,
        --------------------
        shelleject = "RifleShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/mk16/mk16_fire.wav",
        ------------------
        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.9,
        reloadsounds = { 
            { 0, "lambdaplayers/weapons/SlendytubbiesSFX's/mk16/mk16_magout.wav" },
            { 0.6, "lambdaplayers/weapons/SlendytubbiesSFX's/mk16/mk16_magmove.wav" },
            { 1.2, "lambdaplayers/weapons/SlendytubbiesSFX's/mk16/mk16_magin.wav" }
        },
--------------------------------------------
        OnDeploy = function( self, wepent )
        	wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
        end,
--------------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
	if balanceAdjustment:GetBool() then
		_LAMBDAPLAYERSWEAPONS["st_mk16"].damage = 16
        _LAMBDAPLAYERSWEAPONS["st_mk16"].spread = 0.125
	else
        _LAMBDAPLAYERSWEAPONS["st_mk16"].damage = 28
        _LAMBDAPLAYERSWEAPONS["st_mk16"].spread = 0.2
	end
end,
--------------------------------------------
OnReload = function( self, wepent )
   if self.l_Clip > 15 then return true end
 end,
----------------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end

	}
} )