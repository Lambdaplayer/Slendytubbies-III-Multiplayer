
------------------------------
------MP UNUSED---------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_mp = {
		model = "models/lambdaplayers/weapons/w_st3_mp_unused.mdl",
		bonemerge = true,
		holdtype = "rpg",
		prettyname = "Mp",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_mp",
----------------------------------------------------------------
        islethal = true,
		keepdistance = 500,
		attackrange = 2000,
        speedmultiplier = 0.884,
-----------------------------------------------------------------
		clip = 35,
        damage = 10,
        spread = 0.125,
        rateoffire = 0.1,
        tracername = "st3_ogtracer",
        muzzleflash = 1,
        shelleject = "RifleShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/MP/st3_mp_shoot.wav",
---------------------------------------------------------------
        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.3, "lambdaplayers/weapons/SlendytubbiesSFX's/MP/st3_mp.wav" },
        },

        OnDeploy = function( self, wepent )
        	wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
        end,

        OnAttack = function( lambda )
            if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
        end,
------------------------------------------------------------------
        OnReload = function( self, wepent )
            if self.l_Clip > 15 then return true end
        end
	}
} )