-----
-----
-----
-----
Script:LoadScript("SCRIPTS/GUI/ScoreboardLib.lua")
-----

function ScoreBoardManager:Render()
	self:RenderTeamGame(1)
	self.iClassTexture = System:LoadImage("textures/gui/class_symbols_small")
end