-----
-----
-----
-----
ScoreBoardManager =
{
	messages = {},
	visible = 0 
}
-----
function ScoreBoardManager:NewScore(playerid,newscore)
	
end
-----
function ScoreBoardManager:Render()
	if (self.visible==1) then
		Hud:MissionBox()
	end
end
-----
function ScoreBoardManager.SetVisible(v)
	ScoreBoardManager.visible = v 
end
-----
function ScoreBoardManager.ClearScores()
	ScoreBoardManager.scores = {} 
end
