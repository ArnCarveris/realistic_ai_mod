--	exclusive areas
--	areas have to be nested - the next area copmlitly inside the parent
--	tha first (outside) area has to have AreaID 1
--	there might be up to 10 exclusive nested areas for one entity
SoundExclusivePreset = {
	type = "SoundExclusivePreset",

	Editor = {
		Model="Objects/Editor/S.cgf",
	},

	Properties = {
		bPlayFromCenter=0,
		sndpresetSoundPreset = "",
		fScale = 1,
		AreaId = 1,
	},

	fLastFadeCoeff = 0,
	MaxBox = 200,
	MinBox = 40,
	maxChance = 1000,
	
	
	InsideArray = 	{0,0,0,0,0,0,0,0,0,0},
	fadeCoeffArea = {0,0,0,0,0,0,0,0,0,0},
}

function SoundExclusivePreset:OnPropertyChange()

	self:LoadSounds()
end

---------------------------------------------------------

function SoundExclusivePreset:OnReset()
	self:NetPresent(nil)
end

function SoundExclusivePreset:CliSrv_OnInit()

	self.Sounds = {} 

	--System:Log("--> EX init ")		
	if (self.Initialized) then
		return
	end
	self:EnableUpdate(0)
	
	self:OnReset()
	self:RegisterState("Inactive")
	self:RegisterState("Active")
	self:GotoState("Inactive")
	self["Initialized"]=1 
end


function SoundExclusivePreset:OnSave(stm)
	WriteToStream(stm,self.Properties)
end

function SoundExclusivePreset:OnLoad(stm)
	self.Properties=ReadFromStream(stm)
end


---------------------------------------------------------
--
function SoundExclusivePreset:FlashSounds()
	self.Sounds={} 
	--System:Log("FlashSounds")
--	for i,Element in self.Properties do
--		if (type(Element)=="table") then
--			Element.Sound=nil 
--		end
--	end
end

---------------------------------------------------------
--
function SoundExclusivePreset:LoadSounds()
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset)
		return
	end
	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		self.Sounds[i] = {} 
		if (type(Element)=="table" and Element.Sound) then
			if (tonumber(Element.Chance)==self.maxChance) then
				Element.NoOverlap = "1" 
			end	
--			System:Log("doing Sound "..Element.sndSound)

				if (Element.Centered=="1") then
					if (Element.Sound~="") then
						self.Sounds[i].Sound = Sound:LoadSound(Element.Sound)
						if (self.Sounds[i].Sound) then
							--System:Log("Loading sound "..Element.Sound)
						end
					end
					if (self.Sounds[i].Sound) then
						if ((tonumber(Element.Chance)==self.maxChance) and ((not Element.Timeout) or (Element.Timeout=="0"))) then
							--play and stop to force loading
							Sound:PlaySound(self.Sounds[i].Sound)
							if (self.fLastFadeCoeff==0) then
								Sound:StopSound(self.Sounds[i].Sound)
							end
							Sound:SetSoundLoop(self.Sounds[i].Sound,1)
						else
							Sound:PlaySound(self.Sounds[i].Sound)
							Sound:StopSound(self.Sounds[i].Sound)
							Sound:SetSoundLoop(self.Sounds[i].Sound,0)	
						end	
--						Sound:PlaySound(Element.Sound)
					end	
				else
					if (Element.Sound~="") then
						self.Sounds[i] = {} 
						self.Sounds[i].Sound = Sound:Load3DSound(Element.Sound,SOUND_RADIUS)
						if (self.Sounds[i].Sound) then
							--System:Log("Loading 3d-sound "..Element.Sound)
						end
					end
				end
			
			if (self.Sounds[i] and self.Sounds[i].Sound) then
				Sound:SetSoundVolume(self.Sounds[i].Sound,tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale)
			end	
		end--if table
	end --for

end

---------------------------------------------------------
--


