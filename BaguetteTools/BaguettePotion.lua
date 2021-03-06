--[[

You can use Buff too, especialy for re-launch a potion

]]--


-- Function to send chat logs.
function EnvoiMessage(msg)
	PrintChat("<font color=\"#e74c3c\"><b>[BaguettePotion]</b></font> <font color=\"#ffffff\">" .. msg .. "</font>")
end
-- End

-- Just getting the current time in millis.
function CurrentTimeInMillis()
	return (os.clock() * 1000);
end
-- End

-- Local var.
local lastPotion = 0
local ActualPotTime = 15
local ActualPotName = "None"
local ActualPotData = "None"
-- End

--- Starting AutoUpdate.
local version = "0.13"
local author = "spyk"
local SCRIPT_NAME = "BaguettePotion"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.githubusercontent.com"
local UPDATE_PATH = "/spyk1/BoL/master/BaguetteTools/BaguettePotion.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local whatsnew = 0

if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/spyk1/BoL/master/BaguetteTools/BaguettePotion.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				EnvoiMessage("New version available "..ServerVersion)
				EnvoiMessage(">>Updating, please don't press F9<<")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () EnvoiMessage("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
				whatsnew = 1
			else
				DelayAction(function() EnvoiMessage("Hello, "..GetUser()..". You got the latest version! :) ("..ServerVersion..") Enjoy you'r game!") end, 3)
			end
		end
		else
			EnvoiMessage("Error downloading version info")
	end
end
 --- End Of AutoUpdate.

-- Return this function of a game start or on F9.
function OnLoad()
	-- Print when the script is just loaded.
	print("<font color=\"#ffffff\">Loaded</font><font color=\"#e74c3c\"><b> [BaguettePotion]</b></font> <font color=\"#ffffff\">by spyk</font>")
	-- If you got a new version, then print a message.
	if whatsnew == 1 then
		DelayAction(function() EnvoiMessage("What's new : 'Released AutoPotion")end, 15)
		whatsnew = 0
	end
	-- Menu.
	Pots = scriptConfig("[Baguette] Potion", "BaguettePotion")
		Pots:addParam("PotsEnable", "Use potions with this script?", SCRIPT_PARAM_ONOFF, true)
		Pots:addParam("PotsAtXHP", "At how many %HP?", SCRIPT_PARAM_SLICE, 60, 0, 100)
		Pots:addParam("PotsOnlyCombo", "Use potions only in ComboMode?", SCRIPT_PARAM_ONOFF, true)
		Pots:addParam("PotsComboKey", "ComboMode Key is?", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Pots:permaShow("PotsEnable")
	--
end
-- end

-- Returned each ticks. (Around +10 times seconds)
function OnTick()
	if Pots.PotsEnable and not Pots.PotsOnlyCombo then -- Normal mode without combo required. 
		AutoPotions()
	elseif Pots.PotsEnable and Pots.PotsOnlyCombo and Pots.PotsComboKey then -- Combo Mode with ComboKey required.
		AutoPotions() 
	end
end
-- End 

-- Start of which potions return.
function AutoPotions()
	if not Pots.PotsEnable then return end -- If not 'Use potions with this script' then stop here.
		if os.clock() - lastPotion < ActualPotTime then return end -- If the time returned is inferior to the time of a potion, then check. More cleary, if you don't got any potion active.
			for SLOT = ITEM_1, ITEM_6 do -- Check every slots.
				if myHero:GetSpellData(SLOT).name == "RegenerationPotion" then 
					ActualPotName = "Health Potion"
					ActualPotTime = 15
					ActualPotData = "RegenerationPotion"
					Usepot() -- Return Usepot()
				elseif myHero:GetSpellData(SLOT).name == "ItemMiniRegenPotion" then
					ActualPotName = "Cookie"
					ActualPotTime = 15
					ActualPotData = "ItemMiniRegenPotion"
					Usepot() -- Return Usepot()
				elseif myHero:GetSpellData(SLOT).name == "ItemCrystalFlaskJungle" then
					ActualPotName = "Hunter's Potion"
					ActualPotTime = 8
					ActualPotData = "ItemCrystalFlaskJungle"
					Usepot() -- Return Usepot()
				elseif myHero:GetSpellData(SLOT).name == "ItemCrystalFlask" then
					ActualPotName = "Refillable Potion"
					ActualPotTime = 12
					ActualPotData = "ItemCrystalFlask"
					Usepot() -- Return Usepot()
				elseif myHero:GetSpellData(SLOT).name == "ItemDarkCrystalFlask" then
					ActualPotName = "Corrupting Potion"
					ActualPotTime = 12
					ActualPotData = "ItemDarkCrystalFlask" 
					Usepot() -- Return Usepot()
				else end -- If you don't got potion but the function is here.. Well.. Nice! You broke my function, anyway, I got a backup ! :D (Useless one by the way)
			end
		--
	--
end
-- End 

-- Start the function who cast the potion with which parameters.
function Usepot()
	for SLOT = ITEM_1, ITEM_6 do -- Slot checking.
		if myHero:GetSpellData(SLOT).name == ActualPotData then -- If my Hero got a slot who can been used then, this slot is ActualPotData(Autopotion()).
			if myHero:CanUseSpell(SLOT) == READY and (myHero.health*100)/myHero.maxHealth < Pots.PotsAtXHP and not InFountain() then -- If my Hero can use this slot now (like if you can't because of CD) and if Hero got x% < HP set.
				CastSpell(SLOT) -- Cast potion.
				lastPotion = os.clock()	-- Make a new value with the time when a potion works.
				EnvoiMessage("1x "..ActualPotName.." => Used.") -- Print which potion was casted.
			end
		end
	end
end
-- End
