local CurTime = CurTime
local ents_Create = ents.Create
local random = math.random
local Rand = math.Rand
local EffectData = EffectData
local util_Effect = util.Effect
local SpriteTrail = util.SpriteTrail
local BlastDamage = util.BlastDamage
local PlyColor = PlyColor

game.AddParticles("particles/stickybomb.pcf")

local function GrenadeOnTouch( self, ent )
    local owner = self:GetOwner()
    if ent == owner or !ent:IsSolid() or ent:GetSolidFlags() == FSOLID_VOLUME_CONTENTS then return end

    local projPos = self:GetPos()
    local attacker = ( IsValid( owner ) and owner or self )
    local inflictor = ( attacker == owner and ( IsValid( owner:GetWeaponENT() ) and owner:GetWeaponENT() or owner ) or self )
    BlastDamage( inflictor, attacker, projPos, 999, 999 )

    if IsFirstTimePredicted() then
        local effectData = EffectData()
        effectData:SetOrigin( projPos )
        effectData:SetFlags( 4 )
        util_Effect( "cball_explode", effectData )

        ParticleEffect("ExplosionCore_MidAir", self:GetPos(), self:GetAngles())
    end

    self:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/grenade/explode"..math.random(1,3)..".mp3", 100, nil, nil, CHAN_STATIC )
    self:Remove()
end

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st3_grenade_launcher = {
        model = "models/lambdaplayers/weapons/st3/w_m79_grenadelauncher.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Grenade Launcher",
        holdtype = "shotgun",
        killicon = "lambdaplayers/killicons/icon_st3_grenadelauncher",
        bonemerge = true,

        clip = 1,
        islethal = true,
        attackrange = 999,
        keepdistance = 1000,

        reloadtime = 2.2,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        reloadanimspeed = 1,
        reloadsounds = { 
            { 0.3, "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_grenade_open_drum.wav" },
            { 0.75, "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_grenade_shellout.mp3" },
            { 1.4, "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_insert_grenade.mp3" },
            { 1.95, "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_grenade_closed.mp3" }
        },

        OnDeploy = function( lambda, wepent )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav", 65, 100, 1, CHAN_ITEM )
        end,

        OnAttack = function( lambda, wepent, target )
            local spawnPos = wepent:GetAttachment( wepent:LookupAttachment( "muzzle" ) ).Pos
            local targetPos = ( lambda:IsInRange( target, 100 ) and target:WorldSpaceCenter() or target:GetPos() + vector_up * ( lambda:GetRangeTo( target ) / random( 10, 12 ) ) )
            targetPos = LAMBDA_ST3:CalculateEntityMovePosition( target, spawnPos:Distance( targetPos ), 1200, Rand( 0.5, 1.1 ), targetPos )

            if lambda.l_Clip <= 0 then lambda:ReloadWeapon() return true end

            --local muzzleData = wepent:GetAttachment( wepent:LookupAttachment( "muzzle" ) )
            --local spawnPos = wepent:GetAttachment( wepent:LookupAttachment( "muzzle" ) ).Pos

            local velAng = ( ( target:GetPos() + Vector( 0, 0, lambda:GetRangeTo( target ) / 8 ) ) - spawnPos ):Angle()
            if lambda:GetForward():Dot( velAng:Forward() ) < 0.66 then lambda.l_WeaponUseCooldown = CurTime() + 0.1; return true end

            lambda.l_Clip = lambda.l_Clip - 1
            lambda.l_WeaponUseCooldown = CurTime() + Rand( 0.66, 0.8 )

            lambda:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )
            lambda:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW )

            lambda:HandleMuzzleFlash( 1 )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_grenade_shoot.wav", 75, random( 98, 102 ), 1, CHAN_WEAPON )

            local proj = ents_Create( "base_anim" )
            proj:SetModel( "models/lambdaplayers/weapons/st3/w_40mm_grenade_launched.mdl" )
            proj:SetPos( spawnPos )
            proj:SetOwner( lambda )
            proj:Spawn()

            proj.Touch = GrenadeOnTouch
            proj:SetMoveType( MOVETYPE_FLYGRAVITY )
            proj:SetSolid( SOLID_BBOX )
            proj:SetAngles( velAng )
            proj:SetVelocity( velAng:Forward() * 1400 )
            ParticleEffectAttach( "player_intel_trail_blue", PATTACH_ABSORIGIN_FOLLOW, proj, 0 )
            SpriteTrail( proj, 0, PlyColor, true, 8, 8, 1, 0.025, "trails/laser" )

            return true
        end
    }
} )