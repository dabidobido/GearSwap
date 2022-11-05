include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Victory Smite"] = { set = sets["Victory Smite"], tp_bonus = true }
	ws["Ascetic's Fury"] = { set = sets["Victory Smite"], tp_bonus = true }
	ws["Shijin Spiral"] = { set = sets["Shijin Spiral"], tp_bonus = false }
	ws["Asuran Fists"] = { set = sets["Asuran Fists"], tp_bonus = false }
	ws["Raging Fists"] = { set = sets["Raging Fists"], tp_bonus = true }
	ws["Howling Fist"] = { set = sets["Raging Fists"], tp_bonus = true }
	ws["Dragon Kick"] = { set = sets["Raging Fists"], tp_bonus = true }
	ws["Tornado Kick"] = { set = sets["Raging Fists"], tp_bonus = true }
	ws["Spinning Attack"] = { set = sets["Raging Fists"], tp_bonus = false }
	
	ws["Full Swing"] = { set = sets["Howling Fist"], tp_bonus = true }
	ws["Retribution"] = { set = sets["Howling Fist"], tp_bonus = true }
	ws["Shell Crusher"] = { set = sets["Howling Fist"], tp_bonus = true }
	ws["Sunburst"] = { set = sets["Sunburst"], tp_bonus = true }
	ws["Cataclysm"] = { set = sets["Sunburst"], tp_bonus = true }
	ws["Rock Crusher"] = { set = sets["Rock Crusher"], tp_bonus = true }
	ws["Earth Crusher"] = { set = sets["Rock Crusher"], tp_bonus = true }
	
	send_command('@input /macro book 18')
	subjob_macro_page(player.sub_job)
end

function custom_precast(spell)
	if spell.type=="WeaponSkill" then
		if ws and ws[spell.english] then
			if sets[modes[mode].name .. spell.english] then 
				equip(sets[modes[mode].name .. spell.english])
			else equip(ws[spell.english].set) end
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.equipment.main == "Godhands" then maxTP = maxTP - 500	end
				if ws[spell.english].set.head.name == "Mpaca's Cap" then maxTP = maxTP - 200 end
				if player.tp < maxTP then
					equip(sets["TPBonus"])
				end
			end
			if buffactive["Footwork"] and 
			(spell.english == "Tornado Kick" or spell.english == "Dragon Kick") then
				equip(sets["Footwork_Swap"])
			end
			if buffactive["Impetus"] and
			(spell.english == "Victory Smite" or spell.english == "Dragon Kick") then
				equip(sets["Impetus_Swap"])
			end
			return true
		end
	end
end

function custom_aftercast(spell)
	if combat or player.status == "Engaged" then
		equip(modes[mode].set)
    else
        equip(sets.Idle)
    end
	if buffactive["Impetus"] then 
		equip(sets["Impetus_Swap"]) 
	end
	return true
end

function buff_change(name,gain,buff_details)
	if name == "Boost" then
		if gain then equip(sets["BoostRegain"])
		else
			if combat or player.status == "Engaged" then
				equip(modes[mode].set)
			else
				equip(sets.Idle)
			end
		end
	end
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function subjob_macro_page(job)
	if job == "WAR" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "DRG" then
		send_command('@wait 1;input /macro set 2')
	end
end