--VZ61--
table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_vz61 = {
        model = "models/lambdaplayers/weapons/st3/w_st3_vz61.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Vz61",
        holdtype = "pistol",
        killicon = "lambdaplayers/killicons/icon_st3_vz61", 
        bonemerge = true,
        keepdistance = 350,
        attackrange = 2000,
        ------------------
        clip = 20,
        tracername = "st3_ogtracer",
        damage = 14, --this was 5 so i change to 14
        spread = 0.6,
        rateoffire = 0.1,
        -------------------
        muzzleflash = 1,
        shelleject = "ShellEject",
        shelloffpos = Vector(0,2,5),
        --------------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/vz61/st3_vz61_fire.wav",
        ---------------------
        reloadtime = 1.8,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.7, "lambdaplayers/weapons/SlendytubbiesSFX's/vz61/st3_vz61_magout.wav" },
            { 1.5, "lambdaplayers/weapons/SlendytubbiesSFX's/vz61/st3_vz61_magin.wav" }
        },

        islethal = true,

---------------------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
----------------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
	if balanceAdjustment:GetBool() then
			_LAMBDAPLAYERSWEAPONS["st_vz61"].damage = 14
            _LAMBDAPLAYERSWEAPONS["st_vz61"].spread = 0.125
		else
            _LAMBDAPLAYERSWEAPONS["st_vz61"].damage = 29
            _LAMBDAPLAYERSWEAPONS["st_vz61"].spread = 0.4
		end
    end,
---------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_pistol.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,

    }
})
