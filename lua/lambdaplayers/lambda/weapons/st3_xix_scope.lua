table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_xix_pistol_scoped = {
        model = "models/lambdaplayers/weapons/st3/w_st3_xix_ii.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Xix II [Scope]",
        holdtype = "revolver",
        killicon = "lambdaplayers/killicons/icon_st3_xix",
        ------------------------
        bonemerge = true,
        keepdistance = 450,
        attackrange = 2000,
        -----Don't Touch This CODE This Weapon Needs it for work-----
        islethal = true,
        -----------------------------
        clip = 10,
        tracername = "st3_ogtracer",
        damage = 14,
        spread = 0.133,
        rateoffire = 0.19,
        ---------------------------------
        muzzleflash = 1,
        shelleject = "ShellEject",
        shelloffpos = Vector(0,2,5),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/xix/xix_fire.wav",

        reloadtime = 1.8,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0, "lambdaplayers/weapons/SlendytubbiesSFX's/xix/xix_magout.wav" },
            { 0.6, "lambdaplayers/weapons/SlendytubbiesSFX's/xix/xix_magin.wav" },
            { 1.3, "lambdaplayers/weapons/SlendytubbiesSFX's/xix/xix_slideback.wav" },
            { 1.5, "lambdaplayers/weapons/SlendytubbiesSFX's/xix/xix_slideforward.wav" },
         },
---------------------------------------------
OnThink = function ( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
	if balanceAdjustment:GetBool() then
		_LAMBDAPLAYERSWEAPONS["st_xix_pistol_scoped"].damage = 14
        _LAMBDAPLAYERSWEAPONS["st_xix_pistol_scoped"].spread = 0.133
	else
        _LAMBDAPLAYERSWEAPONS["st_xix_pistol_scoped"].damage = 21
        _LAMBDAPLAYERSWEAPONS["st_xix_pistol_scoped"].spread = 0.2
	end
end,
--------------------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
-------------------------------------------------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_pistol.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,
    }
} )