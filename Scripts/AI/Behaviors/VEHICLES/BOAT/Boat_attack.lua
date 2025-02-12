
AIBehaviour.Boat_attack = {
	Name = "Boat_attack",
	
	step = 0,
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

		self.step = entity.Properties.pathstart 

	end,
	---------------------------------------------
	OnActivate = function(self,entity)

	end,
	---------------------------------------------
	---------------------------------------------
	OnGrenadeSeen = function(self,entity)

		printf("Vehicle -------------- OnGranateSeen")	
	
		entity:InsertSubpipe(0,"c_grenade_run_away")
		
	end,
	
	OnGrenadeSeen = function(self,entity,fDistance)
		AI:Signal(0,1,"TO_PREVIOUS",entity.id)
	end,
	
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	---------------------------------------------
	OnGroupMemberDied = function(self,entity,sender)
		--	OnDeath = function(self,entity,sender)

		--do return end
			
		printf("Vehicle -------------- OnDeath")	
			
		--		if (entity.UnloadPeople) then
		--			entity:UnloadPeople()
		--		end	
		--		if (sender==entity.driver) then				-- stop if the driver is killed
		--			AI:Signal(0,1,"DRIVER_OUT",entity.id)
		--		end	
			
	end,	

	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
		--printf("Vehicle -------------- RejectPlayer")	

		--		entity:TriggerEvent(AIEVENT_REJECT)

	end,

	--------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		local target = AI:GetAttentionTargetOf(entity.id)
		if (target and type(target)=="table" and target.GetPos) then
			local water = Game:GetWaterHeight()
			--	local terrain = System:GetTerrainElevation(target:GetPos())
			--	if (terrain<water) then
			local tagretPos = target:GetPos()
			--	if ((tagretPos.z-water)<1) then
			--System:Log("\002 OnPlayerSeen "..tagretPos.z.." water "..water)	
			if (tagretPos.z<water or (target.theVehicle and target.theVehicle.IsBoat)) then
				entity:SelectPipe(0,"b_stick")
			--System:Log("\002 OnPlayerSeen -------------- inWATER")
			else
				AI:Signal(0,1,"TARGET_ON_LAND",entity.id)	
			--printf("OnPlayerSeen -------------- LAND")
			--System:Log("\002 OnPlayerSeen -------------- LAND")
			end	
		else
			entity:SelectPipe(0,"b_stick")		
			--System:Log("\002 OnPlayerSeen -------------- STICK")			
		end	
		--printf("Vehicle -------------- RejectPlayer")	
		--		entity:TriggerEvent(AIEVENT_REJECT)
	end,

	---------------------------------------------
	-- CUSTOM
	---------------------------------------------
	---------------------------------------------
	VEHICLE_ARRIVED = function(self,entity,sender)
		printf("Vehicle is there")
		entity:SelectPipe(0,"v_brake")
	end,
	

	--------------------------------------------
	DRIVER_IN = function(self,entity,sender)
	
		-- change sightrange/fow to attack values
		VC.SetAttackProperties(entity)
		AI:Signal(0,1,"next_point",entity.id)					
		
--entity:SelectPipe(0,"c_standingthere")		
	end,	
	
	--------------------------------------------
	next_point = function(self,entity,sender)	

--System:Log("\002 next_point -------------- LAND")

		AIBehaviour.Boat_attack.OnPlayerSeen(self,entity)
	
--		self:OnPlayerSeen(entity,0,1)
	
--		entity:SelectPipe(0,"b_stick")		
--		do return end 
		
	end,
	
	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
--printf("boat attack  -------------- driver out")	
		entity:SelectPipe(0,"b_standingthere")
		
--		entity:Event_KillTriger()
		
--		if (entity.UnloadPeople) then
--			entity:UnloadPeople()
--		end	
	end,	

	---------------------------------------------
	GUNNER_OUT = function(self,entity,sender)

		entity:SelectPipe(0,"b_goto_ignore",entity.Properties.pointBackOff)
		AI:Signal(0,1,"drop_people",entity.id)

--printf("boat attack  -------------- gunner out")	
--		entity:SelectPipe(0,"b_standingthere")

--		entity:Event_KillTriger()

--		if (entity.UnloadPeople) then
--			entity:UnloadPeople()
--		end

	end,	

	---------------------------------------------
	BRING_REINFORCMENT = function(self,entity,sender)

		entity:SelectPipe(0,"b_goto_ignore",entity.Properties.pointReinforce)
		AI:Signal(0,1,"drop_people",entity.id)

	end,	

	--------------------------------------------
	ON_GROUND = function(self,entity,sender)	

		if (entity.UnloadPeople) then
			entity:UnloadPeople()
		end	

		printf("---->>Boat_transport >>> onground ")		
		entity:SelectPipe(0,"b_standingthere")
	end,

	--------------------------------------------
	OnEnemyMemory = function(self,entity,sender)
		entity.EventToCall = "DRIVER_IN" 
	end,

	--------------------------------------------
	PLAYER_LEFT_VEHICLE = function(self,entity,sender)

--System:Log("\001 BOAT attack  on  PLAYER_LEFT_VEHICLE ")
--
--		if (entity.Properties.bLandOnPlayerLand~=1) then return end
--
----		local target = AI:GetAttentionTargetOf(entity.id)
----		if (target and type(target)=="table" and target.GetPos) then
--
--		local target = _localplayer 
--		if (target and type(target)=="table" and target.GetPos) then
--			
--System:Log("\001 BOAT attack  on  PLAYER_LEFT_VEHICLE >>>>>>> ")
--			
--			local pos = target:GetPos()
--			local water = Game:GetWaterHeight()
--			local terrain = System:GetTerrainElevation(pos)
--			
--			if (terrain - water > -1.5)	then
--				entity:SelectPipe(0,"b_goto_beacon_ignore")	
--				entity:TriggerEvent(AIEVENT_DROPBEACON)
--				AI:Signal(0,1,"drop_people",entity.id)
--				
--System:Log("\001 BOAT attack  on  PLAYER_LEFT_VEHICLE +++++++++++++++++++++ ")
--				
--			end	
--		end	
	end,	

	--------------------------------------------
	LAND_AT_PLAYERPOS = function(self,entity,sender)

--System:Log("\001 BOAT attack  on  LAND_ATPLAYERPOS ")

		if (entity.Properties.bLandOnPlayerLand~=1) then return end

--		local target = AI:GetAttentionTargetOf(entity.id)
--		if (target and type(target)=="table" and target.GetPos) then

		local target = _localplayer 
		if (target and type(target)=="table" and target.GetPos) then
			
--System:Log("\001 BOAT attack  on  LAND_ATPLAYERPOS >>>>>>> ")
			
			local pos = target:GetPos()
			local water = Game:GetWaterHeight()
			local terrain = System:GetTerrainElevation(pos)
			
			if (terrain - water > -1.5)	then
				entity:SelectPipe(0,"b_goto_beacon_ignore")	
				entity:TriggerEvent(AIEVENT_DROPBEACON)
				AI:Signal(0,1,"drop_people",entity.id)
				
--System:Log("\001 BOAT attack  on  LAND_ATPLAYERPOS +++++++++++++++++++++ ")
				
			end	
		end	
	end,	

	
	
	TARGET_ON_LAND = function(self,entity,sender) -- C++

--System:Log("\001 BOAT attack  TARGET_ON_LAND")

		if (entity.Properties.bLandOnPlayerLand==0) then
			VC.BoatLandAttack(entity)		
		else
--System:Log("\002 BOAT attack  on  TARGET_ON_LAND ")
			AI:Signal(0,1,"LAND_AT_PLAYERPOS",entity.id)
		end
	end,	

	OnSomethingDiedNearest = function(self,entity,sender)
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	OnReceivingDamage = function(self,entity,sender)
	end,

	OnBulletRain = function(self,entity,sender)
	end,

	OnCloseContact = function(self,entity,sender)
	end,

	ALARM_ON = function(self,entity,sender)
	end,

	ALERT_SIGNAL = function(self,entity,sender)
	end,

	NORMAL_THREAT_SOUND = function(self,entity,sender)
	end,

	LOOK_AT_BEACON = function(self,entity,sender)
	end,

	STOP_LOOK_AT_BEACON = function(self,entity,sender)
	end,

	INCOMING_FIRE = function(self,entity,sender)
	end,

	HEADS_UP_GUYS = function(self,entity,sender)
	end,

	GoForReinforcement = function(self,entity,sender)
	end,

	RunToAlarmSignal = function(self,entity,sender)
	end,

	FIND_A_TARGET = function(self,entity,sender)
	end,

	TARGET_LOST = function(self,entity,sender)
	end,

	SWITCH_TO_MORTARGUY = function(self,entity,sender)
	end,

	SEARCH_AMMUNITION = function(self,entity,sender)
	end,

	SELECT_IDLE = function(self,entity,sender)
	end,

}
