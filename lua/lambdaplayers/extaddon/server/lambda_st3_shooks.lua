local table_Empty = table.Empty
local CurTime = CurTime
local random = math.random
local ScreenShake = util.ScreenShake
local ents_Create = ents.Create
local SafeRemoveEntityDelayed = SafeRemoveEntityDelayed
local IsValid = IsValid
local SimpleTimer = timer.Simple
local max = math.max
local min = math.min
local band = bit.band
local istable = istable
local AngleRand = AngleRand
local net = net
local isfunction = isfunction
local ipairs = ipairs
local table_remove = table.remove
local Rand = math.Rand
local coroutine_yield = coroutine.yield
local ParticleEffectAttach = ParticleEffectAttach
local Clamp = math.Clamp
local deg = math.deg
local acos = math.acos
local TraceHull = util.TraceHull
local DamageInfo = DamageInfo
local FrameTime = FrameTime
local debugoverlay = debugoverlay
local Round = math.Round
local RandomPairs = RandomPairs
local isvector = isvector
local GetConVar = GetConVar
local IsSinglePlayer = game.SinglePlayer
local coroutine_wait = coroutine.wait
local FindByClass = ents.FindByClass
local pairs = pairs
local table_Random = table.Random

local ammoboxAngImpulse = Vector()
local groundCheckTbl = {}
local serverRags = GetConVar( "lambdaplayers_lambda_serversideragdolls" )

local dmgCustomKillicons = {
    [ ST_DMG_CUSTOM_BACKSTAB ]              = "lambdaplayers/killicons/icon_st3_backstab",
}

local dmgCustomBackstabs = (
    ST_DMG_CUSTOM_BACKSTAB
)

local gmodDeathAnims = { 
    "death_01", 
    "death_02", 
    "death_03", 
    "death_04"
}