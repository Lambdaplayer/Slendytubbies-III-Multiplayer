local IsValid = IsValid
local net = net
local SimpleTimer = timer.Simple
local random = math.random
local min = math.min
local VectorRand = VectorRand
local isnumber = isnumber
local CurTime = CurTime
local coroutine_yield = coroutine.yield
local istable = istable
local ents_Create = ents.Create
local ParticleEffect = ParticleEffect
local ParticleEffectAttach = ParticleEffectAttach
local GetConVar = GetConVar
local band = bit.band
local string_Explode = string.Explode
local Rand = math.Rand
local Clamp = math.Clamp
local Round = math.Round
local max = math.max
local ipairs = ipairs
local FrameTime = FrameTime
local DamageInfo = DamageInfo
local SafeRemoveEntity = SafeRemoveEntity
local SafeRemoveEntityDelayed = SafeRemoveEntityDelayed
local SpriteTrail = util.SpriteTrail
local Decal = util.Decal
local table_Empty = table.Empty
local table_remove = table.remove
local table_Count = table.Count
local FindInSphere = ents.FindInSphere
local Weld = constraint.Weld
local SetPhysProp = construct.SetPhysProp
local TraceLine = util.TraceLine
local TraceHull = util.TraceHull

local pushScale = GetConVar( "phys_pushscale" )
local ignorePlys = GetConVar( "ai_ignoreplayers" )

LAMBDA_ST3 = LAMBDA_ST3 or {}

ST_DMG_CUSTOM_BACKSTAB                  = 512

function LAMBDA_ST3:IsBehindBackstab( ent, target )
    local vecToTarget = ( target:GetPos() - ent:GetPos() ); vecToTarget.z = 0; vecToTarget:Normalize()
    local vecOwnerForward = ent:GetForward(); vecOwnerForward.z = 0; vecOwnerForward:Normalize()
    local vecTargetForward = target:GetForward(); vecTargetForward.z = 0; vecTargetForward:Normalize()
    return ( vecToTarget:Dot( vecTargetForward ) > 0 and vecToTarget:Dot( vecOwnerForward ) > 0.5 and vecTargetForward:Dot( vecOwnerForward ) > -0.3 )
end

local calcMoveTrTbl = {}

function LAMBDA_ST3:CalculateEntityMovePosition( ent, distance, speed, offsetScale, offsetPos )
    offsetPos = ( offsetPos or ent:GetPos() )
    local mins, maxs = ent:GetCollisionBounds()

    local entVel = ( ( ent:IsNextBot() and ent.loco or ent ):GetVelocity() * ( ( distance * offsetScale ) / speed )  )
    local entVelPos = ( offsetPos + entVel )
    if ent:OnGround() and entVelPos.z > offsetPos.z then entVelPos.z = offsetPos.z end

    calcMoveTrTbl.start = offsetPos
    calcMoveTrTbl.endpos = entVelPos
    calcMoveTrTbl.filter = ent
    calcMoveTrTbl.collisiongroup = ent:GetCollisionGroup()
    calcMoveTrTbl.mins = mins
    calcMoveTrTbl.maxs = maxs

    return TraceHull( calcMoveTrTbl ).HitPos
end

function LAMBDA_ST3:TakeNoDamage( ent )
    ent:SetSaveValue( "m_takedamage", 0 )
end

function LAMBDA_ST3:TakesDamage( ent )
    return ( ent:GetInternalVariable( "m_takedamage" ) == 2 )
end

function LAMBDA_ST3:IsDamageCustom( dmginfo, dmgCustom )
    return band( ( isnumber( dmginfo ) and dmginfo or dmginfo:GetDamageCustom() ), dmgCustom ) != 0
end

function LAMBDA_ST3:InitializeWeaponData( lambda, weapon )
    weapon.ST3Data = {}

    weapon:SetSkin( 0 )
    for _, bg in ipairs( weapon:GetBodyGroups() ) do
        weapon:SetBodygroup( bg.id, 0 )
    end

    weapon.l_ST_CritTime = CurTime()
    weapon.l_ST_LastFireTime = CurTime()
    weapon.l_ST_LastRapidFireCritCheckT = CurTime()

    weapon.SetWeaponAttribute = SetWeaponAttribute
    weapon.GetWeaponAttribute = GetWeaponAttribute
    weapon.CalcIsAttackCriticalHelper = CalcIsAttackCriticalHelper
end

function LAMBDA_ST3:RadiusDamageInfo( dmginfo, pos, radius, impactEnt, ignoreEnt )
    if radius <= 0 then return end
    
    local radSqr = ( radius * radius )

    local baseDamage = dmginfo:GetDamage()
    local baseDamageForce = dmginfo:GetDamageForce()
    local baseDamagePos = dmginfo:GetDamagePosition()
    
    local fallOff = ( baseDamage / radius )
    if LAMBDA_ST3:IsDamageCustom( dmginfo, TF_DMG_CUSTOM_RADIUS_MAX ) then
        fallOff = 0
    elseif LAMBDA_ST3:IsDamageCustom( dmginfo, TF_DMG_CUSTOM_HALF_FALLOFF ) then
        fallOff = 0.5
    end

    explosionTrTbl.start = pos

    for _, ent in ipairs( FindInSphere( pos, radius ) ) do
        if ent == ignoreEnt or !LambdaIsValid( ent ) or !LAMBDA_ST3:TakesDamage( ent ) then continue end

        local nearPoint = ent:NearestPoint( pos )
        if nearPoint:DistToSqr( pos ) > radSqr then continue end
        
        local entPos = ent:WorldSpaceCenter()
        explosionTrTbl.endpos = entPos
        
        local tr = TraceLine( explosionTrTbl )
        if tr.Fraction != 1.0 and tr.Entity != ent then continue end

        local distToEnt
        if IsValid( impactEnt ) and ent == impactEnt then
            distToEnt = 0
        elseif LAMBDA_ST3:IsValidCharacter( ent ) then
            distToEnt = min( pos:Distance( entPos ), pos:Distance( ent:GetPos() ) )
        else
            distToEnt = pos:Distance( tr.HitPos )
        end

        local adjustedDamage = LAMBDA_ST3:RemapClamped( distToEnt, 0, radius, baseDamage, baseDamage * fallOff )
        if adjustedDamage <= 0 then continue end

        if tr.StartSolid then
            tr.HitPos = pos
            tr.Fraction = 0
        end

        dmginfo:SetDamage( adjustedDamage )

        local dirToEnt = ( entPos - pos ):GetNormalized()
        if baseDamageForce:IsZero() or baseDamagePos:IsZero() then
            dmginfo:SetDamageForce( dirToEnt * ( min( baseDamage * 300, 30000 ) * Rand( 0.85, 1.15 ) ) * LAMBDA_TF2:GetPushScale() * 1.5 )
        else
            dmginfo:SetDamageForce( dirToEnt * ( baseDamageForce:Length() * fallOff ) )
        end
        dmginfo:SetDamagePosition( pos )

        if tr.Fraction != 1 and tr.Entity == ent then
            ent:DispatchTraceAttack( dmginfo, tr, dirToEnt )
        else
            ent:TakeDamageInfo( dmginfo )
        end
    end
end