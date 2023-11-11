/*
---------------------------------------
---------------------------------------

     Slendytubbies III Multiplayer
             Fire AXE

---------------------------------------
---------------------------------------*/
table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_fireaxe = {
        model = "models/lambdaplayers/weapons/st3/w_st3_fireaxe.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Fire Axe",
        holdtype = "melee2",
        ---------------
        killicon = "lambdaplayers/killicons/icon_st3_fireaxe",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        ----------------
        attackrange = 55,
        damage = 32,
        rateoffire = 0.9,
        islethal = true,
        ------------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/fireaxe/axe_hit.wav",
        hitsnd = "lambdaplayers/weapons/SlendytubbiesSFX's/fireaxe/st3_axe_swing.wav",

        OnThink = function( lambda )
            local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")

            if balanceAdjustment:GetBool() then
                _LAMBDAPLAYERSWEAPONS["st_fireaxe"].damage = 32
            else
                _LAMBDAPLAYERSWEAPONS["st_fireaxe"].damage = 39
            end
        end,

        OnDeploy = function( self, wepent )            
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav", 60, 100, 1, CHAN_ITEM )
        end,
    }
})
