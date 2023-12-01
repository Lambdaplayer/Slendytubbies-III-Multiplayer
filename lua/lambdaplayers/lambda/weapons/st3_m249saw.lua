table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_m249_saw = {
		model = "models/lambdaplayers/weapons/st3/w_st3_m249_saw.mdl",
		bonemerge = true,
		holdtype = {
            idle = ACT_HL2MP_IDLE_AR2,
            run = ACT_HL2MP_RUN_AR2,
            walk = ACT_HL2MP_WALK_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouchIdle = ACT_HL2MP_IDLE_CROUCH_AR2,
            crouchWalk = ACT_HL2MP_WALK_CROUCH_SHOTGUN,
            swimIdle = ACT_HL2MP_SWIM_IDLE_AR2,
            swimMove = ACT_HL2MP_SWIM_AR2
        },
		prettyname = "M249 Saw",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_m249_saw",

        islethal = true,
		keepdistance = 400,
		attackrange = 1000,
        speedmultiplier = 0.88,

		clip = 150,
        damage = 15,
        spread = 0.133,
        rateoffire = 0.075,
        bulletcount = 1,
        tracername = "st3_ogtracer",
        muzzleflash = 7,
        ----------------------------
        shelleject = "RifleShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        ----------------------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_fire.wav",

        reloadtime = 5.7,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.4,
        reloadsounds = { 
            { 0.5, "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_magout.wav" },
            { 1.5, "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_cover_open.wav" },
            { 2.7, "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_magin.wav" },
            { 3.3, "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_links_fall.wav" },
            { 4.5, "lambdaplayers/weapons/SlendytubbiesSFX's/m249_saw/st3_m249_saw_cover_close.wav" }
        },
-----------------------------------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
-----------------------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,
----------------------------------------------------
OnThink = function( lambda )
        local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
		if balanceAdjustment:GetBool() then
			_LAMBDAPLAYERSWEAPONS["st_m249_saw"].damage = 15
            _LAMBDAPLAYERSWEAPONS["st_m249_saw"].spread = 0.133
		else
            _LAMBDAPLAYERSWEAPONS["st_m249_saw"].damage = 27
            _LAMBDAPLAYERSWEAPONS["st_m249_saw"].spread = 0.2
		end
    end,
------------------------------------------------------
OnReload = function( self, wepent )
    if self.l_Clip > 0 then return true end
end
	}
} )