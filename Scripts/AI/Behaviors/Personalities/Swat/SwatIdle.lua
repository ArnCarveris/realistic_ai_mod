--------------------------------------------------
--   Description: This behaviour describes the indoor swat personality in idle mode
--------------------------
--

AIBehaviour.SwatIdle = {
	Name = "SwatIdle",


	-- SYSTEM EVENTS --
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
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- reviewed
--		System:Log("["..entity:GetName().."]+SwatIdle++++++++++++ OnPlayerSeen [<15]in "..fDistance)
		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)
		if (fDistance<15) then
			AI:Signal(SIGNALFILTER_GROUPONLY,1,"ENEMY_CLOSE",entity.id)
		end

		if (entity:GetGroupCount() > 1) then
			-- only send this signal if you are not alone
			AI:Signal(SIGNALFILTER_GROUPONLY,1,"ENEMY_SPOTTED",entity.id)
			AI:Signal(0,1,"SELECT_GROUPADVANCE",entity.id)
			entity:SelectPipe(0,"DropBeaconAt")
		else
			entity:SelectPipe(0,"swat_singleadvance")
		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		System:Log("["..entity:GetName().."]+SwatIdle++++++++++++. OnEnemyMemory")
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
--		System:Log("["..entity:GetName().."]+SwatIdle++++++++++++. OnEnemySeen")
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"IDLE_TO_THREATENED",entity.id)
		-------------------------------------------------------------------
		entity:MakeAlerted()
		entity:SelectPipe(0,"swat_attentive")
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"IDLE_TO_THREATENED",entity.id)
		-------------------------------------------------------------------
		entity:MakeAlerted()
		entity:SelectPipe(0,"swat_attentive")
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		System:Log("["..entity:GetName().."]+SwatIdle++++++++++++ OnNoHidingPlace")
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"INCOMING_FIRE",entity.id)

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"GETTING_SHOT_AT",entity.id)
		----------------------------------------------------------------

		entity:MakeAlerted()
		entity:SelectPipe(0,"randomhide")
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when detect weapon fire around AI
	
		AI:Signal(SIGNALFILTER_GROUPONLY,1,"INCOMING_FIRE",entity.id)
		
		entity:MakeAlerted()
		entity:SelectPipe(0,"randomhide")
	end,
	--------------------------------------------------	
	OnCoverRequested = function(self,entity,sender)
		-- called when cover is requested
	end,
	--------------------------------------------------	
	SCOUT_HIDE_LEFT_OR_RIGHT = function(self,entity,sender)
		local rnd = random(1,2)
		if (rnd==1) then
--			System:Log("["..entity:GetName().."]+SwatIdle++++++++++++IDLE scout_hide_left")
			entity:InsertSubpipe(0,"scout_hide_left")
		else
--			System:Log("["..entity:GetName().."]+SwatIdle++++++++++++IDLE scout_hide_right")
			entity:InsertSubpipe(0,"scout_hide_right")
		end
		
	end,
	--------------------------------------------------
	----------------- GROUP SIGNALS ------------------
	--------------------------------------------------
	OnGroupMemberDied = function(self,entity,sender)
		-- call default handling
	 	if (entity~=sender) then
		 	entity:SelectPipe(0,"randomhide")
	 	end
	end,
	--------------------------------------------------
	OnGroupMemberDiedNearest = function(self,entity,sender)
		-- call default handling
		entity:MakeAlerted()

		-- DO NOT TOUCH THIS READIBILITY SIGNAL	---------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"FRIEND_DEATH",entity.id)
		-------------------------------------------------------------------
		
		-- bounce the dead friend notification to the group (you are going to investigate it)
		AI:Signal(SIGNALFILTER_SPECIESONLY,1,"OnGroupMemberDied",entity.id)

		-- investigate corpse
		entity:SelectPipe(0,"randomhide")

	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		if (entity~=sender) then
			-- entity:SelectPipe(0,"randomhide")
		end
	end,
	---------------------------------------------
	HERE_I_COME = function(self,entity,sender)
		System:Log("[".. entity:GetName().."]++++++++++++++++++HERE_I_COME")
	end,
	-------------------------------------------------
	OUT_HIDE = function(self,entity,sender)
		System:Log("[".. entity:GetName().."]++++++++++++++++++OUT_HIDE")
	end,	
	----------------- SWAT SIGNALS ------------------
	ENEMY_CLOSE  = function(self,entity,sender)
		AI:Signal(0,1,"swat_attack",entity.id)
	end,
	-------------------------------------------------	
	SELECT_GROUPREADY = function(self,entity,sender)
		entity:SelectPipe(0,"swat_groupwait")
	end,
	--------------------------------------------------	
	SELECT_GROUPADVANCE = function(self,entity,sender)
		entity:SelectPipe(0,"swat_advance")
		-- entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,
	-------------------------------------------------
	ENEMY_SPOTTED = function(self,entity,sender)
--		System:Log("+++++++++++++++++++++++++++IDLE "..entity:GetName().." received ENEMY_SPOTTED")
		if (entity~=sender) then 
			entity:SelectPipe(0,"AcqBeacon")
			AI:Signal(0,1,"SELECT_GROUPREADY",entity.id)
		end
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
	
	AISF_CallForHelp = function(self,entity,sender)
--	System:Log("["..entity:GetName().."]+++++++++++++++++++++++++++AISF_CallForHelp")
		entity:SelectPipe(0,"send_reinforcements",sender.id)
	end,
	
	ALARM_PULLED = function(self,entity,sender)
--	System:Log("["..entity:GetName().."]+++++++++++++++++++++++++++ALARM_PULLED")
		entity:SelectPipe(0,"swat_trace_sender",sender.id)
	end,
	
	------------------------------ Animation -------------------------------
	kneel_start_animation = function(self,entity,sender)
		entity:StartAnimation(0,"kneel_start",0)
	end,
	
	kneel_idle_loop_animation = function(self,entity,sender)
		entity:StartAnimation(0,"kneel_idle_loop",0)
	end,
	
	kneel_end_animation = function(self,entity,sender)
		entity:StartAnimation(0,"kneel_end",0)
	end,
	
	signal_inposition = function(self,entity,sender)
		System:Log(entity:GetName().." .. signal_inposition")
		entity:StartAnimation(0,"signal_inposition",0)
	end,
	
	confused_animation = function(self,entity,sender)
		entity:StartAnimation(0,"_chinrub",0)
	end,
	
	target_lost_animation = function(self,entity,sender)
		local XRandom = random(1,2)
		if (XRandom==1) then
			entity:StartAnimation(0,"_curious1",0)
		elseif (XRandom==2) then
			entity:StartAnimation(0,"_curious2",0)
		end
	end,

}