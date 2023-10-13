--MP5N--
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_mp5n = {
		model = "models/lambdaplayers/weapons/st3/w_st3_mp5n.mdl ",
		bonemerge = true,
		holdtype = "smg", --yeah the model doesn't fit with smg anims
		prettyname = "Mp5n",
		origin =  "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_mp5n",
        ------------------------------------------
        islethal = true,
		keepdistance = 500,
		attackrange = 1500,
        -------------------------------------------
		clip = 25,
        damage = 15,
        spread = 0.2,
        rateoffire = 0.1,
        tracername = "st3_ogtracer",
        muzzleflash = 1,
        --------------------------------------------
        shelleject = "ShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_fire.wav",
        ----------------------------------------------
        reloadtime = 3.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 0.6,
        reloadsounds = { 
            { 0, "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_boltpull.wav" },
            { 0.6, "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_magout.wav" },
            { 1.0, "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_magmove.wav" },
            { 1.7, "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_magin.wav" },
            { 2.5, "lambdaplayers/weapons/SlendytubbiesSFX's/mp5n/mp5n_boltslap.wav" }
        },
-------------------------------------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
 end,
-------------------------------------------------------
OnAttack = function( lambda )
    if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
end,
------------------------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
	if balanceAdjustment:GetBool() then
		_LAMBDAPLAYERSWEAPONS["st_mp5n"].damage = 15
        _LAMBDAPLAYERSWEAPONS["st_mp5n"].spread = 0.2
		else
        _LAMBDAPLAYERSWEAPONS["st_mp5n"].damage = 28
        _LAMBDAPLAYERSWEAPONS["st_mp5n"].spread = 0.4
	end
end,
---------------------------------------------------------
OnReload = function( self, wepent )
    if self.l_Clip > 10 then return true end
end
	}
} )