function SoundExclusivePreset:Client_Active_OnTimer()
	local Player = _localplayer 
	
	if (Player==nil) then
			return
	end

	local ListenerPosition = Player:GetPos()
	local SoundPos = new(ListenerPosition)
	
	local hostIdx=-1 
	local nextIdx=-1 
	
	for i,Element in self.InsideArray do
		if (Element==1) then
			nextIdx = hostIdx 
			hostIdx = i 
		end	
	end	

	if (hostIdx==-1) then
		return
	end

	self.fLastFadeCoeff = self.fadeCoeffArea[hostIdx] 
	
	local TimerDelta=1 
	
	--set the next iteration
	self:SetTimer(TimerDelta*1000)

	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset)
		return
	end

	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element)=="table") then
			if (self.Sounds[i] and self.Sounds[i].Sound) then
				local CurSnd = self.Sounds[i].Sound 
				if (tonumber(self.Properties.AreaId)==hostIdx) then
				--System.LogToConsole("FadeOff: "..self.fLastFadeCoeff)
					Sound:SetSoundVolume(CurSnd,tonumber(Element.Volume) * self.fadeCoeffArea[hostIdx] * self.Properties.fScale)
				elseif (tonumber(self.Properties.AreaId)==nextIdx) then
					Sound:SetSoundVolume(CurSnd,tonumber(Element.Volume) * (1-self.fadeCoeffArea[hostIdx]) * self.Properties.fScale)
				end	
			end
		end
	end
	
	--System:Log("OnTimer")
	--System:Log("__111")
	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		--System:Log("__222")
		if (type(Element)=="table") then
			--System:Log("__333")
			if (self.Sounds[i] and self.Sounds[i].Sound) then
				--System:Log("__444")
				if (tonumber(self.Properties.AreaId)==hostIdx) then
					--System:Log("__555")
					local bSkip = 0 
					if (Element.Centered~="0" and tonumber(Element.Chance)==self.maxChance) then
						bSkip = 1 
					elseif (Element.NoOverlap=="1" and Sound:IsPlaying(self.Sounds[i].Sound)) then
						bSkip = 1 
					elseif ((Element.Timeout) and (self.Sounds[i].Timeout) and (self.Sounds[i].Timeout<tonumber(Element.Timeout))) then
						bSkip = 1 
					end
					if (self.Sounds[i].Timeout) then
						self.Sounds[i].Timeout=self.Sounds[i].Timeout+TimerDelta 
					end
				
					if (bSkip==0) then
						--System:Log("__666")
						local CurSnd = self.Sounds[i].Sound 
						if (random(0,self.maxChance) < tonumber(Element.Chance)) then
							if (Element.Centered=="0") then
								if (self.Properties.bPlayFromCenter~=0) then
									SoundPos=self:GetPos()
								else
									local fEdgeDist=self.MaxBox-self.MinBox 
									local fRandom 
									fRandom=random(0,fEdgeDist)
									if (fRandom<fEdgeDist*.5) then
										SoundPos.x = ListenerPosition.x - fRandom - self.MinBox*.5 
									else
										SoundPos.x = ListenerPosition.x + (fRandom-fEdgeDist*.5) + self.MinBox*.5 
									end
									fRandom=random(0,fEdgeDist)
									if (fRandom<fEdgeDist*.5) then
										SoundPos.y = ListenerPosition.y - fRandom - self.MinBox*.5 
									else
										SoundPos.y = ListenerPosition.y + (fRandom-fEdgeDist*.5) + self.MinBox*.5 
									end
									fRandom=random(0,fEdgeDist)
									if (fRandom<fEdgeDist*.5) then
										SoundPos.z = ListenerPosition.z - fRandom - self.MinBox*.5 
									else
										SoundPos.z = ListenerPosition.z + (fRandom-fEdgeDist*.5) + self.MinBox*.5 
									end
									--SoundPos.x = ListenerPosition.x + random(0,self.ABox) - self.ABox*.5 
									--SoundPos.y = ListenerPosition.y + random(0,self.ABox) - self.ABox*.5 
									--SoundPos.z = ListenerPosition.z + random(0,self.ABox) - self.ABox*.5 
								end
								Sound:SetSoundPosition(CurSnd,SoundPos)
								Sound:SetMinMaxDistance(CurSnd,10,300)
								Sound:PlaySound(CurSnd)						
		
							else
								Sound:PlaySound(CurSnd)
							end
							Sound:SetSoundVolume(CurSnd,tonumber(Element.Volume) * self.fLastFadeCoeff * self.Properties.fScale)
							self.Sounds[i].Timeout=0  -- reset timeout
						end
					end
				end			
			end
		end
	end
end



---------------------------------------------------------
--
function SoundExclusivePreset:OnShutDown()
end


---------------------------------------------------------
--
function SoundExclusivePreset:Client_Inactive_OnEnterArea(player,areaId)

	--System:Log("Entering Sound Area "..areaId)

--load the sounds
--	self:LoadSounds()
	self:LoadSounds()	
	
