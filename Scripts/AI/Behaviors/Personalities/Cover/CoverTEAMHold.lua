--------------------------------------------------
--   Created By: Petar
--   Description: Cover goes into this behaviour when there is no more cover,so he holds his ground
--------------------------

AIBehaviour.CoverTEAMHold = {
	Name = "CoverTEAMHold",


	---------------------------------------------
	OnKnownDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		entity:InsertSubpipe(0,"not_so_random_hide_from",sender.id)
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
	end,

	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- drop beacon and shoot like crazy

--		local rnd = random(1,10)
--		if (rnd < 2) then 
--			NOCOVER:SelectAttack(entity)
--		else
			entity:SelectPipe(0,"just_shoot")
			entity:TriggerEvent(AIEVENT_DROPBEACON)
--		end
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)

		entity:SelectPipe(0,"just_shoot") -- dumb_shoot

--		entity:SelectPipe(0,"seek_target")
--		entity:InsertSubpipe(0,"reload")
--
--		if (fDistance > 10) then 
--			entity:InsertSubpipe(0,"do_it_running")
---		else
--			entity:InsertSubpipe(0,"do_it_walking")
--		end
--				
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- ignore this
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- ignore this
	end,
	---------------------------------------------
	OnReload = function(self,entity)

	end,

	OnNoHidingPlace = function(self,entity,sender)
		-- he is not trying to hide in this behaviour
	end,	
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		AIBehaviour.DEFAULT:OnReceivingDamage(entity,sender)
	end,
	---------------------------------------------
	OnCoverRequested = function(self,entity,sender)
		-- called when the enemy is damaged
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
	end,
	
	OnClipNearlyEmpty = function(self,entity,sender)
		entity:InsertSubpipe(0,"take_cover")
	end,
	--------------------------------------------------
	-- CUSTOM SIGNALS
	--------------------------------------------------
	COVER_NORMALATTACK = function(self,entity,sender)
	end,
	---------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		-- do nothing on this signal
		entity.RunToTrigger = 1 
	end,
	---------------------------------------------
	INCOMING_FIRE = function(self,entity,sender)
		-- do nothing on this signal
	end,
	---------------------------------------------
	LOOK_FOR_TARGET = function(self,entity,sender)
		-- do nothing on this signal
		entity:SelectPipe(0,"look_around")
	end,	

	---------------------------------------------	
	PHASE_BLACK_ATTACK = function(self,entity,sender)
		-- team leader instructs black team to attack
		entity.Covering = nil 
		entity:SelectPipe(0,"black_cover_pindown")
	end,

	---------------------------------------------	
	PHASE_RED_ATTACK = function(self,entity,sender)
		-- team leader instructs red team to attack
		entity.Covering = nil 
		entity:SelectPipe(0,"red_cover_pindown")
	end,

}