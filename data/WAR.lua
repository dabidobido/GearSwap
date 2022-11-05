include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Impulse Drive"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Sonic Thrust"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Stardiver"] = { set = sets["Upheaval"], tp_bonus = false }
	ws["SO_Impulse Drive"] = { set = sets["SO_Impulse Drive"], tp_bonus = true }
	ws["SO_Sonic Thrust"] = { set = sets["SO_Impulse Drive"], tp_bonus = true }
	ws["SO_Stardiver"] = { set = sets["Ukko's Fury"], tp_bonus = true }
	ws["Raiden Thrust"] = { set = sets["Cloudsplitter"], tp_bonus = true }
	
	ws["Steel Cyclone"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Sturmwind"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Iron Tempest"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Fell Cleave"] = { set = sets["Steel Cyclone"], tp_bonus = false }
	ws["Upheaval"] = { set = sets["Upheaval"], tp_bonus = true }
	ws["King's Justice"] = { set = sets["Upheaval"], tp_bonus = true }
	ws["Ukko's Fury"] = { set = sets["Ukko's Fury"], tp_bonus = true }
	ws["Keen Edge"] = { set = sets["Ukko's Fury"], tp_bonus = true }
	ws["Raging Rush"] = { set = sets["Ukko's Fury"], tp_bonus = true }
	ws["Armor Break"] = { set = sets["Armor Break"], tp_bonus = false }
	ws["Shield Break"] = { set = sets["Armor Break"], tp_bonus = false }
	ws["Weapon Break"] = { set = sets["Armor Break"], tp_bonus = false }
	ws["Full Break"] = { set = sets["Armor Break"], tp_bonus = false }
	
	ws["Ground Strike"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Scourge"] = { set = sets["Steel Cyclone"], tp_bonus = false }
	ws["Resolution"] = { set = sets["Upheaval"], tp_bonus = true }
	
	ws["Decimation"] = { set = sets["Decimation"], tp_bonus = false }
	ws["Smash Axe"] = { set = sets["Steel Cyclone"], tp_bonus = false }
	ws["Ruinator"] = { set = sets["Decimation"], tp_bonus = false }
	ws["Mistral Axe"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Calamity"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Cloudsplitter"] = { set = sets["Cloudsplitter"], tp_bonus = true }
	
	ws["Cataclysm"] = { set = sets["Cataclysm"], tp_bonus = true }
	ws["Sunburst"] = { set = sets["Cataclysm"], tp_bonus = true }
	ws["Earth Crusher"] = { set = sets["Cloudsplitter"], tp_bonus = true }
	ws["Full Swing"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Retribution"] = { set = sets["Steel Cyclone"], tp_bonus = true }
	ws["Shell Crusher"] = { set = sets["Armor Break"], tp_bonus = false }
	
	ws["Sanguine Blade"] = { set = sets["Cloudsplitter"], tp_bonus = false }
	
	send_command('@input /macro book 19;wait 1;input /macro set 1')
end

function custom_precast(spell)
	if spell.type == "WeaponSkill" then
		if player.equipment.main == "Shining One" then
			if ws["SO_" .. spell.english] then equip(ws["SO_" .. spell.english].set)
			elseif ws[spell.english] then equip(ws[spell.english].set) end
			if player.tp < 3000 then
				equip(sets["TPBonus"])
			end
			return true
		elseif player.equipment.main == "Lycurgos" and ws[spell.english] ~= nil then
			local setToUse = ws[spell.english].set
			local maxTP = 3000
			local hp_bonus = math.floor(player.hp / 5)
			if hp_bonus > 1000 then hp_bonus = 1000 end
			maxTP = maxTP - hp_bonus
			if player.tp < maxTP then
				setToUse = set_combine(setToUse, sets["TPBonus"])
			end
			return true
		end
	end
end