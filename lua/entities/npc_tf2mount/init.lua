---------------------------------------
---------------------------------------
---                                 ---
---     Check TF2 Mount             ---
---                                 ---
---------------------------------------
---------------------------------------
function ENT:Initialize()

	if not IsMounted("tf") then	
		local players = player.GetAll( )
		
		for k,v in pairs(players) do
			v:PrintMessage(4, "Team Fortress 2 isn't mounted! Check the console for more information.")
			v:PrintMessage(2, "====================================================================================")
			v:PrintMessage(2, "This weapon Pack will not progress the particles correctly without having the game mounted.")
			v:PrintMessage(2, "...")
			v:PrintMessage(2, "If you already have it installed, you can load it into Garry's Mod by clicking on")
			v:PrintMessage(2, "the controller icon, next to the language icon in the main menu. Scroll through the")
			v:PrintMessage(2, "list, and make sure 'Team Fortress 2' is selected. Then, restart Garry's Mod.")
			v:PrintMessage(2, "...")
			v:PrintMessage(2, "If you don't have Team Fortress 2 installed, you can download it free with Steam.")
			v:PrintMessage(2, "====================================================================================")
			v:ConCommand("play buttons/button11.wav")
		end
		self:Remove()
		return
	end