local IsValid = IsValid
local CurTime = CurTime
local random = math.random
local ents_Create = ents.Create
local SpriteTrail = util.SpriteTrail
-----------RANGED WEAPONS----------
------ST3 GRENADE------
table.Merge( _LAMBDAPLAYERSWEAPONS, {
    st_grenade = {
        model = "models/lambdaplayers/weapons/st3/w_grenade.mdl",
        origin = "Slendytubbies:III Multiplayer",
-----------------------------------------
        prettyname = "Grenade",
        holdtype = "grenade",
        islethal = true,
-----------------------------------------
        bonemerge = true,
        keepdistance = 500,
        attackrange = 1000,
-----------------------------------------
OnAttack = function( self, wepent, target )
    local grenade = ents_Create( "st3_grenade" )
    if !IsValid( grenade ) then return end

    self.l_WeaponUseCooldown = CurTime() + 1.8

    self:RemoveGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE )
    self:AddGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE )

    grenade:SetPos( self:GetPos() + self:GetUp() * 60 + self:GetForward() * 20 + self:GetRight() * -10 )
    grenade:Fire( "SetTimer", 3, 0 )
    grenade:SetSaveValue( "m_hThrower", self )
    grenade:SetOwner( self )
    grenade:Spawn()

    local throwForce = 1200
    local throwDir = self:GetForward()
    local throwSnd = "weapons/cleaver_throw.wav"
    if IsValid( target ) then
        throwDir = ( target:GetPos() - grenade:GetPos() ):GetNormalized()
            if self:IsInRange( target, 350 ) then
                throwForce = 1200
                 throwSnd = "WeaponFrag.Roll"
            end
        end
        wepent:EmitSound( throwSnd )

        local phys = grenade:GetPhysicsObject()
        if IsValid( phys ) then
            phys:ApplyForceCenter( throwDir * throwForce )
            phys:AddAngleVelocity( Vector( 600, random(-1200, 1200) ) )
        end
        
        return true
    end,
    -------------------------
    }
})