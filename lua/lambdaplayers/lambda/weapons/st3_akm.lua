------------RANGED WEAPON------------------
--AKM--
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_akm = {
		model = "models/lambdaplayers/weapons/st3/w_st3_akm.mdl",
		bonemerge = true,
		holdtype = "ar2",
		prettyname = "Akm",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_akm",
----------------------------------------------------------------
        islethal = true,
		keepdistance = 500,
		attackrange = 2000,
        speedmultiplier = 0.884,
-----------------------------------------------------------------
		clip = 30,
        damage = 9,
        spread = 0.125,
        rateoffire = 0.1,
        tracername = "st3_ogtracer",
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_fire.wav",
---------------------------------------------------------------
        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 0.9,
        reloadsounds = { 
            { 0., "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_release.wav" },
            { 0.3, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_magout.wav" },
            { 0.4, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_magmove.wav" },
            { 0.9, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_magplace.wav"},
            { 1.0, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_magin.wav" },
            { 1.6, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_boltpull.wav" },
            { 2.1, "lambdaplayers/weapons/SlendytubbiesSFX's/Akm/st3_akm_boltforward.wav" }
        },
-------------Functions Code. Remove this if you want they are just to be Accurated to the Slendytubbies III Game-------------------
OnDeploy = function( self, wepent )
        wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
---------------------------------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,
----------------------------------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
    
    if balanceAdjustment:GetBool() then
        _LAMBDAPLAYERSWEAPONS["st_akm"].damage = 9
        _LAMBDAPLAYERSWEAPONS["st_akm"].spread = 0.125
    else
        _LAMBDAPLAYERSWEAPONS["st_akm"].damage = 36
        _LAMBDAPLAYERSWEAPONS["st_akm"].spread = 0.4
    end
end,
----------------------------------------------------------------
OnReload = function( self, wepent )
    if self.l_Clip > 15 then return true end
end,

	}
} )