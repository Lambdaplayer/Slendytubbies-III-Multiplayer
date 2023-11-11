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
local util_Effect = util.Effect

local useBlockSounds = CreateLambdaConvar( "lambdaplayers_st3_blocksounds", 1, true, false, true, "Can The Katana Play Block Sounds on damage?", 0, 1, { type = "bool", name = "Katana - Block Zeta SFX's", category = "[Lambda ST3]Weapons Stuff" } )
local useblockdmg = CreateLambdaConvar( "lambdaplayers_st3_katanablock", 1, true, false, true,  "Allow The Katana Can Reflect Bullets and melee weapons?", 0, 1, { type = "bool", name = "Katana - Block Damage", category = "[Lambda ST3]Weapons Stuff" } )
local getHyped = CreateLambdaConvar( "lambdaplayers_st3_hypekatana", 1, true, false, true, "If a Lambda Player that equips the katana should play Soundtracks?", 0, 1, { type = "Bool", name = "Katana - Hype", category = "[Lambda ST3]Weapons Stuff" } )

local hypeSnds = {
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype1.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype2.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype3.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype4.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype5.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype6.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype7.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype8.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype9.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype10.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype11.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype12.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype13.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype14.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype15.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype16.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype17.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype18.ogg",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype19.mp3",
    "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_hype20.mp3"
}

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
        keepdistance = 2,
        attackrange = 50,
        ----------------
        offpos = Vector( -2.5, -2, 0 ),
        ----------------
        damage = 29,
        rateoffire = 0.5,
        speedmultiplier = 1.48,
        ----------------
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_swing_miss*4*.wav",
        hitsnd = "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_0*3*.wav",
----------------------------
OnDeploy = function( lambda, wepent )
    wepent:EmitSound( "weapons/discipline_device_power_up.wav" )
    ParticleEffectAttach( "speed_boost_trail", PATTACH_ABSORIGIN_FOLLOW, lambda, 0 )

wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/katana/st3_katana_deploy.wav" )
    if GetConVar("lambdaplayers_st3_motivatedkatana"):GetBool() then
        wepent:EmitSound("lambdaplayers/weapons/SlendytubbiesSFX's/katana/motivated/motivated"..math.random(1,20)..'.mp3', 90 )
    end

    if getHyped:GetBool() then
        wepent:EmitSound( hypeSnds[ random(#hypeSnds ) ], 122, 100, 0.9, CHAN_STATIC )
    end
end,
-----------------------------
OnHolster = function( lambda, wepent )
    LAMBDA_ST3:StopParticlesNamed( lambda, "speed_boost_trail" )

    wepent:EmitSound( "weapons/discipline_device_power_down.wav", 70 )

    for i = 1, #hypeSnds do
        wepent:StopSound( hypeSnds[ i ] )
    end
end,
----------------------------
OnThink = function( lambda, wepent )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
    
    if balanceAdjustment:GetBool() then
        _LAMBDAPLAYERSWEAPONS["st_katana"].damage = 29
    else
        _LAMBDAPLAYERSWEAPONS["st_katana"].damage = 42
    end
end,
----------------------
OnTakeDamage = function( self, wepent, dmginfo )
    if !useblockdmg:GetBool() or !dmginfo:IsDamageType( bor( DMG_CLUB, DMG_SLASH, DMG_BULLET ) ) or random( 1, 2 ) == 1 or ( ( self.l_WeaponUseCooldown - 0.5 ) - CurTime() ) > 0 then return end

    self:RemoveGesture( ACT_HL2MP_FIST_BLOCK )
    self:AddGesture( ACT_HL2MP_FIST_BLOCK, false )
    self:SimpleTimer( 0.2, function() self:RemoveGesture( ACT_HL2MP_FIST_BLOCK ) end, true )

    local attacker = dmginfo:GetAttacker()
    if (self:GetForward():Dot((attacker:GetPos() - self:GetPos()):GetNormalized()) <= math.cos(math.rad(80))) then return end

    local effectdata = EffectData()
    local sparkPos = dmginfo:GetDamagePosition()
    if self:GetRangeSquaredTo(sparkPos) > (150*150) then sparkPos = wepent:GetPos() end
    local sparkForward = ((attacker:GetPos()+attacker:OBBCenter()) - sparkPos):Angle():Forward()
    effectdata:SetOrigin( sparkPos + sparkForward*10 )
    effectdata:SetNormal( sparkForward )
    util.Effect( "Sparks", effectdata, true, true ) --IT WORKS!!!!! FUCK YEAHHHHHHHH

    dmginfo:ScaleDamage( 0.82 )
    if !useBlockSounds:GetBool() then wepent:EmitSound( "physics/metal/metal_solid_impact_bullet4.wav" ) end
    if useBlockSounds:GetBool() then wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/katana/katana_deflect_bullet".. random( 1, 3 ).. ".wav", 80 ) end
    self.l_WeaponUseCooldown = self.l_WeaponUseCooldown + Rand( 0.25, 0.33 )
end,
----------------------------------
    }
})