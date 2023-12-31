table.Merge( _LAMBDAPLAYERSWEAPONS, { --Another PlaceHolder Code
    st_machete = {
        model = "models/lambdaplayers/weapons/st3/w_st3_machete.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Machete",
        holdtype = "melee",
        ------------------------
        killicon = "lambdaplayers/killicons/icon_st3_machete",
        ismelee = true,
        keepdistance = 10,
        rateoffire = 0.8,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/knife/st3_knife_swing.wav",
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,
        hitsnd = "lambdaplayers/weapons/SlendytubbiesSFX's/machete/mach_hit_0*3*.wav",
        --------------------------

        bonemerge = true,
        islethal = true,
        damage = 45,
        attackrange = 73,
        ---------------------------
        OnThink = function( lambda )
            local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
            
            if balanceAdjustment:GetBool() then
                _LAMBDAPLAYERSWEAPONS["st_mcs870"].damage = 9
            else
                _LAMBDAPLAYERSWEAPONS["st_mcs870"].damage = 38
            end
        end,

        OnDeploy = function( self, wepent )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/draw_machete_sniper.wav" )
        end,
        ---------------------

        --------------------
    }
})
