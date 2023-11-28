local IsValid = IsValid
------44 Combat----------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
-------------------
    st_44combat = {
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "44 Combat",
        holdtype = "revolver",
        killicon = "lambdaplayers/killicons/icon_st3_44_combat",
        bonemerge = true,
        ------------------
        model = "models/lambdaplayers/weapons/st3/w_st3_44_combat.mdl",
        keepdistance = 550,
        attackrange = 3500,
        -------------------
        clip = 4,
        tracername = "st3_ogtracer",
        damage = 10,
        spread = 0.08,
        ------------------
        rateoffire = 0.7,
        muzzleflash = 1,
        shelleject = "none",
        -------------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/44Combat/st3_44_fire.wav",
        -------------------
        reloadtime = 3.62,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0, "lambdaplayers/weapons/SlendytubbiesSFX's/44Combat/st3_44_reload.wav" },
        },
--------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
---------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
			
		if balanceAdjustment:GetBool() then
			_LAMBDAPLAYERSWEAPONS["st_44combat"].damage = 10
            _LAMBDAPLAYERSWEAPONS["st_44combat"].spread = 0.08
		else
            _LAMBDAPLAYERSWEAPONS["st_44combat"].damage = 49
            _LAMBDAPLAYERSWEAPONS["st_44combat"].spread = 0.2
		end
    end,
-----------------------------------------------------
    OnAttack = function( lambda )
        if LAMBDA_ST3:IsUnderwater(lambda) then lambda:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/dryfire_revolver.wav") lambda.l_WeaponUseCooldown = CurTime() + 0.2 return end
    end,
-------------------------------------------------------------------------
    OnReload = function( self, wepent )
        local anim = self:LookupSequence( "reload_revolver_base_layer" )
        if anim != -1 then
                -- Stops animation's event sounds from running
            self:AddGestureSequence( anim )
        else
            self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_REVOLVER )
        end

            -- Cool shell ejects
        self:SimpleWeaponTimer( 1.3, function() 
            for i = 1, 6 do self:HandleShellEject( "ShellEject" ) end
        end )
    end,
------------------------------------------------------------------------
        islethal = true,
    }

})