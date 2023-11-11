local IsValid = IsValid
local CurTime = CurTime
local random = math.random
local Rand = math.Rand
local DamageInfo = DamageInfo
local CreateSound = CreateSound
local trLine = util.TraceLine
local trHull = util.TraceHull
local trTbl = { mask = MASK_SHOT_HULL, mins = Vector( -4, -4, -2 ), maxs = Vector( 4, 4, 2 ) }

local function KillSounds( self )
    self:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_put_away.wav", 70 )
    self:StopSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_pull_zip.wav" )
    self:StopSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_pull_zip.wav" )

    if self.IdleSound then self.IdleSound:Stop(); self.IdleSound = nil end
    if self.AttackSound then self.AttackSound:Stop(); self.AttackSound = nil end 
end
--------RANGED WEAPONS--------
------CHAINSAW-----------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_chainsaw = {
        model = "models/lambdaplayers/weapons/st3/w_st3_chainsaw.mdl", --the model where is goes
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Chainsaw",
        holdtype = "physgun", --i don't feel its gonna fit this but it add some little realism
        killicon = "lambdaplayers/killicons/icon_st3_chainsaw", --his kill icon
        ismelee = true,
        keepdistance = 10,
        attackrange = 70,
        bonemerge = true, --the Host really needs it
        islethal = true,

        OnDeploy = function( self, wepent )
            ParticleEffectAttach( "Rocket_Smoke", PATTACH_ABSORIGIN_FOLLOW, wepent, 0 )

            self.l_WeaponUseCooldown = CurTime() + 2.5
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_pull_zip.wav", 70 )

            local layerID = self:AddGestureSequence( self:LookupSequence( "reload_revolver_base_layer" ), true )
            self:SetLayerCycle( layerID, 0.25 ); self:SetLayerBlendOut( layerID, 0.25 )

            wepent.IsDeploying = true
            wepent.AttackTime = CurTime() + 2.5

            wepent.IdleSound = CreateSound( wepent, "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_idle.wav" )
            wepent.AttackSound = CreateSound( wepent, "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/chainsaw_high_speed_lp_01.wav" ) --Realism

            wepent:CallOnRemove( "LambdaChainsaw_KillSounds" .. wepent:EntIndex(), KillSounds )
        end,

        OnThink = function( self, wepent, isdead )
            if isdead then
                if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end 
            else
                if CurTime() > wepent.AttackTime then
                    wepent.IsDeploying = false
                    if wepent.IdleSound and !wepent.IdleSound:IsPlaying() then wepent.IdleSound:PlayEx( 0.5, 100 ) end
                    if wepent.AttackSound and wepent.AttackSound:IsPlaying() then wepent.AttackSound:Stop() end
                end

                if !wepent.IsDeploying then
                    if !self:IsPlayingGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 ) then
                        local shakeLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true )
                        self:SetLayerPlaybackRate( shakeLayer, 2.0 ); self:SetLayerBlendOut( shakeLayer, 2.0 )
                    end

                    if CurTime() <= wepent.AttackTime then 
                        if wepent.IdleSound and wepent.IdleSound:IsPlaying() then wepent.IdleSound:Stop() end
                        if wepent.AttackSound and !wepent.AttackSound:IsPlaying() then wepent.AttackSound:Play() end

                        local attackLayer = self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM, true )
                        self:SetLayerCycle( attackLayer, 0.2 ) self:SetLayerBlendOut( attackLayer, 1.25 )

                        local fireSrc = self:GetAttachmentPoint( "eyes" ).Pos
                        local enemy = self:GetEnemy()
                        local fireDir = ( LambdaIsValid( enemy ) and ( enemy:WorldSpaceCenter() - fireSrc ):Angle() or self:GetAngles() )

                        trTbl.start = fireSrc
                        trTbl.endpos = ( fireSrc + fireDir:Forward() * 56 )
                        trTbl.filter = { self, wepent }
                        local tr = trLine( trTbl )
                        if !LambdaIsValid( tr.Entity ) then tr = trHull( trTbl ) end

                        local hitEnt = tr.Entity
                        if tr.Hit and IsValid( hitEnt ) then
                            local dmginfo = DamageInfo()
                            dmginfo:SetDamage( 2 )
                            dmginfo:SetDamageType( DMG_SLASH )
                            dmginfo:SetDamagePosition( tr.HitPos )
                            dmginfo:SetDamageForce( fireDir:Forward() * 2000 - fireDir:Up() * 2000)
                            dmginfo:SetInflictor( wepent )
                            dmginfo:SetAttacker( self )
                            hitEnt:DispatchTraceAttack( dmginfo, tr )
                        end
                    end
                end
            end
        end,

        OnTakeDamage = function( self, wepent, dmginfo ) 
            dmginfo:ScaleDamage( ( CurTime() <= wepent.AttackTime ) and 0.5 or 0.8 ) 
        end,
        
        OnAttack = function( self, wepent, target ) 
            if !wepent.IsDeploying then wepent.AttackTime = CurTime() + Rand( 0.33, 0.66 )  end
            return true 
        end,

        OnHolster = function( self, wepent )
            LAMBDA_ST3:StopParticlesNamed( wepent, "Rocket_Smoke" )

            wepent.IsDeploying = nil
            wepent.AttackTime = nil

            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_put_away.wav", 70 )
            wepent:StopSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_pull_zip.wav" )
            wepent:StopSound( "lambdaplayers/weapons/SlendytubbiesSFX's/Chainsaw/st3_pull_zip.wav" )

            if wepent.IdleSound then wepent.IdleSound:Stop(); wepent.IdleSound = nil end
            if wepent.AttackSound then wepent.AttackSound:Stop(); wepent.AttackSound = nil end 
        end
    }
} )
