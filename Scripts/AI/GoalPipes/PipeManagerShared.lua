
function PipeManager:OnInitShared()
	System:Log("ON INIT SHARED")
-- ______________________________________________________________________________________________________________________
-- -------------------------------------------------- SHARED SCRIPTS ----------------------------------------------------
		AI:CreateGoalPipe("AIS_GoOn")
		AI:PushGoal("AIS_GoOn","signal",0,1,"AISF_GoOn",0)

		AI:CreateGoalPipe("GoOn2sec")
		AI:PushGoal("GoOn2sec","timeout",1,2)
		AI:PushGoal("GoOn2sec","signal",0,1,"GoOn",0)

		AI:CreateGoalPipe("GoOn4sec")
		AI:PushGoal("GoOn4sec","timeout",1,4)
		AI:PushGoal("GoOn4sec","signal",0,1,"GoOn",0)


		AI:CreateGoalPipe("AIS_Test")
		AI:PushGoal("AIS_Test","bodypos",1,0)

		------------------------------ IGNORE ---------------------------
		AI:CreateGoalPipe("AIS_ignoreall")
		AI:PushGoal("AIS_ignoreall","ignoreall",1,1)

		AI:CreateGoalPipe("AIS_dont_ignore")
		AI:PushGoal("AIS_dont_ignore","ignoreall",1,0)
		AI:PushGoal("AIS_dont_ignore","signal",0,1,"AISF_GoOn",0)
		------------------------------------------------------------------
		-------------------------------- DELAY ---------------------------
		-- Delay_1
		AI:CreateGoalPipe("AIS_Delay_1")
		AI:PushGoal("AIS_Delay_1","timeout",1,1)
		AI:PushGoal("AIS_Delay_1","signal",0,1,"AISF_GoOn",0)

		-- Delay_2
		AI:CreateGoalPipe("AIS_Delay_2")
		AI:PushGoal("AIS_Delay_2","timeout",1,2)
		AI:PushGoal("AIS_Delay_2","signal",0,1,"AISF_GoOn",0)

		-- Delay_3
		AI:CreateGoalPipe("AIS_Delay_3")
		AI:PushGoal("AIS_Delay_3","timeout",1,4)
		AI:PushGoal("AIS_Delay_3","signal",0,1,"AISF_GoOn",0)

		-- Delay_4
		AI:CreateGoalPipe("AIS_Delay_4")
		AI:PushGoal("AIS_Delay_4","timeout",1,6)
		AI:PushGoal("AIS_Delay_4","signal",0,1,"AISF_GoOn",0)

		-- Delay_5
		AI:CreateGoalPipe("AIS_Delay_5")
		AI:PushGoal("AIS_Delay_5","timeout",1,8)
		AI:PushGoal("AIS_Delay_5","signal",0,1,"AISF_GoOn",0)

		-- Delay_6
		AI:CreateGoalPipe("AIS_Delay_6")
		AI:PushGoal("AIS_Delay_6","timeout",1,10)
		AI:PushGoal("AIS_Delay_6","signal",0,1,"AISF_GoOn",0)

		-- Delay_7
		AI:CreateGoalPipe("AIS_Delay_7")
		AI:PushGoal("AIS_Delay_7","timeout",1,12)
		AI:PushGoal("AIS_Delay_7","signal",0,1,"AISF_GoOn",0)

		-- Delay_8
		AI:CreateGoalPipe("AIS_Delay_8")
		AI:PushGoal("AIS_Delay_8","timeout",1,14)
		AI:PushGoal("AIS_Delay_8","signal",0,1,"AISF_GoOn",0)
		------------------------------------------------------------------
		------------------------------ searching -------------------------
		-- Look for Threat
		AI:CreateGoalPipe("LookForThreat")
		AI:PushGoal("LookForThreat","lookat",1,-150,-210)
		AI:PushGoal("LookForThreat","timeout",1,1)
		AI:PushGoal("LookForThreat","lookat",1,-90,-180)
		AI:PushGoal("LookForThreat","timeout",1,1)
		AI:PushGoal("LookForThreat","lookat",1,70,110)
		AI:PushGoal("LookForThreat","lookat",1,-70,-110)

		-- Look for Threat GoOn
		AI:CreateGoalPipe("LookForThreatGoOn")
		AI:PushGoal("LookForThreatGoOn","LookForThreat")
		AI:PushGoal("LookForThreatGoOn","signal",0,1,"AISF_GoOn",0)

		-- LookLeft
		AI:CreateGoalPipe("LookLeft")
		AI:PushGoal("LookLeft","lookat",1,75,90)
		AI:PushGoal("LookLeft","timeout",1,1,2)

		-- LookRight
		AI:CreateGoalPipe("LookRight")
		AI:PushGoal("LookRight","lookat",1,-75,-90)
		AI:PushGoal("LookRight","timeout",1,1,2)

		-- LookInTargetDirection
		AI:CreateGoalPipe("LookInTargetDirection")
		AI:PushGoal("LookInTargetDirection","lookat",1,0,0)
		AI:PushGoal("LookInTargetDirection","timeout",1,1,2)


		-- randomly search a hide point,walk towards
		AI:CreateGoalPipe("RandomSearch")
		AI:PushGoal("RandomSearch","locate",0,"hidepoint")
		AI:PushGoal("RandomSearch","setup_stealth")
		AI:PushGoal("RandomSearch","do_it_walking")
		AI:PushGoal("RandomSearch","acqtarget",1,"")
		AI:PushGoal("RandomSearch","approach",1,3)
		AI:PushGoal("RandomSearch","hide",0,60,HM_RANDOM,1)
		AI:PushGoal("RandomSearch","timeout",1,1,20)
		-- AI:PushGoal("RandomSearch","clear",0)

		AI:CreateGoalPipe("RandomSearchTrace")
		AI:PushGoal("RandomSearchTrace","locate",0,"hidepoint")
		AI:PushGoal("RandomSearchTrace","setup_stealth")
		AI:PushGoal("RandomSearchTrace","do_it_walking")
		AI:PushGoal("RandomSearchTrace","pathfind",1,"")
		AI:PushGoal("RandomSearchTrace","trace",1,1)
		AI:PushGoal("RandomSearchTrace","clear",0)

		AI:CreateGoalPipe("InvestigateSound")
		AI:PushGoal("InvestigateSound","bodypos",1,0)
		AI:PushGoal("InvestigateSound","timeout",1,5)
		AI:PushGoal("InvestigateSound","do_it_walking")
		AI:PushGoal("InvestigateSound","approach",1,.5)

		AI:CreateGoalPipe("ApproachSound")
		AI:PushGoal("ApproachSound","form",1,"beacon")
		AI:PushGoal("ApproachSound","locate",1,"beacon")
		AI:PushGoal("ApproachSound","acqtarget",1,"")
		AI:PushGoal("ApproachSound","setup_stand")
		AI:PushGoal("ApproachSound","do_it_walking")
		AI:PushGoal("ApproachSound","hide",1,10,HM_NEAREST)
		AI:PushGoal("ApproachSound","setup_stealth")
		AI:PushGoal("ApproachSound","do_it_walking")
		AI:PushGoal("ApproachSound","timeout",1,1)
		AI:PushGoal("ApproachSound","hide",1,10,HM_NEAREST_TO_TARGET)
		AI:PushGoal("ApproachSound","timeout",1,0,1)
		AI:PushGoal("ApproachSound","branch",0,-3,1)	-- this will loop until there is no more hiding points
		AI:PushGoal("ApproachSound","approach",1,.5)

		------------------------------------------------------------------
		------------------------------ beacon ----------------------------

		------------------------------------------------------------------
		---------------------- Reinforcement -----------------------------
		AI:CreateGoalPipe("AIS_GoForReinforcement")
		-- AI:PushGoal("AIS_GoForReinforcement","ignoreall",0,1)
		AI:PushGoal("AIS_GoForReinforcement","setup_idle")
		AI:PushGoal("AIS_GoForReinforcement","do_it_running")
		AI:PushGoal("AIS_GoForReinforcement","acqtarget",1,"")
		AI:PushGoal("AIS_GoForReinforcement","pathfind",1,"")
		AI:PushGoal("AIS_GoForReinforcement","trace",1,1)
		AI:PushGoal("AIS_GoForReinforcement","ignoreall",0,1)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,1,"MAKE_REINFORCEMENT_ANIM",0)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,1,"TELL_LEADER_BAD_NEWS",SIGNALID_READIBILITY)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,-1,"WakeUp",SIGNALFILTER_ANYONEINCOMM)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,-1,"WakeUp2",SIGNALFILTER_ANYONEINCOMM)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,1,"AISF_CallForHelp",SIGNALFILTER_ANYONEINCOMM)
		AI:PushGoal("AIS_GoForReinforcement","setup_stand")
		AI:PushGoal("AIS_GoForReinforcement","ignoreall",0,0)
		AI:PushGoal("AIS_GoForReinforcement","signal",1,1,"RETURN_TO_PREVIOUS",0)
		AI:PushGoal("AIS_GoForReinforcement","check_beacon") -- Побежать на цель.
		AI:PushGoal("AIS_GoForReinforcement","clear",0)


		------------------------------------------------------------------
		---------------------- SeenByGroupMember -------------------------
		AI:CreateGoalPipe("PlayerSeenByGroupMember")
		AI:PushGoal("PlayerSeenByGroupMember","LookForThreat")
		AI:PushGoal("PlayerSeenByGroupMember","setup_stand")
		AI:PushGoal("PlayerSeenByGroupMember","do_it_running")
		AI:PushGoal("PlayerSeenByGroupMember","timeout",1,.2)
		AI:PushGoal("PlayerSeenByGroupMember","acqtarget",1,"")
		AI:PushGoal("PlayerSeenByGroupMember","approach",1,5)
		AI:PushGoal("PlayerSeenByGroupMember","LookForThreat")

		AI:CreateGoalPipe("PlayerSeenByGroupMemberIndoor")
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","bodypos",1,0)
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","do_it_running")
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","timeout",1,.5)
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","pathfind",1,"")
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","timeout",1,.5)
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","trace",1,1)
		AI:PushGoal("PlayerSeenByGroupMemberIndoor","LookForThreat")
		------------------------------------------------------------------
		------------------------ TeamMemberDied --------------------------
		-- Team Member Died
		AI:CreateGoalPipe("TeamMemberDied")
		AI:PushGoal("TeamMemberDied","timeout",1,.2)
		AI:PushGoal("TeamMemberDied","locate",1,"beacon")
		AI:PushGoal("TeamMemberDied","acqtarget",1,"")
		AI:PushGoal("TeamMemberDied","bodypos",1,0)
		AI:PushGoal("TeamMemberDied","do_it_running")
		AI:PushGoal("TeamMemberDied","timeout",1,1)
		AI:PushGoal("TeamMemberDied","hide",1,10,HM_NEAREST,1)
		AI:PushGoal("TeamMemberDied","bodypos",1,5)
		AI:PushGoal("TeamMemberDied","do_it_walking")
		AI:PushGoal("TeamMemberDied","signal",0,1,"CHECK_FOR_FIND_A_TARGET",0)

		AI:CreateGoalPipe("TeamMemberDiedLook")
		AI:PushGoal("TeamMemberDiedLook","TeamMemberDied")
		AI:PushGoal("TeamMemberDiedLook","locate",0,"hidepoint")
		AI:PushGoal("TeamMemberDiedLook","acqtarget",0,"")
		AI:PushGoal("TeamMemberDiedLook","approach",1,3)
		AI:PushGoal("TeamMemberDiedLook","lookat",1,-45,45)
		AI:PushGoal("TeamMemberDiedLook","lookat",1,-45,45)

		AI:CreateGoalPipe("TeamMemberDiedLook2") -- Когда труп "изучают".
		AI:PushGoal("TeamMemberDiedLook2","setup_stand")
		AI:PushGoal("TeamMemberDiedLook2","timeout",1,0,.5)
		AI:PushGoal("TeamMemberDiedLook2","form",1,"beacon")
		AI:PushGoal("TeamMemberDiedLook2","locate",1,"beacon")
		AI:PushGoal("TeamMemberDiedLook2","acqtarget",1,"")
		AI:PushGoal("TeamMemberDiedLook2","timeout",1,.5,1.5)
		AI:PushGoal("TeamMemberDiedLook2","do_it_running")
		AI:PushGoal("TeamMemberDiedLook2","hide",1,30,HM_NEAREST,1)
		-- AI:PushGoal("TeamMemberDiedLook2","hide",1,30,HM_NEAREST,0)
		AI:PushGoal("TeamMemberDiedLook2","LookForThreat")
		AI:PushGoal("TeamMemberDiedLook2","locate",0,"beacon") -- Должен быть нуль.
		AI:PushGoal("TeamMemberDiedLook2","acqtarget",0,"") -- И здесь тоже.
		AI:PushGoal("TeamMemberDiedLook2","timeout",1,.5,3)

		AI:CreateGoalPipe("LookAtTheBodyInAction")
		AI:PushGoal("LookAtTheBodyInAction","timeout",.2,1)
		-- AI:PushGoal("LookAtTheBodyInAction","form",1,"beacon")
		-- AI:PushGoal("LookAtTheBodyInAction","locate",1,"beacon")
		AI:PushGoal("LookAtTheBodyInAction","just_shoot")
		AI:PushGoal("LookAtTheBodyInAction","acqtarget",1,"")
		AI:PushGoal("LookAtTheBodyInAction","timeout",1,1)
		AI:PushGoal("LookAtTheBodyInAction","locate",1,"beacon")
		AI:PushGoal("LookAtTheBodyInAction","acqtarget",1,"")

		---------------------- SeenByGroupMember -------------------------

		AI:CreateGoalPipe("TeamMemberDiedBeaconGoOn")
		AI:PushGoal("TeamMemberDiedBeaconGoOn","DropBeaconAt")
		AI:PushGoal("TeamMemberDiedBeaconGoOn","TeamMemberDied")
		AI:PushGoal("TeamMemberDiedBeaconGoOn","clear",0)
		AI:PushGoal("TeamMemberDiedBeaconGoOn","signal",0,1,"DEATH_CONFIRMED",SIGNALFILTER_GROUPONLY)

		AI:CreateGoalPipe("ChooseManner")
		AI:PushGoal("ChooseManner","timeout",1,1,2)
		AI:PushGoal("ChooseManner","signal",0,1,"ChooseManner",0)

		-- approach dead body beacon
		AI:CreateGoalPipe("ApproachDeadBeacon") -- Может подойти когда нашедший труп человек один, а не группа.
		AI:PushGoal("ApproachDeadBeacon","setup_stealth")
		AI:PushGoal("ApproachDeadBeacon","do_it_walking")
		AI:PushGoal("ApproachDeadBeacon","locate",1,"beacon")
		AI:PushGoal("ApproachDeadBeacon","acqtarget",1,"")
		AI:PushGoal("ApproachDeadBeacon","approach",1,3)
		AI:PushGoal("ApproachDeadBeacon","clear",0)
		AI:PushGoal("ApproachDeadBeacon","LookForThreat")
		AI:PushGoal("ApproachDeadBeacon","RandomSearch")

		-- approach dead body beacon
		AI:CreateGoalPipe("ApproachDeadBeaconTrace")
		AI:PushGoal("ApproachDeadBeaconTrace","setup_stealth")
		AI:PushGoal("ApproachDeadBeaconTrace","do_it_walking")
		AI:PushGoal("ApproachDeadBeaconTrace","locate",1,"beacon")
		AI:PushGoal("ApproachDeadBeaconTrace","pathfind",1,"")
		AI:PushGoal("ApproachDeadBeaconTrace","trace",1,1)
		AI:PushGoal("ApproachDeadBeaconTrace","LookForThreat")
		AI:PushGoal("ApproachDeadBeaconTrace","RandomSearch")

		-- Recognice Corpse
		AI:CreateGoalPipe("RecogCorpse")
		AI:PushGoal("RecogCorpse","form",1,"beacon") -- Нужно ли после InsertSubpipe "TeamMemberDiedLook2"?
		AI:PushGoal("RecogCorpse","locate",1,"beacon")
		AI:PushGoal("RecogCorpse","acqtarget",1,"")
		AI:PushGoal("RecogCorpse","setup_stealth")
		AI:PushGoal("RecogCorpse","do_it_walking")
		-- AI:PushGoal("RecogCorpse","hide",1,10,HM_NEAREST_TO_LASTOPRESULT)
		-- AI:PushGoal("RecogCorpse","timeout",1,0,1)
		-- AI:PushGoal("RecogCorpse","branch",0,-2,1)	-- this will loop until there is no more hiding points
		AI:PushGoal("RecogCorpse","acqtarget",1,"")
		AI:PushGoal("RecogCorpse","timeout",1,1,2)
		AI:PushGoal("RecogCorpse","approach",1,1) -- Сделать трейс без пропуска маршрута.
		AI:PushGoal("RecogCorpse","timeout",1,.3)
		AI:PushGoal("RecogCorpse","signal",1,1,"death_recognition",0) -- Анимация.
		AI:PushGoal("RecogCorpse","timeout",1,2)
		AI:PushGoal("RecogCorpse","signal",1,1,"DEATH_CONFIRMED_X",0) -- Себе.
		AI:PushGoal("RecogCorpse","timeout",1,1)
		AI:PushGoal("RecogCorpse","setup_stand")
		AI:PushGoal("RecogCorpse","signal",1,1,"NOTIFY_FRIENDS_X",0) -- Отправить всем на расстоянии 60 метров сигнал DEATH_CONFIRMED.
		AI:PushGoal("RecogCorpse","do_it_running")
		AI:PushGoal("RecogCorpse","hide",1,20,HM_NEAREST)
		AI:PushGoal("RecogCorpse","do_it_walking")
		AI:PushGoal("RecogCorpse","timeout",1,1)
		AI:PushGoal("RecogCorpse","clear",0)
		AI:PushGoal("RecogCorpse","signal",0,1,"DEATH_CONFIRMED_X",0) -- Себе.

		AI:CreateGoalPipe("LookAtTheBody") -- Постоянно смотрит на тело. В чём дело?
		AI:PushGoal("LookAtTheBody","timeout",0,0,1)
		AI:PushGoal("LookAtTheBody","form",1,"beacon")
		AI:PushGoal("LookAtTheBody","acqtarget",1,"")
		AI:PushGoal("LookAtTheBody","setup_stand")
		AI:PushGoal("LookAtTheBody","timeout",1,0,1)
		AI:PushGoal("LookAtTheBody","signal",0,1,"THROW_SMOKE",0)
		AI:PushGoal("LookAtTheBody","just_shoot")
		AI:PushGoal("LookAtTheBody","do_it_running")
		AI:PushGoal("LookAtTheBody","hide",1,15,HM_NEAREST,0)
		AI:PushGoal("LookAtTheBody","timeout",1,0,1)
		AI:PushGoal("LookAtTheBody","not_shoot")
		AI:PushGoal("LookAtTheBody","locate",0,"hidepoint")
		AI:PushGoal("LookAtTheBody","acqtarget",1,"")
		AI:PushGoal("LookAtTheBody","timeout",1,0,1)
		AI:PushGoal("LookAtTheBody","hide",1,60,HM_NEAREST,1)
		AI:PushGoal("LookAtTheBody","locate",0,"beacon")
		AI:PushGoal("LookAtTheBody","acqtarget",1,"")
		AI:PushGoal("LookAtTheBody","hide",1,60,HM_RANDOM,1)
		AI:PushGoal("LookAtTheBody","clear")
		-- AI:PushGoal("LookAtTheBody","timeout",1,0,60)
		AI:PushGoal("LookAtTheBody","signal",0,1,"FIND_A_TARGET",0)
		
		AI:CreateGoalPipe("LookAtTheBody2") -- Работает?
		AI:PushGoal("LookAtTheBody2","form",1,"beacon")
		AI:PushGoal("LookAtTheBody2","acqtarget",1,"")

		------------------------------------------------------------------
		------------------------ Formation -------------------------------
		AI:CreateGoalPipe("MoveFormation")
		AI:PushGoal("MoveFormation","ignoreall",1,1)
		AI:PushGoal("MoveFormation","do_it_running")
		AI:PushGoal("MoveFormation","locate",1,"formation")
		AI:PushGoal("MoveFormation","acqtarget",1,"")
		AI:PushGoal("MoveFormation","approach",1,1)
		AI:PushGoal("MoveFormation","ignoreall",1,0)

		AI:CreateGoalPipe("PatrolFormation")
		AI:PushGoal("PatrolFormation","timeout",1,.5)
		AI:PushGoal("PatrolFormation","locate",1,"formation")
		AI:PushGoal("PatrolFormation","acqtarget",1,"")
		AI:PushGoal("PatrolFormation","approach",1,1)

		AI:CreateGoalPipe("RegainFormation")
		AI:PushGoal("RegainFormation","signal",0,1,"MOVE_IN_FORMATION",0)

		AI:CreateGoalPipe("FormWoodwalk")
		AI:PushGoal("FormWoodwalk","form",1,"woodwalk")
		------------------------------------------------------------------
		-- go to tag
		AI:CreateGoalPipe("AIS_GoToTag")
		AI:PushGoal("AIS_GoToTag","signal",0,1,"JoinGroup",SIGNALFILTER_LASTOP)
		AI:PushGoal("AIS_GoToTag","timeout",1,.5)
		AI:PushGoal("AIS_GoToTag","form",0,"wedge")
		AI:PushGoal("AIS_GoToTag","timeout",1,.5)
		AI:PushGoal("AIS_GoToTag","signal",0,-1,"WakeUp",SIGNALFILTER_SUPERGROUP)
		AI:PushGoal("AIS_GoToTag","signal",0,-1,"WakeUp2",SIGNALFILTER_SUPERGROUP)
		AI:PushGoal("AIS_GoToTag","signal",0,1,"MOVE_IN_FORMATION",SIGNALFILTER_SUPERGROUP)
		AI:PushGoal("AIS_GoToTag","do_it_running")
		AI:PushGoal("AIS_GoToTag","setup_stand")
		AI:PushGoal("AIS_GoToTag","just_shoot")
		AI:PushGoal("AIS_GoToTag","locate",1,"beacon")
		AI:PushGoal("AIS_GoToTag","acqtarget",1,"")
		AI:PushGoal("AIS_GoToTag","approach",1,1)
		AI:PushGoal("AIS_GoToTag","timeout",1,1)

		------------------------------------------------------------------
		-------------------------- Job -----------------------------------
		-- acquire fenceanchor
		AI:CreateGoalPipe("AcqFenceAnchor")
		AI:PushGoal("AcqFenceAnchor","locate",1,AIAnchor.AIANCHOR_FENCE)
		AI:PushGoal("AcqFenceAnchor","acqtarget",1,"")
		AI:PushGoal("AcqFenceAnchor","ApproachAnchor")

		-- acquire pissanchor
		AI:CreateGoalPipe("AcqPissAnchor")
		AI:PushGoal("AcqPissAnchor","locate",1,AIAnchor.AIANCHOR_PISS)
		AI:PushGoal("AcqPissAnchor","acqtarget",1,"")
		AI:PushGoal("AcqPissAnchor","ApproachAnchor")

		-- acquire smokeanchor
		AI:CreateGoalPipe("AcqSmokeAnchor")
		AI:PushGoal("AcqSmokeAnchor","locate",1,AIAnchor.AIANCHOR_SMOKE)
		AI:PushGoal("AcqSmokeAnchor","acqtarget",1,"")
		AI:PushGoal("AcqSmokeAnchor","ApproachAnchor")

		-- acquire animalanchor
		AI:CreateGoalPipe("AcqAnimalAnchor")
		AI:PushGoal("AcqAnimalAnchor","locate",1,AIAnchor.AIANCHOR_ANIMALSPOT)
		AI:PushGoal("AcqAnimalAnchor","acqtarget",1,"")
		AI:PushGoal("AcqAnimalAnchor","ApproachAnchor")

		-- look at idleanchor
		AI:CreateGoalPipe("LookIdleAnchor")
		AI:PushGoal("LookIdleAnchor","timeout",1,.5)
		AI:PushGoal("LookIdleAnchor","locate",1,AIAnchor.AIANCHOR_IDLE)
		AI:PushGoal("LookIdleAnchor","lookat",1,0,0)
		AI:PushGoal("LookIdleAnchor","timeout",1,1,2)


		-- approach anchor
		AI:CreateGoalPipe("ApproachAnchor")
		AI:PushGoal("ApproachAnchor","timeout",1,.5,2)
		AI:PushGoal("ApproachAnchor","approach",1,2)
		AI:PushGoal("ApproachAnchor","timeout",1,.2)
		AI:PushGoal("ApproachAnchor","lookat",1,0,0)
		AI:PushGoal("ApproachAnchor","devalue",0)
		AI:PushGoal("ApproachAnchor","timeout",1,.2)

		-- general idle pipe
		AI:CreateGoalPipe("IdlePipe")
		AI:PushGoal("IdlePipe","timeout",1,.5,1.5)
		AI:PushGoal("IdlePipe","signal",0,1,"SelectAnchor",0)
		AI:PushGoal("IdlePipe","signal",0,1,"IdleStart",0)
		AI:PushGoal("IdlePipe","signal",0,1,"IdleLoop",0)
		AI:PushGoal("IdlePipe","timeout",0,18,22)
		AI:PushGoal("IdlePipe","timeout",1,6,9)
		AI:PushGoal("IdlePipe","signal",0,1,"IdleRandom",0)
		AI:PushGoal("IdlePipe","branch",1,-2)
		AI:PushGoal("IdlePipe","timeout",1,6,9)
		AI:PushGoal("IdlePipe","signal",0,1,"IdleEnd",0)

		-- patrol idle pipe
		AI:CreateGoalPipe("PatrolIdle")
		AI:PushGoal("PatrolIdle","do_it_walking")
		AI:PushGoal("PatrolIdle","bodypos",1,0)
		-- AI:PushGoal("PatrolIdle","timeout",0,8)
		AI:PushGoal("PatrolIdle","timeout",1,.5,1)
		AI:PushGoal("PatrolIdle","signal",0,1,"IdleRandom",0)
		AI:PushGoal("PatrolIdle","timeout",1,.5,1)
		AI:PushGoal("PatrolIdle","signal",0,1,"IdleLook",0)
		-- AI:PushGoal("PatrolIdle","branch",1,-4)
		AI:PushGoal("PatrolIdle","timeout",1,.5,1)
		AI:PushGoal("PatrolIdle","signal",0,1,"IdleEnd",0)

		-- pecari idel pipe
		AI:CreateGoalPipe("PecariPipe")
		AI:PushGoal("PecariPipe","do_it_walking")
		AI:PushGoal("PecariPipe","bodypos",1,0)
		AI:PushGoal("PecariPipe","timeout",1,.5,1.5)
		AI:PushGoal("PecariPipe","signal",0,1,"SelectAnchor",0)
		AI:PushGoal("PecariPipe","signal",0,1,"IdleStart",0)
		AI:PushGoal("PecariPipe","signal",0,1,"IdleLoop",0)
		AI:PushGoal("PecariPipe","timeout",0,2,3)
		AI:PushGoal("PecariPipe","timeout",1,2,3)
		AI:PushGoal("PecariPipe","signal",0,1,"IdleRandom",0)
		AI:PushGoal("PecariPipe","branch",1,-2)
		AI:PushGoal("PecariPipe","timeout",1,2,3)
		AI:PushGoal("PecariPipe","signal",0,1,"IdleEnd",0)

		------------------------------------------------------------------
		------------------------ Patrol ----------------------------------
		--Outdoor

		AI:CreateGoalPipe("JobPatrol")
		AI:PushGoal("JobPatrol","do_it_walking")
		AI:PushGoal("JobPatrol","bodypos",1,0)
		AI:PushGoal("JobPatrol","acqtarget",1,"")
		AI:PushGoal("JobPatrol","signal",0,1,"RELAXED_STANCE",0)
		AI:PushGoal("JobPatrol","timeout",1,1)
		AI:PushGoal("JobPatrol","approach",1,2)
		AI:PushGoal("JobPatrol","devalue",0)
		AI:PushGoal("JobPatrol","timeout",1,.5,1)
		AI:PushGoal("JobPatrol","signal",0,1,"IdleStart",0)

		-- Indoor
		AI:CreateGoalPipe("JobPatrolIndoor")
		AI:PushGoal("JobPatrolIndoor","do_it_walking")
		AI:PushGoal("JobPatrolIndoor","bodypos",1,0)
		AI:PushGoal("JobPatrolIndoor","pathfind",1,"")
		AI:PushGoal("JobPatrolIndoor","signal",0,1,"RELAXED_STANCE",0)
		AI:PushGoal("JobPatrolIndoor","timeout",1,.5)
		AI:PushGoal("JobPatrolIndoor","trace",1,1)
		--AI:PushGoal("JobPatrolIndoor","devalue",0)
		AI:PushGoal("JobPatrolIndoor","timeout",1,.5,1)
		AI:PushGoal("JobPatrolIndoor","signal",0,1,"IdleStart",0)
		------------------------------------------------------------------
		-------------------------- Hide ----------------------------------
		-- SneakNearestToTarget
		AI:CreateGoalPipe("SneakNearestToTarget")
		AI:PushGoal("SneakNearestToTarget","bodypos",1,5)
		AI:PushGoal("SneakNearestToTarget","do_it_walking")
		AI:PushGoal("SneakNearestToTarget","hide",1,15,HM_NEAREST_TO_TARGET)

		-- RunNearestToTarget
		AI:CreateGoalPipe("AIS_RunNearestToTarget")
		AI:PushGoal("AIS_RunNearestToTarget","do_it_running")
		AI:PushGoal("AIS_RunNearestToTarget","hide",1,7,HM_NEAREST_TO_TARGET)
		AI:PushGoal("AIS_RunNearestToTarget","signal",0,1,"AISF_GoOn",0)

		-- RunFarCoverGoOn
		AI:CreateGoalPipe("AIS_PatrolRunFarCoverGoOn")
		AI:PushGoal("AIS_PatrolRunFarCoverGoOn","do_it_running")
		AI:PushGoal("AIS_PatrolRunFarCoverGoOn","hide",1,15,HM_FARTHEST_FROM_TARGET)
		AI:PushGoal("AIS_PatrolRunFarCoverGoOn","signal",0,1,"AISF_GoOn",0)

		-- RunNearCover GoOn
		AI:CreateGoalPipe("AIS_PatrolRunNearCoverGoOn")
		AI:PushGoal("AIS_PatrolRunNearCoverGoOn","setup_stand")
		AI:PushGoal("AIS_PatrolRunNearCoverGoOn","do_it_running")
		AI:PushGoal("AIS_PatrolRunNearCoverGoOn","hide",1,15,HM_NEAREST)
		AI:PushGoal("AIS_PatrolRunNearCoverGoOn","signal",0,1,"AISF_GoOn",0)
		------------------------------------------------------------------
		---------------------------- Side Step ---------------------------
		AI:CreateGoalPipe("AIS_SideStepLeft")
		AI:PushGoal("AIS_SideStepLeft","do_it_running")
		AI:PushGoal("AIS_SideStepLeft","bodypos",1,0)
		AI:PushGoal("AIS_SideStepLeft","strafe",1,-1)
		AI:PushGoal("AIS_SideStepLeft","timeout",1,.5)
		AI:PushGoal("AIS_SideStepLeft","strafe",1,0)
		AI:PushGoal("AIS_SideStepLeft","signal",0,1,"AISF_GoOn",0)

		AI:CreateGoalPipe("AIS_SideStepRight")
		AI:PushGoal("AIS_SideStepRight","do_it_running")
		AI:PushGoal("AIS_SideStepRight","bodypos",1,0)
		AI:PushGoal("AIS_SideStepRight","strafe",1,1)
		AI:PushGoal("AIS_SideStepRight","timeout",1,.5)
		AI:PushGoal("AIS_SideStepRight","strafe",1,0)
		AI:PushGoal("AIS_SideStepRight","signal",0,1,"AISF_GoOn",0)
		------------------------------------------------------------------
		--------------------------- Side Strafe --------------------------
		AI:CreateGoalPipe("StrafeLeftDelay")
		AI:PushGoal("StrafeLeftDelay","bodypos",1,0)
		AI:PushGoal("StrafeLeftDelay","strafe",1,-1)
		AI:PushGoal("StrafeLeftDelay","timeout",1,.2,.8)
		AI:PushGoal("StrafeLeftDelay","strafe",1,0)


		AI:CreateGoalPipe("StrafeRightDelay")
		AI:PushGoal("StrafeRightDelay","bodypos",1,0)
		AI:PushGoal("StrafeRightDelay","strafe",1,1)
		AI:PushGoal("StrafeRightDelay","timeout",1,.2,.8)
		AI:PushGoal("StrafeRightDelay","strafe",1,0)

		------------------------------------------------------------------
		---------------------------- Side Roll ---------------------------
		AI:CreateGoalPipe("RollFromRight")
		AI:PushGoal("RollFromRight","not_shoot")
		AI:PushGoal("RollFromRight","strafe",0,1)
		AI:PushGoal("RollFromRight","signal",0,1,"PlayRollLeftAnim",0)
		AI:PushGoal("RollFromRight","timeout",1,.5)
		AI:PushGoal("RollFromRight","strafe",0,0)
		AI:PushGoal("RollFromRight","setup_crouch")
		AI:PushGoal("RollFromRight","just_shoot")

		AI:CreateGoalPipe("RollFromLeft")
		AI:PushGoal("RollFromLeft","not_shoot")
		AI:PushGoal("RollFromLeft","strafe",0,-1)
		AI:PushGoal("RollFromLeft","signal",0,1,"PlayRollRightAnim",0)
		AI:PushGoal("RollFromLeft","timeout",1,.5)
		AI:PushGoal("RollFromLeft","strafe",0,0)
		AI:PushGoal("RollFromLeft","setup_crouch")
		AI:PushGoal("RollFromLeft","just_shoot")

		------------------------------------------------------------------
		---------------------------- Attack ---------------------------
		AI:CreateGoalPipe("AIS_Fight")
		AI:PushGoal("AIS_Fight","just_shoot")
		AI:PushGoal("AIS_Fight","bodypos",1,0)
		AI:PushGoal("AIS_Fight","strafe",1,0)
		AI:PushGoal("AIS_Fight","signal",0,1,"AISF_GoOn",0)
		------------------------------------------------------------------
		AI:CreateGoalPipe("CoverFight")
		AI:PushGoal("CoverFight","just_shoot")
		AI:PushGoal("CoverFight","setup_stand")
		-- AI:PushGoal("CoverFight","timeout",1,1,2)
		AI:PushGoal("CoverFight","hide",1,10,HM_NEAREST)

		-- acquire shootspot
		AI:CreateGoalPipe("AcqShootAnchor")
		AI:PushGoal("AcqShootAnchor","timeout",1,.2,.5)
		AI:PushGoal("AcqShootAnchor","pathfind",1,"")
		AI:PushGoal("AcqShootAnchor","trace",1,0)

		AI:CreateGoalPipe("TraceToPlayer")
		AI:PushGoal("TraceToPlayer","locate",1,"atttarget")
		AI:PushGoal("TraceToPlayer","just_shoot")
		AI:PushGoal("TraceToPlayer","setup_stand")
		AI:PushGoal("TraceToPlayer","pathfind",1,"")
		-- AI:PushGoal("TraceToPlayer","timeout",1,.3,.6)
		AI:PushGoal("TraceToPlayer","trace",1,0,1)
		AI:PushGoal("TraceToPlayer","timeout",1,.3,.6)
		AI:PushGoal("TraceToPlayer","cover_scramble")
		---------------------
		--
		--  COVER
		--
		---------------------

		-- interesting sound heard
		-- attentive -----------------------
		AI:CreateGoalPipe("cover_attentive")
		AI:PushGoal("cover_attentive","setup_stand")
		AI:PushGoal("cover_attentive","timeout",0,10,15) -- start branch
		AI:PushGoal("cover_attentive","lookat",1,-45,45)
		AI:PushGoal("cover_attentive","timeout",1,3,4)
		AI:PushGoal("cover_attentive","branch",1,-2)	-- end branch
		AI:PushGoal("cover_attentive","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("cover_attentive","signal",0,1,"GoOn",0) -- start proper action there

		-- investigate -----------------------
		AI:CreateGoalPipe("cover_investigate")
		AI:PushGoal("cover_investigate","do_it_walking")
		AI:PushGoal("cover_investigate","bodypos",1,1)
		AI:PushGoal("cover_investigate","bodypos",1,0)
		AI:PushGoal("cover_investigate","timeout",1,1,1.5)
		AI:PushGoal("cover_investigate","approach",1,.5)
		AI:PushGoal("cover_investigate","timeout",1,2,3)
		AI:PushGoal("cover_investigate","signal",0,1,"Cease",0)

		-- cease -------------------------------------
		AI:CreateGoalPipe("cover_cease_investigation")
		AI:PushGoal("cover_cease_investigation","devalue",0)
		AI:PushGoal("cover_cease_investigation","timeout",0,8,12) -- start branch
		AI:PushGoal("cover_cease_investigation","signal",0,1,"Soundheard",0) -- play animation
		AI:PushGoal("cover_cease_investigation","timeout",1,2,3)
		AI:PushGoal("cover_cease_investigation","lookat",1,-60,60)
		AI:PushGoal("cover_cease_investigation","timeout",1,2,2.5)
		AI:PushGoal("cover_cease_investigation","branch",1,-4)	-- end branch
		AI:PushGoal("cover_cease_investigation","signal",0,1,"confused_animation",0) -- play animation
		AI:PushGoal("cover_cease_investigation","timeout",1,3,4)
		AI:PushGoal("cover_cease_investigation","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("cover_cease_investigation","signal",0,1,"GoOn",0)  -- start proper action there



		-- threatened ----------------------------
		AI:CreateGoalPipe("cover_approach_threat")
		AI:PushGoal("cover_approach_threat","bodypos",1,0)
		AI:PushGoal("cover_approach_threat","do_it_running")
		AI:PushGoal("cover_approach_threat","hide",1,10,HM_NEAREST)
	--	AI:PushGoal("cover_approach_threat","bodypos",1,1)
		AI:PushGoal("cover_approach_threat","timeout",1,.5,1)
		AI:PushGoal("cover_approach_threat","do_it_walking")
		AI:PushGoal("cover_approach_threat","bodypos",1,5)
		AI:PushGoal("cover_approach_threat","approach",1,.8)
		AI:PushGoal("cover_approach_threat","bodypos",1,0)
		AI:PushGoal("cover_approach_threat","approach",1,.5)
		AI:PushGoal("cover_approach_threat","timeout",1,1)
		AI:PushGoal("cover_approach_threat","signal",0,1,"Cease",0)

		-- cease -------------------------------------
		AI:CreateGoalPipe("cover_cease_approach")
		AI:PushGoal("cover_cease_approach","devalue",0)
		AI:PushGoal("cover_cease_approach","timeout",0,8,10) -- start branch
		AI:PushGoal("cover_cease_approach","signal",0,1,"target_lost_animation",0) -- play animation
		AI:PushGoal("cover_cease_approach","timeout",1,2,3)
		AI:PushGoal("cover_cease_approach","lookat",1,-60,60)
		AI:PushGoal("cover_cease_approach","timeout",1,2,2.5)
		AI:PushGoal("cover_cease_approach","branch",1,-4)	-- end branch
		AI:PushGoal("cover_cease_approach","timeout",1,1)
		AI:PushGoal("cover_cease_approach","signal",0,1,"confused_animation",0) -- play animation
		AI:PushGoal("cover_cease_approach","timeout",1,2,3)
		AI:PushGoal("cover_cease_approach","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("cover_cease_approach","signal",0,1,"GoOn",0)  -- start proper action there


		-- go for cover
		AI:CreateGoalPipe("cover_goforcover")
		AI:PushGoal("cover_goforcover","locate",0,"beacon")
		AI:PushGoal("cover_goforcover","acqtarget",0,"")
		AI:PushGoal("cover_goforcover","bodypos",1,0)
		AI:PushGoal("cover_goforcover","do_it_running")
		AI:PushGoal("cover_goforcover","hide",1,10,HM_NEAREST)
		AI:PushGoal("cover_goforcover","devalue",0)
		AI:PushGoal("cover_goforcover","timeout",1,.25,.5)
		AI:PushGoal("cover_goforcover","lookat",1,180)
		AI:PushGoal("cover_goforcover","timeout",1,1,1.5)
		AI:PushGoal("cover_goforcover","locate",0,"beacon")
		AI:PushGoal("cover_goforcover","acqtarget",0,"")
		AI:PushGoal("cover_goforcover","cover_approach_threat")


		---------------------
		--
		--  REAR
		--
		---------------------

		-- interesting sound heard
		-- attentive -----------------------
		AI:CreateGoalPipe("rear_attentive")
		AI:PushGoal("rear_attentive","setup_stand")
		AI:PushGoal("rear_attentive","timeout",0,15,20) -- start branch
		AI:PushGoal("rear_attentive","lookat",1,-75,75)
		AI:PushGoal("rear_attentive","timeout",1,3,4)
		AI:PushGoal("rear_attentive","branch",1,-2)	-- end branch
		AI:PushGoal("rear_attentive","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_attentive","signal",0,1,"GoOn",0) -- start proper action there

		-- investigate -----------------------
		AI:CreateGoalPipe("rear_investigate")
		AI:PushGoal("rear_investigate","do_it_walking")
		AI:PushGoal("rear_investigate","bodypos",1,5)
		AI:PushGoal("rear_investigate","timeout",1,.5,.75)
		AI:PushGoal("rear_investigate","approach",1,.75)
		AI:PushGoal("rear_investigate","timeout",1,.2,.3)
		AI:PushGoal("rear_investigate","lookat",1,35,55)
		AI:PushGoal("rear_investigate","timeout",1,.2,.3)
		AI:PushGoal("rear_investigate","lookat",1,-35,-55)
		AI:PushGoal("rear_investigate","timeout",1,2,3)
		AI:PushGoal("rear_investigate","signal",0,1,"Cease",0)

 		-- cease -------------------------------------
		AI:CreateGoalPipe("rear_cease_investigation")
		AI:PushGoal("rear_cease_investigation","devalue",0)
		AI:PushGoal("rear_cease_investigation","timeout",0,8,12) -- start branch
		AI:PushGoal("rear_cease_investigation","signal",0,1,"target_lost_animation",0) -- play animation
		AI:PushGoal("rear_cease_investigation","timeout",1,2.5,3)
		AI:PushGoal("rear_cease_investigation","lookat",1,-55,55)
		AI:PushGoal("rear_cease_investigation","timeout",1,3)
		AI:PushGoal("rear_cease_investigation","branch",1,-4)	-- end branch
		AI:PushGoal("rear_cease_investigation","bodypos",1,0)
		AI:PushGoal("rear_cease_investigation","timeout",1,1,2)
		AI:PushGoal("rear_cease_investigation","signal",0,1,"confused_animation",0) -- play animation
		AI:PushGoal("rear_cease_investigation","timeout",1,2,3)
		AI:PushGoal("rear_cease_investigation","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_cease_investigation","signal",0,1,"GoOn",0)  -- start proper action there

		-- threatening sound heard
		-- disturbed -----------------------
		AI:CreateGoalPipe("rear_disturbed")
		AI:PushGoal("rear_disturbed","setup_stealth")
		AI:PushGoal("rear_disturbed","timeout",0,15,20) -- start branch
		AI:PushGoal("rear_disturbed","lookat",1,-120,120)
		AI:PushGoal("rear_disturbed","timeout",1,.5,1)
		AI:PushGoal("rear_disturbed","branch",1,-2) -- end branch
		AI:PushGoal("rear_disturbed","timeout",1,4,6)
		AI:PushGoal("rear_disturbed","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_disturbed","signal",0,1,"GoOn",0)  -- start proper action there

		-- threatened ----------------------------
		AI:CreateGoalPipe("rear_approach_threat")
		AI:PushGoal("rear_approach_threat","bodypos",1,0)
		AI:PushGoal("rear_approach_threat","do_it_running")
		AI:PushGoal("rear_approach_threat","hide",1,10,HM_NEAREST_TO_TARGET)
		AI:PushGoal("rear_approach_threat","timeout",1,.5,1)
		AI:PushGoal("rear_approach_threat","do_it_walking")
		AI:PushGoal("rear_approach_threat","approach",1,.8)
		AI:PushGoal("rear_approach_threat","bodypos",1,5)
		AI:PushGoal("rear_approach_threat","approach",1,.8)
		AI:PushGoal("rear_approach_threat","timeout",1,1)
		AI:PushGoal("rear_approach_threat","signal",0,1,"Cease",0)

		-- cease --------------------------------
		AI:CreateGoalPipe("rear_cease_approach")
		AI:PushGoal("rear_cease_approach","devalue",0)
		AI:PushGoal("rear_cease_approach","timeout",0,8,12)  -- start branch
		AI:PushGoal("rear_cease_approach","signal",0,1,"target_lost_animation",0) -- play animation
		AI:PushGoal("rear_cease_approach","timeout",1,3,3.5)
		AI:PushGoal("rear_cease_approach","lookat",1,-65,65)
		AI:PushGoal("rear_cease_approach","timeout",1,3)
		AI:PushGoal("rear_cease_approach","branch",1,-4) -- end branch
		AI:PushGoal("rear_cease_approach","bodypos",1,0)
		AI:PushGoal("rear_cease_approach","timeout",1,1,2)
		AI:PushGoal("rear_cease_approach","signal",0,1,"confused_animation",0) -- play animation
		AI:PushGoal("rear_cease_approach","timeout",1,2,3)
		AI:PushGoal("rear_cease_approach","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_cease_approach","signal",0,1,"GoOn",0) -- start proper action there




		-- got shoot from,no clue who -----------------
		AI:CreateGoalPipe("rear_lookaround_threatened")
		AI:PushGoal("rear_lookaround_threatened","bodypos",1,1)
		AI:PushGoal("rear_lookaround_threatened","timeout",0,10,15)  -- start branch
		AI:PushGoal("rear_lookaround_threatened","LookForThreat")
		AI:PushGoal("rear_lookaround_threatened","branch",1,-1)  -- end branch
		AI:PushGoal("rear_lookaround_threatened","setup_stand")
		AI:PushGoal("rear_lookaround_threatened","timeout",1,2,3)
		AI:PushGoal("rear_lookaround_threatened","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_lookaround_threatened","signal",0,1,"GoOn",0) -- start proper action there

		-- prone,because there is not cover and you got shot
		AI:CreateGoalPipe("rear_nocover_prone")
		AI:PushGoal("rear_nocover_prone","signal",0,1,"PlayGetDownAnim",0)
		AI:PushGoal("rear_nocover_prone","timeout",1,2)
		AI:PushGoal("rear_nocover_prone","bodypos",1,2)
		AI:PushGoal("rear_nocover_prone","devalue",0)
		AI:PushGoal("rear_nocover_prone","timeout",0,13,17)  -- start branch
		AI:PushGoal("rear_nocover_prone","timeout",1,3,6)
		AI:PushGoal("rear_nocover_prone","lookat",1,50,-50)
		AI:PushGoal("rear_nocover_prone","branch",1,-2) -- end branch
		AI:PushGoal("rear_nocover_prone","timeout",1,2,3)
		AI:PushGoal("rear_nocover_prone","signal",0,1,"PlayGetUpAnim",0)
		AI:PushGoal("rear_nocover_prone","timeout",1,2)
		AI:PushGoal("rear_nocover_prone","bodypos",1,0)
		AI:PushGoal("rear_nocover_prone","timeout",0,7,12)  -- start branch
		AI:PushGoal("rear_nocover_prone","timeout",1,2,5)
		AI:PushGoal("rear_nocover_prone","lookat",1,35,-35)
		AI:PushGoal("rear_nocover_prone","branch",1,-2) -- end branch
		AI:PushGoal("rear_nocover_prone","timeout",1,3,4)
		AI:PushGoal("rear_nocover_prone","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_nocover_prone","signal",0,1,"GoOn",0) -- start proper action there

		-- received damage or bullet rain
		AI:CreateGoalPipe("rear_crouchlook")
		AI:PushGoal("rear_crouchlook","bodypos",1,1)
		AI:PushGoal("rear_crouchlook","devalue",0)
		AI:PushGoal("rear_crouchlook","timeout",0,7,10)  -- start branch
		AI:PushGoal("rear_crouchlook","lookat",1,50,-50)
		AI:PushGoal("rear_crouchlook","timeout",1,2,4)
		AI:PushGoal("rear_crouchlook","branch",1,-2) -- end branch
		AI:PushGoal("rear_crouchlook","bodypos",1,0)
		AI:PushGoal("rear_crouchlook","timeout",0,7,10)  -- start branch
		AI:PushGoal("rear_crouchlook","timeout",1,3,6)
		AI:PushGoal("rear_crouchlook","lookat",1,50,-50)
		AI:PushGoal("rear_crouchlook","branch",1,-2) -- end branch
		AI:PushGoal("rear_crouchlook","signal",0,1,"back_to",0) -- change behaviour back to idle
		AI:PushGoal("rear_crouchlook","signal",0,1,"GoOn",0) -- start proper action there

		-- go for cover
		AI:CreateGoalPipe("rear_goforcover")
		AI:PushGoal("rear_goforcover","locate",0,"beacon")
		AI:PushGoal("rear_goforcover","acqtarget",0,"")
		AI:PushGoal("rear_goforcover","bodypos",1,0)
		AI:PushGoal("rear_goforcover","do_it_running")
		AI:PushGoal("rear_goforcover","hide",1,10,HM_NEAREST)
		AI:PushGoal("rear_goforcover","devalue",0)
		AI:PushGoal("rear_goforcover","bodypos",1,1)
		AI:PushGoal("rear_goforcover","timeout",1,.25,.5)
		AI:PushGoal("rear_goforcover","timeout",0,10,12) -- start branch
		AI:PushGoal("rear_goforcover","lookat",1,50,-50)
		AI:PushGoal("rear_goforcover","timeout",1,1,1.5)
		AI:PushGoal("rear_goforcover","branch",1,-2) -- end branch
		AI:PushGoal("rear_goforcover","locate",0,"beacon")
		AI:PushGoal("rear_goforcover","acqtarget",0,"")
		AI:PushGoal("rear_goforcover","rear_approach_threat")

		-- heads up,and go -------------
		AI:CreateGoalPipe("rear_headup")
		AI:PushGoal("rear_headup","locate",0,"beacon")
		AI:PushGoal("rear_headup","acqtarget",0,"")
		AI:PushGoal("rear_headup","bodypos",1,0)
		AI:PushGoal("rear_headup","do_it_running")
		AI:PushGoal("rear_headup","hide",1,10,HM_NEAREST_TO_TARGET)
		AI:PushGoal("rear_headup","timeout",1,1,1.5)
		AI:PushGoal("rear_headup","approach",1,.9)


		-- Attack Modes
		-- comeout
		AI:CreateGoalPipe("rear_comeout2")
		AI:PushGoal("rear_comeout2","setup_crouch")
		AI:PushGoal("rear_comeout2","just_shoot")
		AI:PushGoal("rear_comeout2","approach",1,.9)
		AI:PushGoal("rear_comeout2","timeout",1,2,4)
		AI:PushGoal("rear_comeout2","signal",0,1,"REAR_SELECTATTACK",0)

		-- left cover
		AI:CreateGoalPipe("rear_takeleftcover")
		AI:PushGoal("rear_takeleftcover","bodypos",1,0)
		AI:PushGoal("rear_takeleftcover","do_it_running")
		AI:PushGoal("rear_takeleftcover","hide",1,10,HM_LEFTMOST_FROM_TARGET)
		AI:PushGoal("rear_takeleftcover","approach",1,.9)
		AI:PushGoal("rear_takeleftcover","just_shoot")
		AI:PushGoal("rear_takeleftcover","timeout",1,.7,1.3)
		AI:PushGoal("rear_takeleftcover","signal",0,1,"REAR_SELECTATTACK",0)

		-- right cover
		AI:CreateGoalPipe("rear_takerightcover")
		AI:PushGoal("rear_takerightcover","bodypos",1,0)
		AI:PushGoal("rear_takerightcover","do_it_running")
		AI:PushGoal("rear_takerightcover","hide",1,10,HM_RIGHTMOST_FROM_TARGET)
		AI:PushGoal("rear_takerightcover","approach",1,.9)
		AI:PushGoal("rear_takerightcover","just_shoot")
		AI:PushGoal("rear_takerightcover","timeout",1,.7,1.3)
		AI:PushGoal("rear_takerightcover","signal",0,1,"REAR_SELECTATTACK",0)
end