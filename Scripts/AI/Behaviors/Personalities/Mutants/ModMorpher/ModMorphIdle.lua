--------------------------------------------------
--    Created By: Petar


AIBehaviour.ModMorphIdle = {
	Name = "ModMorphIdle",

	OnNoTarget = function(self,entity)
	end,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)

		if (entity.SIGNAL_SENT==nil) then
			AI:Signal(0,1,"NOTIFY_GROUP_SIGNAL",entity.id)		
		end

		entity:TriggerEvent(AIEVENT_DROPBEACON)
	end,

	---------------------------------------------
	OnPlayerLookingAway =  function(self,entity,fDistance)
		entity:GoRefractive()
		entity:SelectPipe(0,"morpher_invisible_attack")
	end,
	---------------------------------------------
	OnSomethingSeen = function(self,entity,fDistance)
		-- called when the enemy sees a living player
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
		-- called when the enemy is damaged
		entity:GoVisible()
		entity:SelectPipe(0,"morpher_attack_wrapper")

		if (entity.AI_GunOut==nil) then
			entity:InsertSubpipe(0,"DRAW_GUN")
		end
	end,
	--------------------------------------------------
	OnBulletRain = function(self,entity,sender)
		-- called when the enemy detects bullet trails around him
	end,
	--------------------------------------------------
	JUMP_FINISHED = function(self,entity,sender)
		entity:SelectPipe(0,"mutant_walk_to_beacon")
		entity:InsertSubpipe(0,"setup_stand")
	end,
	--------------------------------------------------
	OnCloseContact = function(self,entity,sender)
		entity:GoVisible()
		entity:SelectPipe(0,"morpher_attack_wrapper")
		if (entity.MELEE_ANIM_COUNT) then
			local rnd = random(1,entity.MELEE_ANIM_COUNT)
			local melee_anim_name = format("attack_melee%01d",rnd)
			entity:InsertAnimationPipe(melee_anim_name,3)
		else
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
			Hud:AddMessage("Entity "..entity:GetName().." made melee attack but has no melee animations.")
			Hud:AddMessage("==================UNACCEPTABLE ERROR====================")
		end

			AI:Signal(SIGNALFILTER_GROUPONLY,1,"HEADS_UP_GUYS",entity.id)
			AI:Signal(SIGNALFILTER_SUPERGROUP,-1,"WakeUp",entity.id)
			AI:Signal(SIGNALFILTER_SUPERGROUP,-1,"WakeUp2",entity.id)
	end,

	--------------------------------------------------
	MORPH = function(self,entity,sender)
		entity:GoVisible()
--		AI:Cloak(entity.id)
	end,
	--------------------------------------------------
	UNMORPH = function(self,entity,sender)
		AI:DeCloak(entity.id)
	end,

	--------------------------------------------------
	GO_REFRACTIVE = function(self,entity,sender)
	end,
	--------------------------------------------------
	GO_VISIBLE = function(self,entity,sender)
	end,

	--------------------------------------------------
	HEADS_UP_GUYS = function(self,entity,sender)
		entity:SelectPipe(0,"mutant_run_to_beacon")
	end,

}