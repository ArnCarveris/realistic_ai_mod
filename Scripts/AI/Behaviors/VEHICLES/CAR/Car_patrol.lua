
AIBehaviour.Car_patrol = {
	Name = "Car_patrol",
	

	-- SYSTEM EVENTS			-----
	---------------------------------------------
	OnSpawn = function(self,entity)

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
	OnGrenadeSeen_Flying = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,

	OnGrenadeSeen_Colliding = function(self,entity,sender)
		self:OnGrenadeSeen(entity)
	end,
	OnGroupMemberDied = function(self,entity,sender)
--	OnDeath = function(self,entity,sender)

--do return end
	
printf("Vehicle -------------- OnDeath")	
	
		if (sender==entity.driver) then				-- stop if the driver is killed
			AI:Signal(0,1,"DRIVER_OUT",entity.id)
--			entity:SelectPipe(0,"c_brake")		
--			entity:SelectPipe(0,"c_standingthere")
		end	
	
	end,	

	---------------------------------------------
	OnEnemyMemory = function(self,entity,fDistance,NotContact)
--printf("Vehicle -------------- RejectPlayer")	

--		entity:TriggerEvent(AIEVENT_REJECT)

	end,

	--------------------------------------------
	OnPlayerSeen = function(self,entity,fDistance,NotContact)

--printf("Vehicle -------------- RejectPlayer")	

--		AI:Signal(0,1,"EVERYONE_OUT",entity.id)
			
	
		if (_localplayer.theVehicle) then
			AI:Signal(0,1,"GO_CHASE",entity.id)
		elseif (entity.Properties.bApproachPlayer==1) then
			entity:SelectPipe(0,"c_approach_n_drop")
		else
			AI:Signal(0,1,"EVERYONE_OUT",entity.id)
		end	

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
	
		AI:Signal(0,1,"next_point",entity.id)					
		
--entity:SelectPipe(0,"c_standingthere")		
		
	end,	
	
	--------------------------------------------
	EVERYONE_OUT = function(self,entity,sender)

		entity:SelectPipe(0,"c_brake")
		entity:TriggerEvent(AIEVENT_DROPBEACON)

--		entity:EveryoneOut()	
		VC.DropPeople(entity)
--		AI:Signal(0,1,"next_point",entity.id)					
--entity:SelectPipe(0,"c_standingthere")
				
		
	end,	
	

	---------------------------------------------
	DRIVER_OUT = function(self,entity,sender)
printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
	end,	

	---------------------------------------------
	GUNNER_OUT = function(self,entity,sender)
--printf("car patol  -------------- driver out")	
		entity:SelectPipe(0,"c_brake")
		entity:DropPeople()
	end,	

	--------------------------------------------
	next_point = function(self,entity,sender)	
	
		entity.step = entity.step + 1 
		if (entity.step >= entity.Properties.pathsteps) then
			if (entity.Properties.bPathloop==1) then
				entity.step = entity.Properties.pathstart 			
			else	
				AI:Signal(0,1,"EVERYONE_OUT",entity.id)
			end	
		end	
		
		printf("---->>let's go!!  #%d",entity.step)		
		entity:SelectPipe(0,"c_goto",entity.Properties.pathname..entity.step)
--		entity:SelectPipe(0,"c_goto_path",entity.Properties.pathname..self.step)		

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
