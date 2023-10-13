local TraceLine = util.TraceLine
local TraceHull = util.TraceHull
local CurTime = CurTime
local ipairs = ipairs
local random = math.random
local net = net
local min = math.min
local max = math.max
local FrameTime = FrameTime
local IsValid = IsValid
local StartWith = string.StartWith
local coroutine_wait = coroutine.wait
local coroutine_yield = coroutine.yield
local SoundDuration = SoundDuration
local DamageInfo = DamageInfo
local Rand = math.Rand
local VectorRand = VectorRand
local ents_Create = ents.Create
local FindAlongRay = ents.FindAlongRay
local ParticleTracerEx = util.ParticleTracerEx
local ParticleEffect = ParticleEffect
local ParticleEffectAttach = ParticleEffectAttach
local istable = istable
local isvector = isvector
local isnumber = isnumber
local isfunction = isfunction
local isstring = isstring
local EffectData = EffectData
local util_Effect = util.Effect
local util_Decal = util.Decal
local IsPredicted = IsFirstTimePredicted
local Vector = Vector
local SimpleTimer = timer.Simple

local meleetbl = { 
    mins = Vector( -18, -18, -18 ),
    maxs = Vector( 18, 18, 18 ),
    filter = { NULL, NULL } 
}
local bulletTbl = {
    Tracer = 0
}
local spreadVector = Vector( 0, 0, 0 )
local medigunTraceTbl = {
    mask = ( MASK_SHOT - CONTENTS_HITBOX ),
    filter = { NULL, NULL, NULL }
}
local rayWorldTbl = {}
local dmgTraceTbl = { mask = ( MASK_SOLID + CONTENTS_HITBOX ) }
local fixedWpnSpreadPellets = {
    Vector( 0, 0, 0 ),
    Vector( 1, 0, 0 ),	
    Vector( -1, 0, 0 ),	
    Vector( 0, -1, 0 ),	
    Vector( 0, 1, 0 ),	
    Vector( 0.85, -0.85, 0 ),	
    Vector( 0.85, 0.85, 0 ),	
    Vector( -0.85, -0.85, 0 ),	
    Vector( -0.85, 0.85, 0 ),	
    Vector( 0, 0, 0 )
}
local shotgunCockingTimings = {
    { 0.342857, 0.485714 },
    { 0.285714, 0.428571 },
    { 0.4, 0.533333 },
    { 0.233333, 0.366667 }
}
local flameSize = Vector( 12, 12, 12 )
local pipeBounds = Vector( 2, 2, 2 )
local pipeTouchTrTbl = { mask = MASK_SOLID }
local groundTrTbl = { mask = MASK_SOLID_BRUSHONLY }

local shotgunReloadInterruptCond = function( lambda, weapon )
    return ( lambda.l_Clip > 0 and random( 1, 3 ) == 1 and lambda:InCombat() and lambda:IsInRange( lambda:GetEnemy(), 512 ) and lambda:CanSee( lambda:GetEnemy() ) )
