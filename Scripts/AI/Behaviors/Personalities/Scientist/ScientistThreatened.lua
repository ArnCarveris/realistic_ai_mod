--------------------------------------------------
--    Created By: Amanda
--   Description: behaviour when the AI has been alerted to something
--------------------------
--

AIBehaviour.ScientistThreatened = {
	Name = "ScientistThreatened",

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSelected = function(self,entity)
	end,
	---------------------------------------------
	OnSpawn = function(self,entity)
	end,
	---------------------------------------------
	OnActivate = function(self,entity)
	end,
	---------------------------------------------
	OnNoTarget = function(self,entity)
	end,
	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- attack player only if they are too close to get away otherwise
		-- seek reinforcement point or hide farthest from target.
--		System:Log("[".. entity:GetName().."] ScientistThreatened++++++player seen reinforce point["..entity.Properties.ReinforcePoint .."]")

		AI:Signal(0,1,"SAY_FIRST_HOSTILE_CONTACT",entity.id)

		if (entity.SIGNAL_SENT==nil) then
			if (entity:GetGroupCount() > 1) then
				AI:Signal(0,1,"NOTIFY_GROUP_SIGNAL",entity.id)
			end
		end
		
		if ((entity.Properties.ReinforcePoint==nil) or (entity.Properties.ReinforcePoint=="none")) then

			-- you are on your own
			if (fDistance<5) then
--				System:Log("[".. entity:GetName().."] player seen++++++too close defend")
				entity:SelectPipe(0,"scientist_tooclose_defend")
			else
--				System:Log("[".. entity:GetName().."] player seen++++++scientist_runAway")
				entity:SelectPipe(0,"scientist_runAway")
			end
			
		else			
			-- only send this signal if you have a ReinforcePoint defined
--			if (fDistance<10) then
--				System:Log("[".. entity:GetName().."] player seen++++++scientist_tooclose_defend_ReinforcePoint")
--				entity:SelectPipe(0,"scientist_tooclose_defend_ReinforcePoint",entity.Properties.ReinforcePoint)
--			else
--				System:Log("[".. entity:GetName().."] player seen++++++scientist_ReinforcePoint")
				entity:SelectPipe(0,"scientist_ReinforcePoint",entity.Properties.ReinforcePoint)
--			end
		end
	end,
	---------------------------------------------
	OnEnemySeen = function(self,entity)
		-- called when the enemy sees a foe which is not a living player
	end,
	---------------------------------------------
	OnFriendSeen = function(self,entity)
		-- called when the enemy sees a friendly target
	end,

	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
		entity:SelectPipe(0,"scientist_randomhide")
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
		--System:Log("+++++++++++++++++++THREATENED threatening sound")
		
		-- look around wildly or go prone
		entity:SelectPipe(0,"scientist_randomhide")
	end,
	---------------------------------------------
	OnReload = function(self,entity)
		-- called when the enemy goes into automatic reload after its clip is empty
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity)
		-- called when a member of the group dies
	end,
	---------------------------------------------
	OnNoHidingPlace = function(self,entity,sender)
		-- called when no hiding place can be found with the specified parameters
		--System:Log("+++++++++++++++++++THREATENED NO HIDING SCOUT THREATENED")
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		-- DO NOT TOUCH THIS READIBILITY SIGNAL	------------------------
		AI:Signal(SIGNALID_READIBILITY,1,"GETTING_SHOT_AT",entity.id)
		entity:SelectPipe(0,"scientist_randomhide")
		----------------------------------------------------------------
		-- go prone / run away
	end,
}