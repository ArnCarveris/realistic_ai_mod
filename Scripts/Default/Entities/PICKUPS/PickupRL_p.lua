Script:ReloadScript("Scripts/Default/Entities/Pickups/PickupPhysCommon.lua")
	local phys_item = new(BasicEntity)
	----
	---- EDIT HERE: weapon_name   examples: weapon_P90 weapon_M4 etc...
	phys_item.Properties.Animation.Animation = "weapon_RL" 
	phys_item.Properties.Animation.fAmmo_Primary = 4 
	phys_item.Properties.Animation.sAmmotype_Primary="Rocket" 
	phys_item.Properties.Animation.fAmmo_Secondary = 0 
	phys_item.Properties.Animation.sAmmotype_Secondary="" 
	phys_item.pp_sound = "Sounds/Weapons/Mortar/mortar_33.wav" 
	----
	----
	phys_item.Properties.object_Model = "Objects/Weapons/RL/rl_bind.cgf" 
	phys_item.Properties.Physics.damping = .02 
	phys_item.Properties.Physics.Mass = 49 
	phys_item.Properties.Physics.Type = "smisc" 
	phys_item.Properties.Physics.bRigidBody=1 
	phys_item.Properties.Physics.LowSpec.bRigidBody=1 
	phys_item.Properties.Physics.LowSpec.Mass = 49 
	phys_item.physpickup = 1  -- used in basicplayer to indicate it is pickup

	phys_item.weapon="RL" 

	PickupRL_p = phys_item 

function PickupRL_p:OnSave(stm)
	-- store ammo amounts of clips
	stm:WriteInt(self.Properties.Animation.fAmmo_Primary)
	--stm:WriteInt(self.Properties.Animation.fAmmo_Secondary)
end

function PickupRL_p:OnLoad(stm)
	-- load ammo amounts of clips
	self.Properties.Animation.fAmmo_Primary=stm:ReadInt()
	--self.Properties.Animation.fAmmo_Secondary=stm:ReadInt()
end
