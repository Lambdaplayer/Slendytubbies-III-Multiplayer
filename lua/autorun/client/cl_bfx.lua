

CreateClientConVar("bfx_bulletcolor_r", "255", true, true)
CreateClientConVar("bfx_bulletcolor_g", "220", true, true)
CreateClientConVar("bfx_bulletcolor_b", "120", true, true)


CreateClientConVar("bfx_widthmulti", "2", true, true)
CreateClientConVar("bfx_lifetimemulti", "1", true, true)
CreateClientConVar("bfx_alphamulti", "1", true, true)



if CLIENT then
local function BFX_Menu(panel)
   
	panel:AddControl( "Slider", { Label = "Tracer Width", Command = "bfx_widthmulti", Type = "Integer", Min = "0.5", Max = "10" }  )
	panel:AddControl( "Slider", { Label = "Tracer Lifetime", Command = "bfx_lifetimemulti", Type = "Integer", Min = "0.5", Max = "10" }  )
	panel:AddControl( "Slider", { Label = "Tracer Brightness", Command = "bfx_alphamulti", Type = "Integer", Min = "0.5", Max = "5" }  )
	
	panel:AddControl( "Color", { Label = "Bullet Color", Red = "bfx_bulletcolor_r", Green = "bfx_bulletcolor_g", Blue = "bfx_bulletcolor_b", ShowAlpha = "0", ShowHSV = "1", ShowRGB = "1" }  )
end

hook.Add("PopulateToolMenu","BFX_Menu", function()
	spawnmenu.AddToolMenuOption("Lambda Player","Lambda Player","Slendytubbies Stuff","Slendytubbies III Tracer","","",BFX_Menu)
end)
end

