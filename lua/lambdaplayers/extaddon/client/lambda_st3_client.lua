local LocalPlayer = LocalPlayer
local net = net
local CreateParticleSystem = CreateParticleSystem
local IsValid = IsValid
local ipairs = ipairs
local random = math.random
local SimpleTimer = timer.Simple
local max = math.max
local hook_Add = hook.Add
local hook_Remove = hook.Remove
local GetConVar = GetConVar
local ents_CreateClientside = ents.CreateClientside

LAMBDA_ST3 = LAMBDA_ST3 or {}

// Killicons
killicon.Add( "lambdaplayers_weaponkillicons_tf2_backstab", "lambdaplayers/killicons/icon_tf2_backstab", killiconClr )
//

net.Receive( "lambda_st3_stopnamedparticle", function()
    local ent = net.ReadEntity()
    if !IsValid( ent ) then return end 

    local partName = net.ReadString()
    ent:StopParticlesNamed( partName )
end )


net.Receive( "lambda_st3_dispatchcolorparticle", function()
    local ent = net.ReadEntity()
    if !IsValid( ent ) or ent:IsDormant() then return end

    local trail
    local effectName = net.ReadString()
    local partAttachment = net.ReadUInt( 3 )
    if partAttachment == PATTACH_WORLDORIGIN then
        local origin = net.ReadVector()
        trail = CreateParticleSystem( Entity( 0 ), effectName, partAttachment, 0, origin )
    else
        local entAttachment = net.ReadUInt( 6 )
        trail = CreateParticleSystem( ent, effectName, partAttachment, entAttachment, vector_origin )
    end

    if IsValid( trail ) then
        local reverseClr = net.ReadBool()
        local customClr = net.ReadBool()

        local baseColor, secondColor
        if customClr then
            baseColor = net.ReadVector()
            secondColor = ( baseColor * 0.7 )
        else
            local teamColor = net.ReadUInt( 2 )
            baseColor = ( teamColor == 1 and TF_PARTICLE_WEAPON_BLUE_1 or TF_PARTICLE_WEAPON_RED_1 )
            secondColor = ( teamColor == 1 and TF_PARTICLE_WEAPON_BLUE_2 or TF_PARTICLE_WEAPON_RED_2 )
        end
        trail:SetControlPoint( 9, ( reverseClr and secondColor or baseColor ) )
        trail:SetControlPoint( 10, ( reverseClr and baseColor or secondColor ) )
    end
end )