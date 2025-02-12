EngineerTool = {
	name			= "EngineerTool",
	object		= "Objects/Weapons/wrench/wrench_bind.cgf",
	character	= "Objects/Weapons/wrench/wrench.cgf",
	
	-- factor to slow down the player when he holds that weapon
	PlayerSlowDown = 1,	
	---------------------------------------------------
	NoZoom=1,
	---------------------------------------------------
	-- describes all supported firemodes
	FireParams ={													
	{
		type = 4,					-- used for choosing animation - is pistol 
		FireSounds = {
			"Sounds/items/silence.wav",
			--"Sounds/items/ratchet.wav",		-- todo
		},
		SoundMinMaxVol = {100,1,20},
	},
--SINGLE SHOT--------------------------------
	{
		type = 3,			-- used for choosing animation - is a melee weapon 	
		AmmoType="Unlimited",
		reload_time=.01,
		fire_rate=.3,
		distance=1.4,
		damage=20,
		bullet_per_shot=1,
		bullets_per_clip=20,
		FModeActivationTime = 2,
		iImpactForceMul = 80,
		iImpactForceMulFinal = 80,
		fire_activation=bor(FireActivation_OnPress),
		FireSounds = {
			"Sounds/Weapons/machete/fire1.wav",
			"Sounds/Weapons/machete/fire2.wav",
			"Sounds/Weapons/machete/fire3.wav",
		},
		
		no_ammo=1,
		SoundMinMaxVol = {100,1,20},

	},
	},

--	SoundEvents={
		--	animname,	frame,	soundfile
--		{	"swim",		1,			Sound:LoadSound("Sounds/player/water/underwaterswim2.wav",0,255)},
--	},
}

CreateBasicWeapon(EngineerTool)

---------------------------------------------------------------
--ANIMTABLE
------------------
--SINGLE FIRE
EngineerTool.anim_table={}
EngineerTool.anim_table[1]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
	},
	fire={
		"construct",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}

--SINGLE SHOT
EngineerTool.anim_table[2]={
	idle={
		"Idle11",
		"Idle21",
	},
	fidget={
		"fidget11",
	},
	fire={
		"Fire11",
		"Fire21",
	},
	swim={
		"swim"
	},
	activate={
		"Activate1"
	},
}