--	SoundExclusivePreset:Client_Active_OnEnterArea(player,areaId)
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset)
		return
	end
	
	self.InsideArray[areaId] = 1 
	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		--System:Log("_111")
		if (type(Element)=="table") then
			--System:Log("_222")
			if (tonumber(self.Properties.AreaId)==areaId) then
				--System:Log("_333")
				if (tonumber(Element.Chance)==self.maxChance) then
					--System:Log("_444")
					if (self.Sounds[i].Sound) then
						--System:Log("_555")
						Sound:PlaySound(self.Sounds[i].Sound)
						--System:Log("--> OnEnterArea() Starting Loop Snd")
					end
				end
			end
		end
	end	
		
	self:GotoState("Active")

end

---------------------------------------------------------
--
function SoundExclusivePreset:Client_Active_OnEnterArea(player,areaId)

	--System:Log("--> Entering Area"..areaId)
	
	self.InsideArray[areaId] = 1 
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset)
		return
	end

	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		
--System:Log("#### "..i)
		
		if (type(Element)=="table") then
			
--System:Log("**** "..i)			
			
--if (Element.sndSound~="") then
--System:Log("--> OnEnterArea() ++ "..Element.sndSound.." "..Element.iAreaID)
--end
			
			
			if (tonumber(self.Properties.AreaId)==areaId) then
				

--if (Element.sndSound~="") then
--System:Log("--> OnEnterArea() trying ++ "..Element.sndSound)
--else
--System:Log("--> OnEnterArea() trying -- "..Element.iAreaID.." "..Element.iVolume.." "..Element.bCentered)
--end

				if (tonumber(Element.Chance)==self.maxChance) then
					if (self.Sounds[i]) then
						if (self.Sounds[i].Sound) then
							Sound:PlaySound(self.Sounds[i].Sound)
							--System:Log("--> OnEnterArea() Starting Loop Snd")
						end
					end
				end
			end
		end
	end
end


---------------------------------------------------------
--
function SoundExclusivePreset:Client_Active_OnLeaveArea(player,areaId)
	--System:Log("EX--> Leaving Area")
	
	self.InsideArray[areaId] = 0 
	
	if ((SoundPresetDB==nil) or (SoundPresetDB[self.Properties.sndpresetSoundPreset]==nil)) then
		System:Log("Invalid preset specified: "..self.Properties.sndpresetSoundPreset)
		return
	end

	for i,Element in SoundPresetDB[self.Properties.sndpresetSoundPreset] do
		if (type(Element)=="table") then
			if (tonumber(self.Properties.AreaId)==areaId) then
				if (tonumber(Element.Chance)==self.maxChance) then
					if (self.Sounds[i].Sound) then
						Sound:StopSound(self.Sounds[i].Sound)
					end
				end
			end
		end
	end
	
	if (areaId==1)	then	-- got out of outside area
		self:GotoState("Inactive")
		self:FlashSounds()
		self.fLastFadeCoeff=0 
	end	
	
end


---------------------------------------------------------
--
function SoundExclusivePreset:Client_Active_OnProceedFadeArea(player,areaId,fadeCoeff)

--System:Log("--> Fade Proceed ")
	self.fLastFadeCoeff = fadeCoeff 	
	self.fadeCoeffArea[areaId] = fadeCoeff 
end


----------------------------------------
----------------------------------------
----------------------------------------
----------------------------------------

SoundExclusivePreset.Server={
	OnInit=function(self)
		self:CliSrv_OnInit()
--		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
	},
	Active={
	},
}

SoundExclusivePreset.Client={
	OnInit=function(self)
	
--System.LogToConsole("--> EX init ")	
		self:CliSrv_OnInit()
--		self:CliSrv_OnInit()
	end,
	OnShutDown=function(self)
	end,
	Inactive={
		OnEnterArea=SoundExclusivePreset.Client_Inactive_OnEnterArea,
	},
	Active={
		OnBeginState=function(self)
		--	System:Log("SetTimer")
			self:SetTimer(200)
		end,
		OnTimer=SoundExclusivePreset.Client_Active_OnTimer,
		OnProceedFadeArea=SoundExclusivePreset.Client_Active_OnProceedFadeArea,
		OnEnterArea=SoundExclusivePreset.Client_Active_OnEnterArea,		
		OnLeaveArea=SoundExclusivePreset.Client_Active_OnLeaveArea,
		OnEndState=function(self)
--			System:Log("KillTimer")
			self:KillTimer()
		end,
	},
}


