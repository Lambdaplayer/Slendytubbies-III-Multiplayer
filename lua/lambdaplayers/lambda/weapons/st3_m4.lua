---M4-----
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_m4 = {
		model = "models/lambdaplayers/weapons/w_st3_m4.mdl",
		bonemerge = true,
		holdtype = "smg",
		prettyname = "M4",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_m4",
        -----------------
        islethal = true,
		keepdistance = 500,
		attackrange = 2000,
        speedmultiplier = 0.884,
        ------------------
		clip = 15,
        damage = 16,
        spread = 0.127, 
        rateoffire = 0.20, --The Most Accurated rate of Fire
        tracername = "st3_ogtracer", --Tracer thing
        muzzleflash = 1,
        --------------------
        shelleject = "RifleShellEject",
        shelloffpos = Vector( 10, 0, 3 ),
        shelloffang = Angle( 0, -90, 0 ),
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/M4/st3_m4_fire.wav",
        ------------------
        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 0.9,
        reloadsounds = { 
            { 0.4, "lambdaplayers/weapons/SlendytubbiesSFX's/M4/st3_m4reload.wav" },
        },
        -----------------------
        OnAttack = function( lambda )
            if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_rifle.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
        end,
        -----------------------
        OnDeploy = function( self, wepent )
        	wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
        end,
        ----------------------------
        OnThink = function( lambda )
            local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
			if balanceAdjustment:GetBool() then
				_LAMBDAPLAYERSWEAPONS["st_m4"].damage = 16
			else
                _LAMBDAPLAYERSWEAPONS["st_m4"].damage = 28
			end
        end,
        ------------------------
        OnReload = function( self, wepent )
            if self.l_Clip > 15 then return true end
        end
	}
} )