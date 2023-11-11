local random = math.random
local coroutine_wait = coroutine.wait
------------RANGED WEAPON---------------
--Mcs870--
table.Merge( _LAMBDAPLAYERSWEAPONS, {
	st_mcs870 = {
		model = "models/lambdaplayers/weapons/st3/w_st3_mcs870.mdl",
		bonemerge = true,
		holdtype = "shotgun",
		prettyname = "Mcs870 Shotgun",
		origin = "Slendytubbies:III Multiplayer",
        killicon = "lambdaplayers/killicons/icon_st3_mcs870",
-----------------------------------------------------
        islethal = true,
		keepdistance = 350,
		attackrange = 800,
        speedmultiplier = 0.88,
-------------------------------------------------------
		clip = 5,
        damage = 9,
        spread = 0.15,
        rateoffire = 0.9,
        bulletcount = 6,
--------------------------------------------------------
        tracername = "st3_ogtracer",
        muzzleflash = 1,
        shelleject = false,
        attackanim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        attacksnd = "lambdaplayers/weapons/SlendytubbiesSFX's/mcs870/fire_mcs.wav",
---------------------------------------------------------
OnAttack = function( self, wepent )
    self:SimpleTimer( 0.5, function() self:HandleShellEject( "ShotgunShellEject", shelloffpos, shelloffang ) end )
end,
--------------------------------------------------------
OnThink = function( lambda )
    local balanceAdjustment = GetConVar("lambdaplayers_st3_balanceweps")
    
    if balanceAdjustment:GetBool() then
        _LAMBDAPLAYERSWEAPONS["st_mcs870"].damage = 9
    else
        _LAMBDAPLAYERSWEAPONS["st_mcs870"].damage = 38
    end
end,
--------------------------------------------------------
OnDeploy = function( self, wepent )
    wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/onequip.wav" )
end,
--------------------------------------------------------        
OnReload = function( self, wepent )
    local animID = self:LookupSequence( "reload_smg1_alt_base_layer" )
        if animID != -1 then 
            self:AddGestureSequence( animID ) 
        else 
            self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1 )
        end

        self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1 )
        local reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1, true )

        self:SetIsReloading( true )
        self:Thread( function()

            coroutine_wait( 0.466 )
                
            local interruptEne = false
            while ( self.l_Clip < self.l_MaxClip ) do
                interruptEne = ( self.l_Clip > 0 and random( 1, 2 ) == 1 and self:InCombat() and self:IsInRange( self:GetEnemy(), 512 ) and self:CanSee( self:GetEnemy() ) )
                if interruptEne then break end 

                if !self:IsValidLayer( reloadLayer ) then
                    reloadLayer = self:AddGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1, true )
                end
                self:SetLayerCycle( reloadLayer, 0.3 )
                self:SetLayerPlaybackRate( reloadLayer, 1.33 ) 

                self.l_Clip = self.l_Clip + 1
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/mcs870/mcs870_insertshell" .. random( 1, 4 ) .. ".wav", 65, 100, 1, CHAN_ITEM )
                coroutine_wait( 0.475 )
            end

            if !interruptEne then
                wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/mcs870/mcs870_reload_pump_back.wav", 65, 100, 1, CHAN_ITEM )
                self:SimpleTimer( 0.25, function() wepent:EmitSound( "lambdaplayers/weapons/SlendytubbiesSFX's/mcs870/mcs870_reload_pump_forward.wav", 65, 100, 1, CHAN_ITEM ) end )
                coroutine_wait( 0.6 )
            end

            self:RemoveGesture( ACT_HL2MP_GESTURE_RELOAD_SMG1 )
            self:SetIsReloading( false )
            
        end, "ST3_ShotgunReload" )

        return true
    end,
    --------------------------
	}
} )