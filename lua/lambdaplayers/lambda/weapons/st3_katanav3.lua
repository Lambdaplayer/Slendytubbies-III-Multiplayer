/*
---------------------------------------
----------------------------------------
SLENDYTUBBIES III MULTIPLAYER
            KATANA
---------------------------------------
--------------------------------------- */
local IsValid = IsValid
local random = math.random
local math_min = math.min
local CurTime = CurTime
local Rand = math.Rand
local bor = bit.bor


table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_katana = {
        model = "models/lambdaplayers/weapons/st3/w_st3_katana.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Katana",
        holdtype = "melee2",
        killicon = "lambdaplayers/killicons/icon_st3_katana",
        ismelee = true,
        bonemerge = true,
        ----------------
        islethal = true,
        keepdistance = 10,
        attackrange = 50,
        ----------------
        offpos = Vector( -2.5, -2, 0 ),
        ----------------
        damage = 29,
        rateoffire = 0.8,
        speedmultiplier = 1.41,
        ----------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_swing_miss*4*.wav",
        hitsnd = "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_0*3*.wav",
       ----------------------------
        OnEquip = function( lambda, wepent )
            ParticleEffectAttach( "speed_boost_trail", PATTACH_ABSORIGIN_FOLLOW, lambda, 0 )

            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_deploy.wav" )
            if GetConVar("lambdaplayers_st3_motivatedkatana"):GetBool() then
                wepent:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/katana/motivated/motivated"..math.random(1,20)..'.mp3', 90 )
            end

            if GetConVar("lambdaplayers_st3_alternativekatana"):GetBool() then
                wepent:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/katana/alternative/wave"..math.random(1,8)..".mp3", 90 )
            end
        end,

    }
})