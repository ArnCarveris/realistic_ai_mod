Script:LoadScript("scripts/materials/PhysicsSounds.lua")

CommonEffects =
{
	player_walk_inwater = {
		sounds = {
			{"sounds/player/footsteps/water/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/water/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/water/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/water/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_metal_walk = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_metal_run = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_metal_crouch = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_metal_prone = {
		sounds = {
			{"sounds/player/footsteps/metal/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	player_metalgrate_walk = {
		sounds = {
			{"sounds/player/footsteps/metal/grate/step1.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/grate/step2.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/grate/step3.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/metal/grate/step4.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_metalgrate_run = {
		sounds = {
			{"sounds/player/footsteps/metal/grate/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/grate/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/grate/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/metal/grate/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_metalgrate_crouch = {
		sounds = {
			{"sounds/player/footsteps/metal/grate/step1.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/grate/step2.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/grate/step3.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/metal/grate/step4.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_metalgrate_prone = {
		sounds = {
			{"sounds/player/footsteps/metal/grate/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/grate/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/grate/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/metal/grate/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	player_wood_walk = {
		sounds = {
			{"sounds/player/footsteps/wood/step1.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/wood/step2.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/wood/step3.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/wood/step4.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_wood_run = {
		sounds = {
			{"sounds/player/footsteps/wood/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/wood/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/wood/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/wood/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_wood_crouch = {
		sounds = {
			{"sounds/player/footsteps/wood/step1.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/wood/step2.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/wood/step3.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/wood/step4.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_wood_prone = {
		sounds = {
			{"sounds/player/footsteps/wood/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/wood/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/wood/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/wood/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	player_conc_walk = {
		sounds = {
			{"sounds/player/footsteps/rock/walk1a.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/rock/walk2a.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/rock/walk3a.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/rock/walk4a.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_conc_run = {
		sounds = {
			{"sounds/player/footsteps/rock/walk1a.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/rock/walk2a.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/rock/walk3a.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/rock/walk4a.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_conc_crouch = {
		sounds = {
			{"sounds/player/footsteps/rock/walk1a.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/rock/walk2a.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/rock/walk3a.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/rock/walk4a.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_conc_prone = {
		sounds = {
			{"sounds/player/footsteps/rock/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/rock/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/rock/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/rock/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	player_grass_walk = {
		sounds = {
			{"sounds/player/footsteps/grass_dry/step1.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/grass_dry/step2.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/grass_dry/step3.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/grass_dry/step4.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_grass_run = {
		sounds = {
			{"sounds/player/footsteps/grass_dry/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/grass_dry/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/grass_dry/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/grass_dry/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_grass_crouch = {
		sounds = {
			{"sounds/player/footsteps/grass_dry/step1.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/grass_dry/step2.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/grass_dry/step3.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/grass_dry/step4.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_grass_prone = {
		sounds = {
			{"sounds/player/footsteps/grass_dry/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/grass_dry/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/grass_dry/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/grass_dry/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	player_pebble_walk = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,180,10,100},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,180,10,100},
		},
	},
	player_pebble_run = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,230,10,100},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,230,10,100},
		},
	},
	player_pebble_crouch = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,140,10,100},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,140,10,100},
		},
	},
	player_pebble_prone = {
		sounds = {
			{"sounds/player/footsteps/pebble/step1.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/pebble/step2.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/pebble/step3.wav",SOUND_UNSCALABLE,100,10,100},
			{"sounds/player/footsteps/pebble/step4.wav",SOUND_UNSCALABLE,100,10,100},
		},
	},
	common_bullet_hit_flesh_part = {
		particles = {
			{--Hitbloodonground
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
				focus = 1.5,
				start_color = {1,0,0},
				end_color = {1,0,0},
				speed = 0,
				count = 1,
				size = .25,
				size_speed=.015,
				gravity={x=0,y=0,z=-5},
				lifetime=10,
				tid = System:LoadTexture("Languages\\textures\\decal\\blood.dds"),
				frames=0,
				particle_type = 1,
				bouncyness = 0,
			},
			{--Hitbloodyshower
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
				bLinearSizeSpeed=1,
				focus = .5,
				start_color = {.5,0,0},
				end_color = {.5,0,0},
				speed = .75,
				count = 1,
				size = .025,
				size_speed=.75,
				gravity={x=0,y=0,z=-3},
				lifetime=.75,
				tid = System:LoadTexture("Languages\\textures\\decal\\blood.dds"),
				frames=0,
				bouncyness = 0,

			},
			{--blooddrops
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
				focus = 1,
				speed = 5,
				start_color = {.5,0,0},
				end_color = {.5,0,0},
				count = 3,
				size = .020,
				size_speed=0,
				gravity={x=0,y=0,z=-10},
				lifetime=.25,
				tail_length = .25,
				tid = System:LoadTexture("Languages\\textures\\decal\\blooddrop.dds"),
				frames=0,
				bouncyness = 0,
			},
		},
	},
	common_bullet_hit_wood_part = {
		particles = {
			{--HitChips
				focus = 2,
				speed = 3.5, --default 1.5
				count = 6, --default 2
				size = .05,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -3},
				rotation = {x = 0,y = 0,z = 20},
				lifetime=1.5,
				frames=1,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
			},
			{--HitChips1
				focus = 2,
				speed = 3.5, --default 1.5
				count = 6, --default 2
				size = .05,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -3},
				rotation = {x = 0,y = 0,z = 20},
				lifetime=1.5,
				frames=1,
				tid = System:LoadTexture("textures\\sprites\\chip1.dds"),
			},
			{--HitDirt
				focus = 1.5,
				color = {.29,.19,0},
				speed = .7,
				count = 10, --default 5
				size = .01,
				size_speed=.015,
				gravity={x=0,y=0,z=-2},
				lifetime=.3,
				tid = System:LoadTexture("textures\\dirt1.dds"),
				frames=0,
			},
			{--hitsmoke
 				focus = 0,
				start_color = {.89,.69,.4},
				end_color = {1,1,1},
				speed = .1,
				count = 6, --default 2
				size = .005,
				size_speed=.01,
				gravity = {x = 0,y = 0,z = .25},
				rotation = {x = 0,y = 0,z = 2},
				lifetime=1,
				tid = System:LoadTexture("textures/clouda1.dds"),
				frames=0,
				blend_type = 0,
			},
			{--HotSpot
				focus = 90,
				speed = 0,
				count = 1, --default 1
				size = .01,
				size_speed=.01,
				gravity={x=0,y=0,z=0},
				lifetime=.2,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				frames=0,
				blend_type = 2,
				draw_last = 1,
				},
		},
	},
	common_bullet_hit_particles = {
		particles = {

			{--HitMetalSparksTrail
			focus = 2,
			color = {1,1,1},
			speed = 6,
			count = 10, --default 5
			size = .025,
			size_speed=0,
			gravity={x=0,y=0,z=-1},
			lifetime=.15,
			tid = System:LoadTexture("Textures/Decal/Spark.dds"),
			tail_length = .4,
			frames=0,
			blend_type = 2
			},

			{--HitMetalHotSpot
			focus = 90,
			color = {1,1,1},
			speed = 0,
			count = 1, --default 2
			size = .05,
			size_speed=0,
			gravity={x=0,y=0,z=0},
			lifetime=.3,
			tid = System:LoadTexture("Textures/Decal/Spark.dds"),
			frames=0,
			blend_type = 2
			},
		},
	},
	common_machete_hit_particles = {
		particles = {
			{--HitMetalSparksTrail
				focus = 0,
				speed = 1,
				count = 5,
				size = .01,
				size_speed=0,
				gravity={x=0,y=0,z=-6},
				lifetime=.4,
				tid = System:LoadTexture("Textures/Decal/Spark.dds"),
				tail_length = .6,
				frames=0,
				blend_type = 2
			},
		},

	},
	common_machete_hit_flesh_part = {
		particles = {
			{--Hitbloodyshower
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
				bLinearSizeSpeed=1,
				focus = 1,
				start_color = {.5,0,0},
				end_color = {.5,0,0},
				speed = .75,
				count = 5,
				size = .01,
				size_speed=.5,
				gravity={x=0,y=0,z=-3},
				lifetime=.75,
				tid = System:LoadTexture("Languages\\textures\\decal\\blood.dds"),
				frames=0,
				bouncyness = 0,

			},
			{--blooddrops
			gore = 1,	-- to be able to switch off gore -- to know what's allowed
				focus = 1,
				speed = 5,
				start_color = {.5,0,0},
				end_color = {.5,0,0},
				count = 5,
				size = .015,
				size_speed=0,
				gravity={x=0,y=0,z=-15},
				lifetime=.25,
				tail_length = .25,
				tid = System:LoadTexture("Languages\\textures\\decal\\blooddrop.dds"),
				frames=0,
				bouncyness = 0,
			},
		},
	},
	common_machete_hit_wood_part = {
		particles = {
			{--HitChips
				focus = 0,
				speed = 2,
				count = 10,
				size = .035,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -2},
				rotation = {x = 0,y = 0,z = 20},
				lifetime=.3,
				frames=1,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
			},
			{--HitDirt
				focus = 1.5,
				color = {.29,.19,0},
				speed = .9,
				count = 3,
				size = .015,
				size_speed=.025,
				gravity={x=0,y=0,z=-2},
				lifetime=.5,
				tid = System:LoadTexture("textures\\dirt1.dds"),
				frames=0,
			},
			{--hitsmoke
 				focus = 0,
				start_color = {.89,.69,.4},
				end_color = {1,1,1},
				speed = .1,
				count = 2,
				size = .005,
				size_speed=.01,
				gravity = {x = 0,y = 0,z = .25},
				rotation = {x = 0,y = 0,z = 2},
				lifetime=1,
				tid = System:LoadTexture("textures/cloud1.dds"),
				frames=0,
				blend_type = 1,
			},

		},
	},
	common_machete_hit_canvas_part = {
		particles = {
			{--HitChips
				focus = 0,
				speed = 2,
				count = 5,
				size = .015,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -5},
				rotation = {x = 0,y = 0,z = 20},
				lifetime=.2,
				frames=1,
				tid = System:LoadTexture("textures\\sprites\\chip.dds"),
			},
			{--hitsmoke
 				focus = 0,
				start_color = {.89,.69,.4},
				end_color = {1,1,1},
				speed = .1,
				count = 2,
				size = .05,
				size_speed=.125,
				gravity = {x = 0,y = 0,z = .25},
				rotation = {x = 0,y = 0,z = .5},
				lifetime=1,
				tid = System:LoadTexture("textures/cloud2.dds"),
				frames=0,
				blend_type = 1,
			},

		},
	},
	common_bullet_drop_single_wood = {
		sounds = {
			{"sounds/bullets/casingwood1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwood2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwood3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwood4.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwood5.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwood6.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_drop_rapid_wood = {
		sounds = {
			{"sounds/bullets/casingwoodmulti1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwoodmulti2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwoodmulti3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingwoodmulti4.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_drop_single_ashphalt = {
		sounds = {
			{"sounds/bullets/casingashphalt1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingashphalt2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingashphalt3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingashphalt4.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingashphalt5.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_drop_rapid_ashphalt = {
		sounds = {
			{"sounds/bullets/casingasphaltmulti1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingasphaltmulti2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingasphaltmulti3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingasphaltmulti4.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_drop_single_metal = {
		sounds = {
			{"sounds/bullets/casingmetal1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetal2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetal3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetal4.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetal5.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetal6.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_drop_rapid_metal = {
		sounds = {
			{"sounds/bullets/casingmetalmulti1.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetalmulti2.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetalmulti3.wav",SOUND_UNSCALABLE,175,1,20},
			{"sounds/bullets/casingmetalmulti4.wav",SOUND_UNSCALABLE,175,1,20},
		},
	},
	common_bullet_hit =
	{
		particles =
		{
			{--Hit
				focus = 0,
				color = {.29,.19,0},
				speed = 0,
				count = 1,
				size = .25,
				size_speed=.3,
				gravity=-1,
				lifetime=.6,
				tid = System:LoadTexture("textures/grhit2.dds"),
				frames=0,
				color_based_blending = 3
			},
			{--hitsmoke
 				focus = 10,
				color = {.29,.19,0},
				speed = .15,
				count = 4,
				size = .01,
				size_speed=.01,
				gravity=0,
				lifetime=1.25,
				tid = System:LoadTexture("textures/cloud1.dds"),
				frames=0,
				color_based_blending = 3
			},
			{--particles
				focus = 2,
				color = {.29,.19,0},
				speed = 5,
				count = 3,
				size = .02,
				size_speed=0,
				gravity = {x = 0,y = 0,z = -5},
				lifetime=.3,
				tid =System:LoadTexture("textures/Animated/stone/sta0000.dds"),
				frames=1,
				color_based_blending = 1
			},
		},
	},

	-- common_mg_hit = {-- Эффект для пуль от стационарного пулемёта.
		-- -- particleEffects = {
			-- -- name = "ai_mod_particles.mg_bullet.a",
			-- -- scale = 1,
		-- -- },
	-- },

	-- primary explosion from rocket
	common_projectile_hit = {
		particleEffects = {
			name = "explosions.rocket.a",
			scale = 1,
		},
		sounds = {
			{"Sounds/BulletHits/AT_Rockets/at_rocket_01.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_02.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_03.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_04.mp3",SOUND_UNSCALABLE,255,30,1000},
			{"Sounds/BulletHits/AT_Rockets/at_rocket_05.mp3",SOUND_UNSCALABLE,255,30,1000},
		},
	},


-- secondary explosion from rocket
--
--	common_projectile_hit2 =
--		{
--	        particles =
--			{
--
--				{--ExplosionRocksBig
--				focus = 5,
--				color = {1,1,1},
--				speed = 25, -- default 20
--				count = 15, -- default 20
--				size = .2,size_speed = 0,
--				gravity = {x = 0,y = 0,z = -20},-- default z = 20
--				lifetime = 4, -- default 4
--				frames = 32,
--				color_based_blending = 0,
--				tid = System:LoadAnimatedTexture("textures/animated/stone/sta%04d.tga",16),
--		    		ChildSpawnPeriod = .03,
--		    		ChildProcess =
--					{-- smoking rocks
--				  	focus = 90,
--					start_color = {.3,.3,.3},
--					end_color = {1,1,1},
--				 	speed = 1, -- default 1
--					count = 1, -- default 1
--					size = .15,size_speed = .4,
--					lifetime = .6, -- default .6
--					frames = 1,
--					blend_type = 0,
--					tid = System:LoadTexture("textures/clouda.dds"),
--			  		}
--				},
--				{--ExplosionRocksSmall
--				focus = 5,
--				color = {1,1,1},
--				speed = 30, -- default 30
--				rotation = {x=0,y=0,z=20},
--				count = 75, -- default 75
--				size = .15,size_speed = 0,
--				gravity = {x = 0,y = 0,z = -37},-- z = 37
--				lifetime = 4.25, -- default 2.25
--				color_based_blending = 0,
--				frames = 1,
--				tid = System:LoadTexture("textures/animated/stone/sta0000.tga"),
--				},
--				{--ExplosionLowerDirt
--				focus = 8, -- default 4
--				color = {1,1,1},
--				speed = 20, -- default 25
--				rotation = {x=0,y=0,z=1.5},
--				count = 80, -- default 40
--				size = .05,size_speed = 2,
--				gravity = {x = 0,y = 0,z = -22},-- default z = 22
--				lifetime = 1.8, -- default 1.8
--				color_based_blending = 1,
--				frames = 1,
--				tid = System:LoadTexture("textures/dirt1.dds"),
--				},
--			},
--
--		},




	common_grenade_hit = {
		-- sounds = {
			-- {"SOUNDS/items/grenade_hit.wav",SOUND_UNSCALABLE,255,2,100},
		-- },
		sounds = {
			{"Sounds/BulletHits/HandGrenade/dirt1.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt2.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt3.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt4.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt5.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt6.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt7.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt8.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt9.mp3",SOUND_UNSCALABLE,255,2,100},
			{"Sounds/BulletHits/HandGrenade/dirt10.mp3",SOUND_UNSCALABLE,255,2,100},
		},
	},



	common_mortar_hit =
		{
	        particles =
			{
				{--ExplosionRocksBig
				focus = 2,
				color = {1,1,1},
				speed = 12,
				count = 5,
				size = .2,size_speed = 0,
				gravity = {x = 0,y = 0,z = -20},
				lifetime = 1.5,
				frames = 32,
				color_based_blending = 0,
				tid = System:LoadAnimatedTexture("textures/animated/stone/sta%04d.tga",16),
		    		ChildSpawnPeriod = .03,
		    		ChildProcess =
					{
				  	focus = 90,
					start_color = {.3,.3,.3},
					end_color = {1,1,1},
				 	speed = 1,
					count = 1,
					size = .15,size_speed = .4,
					lifetime = .6,
					frames = 1,
					blend_type = 0,
					tid = System:LoadTexture("textures/clouda.dds"),
			  		}
				},
				{--ExplosionRocksSmall
				focus = 5,
				color = {1,1,1},
				speed = 20,
				rotation = {x=0,y=0,z=20},
				count = 50,
				size = .15,size_speed = 0,
				gravity = {x = 0,y = 0,z = -27},
				lifetime = 2.25,
				color_based_blending = 0,
				frames = 1,
				tid = System:LoadTexture("textures/animated/stone/sta0000.tga"),
				},
	 			{--ExplosionRocksSmallTrails
				focus = 5,
				color = {1,1,1},
				speed = 20,
				rotation = {x=0,y=0,z=20},
				count = 5,
				size = .15,size_speed = 0,
				gravity = {x = 0,y = 0,z = -27},
				lifetime = 1,
				color_based_blending = 0,
				frames = 1,
				tid = System:LoadTexture("textures/animated/stone/sta0000.tga"),
				ChildSpawnPeriod = .02,
    				ChildProcess =
					{
				  	focus = 40,
					start_color = {.3,.3,.3},
					end_color = {1,1,1},
					rotation = {x=0,y=0,z=20},
				 	speed = 0,
					count = 1,
					size = .25,size_speed = .2,
					lifetime = .6,
					frames = 1,
					blend_type = 0,
					tid = System:LoadTexture("textures/clouda.dds"),
			  		}
				},
	 			{--ExplosionDirt
				focus = 8,
				color = {1,1,1},
				speed = 17,
				rotation = {x=0,y=0,z=1.5},
				count = 20,
				size = .05,size_speed = 2,
				gravity = {x = 0,y = 0,z = -22},
				lifetime = 1.8,
				color_based_blending = 1,
				frames = 1,
				tid = System:LoadTexture("textures/dirt1.dds"),
				},
			},

		},

	common_flashgrenade_hit = {
		sounds = {
			{"SOUNDS/items/smokecan_hit.wav",SOUND_UNSCALABLE,255,2,100},
		},
	},

	common_smokegrenade_hit = {
		sounds = {
			{"SOUNDS/items/smokecan_hit.wav",SOUND_UNSCALABLE,255,2,100},
		},
	},

-----------------------------------------
------------------------------------------WATER--------------------------------------------------------
-----------------------------------------
	water_projectile_hit = {
		sounds = {
			{"Sounds/Weapons/grenade/splash1.wav",0,175,20,10000},
			{"Sounds/BulletHits/Water/water_exlpo_big_01.mp3",0,175,20,10000},
		},
		particleEffects = {
			name = "water.water_splash.a",
		},
	},

	AI = {
		fImpactRadius = 30,
	},

	water_splash = {
		sounds = {
			{"Sounds/player/water/bodysplash.wav",SOUND_UNSCALABLE,200,5,200},
		},
		particleEffects = {
			name = "water.water_splash.a",
			scale = .3,
		},
	},

	--vehicle common effects,water is already handled by code.

	--particles
	common_vehicle_particles_rocks = "smoke.vehicle_rocks.a",
	common_vehicle_particles_grass = "smoke.vehicle_rocks.b",

	--smokes
	common_vehicle_smoke_mud = "smoke.vehicle_dust.a",
	common_vehicle_smoke_concrete = "smoke.vehicle_dust.b",
	--common_vehicle_smoke_grass = "smoke.vehicle_dust.c",
}