/*-----------------------------------
-----------------------------------
   SLENDYTUBBIES III OG TRACER RECREATED
-----------------------------------
-----------------------------------*/
local Tracer = Material( "trails/smoke" )
local Tracer2  = Material( "trails/laser" )
local Width = 2.65
local Width2 = 7

function EFFECT:Init( data )

	self.Position = data:GetStart()
	self.EndPos = data:GetOrigin()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()
	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.Dir = ( self.EndPos - self.StartPos ):GetNormalized()
	self.Dist = self.StartPos:Distance( self.EndPos )
	
	self.LifeTime = 1 * GetConVarNumber("bfx_lifetimemulti")/2
	self.LifeTime2 = 0.1 * GetConVarNumber("bfx_lifetimemulti")/2
	self.DieTime = CurTime() + self.LifeTime
	self.DieTime2 = CurTime() + self.LifeTime2

end

function EFFECT:Think()

	if ( CurTime() > self.DieTime ) then return false end
	return true

end

function EFFECT:Render()

	local r = GetConVarNumber("bfx_bulletcolor_r")
	local g = GetConVarNumber("bfx_bulletcolor_g")
	local b = GetConVarNumber("bfx_bulletcolor_b")
	
	local v = ( self.DieTime - CurTime() ) / self.LifeTime
	
	local v2 = ( self.DieTime2 - CurTime() ) / self.LifeTime2

	render.SetMaterial( Tracer )
	render.DrawBeam( self.StartPos, self.EndPos, (v * Width)*GetConVarNumber("bfx_widthmulti")/2, 0, self.Dist/10, Color( 20, 20, 20, v * 90 ) )
	
	render.SetMaterial( Tracer2 )
	render.DrawBeam( self.StartPos, self.EndPos, (v2 * Width2)*GetConVarNumber("bfx_widthmulti")/3, 0, self.Dist/10, Color( r, g, b, (v2 * 95)*GetConVarNumber("bfx_alphamulti")/2 ) )

end
