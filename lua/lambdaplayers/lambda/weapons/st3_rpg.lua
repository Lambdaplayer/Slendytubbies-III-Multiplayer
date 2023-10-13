local IsValid = IsValid
local CurTime = CurTime
local ents_Create = ents.Create
local Rand = math.Rand
local ParticleEffectAttach = ParticleEffectAttach
local random = math.random
local Rand = math.Rand
-------ADD PARTICLE SYSTEM---
game.AddParticles("particles/rocketbackblast.pcf")
------RPG------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_rpg = {
        model = "models/lambdaplayers/weapons/st3/w_st3_rpg.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "RPG",
        -------------
        holdtype = "rpg",
        killicon = "lambdaplayers/killicons/icon_st3_rpg",
        bonemerge = true,
        keepdistance = 1000,
        attackrange = 9000,
        -------------
        clip = 1,
        -------------
        reloadtime = 2.4,
        reloadanim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        reloadanimspeed = 0.8,
        reloadsounds = { 
            { 0.5, "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/st3_rpg_reload_start.wav" },
            { 1.2, "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/st3_rpg_rocket_place.wav" },
            { 1.7, "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/st3_rpg_rocket_in.wav" },
            { 2.0, "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/st3_rpg_reload_end.wav" },
        },
        -----------
        OnDeploy = function( self, wepent )
        	wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
        end,

        OnReload = function( self, wepent )
            local anim = self:LookupSequence( "reload_smg1_alt_base_layer" )
            if anim != -1 then
                -- smg's reload layer fits with this cuz based of the View's Models of the rpg reload
                self:AddGestureSequence( anim )
            else
                self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1 )
            end
        end,
        ------------
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

            lambda:HandleMuzzleFlash( 7 )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/grenade_launcher/st3_grenade_shoot.wav", 75, random( 98, 102 ), 1, CHAN_WEAPON )

            local rocket = ents_Create( "st3_rpg_rocket" )
            if !IsValid( rocket ) then return end

            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/rpg/glauncher-1.wav", 80, 100, 1, CHAN_WEAPON )

            local targetAng = ( target:WorldSpaceCenter() - wepent:GetPos() ):Angle()
            rocket:SetPos( spawnPos + targetAng:Forward() * 40 + targetAng:Up() * 15 )
            rocket:SetAngles( ( target:WorldSpaceCenter() - rocket:GetPos() ):Angle() )
            rocket:SetOwner( lambda )
            rocket:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) -- SetOwner should prevent collision but it doesn't
            rocket:Spawn()
            ParticleEffectAttach( "Rocket_Smoke_Trail", PATTACH_ABSORIGIN_FOLLOW, rocket, 0 )

            lambda:SimpleTimer( 0.4, function() -- Grace period to avoid collision with the shooter
                if !IsValid( rocket ) then return end
                rocket:SetCollisionGroup( COLLISION_GROUP_PROJECTILE )
            end)

            wepent.CurrentRocket = rocket

            return true
        end
    }
} )