--------------------------------------------------
--   Created By: Amanda
--   Description: This behaviour describes the indoor swat personality in idle mode
--------------------------
--

AIBehaviour.SwatGroupReady = {
	Name = "SwatGroupReady",


	-- SYSTEM EVENTS	-----
	---------------------------------------------
	OnSelected = function(self,entity)	
	end,
	---------------------------------------------
	OnSpawn = function(self,entity)
		-- called when enemy spawned or reset
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
		-- called when enemy receives an activate event (from a trigger,for example)
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
		-- called when the enemy stops having an attention target
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)

--		System:Log("["..entity:GetName().."]+SwatGroupReady++++++++++++ OnPlayerSeen [<15]in "..fDistance)
		if (fDistance<15) then
			AI:Signal(SIGNALFILTER_GROUPONLY,1,"ENEMY_CLOSE",entity.id)
		end
		--entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		System:Log("["..entity:GetName().."]+SwatGroupReady++++++++++++ OnEnemyMemory")
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"IDLE_TO_THREATENED",entity.id)
		-------------------------------------------------------------------
		entity:MakeAlerted()
	--	entity:SelectPipe(0,"scout_interesting_sound")
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"IDLE_TO_THREATENED",entity.id)
		-------------------------------------------------------------------
		entity:MakeAlerted()
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"INCOMING_FIRE",entity.id)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"GETTING_SHOT_AT",entity.id)
		----------------------------------------------------------------

		entity:MakeAlerted()
	--	entity:SelectPipe(0,"randomhide")
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"INCOMING_FIRE",entity.id)
		
		entity:MakeAlerted()
	--	entity:SelectPipe(0,"randomhide")
	end,
	--------------------------------------------------	
	OnCoverRequested = function(self,entity,sender)
		-- called when cover is requested
	end,
	--------------------------------------------------	
	SCOUT_HIDE_LEFT_OR_RIGHT = function(self,entity,sender)
		local rnd = random(1,2)
		if (rnd==1) then
			--System:Log("+++++++++++++++++++++++++++IDLE scout_hide_left")
			entity:InsertSubpipe(0,"scout_hide_left")
		else
			--System:Log("+++++++++++++++++++++++++++IDLE scout_hide_right")
			entity:InsertSubpipe(0,"scout_hide_right")
		end
		
	end,
	
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	--------------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			-- entity:SelectPipe(0,"randomhide")
		end
	end,
	-------------------------------------------------	
	OnGroupMemberDied = function(self,entity,sender)
		-- call default handling
		entity:SelectPipe(0,"swat_goforcover")
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function(self,entity,sender)
		-- call default handling
		if (entity:GetGroupCount() > 1) then
			entity:SelectPipe(0,"swat_advance")
			entity:InsertSubpipe(0,"swat_grouphide")
		else
			AI:Signal(SIGNALFILTER_GROUPONLY,1,"ENEMY_CLOSE",entity.id)
		end
	end,
	-------------------------------------------------	
	----------------- SWAT SIGNALS ------------------
	ENEMY_CLOSE  = function(self,entity,sender)
		entity:SelectPipe(0,"swat_coverattack")
	end,
	-------------------------------------------------			
	NEXT_ADVANCE = function(self,entity,sender)
		entity:SelectPipe(0,"swat_trace_sender",sender.id)
				
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"WAIT_I_GO",entity.id)
		AI:Signal(0,1,"SELECT_GROUPADVANCE",entity.id)
	end,
	--------------------------------------------------	
	WAIT_I_GO = function(self,entity,sender)
		if (entity~=sender) then 
			AI:Signal(0,1,"SELECT_GROUPWAIT",entity.id)
		end
	end,
	--------------------------------------------------	
	SELECT_GROUPADVANCE = function(self,entity,sender)
	end,
	--------------------------------------------------	
	SELECT_GROUPWAIT = function(self,entity,sender)
		entity:SelectPipe(0,"swat_groupwait")
	end,
	----------------- SWAT SIGNALS ------------------
	-------------------------------------------------	
	KEEP_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to keep formation
	end,
	---------------------------------------------	
	MOVE_IN_FORMATION = function(self,entity,sender)
		-- the team leader wants everyone to move in formation
	
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,2,"ORDER_RECEIVED",entity.id)
		-------------------------------------------------------------------

		entity:SelectPipe(0,"MoveFormation")
	end,
	---------------------------------------------	
	BREAK_FORMATION = function(self,entity,sender)
		-- the team can split
	end,
	---------------------------------------------	
	SINGLE_GO = function(self,entity,sender)
		-- the team leader has instructed this group member to approach the enemy
	end,
	---------------------------------------------	
	GROUP_COVER = function(self,entity,sender)
		-- the team leader has instructed this group member to cover his friends
	end,
	---------------------------------------------	
	IN_POSITION = function(self,entity,sender)
		-- some member of the group is safely in position
	end,
	---------------------------------------------	
	GROUP_SPLIT = function(self,entity,sender)
		-- team leader instructs group to split
	end,
	---------------------------------------------	
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
	end,
	---------------------------------------------	
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
	end,
	---------------------------------------------	
	GROUP_MERGE = function(self,entity,sender)
		-- team leader instructs groups to merge into a team again
	end,
	---------------------------------------------	
	CLOSE_IN_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	ASSAULT_PHASE = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
	---------------------------------------------	
	GROUP_NEUTRALISED = function(self,entity,sender)
		-- team leader instructs groups to initiate part one of assault fire maneuver
	end,
}