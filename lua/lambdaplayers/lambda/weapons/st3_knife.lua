local backstabCvar = CreateLambdaConvar( "lambdaplayers_st3_knifebackstab", 1, true, false, true, "If Lambda Players should be allowed to use the backstab feature of the ST3 Knife?", 0, 1, { type = "Bool", name = "Allow ST3 Knife Backstab", category = "[Lambda ST3]Weapons Stuff" } )

table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_knife = {
        model = "models/lambdaplayers/weapons/st3/w_st3_knife.mdl",
        origin = "Slendytubbies:III Multiplayer",
        prettyname = "Knife",
        holdtype = "knife",
        killicon = "lambdaplayers/killicons/icon_st3_knife",
        ismelee = true,
        bonemerge = true,
        keepdistance = 10,
        attackrange = 50,
        offpos = Vector( -2.5, -2, 0 ),

        OnDeploy = function( lambda, wepent )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/knife/knife_deploy1.wav" )
        end,

        damage = 15,
        rateoffire = 0.5,
        islethal = true,

        OnAttack = function( self, wepent, target )
            self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE )
            self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE )

            local isBackstab = false
            if backstabCvar:GetBool() then

                local los = ( target:GetPos() - self:GetPos() )
                los.z = 0

                local targetFwd = target:GetForward()
                targetFwd.z = 0

                isBackstab = ( los:GetNormalized():Dot( targetFwd ) > 0.75 )
            end

            local slashDmg = ( isBackstab and 195 or ( ( ( CurTime() - self.l_WeaponUseCooldown ) > 0.4 ) and 20 or 15 ) )
            local dmginfo = DamageInfo() 
            dmginfo:SetDamage( slashDmg )
            dmginfo:SetAttacker( self )
            dmginfo:SetInflictor( wepent )
            dmginfo:SetDamageType( DMG_SLASH )
            dmginfo:SetDamageForce( ( target:WorldSpaceCenter() - self:WorldSpaceCenter() ):GetNormalized() * slashDmg )
            target:TakeDamageInfo( dmginfo )

            self.l_WeaponUseCooldown = ( CurTime() + ( isBackstab and 1.1 or 0.5 ) )
            wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/knife/st3_knife_swing.wav", 110 )

            target:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/knife/knife_hit"..math.random(1,4)..".wav", 110 )


            return true
        end,

    }

})