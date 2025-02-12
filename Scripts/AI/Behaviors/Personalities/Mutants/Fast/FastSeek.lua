--------------------------------------------------
--    Created By: Petar


AIBehaviour.FastSeek = {
	Name = "FastSeek",


	---------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		-- called when the enemy sees a living player
		entity:SelectPipe(0,"fast_shoot")
	end,
	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		-- called when the enemy can no longer see its foe,but remembers where it saw it last
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity)
		-- called when the enemy hears an interesting sound
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity)
		-- called when the enemy hears a scary sound
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
	end,
	---------------------------------------------
	OnReceivingDamage = function(self,entity,sender)
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	OnCloseContact = function(self,entity,sender)
		local rnd=random(1,5)
		entity:InsertMeleePipe("attack_melee"..rnd)
		AI:SoundEvent(entity.id,entity:GetPos(),15,1,0,entity.id) -- Сделать нормальную дистанцию.
	end,
	--------------------------------------------------



}