end
local shotgunReloadEndFunc = function( lambda, weapon, interrupted )
    if interrupted then return end
    local cockTimings = shotgunCockingTimings[ random( #shotgunCockingTimings ) ]
    
    lambda:SimpleWeaponTimer( cockTimings[ 1 ], function()
        weapon:EmitSound( "weapons/shotgun_cock_back.wav", 70, nil, nil, CHAN_STATIC )
    end )
    lambda:SimpleWeaponTimer( cockTimings[ 2 ], function()
        weapon:EmitSound( "weapons/shotgun_cock_forward.wav", 70, nil, nil, CHAN_STATIC )
    end )
end

function LAMBDA_ST3:ShotgunReload( lambda, weapon, dataTbl )
    dataTbl = dataTbl or {}
    local startTime = ( dataTbl.StartDelay or 0.4 )
    local cycleTime = ( dataTbl.CycleDelay or 0.5 )

    local startFunc = dataTbl.StartFunction
    local cycleFunc = dataTbl.CycleFunction
    
    local interruptCondition = dataTbl.InterruptCondition
    if interruptCondition == nil then interruptCondition = shotgunReloadInterruptCond end

    local endFunc = dataTbl.EndFunction
    if endFunc == nil then endFunc = shotgunReloadEndFunc end

    local startSnd = dataTbl.StartSound
    local endSnd = dataTbl.EndSound

    local cycleSnd = dataTbl.CycleSound
    if cycleSnd == nil then cycleSnd = "weapons/shotgun_worldreload.wav" end

    local animAct = ( dataTbl.Animation or ACT_HL2MP_GESTURE_RELOAD_AR2 )
    local layerCycle = ( dataTbl.LayerCycle or 0.2 )
    local layerRate = ( dataTbl.LayerPlayRate or 1.6 )

    local reloadLayer
    if isstring( animAct ) then
        reloadLayer = lambda:AddGestureSequence( lambda:LookupSequence( animAct ) )
    else
        lambda:RemoveGesture( animAct )
        reloadLayer = lambda:AddGesture( animAct )
    end

    lambda:SetIsReloading( true )
    lambda:Thread( function()

        if startFunc then startFunc( lambda, weapon ) end
        if startSnd then weapon:EmitSound( ( istable( startSnd ) and startSnd[ random( #startSnd ) ] or startSnd ), 70, nil, nil, CHAN_STATIC ) end
        coroutine_wait( startTime )

        local interrupted = false
        while ( lambda.l_Clip < lambda.l_MaxClip ) do
            if !lambda:GetIsReloading() then return end

            if interruptCondition then
                interrupted = interruptCondition( lambda, weapon )
                if interrupted then break end
            end

            if !lambda:IsValidLayer( reloadLayer ) then
                reloadLayer = ( isstring( animAct ) and lambda:AddGestureSequence( lambda:LookupSequence( animAct ) ) or lambda:AddGesture( animAct ) )
            end
            lambda:SetLayerCycle( reloadLayer, layerCycle )
            lambda:SetLayerPlaybackRate( reloadLayer, layerRate )

            if cycleFunc then cycleFunc( lambda, weapon ) end

            lambda.l_Clip = lambda.l_Clip + 1
            if cycleSnd then weapon:EmitSound( ( istable( cycleSnd ) and cycleSnd[ random( #cycleSnd ) ] or cycleSnd ), 70, nil, nil, CHAN_STATIC ) end
            coroutine_wait( cycleTime )
        end

        if endSnd then weapon:EmitSound( ( istable( endSnd ) and endSnd[ random( #endSnd ) ] or endSnd ), 70, nil, nil, CHAN_STATIC ) end
        if endFunc then endFunc( lambda, weapon, interrupted ) end
        
        if !isstring( animAct ) then 
            lambda:RemoveGesture( animAct ) 
        elseif lambda:IsValidLayer( reloadLayer ) then
            lambda:SetLayerCycle( reloadLayer, 1 )
        end
        
        lambda:SetIsReloading( false )

    end, "ST3_ShotgunReload" )
end

function LAMBDA_ST3:CreateShellEject( weapon, name )
    if !IsPredicted() then return end

    local shellAttach = weapon:LookupAttachment( "shell" )
    if shellAttach <= 0 then return end

    local shellEject = weapon:GetAttachment( shellAttach )
    local shellData = EffectData()
    shellData:SetOrigin( shellEject.Pos )
    shellData:SetAngles( shellEject.Ang )
    shellData:SetEntity( weapon )
    util_Effect( name, shellData )
end

function LAMBDA_ST3:CreateMuzzleFlash( weapon, muzzleName )
    if !IsPredicted() then return end

    local muzzleAttach = weapon:LookupAttachment( "muzzle" )
    if muzzleAttach <= 0 then return end

    if isnumber( muzzleName ) then
        local muzzleFlash = weapon:GetAttachment( muzzleAttach )
        local muzzleData = EffectData()
        muzzleData:SetOrigin( muzzleFlash.Pos )
        muzzleData:SetStart( muzzleFlash.Pos )
        muzzleData:SetAngles( muzzleFlash.Ang )
        muzzleData:SetFlags( muzzleName )
        muzzleData:SetEntity( weapon )
        util_Effect( "MuzzleFlash", muzzleData )
    else
        ParticleEffectAttach( muzzleName, PATTACH_POINT_FOLLOW, weapon, muzzleAttach )
    end
end

function LAMBDA_ST3:WeaponAttack( lambda, weapon, target, isCrit )
    isCrit = ( isCrit == nil and weapon:CalcIsAttackCriticalHelper() or isCrit )
    local isMelee = weapon:GetWeaponAttribute( "IsMelee", false )

    if !isMelee then
        local clipDrain = weapon:GetWeaponAttribute( "ClipDrain", 1 )
        if clipDrain then
            local curClip = lambda.l_Clip
            if curClip <= 0 then lambda:ReloadWeapon() return end
            lambda.l_Clip = max( curClip - clipDrain, 0 )
        end

        local attackAnim = weapon:GetWeaponAttribute( "Animation" )
        if attackAnim then
            lambda:RemoveGesture( attackAnim )
            lambda:AddGesture( attackAnim, true )
        end

        local cooldown = weapon:GetWeaponAttribute( "RateOfFire", 0.1 )
        if istable( cooldown ) then cooldown = Rand( cooldown[ 1 ], cooldown[ 2 ] ) end
        lambda.l_WeaponUseCooldown = ( CurTime() + cooldown )
    
        local shellName = weapon:GetWeaponAttribute( "ShellEject", "ShellEject" )
        if shellName then LAMBDA_ST3:CreateShellEject( weapon, shellName ) end

        local muzzleType = weapon:GetWeaponAttribute( "MuzzleFlash", 1 )
        if muzzleType then LAMBDA_ST3:CreateMuzzleFlash( weapon, muzzleType ) end

        local fireSnd = weapon:GetWeaponAttribute( "Sound" )
        if fireSnd then
            local critSnd = weapon:GetWeaponAttribute( "CritSound" )
            if critSnd and isCrit then fireSnd = critSnd end
            if istable( fireSnd ) then fireSnd = fireSnd[ random( #fireSnd ) ] end
            weapon:EmitSound( fireSnd, 75, 100, 1, CHAN_WEAPON )
        end

        local fireBullet = weapon:GetWeaponAttribute( "FireBullet", true )
        if fireBullet then
            local wepPos = weapon:GetPos()

            bulletTbl.Attacker = lambda
            bulletTbl.IgnoreEntity = lambda
            bulletTbl.Src = wepPos

            local damage = weapon:GetWeaponAttribute( "Damage", 5 )
            if istable( damage ) then damage = random( damage[ 1 ], damage[ 2 ] ) end
            bulletTbl.Damage = damage
            bulletTbl.Force = ( damage / 3 )

            local weaponSpread = weapon:GetWeaponAttribute( "Spread", 0.1 )
            spreadVector.x = weaponSpread
            spreadVector.y = weaponSpread
            bulletTbl.Spread = spreadVector

            local firePos = ( isvector( target ) and target or target:WorldSpaceCenter() )
            
            local preBulletCallback = weapon:GetWeaponAttribute( "PreFireBulletCallback" )
            if preBulletCallback then 
                local overridePos = preBulletCallback( lambda, weapon, target, dmginfo, bulletTbl ) 
                if isvector( overridePos ) then firePos = overridePos end
            end

            local lambdaAccuracyOffset = LAMBDA_ST3:RemapClamped( lambda:GetRangeTo( firePos ), 128, 1024, 3, 30 )
            local fireAng = ( firePos - wepPos ):Angle()
            fireAng = ( ( firePos + fireAng:Right() * Rand( -lambdaAccuracyOffset, lambdaAccuracyOffset ) + fireAng:Up() * Rand( -lambdaAccuracyOffset, lambdaAccuracyOffset ) ) - wepPos ):Angle()

            bulletTbl.Callback = function( attacker, tr, dmginfo )
                dmginfo:SetDamageType( dmginfo:GetDamageType() + weapon:GetWeaponAttribute( "DamageType", 0 ) )

                local dmgCustom = weapon:GetWeaponAttribute( "DamageCustom", 0 )
                if isCrit then dmgCustom = ( dmgCustom + TF_DMG_CUSTOM_CRITICAL ) end
                dmginfo:SetDamageCustom( dmgCustom )

                local bulletCallback = weapon:GetWeaponAttribute( "BulletCallback" )
                if bulletCallback then bulletCallback( lambda, weapon, tr, dmginfo ) end

                local tracerEffect = weapon:GetWeaponAttribute( "TracerEffect" )
                if tracerEffect then
                    local tracerName = tracerEffect .. ( lambda.l_ST_TeamColor == 1 and "_blue" or "_red" )
                    if isCrit then tracerName = tracerName .. "_crit" end
                    ParticleTracerEx( tracerName, tr.StartPos, tr.HitPos, true, weapon:EntIndex(), -1 )
                end
            end

            local firstShotAccurate = weapon:GetWeaponAttribute( "FirstShotAccurate", false )
            local bulletPreShot = weapon:GetWeaponAttribute( "ProjectileCount", 1 )
            local spreadRecovery = weapon:GetWeaponAttribute( "SpreadRecovery", ( bulletPreShot > 1 and 0.25 or 1.25 ) )
            local fixedSpread = weapon:GetWeaponAttribute( "FixedSpread", false )
            local preBulletCallback = weapon:GetWeaponAttribute( "PreFireBulletCallback" )

            for i = 1, bulletPreShot do
                local spreadScalar = 0.5
                local spreadX, spreadY = 0, 0

                if fixedSpread then
                    local spreadIndex = i
                    if spreadIndex > #fixedWpnSpreadPellets then
                        spreadIndex = ( spreadIndex - #fixedWpnSpreadPellets )
                    end

                    spreadX = ( fixedWpnSpreadPellets[ spreadIndex ].x * spreadScalar )
                    spreadY = ( fixedWpnSpreadPellets[ spreadIndex ].y * spreadScalar )
                elseif !firstShotAccurate or ( CurTime() - weapon.l_TF_LastFireTime ) <= spreadRecovery then 
                    spreadX = ( Rand( -spreadScalar, spreadScalar ) + Rand( -spreadScalar, spreadScalar ) )
                    spreadY = ( Rand( -spreadScalar, spreadScalar ) + Rand( -spreadScalar, spreadScalar ) )
                end
                bulletTbl.Dir = ( fireAng:Forward() + ( spreadX * bulletTbl.Spread.x * fireAng:Right() ) + ( spreadY * bulletTbl.Spread.y * fireAng:Up() ) )

                if preBulletCallback then preBulletCallback( lambda, weapon, target, dmginfo, bulletTbl ) end
                weapon:FireBullets( bulletTbl )

                weapon.l_ST_LastFireTime = CurTime()
            end
        end
    else
        local hitRange = weapon:GetWeaponAttribute( "HitRange", 42 )
        local hitDelay = weapon:GetWeaponAttribute( "HitDelay", 0.2 )
        
        local attackRange = hitRange
        if isnumber( hitDelay ) and hitDelay > 0 then
            attackRange = ( attackRange * ( 1 + Rand( 0, hitDelay ) ) )
        end

        local eyePos = lambda:GetAttachmentPoint( "eyes" ).Pos
        local nearPoint = target:NearestPoint( eyePos )
        if eyePos:DistToSqr( nearPoint ) > ( attackRange ^ 2 ) then return end

        local fireSnd = weapon:GetWeaponAttribute( "Sound", ")weapons/cbar_miss1.wav" )
        if fireSnd then
            local critSnd = weapon:GetWeaponAttribute( "CritSound", ")weapons/cbar_miss1_crit.wav" )
            if critSnd and isCrit then fireSnd = critSnd end
            if istable( fireSnd ) then fireSnd = fireSnd[ random( #fireSnd ) ] end
            weapon:EmitSound( fireSnd, 64, nil, 0.6, CHAN_WEAPON )
        end

        local attackAnim = weapon:GetWeaponAttribute( "Animation", ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
        if attackAnim then 
            lambda:RemoveGesture( attackAnim )
            local attackLayer = lambda:AddGesture( attackAnim, true )
            lambda:SetLayerPlaybackRate( attackLayer, 0.85 )
        end
    
        local cooldown = weapon:GetWeaponAttribute( "RateOfFire", 0.8 )
        if istable( cooldown ) then cooldown = Rand( cooldown[ 1 ], cooldown[ 2 ] ) end
        lambda.l_WeaponUseCooldown = ( CurTime() + cooldown )

        local damage = weapon:GetWeaponAttribute( "Damage", 40 )
        if isfunction( damage ) then damage = damage( lambda, weapon, target ) end

        if damage then
            if istable( damage ) then damage = random( damage[ 1 ], damage[ 2 ] ) end
            local onMissFunc = weapon:GetWeaponAttribute( "OnMiss" )

            local hitFunction = function()
                eyePos = lambda:GetAttachmentPoint( "eyes" ).Pos

                meleetbl.start = eyePos
                meleetbl.endpos = ( eyePos + ( ( LambdaIsValid( target ) and target:WorldSpaceCenter() or ( lambda:WorldSpaceCenter() + lambda:GetForward() * hitRange ) ) - eyePos ):GetNormalized() * hitRange )
                meleetbl.filter[ 1 ] = lambda
                meleetbl.filter[ 2 ] = weapon

                local meleeTr = TraceLine( meleetbl )
                if meleeTr.Fraction >= 1.0 then meleeTr = TraceHull( meleetbl ) end

                local dmginfo = DamageInfo()
                dmginfo:SetDamage( damage )
                dmginfo:SetAttacker( lambda )
                dmginfo:SetInflictor( weapon )
                dmginfo:SetDamagePosition( meleeTr.HitPos )
                dmginfo:SetDamageType( weapon:GetWeaponAttribute( "DamageType", DMG_CLUB ) )

                dmginfo:SetDamageCustom( dmgCustom )

                local hitAng = ( ( meleeTr.HitPos - lambda:GetForward() * ( hitRange and 1 or 0 ) ) - eyePos ):Angle()
                dmginfo:SetDamageForce( hitAng:Forward() * ( damage * 300 ) * LAMBDA_ST3:GetPushScale() * ( 1 / damage * 80 ) )

                local hitEnt = meleeTr.Entity
                local missed = ( !IsValid( hitEnt ) )

                local preHitCallback = weapon:GetWeaponAttribute( missed and "OnMiss" or "PreHitCallback" )
                if ( !preHitCallback or preHitCallback( lambda, weapon, hitEnt, dmginfo ) != true ) and !missed then
                    hitEnt:DispatchTraceAttack( dmginfo, meleeTr, hitAng:Forward() )
                end

                lambda:SetNextMeleeCrit( TF_CRIT_NONE )
            end

            if !isnumber( hitDelay ) or hitDelay <= 0 then
                hitFunction()
            else
                lambda:SimpleWeaponTimer( hitDelay, hitFunction )
            end
        end
    end

    return true
end

///
