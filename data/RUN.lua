include("MasterGear/MasterGearLua.lua")

resist_table = {}
resist_table["ice"] = "ignis"
resist_table["paralyze"] = "ignis"
resist_table["bind"] = "ignis"
resist_table["frost"] = "ignis"
resist_table["evadown"] = "ignis"
resist_table["agidown"] = "ignis"
resist_table["wind"] = "gelus"
resist_table["silence"] = "gelus"
resist_table["gravity"] = "gelus"
resist_table["choke"] = "gelus"
resist_table["defdown"] = "gelus"
resist_table["vitdown"] = "gelus"
resist_table["earth"] = "flabra"
resist_table["slow"] = "flabra"
resist_table["petrify"] = "flabra"
resist_table["rasp"] = "flabra"
resist_table["accdown"] = "flabra"
resist_table["dexdown"] = "flabra"
resist_table["thunder"] = "tellus"
resist_table["stun"] = "tellus"
resist_table["shock"] = "tellus"
resist_table["mnddown"] = "tellus"
resist_table["water"] = "sulpor"
resist_table["poison"] = "sulpor"
resist_table["strdown"] = "sulpor"
resist_table["atkdown"] = "sulpor"
resist_table["fire"] = "unda"
resist_table["addle"] = "unda"
resist_table["amnesia"] = "unda"
resist_table["virus"] = "unda"
resist_table["burn"] = "unda"
resist_table["mabdown"] = "unda"
resist_table["intdown"] = "unda"
resist_table["dark"] = "lux"
resist_table["blind"] = "lux"
resist_table["bio"] = "lux"
resist_table["sleep"] = "lux"
resist_table["dispel"] = "lux"
resist_table["drain"] = "lux"
resist_table["curse"] = "lux"
resist_table["doom"] = "lux"
resist_table["zombie"] = "lux"
resist_table["mevadown"] = "lux"
resist_table["hpdown"] = "lux"
resist_table["mpdown"] = "lux"
resist_table["chrdown"] = "lux"
resist_table["absorb"] = "lux"
resist_table["light"] = "tenebrae"
resist_table["dia"] = "tenebrae"
resist_table["repose"] = "tenebrae"
resist_table["finale"] = "tenebrae"
resist_table["charm"] = "tenebrae"
resist_table["lullaby"] = "tenebrae"
resist_table["sheepsong"] = "tenebrae"
resist_table["maccdown"] = "tenebrae"

runes_elemental_map = {}
runes_elemental_map["light"] = "lux"
runes_elemental_map["dark"] = "tenebrae"
runes_elemental_map["water"] = "unda"
runes_elemental_map["thunder"] = "sulpor"
runes_elemental_map["fire"] = "ignis"
runes_elemental_map["wind"] = "flabra"
runes_elemental_map["earth"] = "tellus"
runes_elemental_map["ice"] = "gelus"

function custom_get_sets()
	rune = "Lux"
	subjob_action = nil
	auto_rune = false
	target_rune_count = {
		["tenebrae"] = 0,
		["lux"] = 0,
		["unda"] = 0,
		["sulpor"] = 0,
		["tellus"] = 0,
		["flabra"] = 0,
		["gelus"] = 0,
		["ignis"] = 0,
	}
	rune_cast = { "lux", "lux", "lux" }
	rune_cast_index = 1
	
	tp_bonus_gear = {
		["main"] = { name = "Lionheart", bonus = 500 }
	}
	
	sets["Precast_Swipe"] = sets["Precast_Lunge"]
	sets["Precast_Vallation"] = sets["Precast_Valiance"]
	sets["Precast_Pflug"] = sets["Precast_Swordplay"]
	sets["Precast_Rayke"] = sets["Precast_Swordplay"]
	sets["Precast_One for All"] = sets["Precast_Swordplay"]
	sets["Precast_Elemental Sforzo"] = sets["Precast_Liement"]
	sets["Precast_Odyllic Sbuterfuge"] = sets["Precast_Swordplay"]
	sets["Precast_Sentinel"] = sets["Precast_Swordplay"]
	sets["Precast_Holy Circle"] = sets["Precast_Swordplay"]
	
	sets["Midcast_Aquaveil"] = sets["Midcast_Crusade"]
	sets["Midcast_Temper"] = sets["Midcast_Crusade"]
	sets["Midcast_Shock Spikes"] = sets["Midcast_Crusade"]
	sets["Midcast_Regen IV"] = sets["Midcast_Crusade"]
	sets["Midcast_Refresh"] = sets["Midcast_Crusade"]
	sets["Midcast_Blink"] = sets["Midcast_Crusade"]
	sets["Midcast_Stoneskin"] = sets["Midcast_Crusade"]
	sets["Midcast_Barfire"] = sets["Midcast_Crusade"]
	sets["Midcast_Barblizzard"] = sets["Midcast_Crusade"]
	sets["Midcast_Baraero"] = sets["Midcast_Crusade"]
	sets["Midcast_Barstone"] = sets["Midcast_Crusade"]
	sets["Midcast_Barthunder"] = sets["Midcast_Crusade"]
	sets["Midcast_Barwater"] = sets["Midcast_Crusade"]
	sets["Midcast_Barsleep"] = sets["Midcast_Crusade"]
	sets["Midcast_Barpoison"] = sets["Midcast_Crusade"]
	sets["Midcast_Barparalyze"] = sets["Midcast_Crusade"]
	sets["Midcast_Barblind"] = sets["Midcast_Crusade"]
	sets["Midcast_Barsilence"] = sets["Midcast_Crusade"]
	sets["Midcast_Barpetrify"] = sets["Midcast_Crusade"]
	sets["Midcast_Barvirus"] = sets["Midcast_Crusade"]
	sets["Midcast_Baramnesia"] = sets["Midcast_Crusade"]
	sets["Midcast_Flash"] = sets["Midcast_Blank Gaze"]
	sets["Midcast_Foil"] = sets["Midcast_Blank Gaze"]
	sets["Midcast_Stun"] = sets["Midcast_Blank Gaze"]
	sets["Midcast_Poisonga"] = sets["Midcast_Blank Gaze"]
	sets["Midcast_Geist Wall"] = sets["Midcast_Blank Gaze"]
	sets["Midcast_Jettatura"] = sets["Midcast_Blank Gaze"]
	
	sets["Midcast_Cure IV"] = sets["Midcast_Crusade"]
	sets["Midcast_Banishga"] = sets["Midcast_Blank Gaze"]
	
	ws = {}
	ws["Frostbite"] = { set = sets["Freezebite"], tp_bonus = true }
	ws["Freezebite"] = { set = sets["Freezebite"], tp_bonus = true }
	ws["Herculean Slash"] = { set = sets["Freezebite"], tp_bonus = false }
	ws["Shockwave"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Resolution"] = { set = sets["Resolution"], tp_bonus = true }
	ws["Sickle Moon"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Dimidiation"] = { set = sets["Dimidiation"], tp_bonus = true }
	
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Requiescat"] = { set = sets["Requiescat"], tp_bonus = true }
	ws["Red Lotus Blade"] = { set = sets["Freezebite"], tp_bonus = true }
	ws["Seraph Blade"] = { set = sets["Freezebite"], tp_bonus = true }
	ws["Sanguine Blade"] = { set = sets["Sanguine Blade"], tp_bonus = false }
	
	ws["Fell Cleave"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Steel Cyclone"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Armor Break"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Upheaval"] = { set = sets["Resolution"], tp_bonus = true }
	
	subjob_check(player.sub_job)
	print_current_rune()
	send_command('@input /macro book 1;wait 1;input /macro set 1')
end

function cast_rune(skip_if_full)
	for k,v in pairs(rune_cast) do
		if buffactive[v] == nil or buffactive[v] < target_rune_count[v] then
			send_command('input /ja "' .. v .. '" <me>')
			rune_cast_index = k + 1
			if rune_cast_index > 3 then rune_cast_index = 1 end
			return
		end
	end
	if not skip_if_full then
		send_command('input /ja "' .. rune_cast[rune_cast_index] .. '" <me>')
		rune_cast_index = rune_cast_index + 1
		if rune_cast_index > 3 then rune_cast_index = 1 end
	end
end
 
function custom_command(args)
	if args[1] == "rune" then
		if args[2] and args[3] and args[4] then
			local ele1 = string.lower(args[2])
			local ele2 = string.lower(args[3])
			local ele3 = string.lower(args[4])
			if runes_elemental_map[ele1] and runes_elemental_map[ele2] and runes_elemental_map[ele3] then
				local rune1 = runes_elemental_map[ele1]
				local rune2 = runes_elemental_map[ele2]
				local rune3 = runes_elemental_map[ele3]
				if target_rune_count[rune1] and target_rune_count[rune2] and target_rune_count[rune3] then
					target_rune_count["lux"] = 0
					target_rune_count["tenebrae"] = 0
					target_rune_count["unda"] = 0
					target_rune_count["sulpor"] = 0
					target_rune_count["tellus"] = 0
					target_rune_count["flabra"] = 0
					target_rune_count["gelus"] = 0
					target_rune_count["ignis"] = 0
					target_rune_count[rune1] = target_rune_count[rune1] + 1
					target_rune_count[rune2] = target_rune_count[rune2] + 1
					target_rune_count[rune3] = target_rune_count[rune3] + 1
					rune_cast = { rune1, rune2, rune3 }
					rune_cast_index = 1
					print_current_rune()
				end
			end
		elseif args[2] then
			local rune_to_cast = runes_elemental_map[string.lower(args[2])]
			if rune_to_cast then
				rune_cast = { rune_to_cast, rune_to_cast, rune_to_cast }
				target_rune_count["lux"] = 0
				target_rune_count["tenebrae"] = 0
				target_rune_count["unda"] = 0
				target_rune_count["sulpor"] = 0
				target_rune_count["tellus"] = 0
				target_rune_count["flabra"] = 0
				target_rune_count["gelus"] = 0
				target_rune_count["ignis"] = 0
				target_rune_count[rune_to_cast] = 3
				rune_cast_index = 1
				print_current_rune()
			end
		else
			cast_rune()
		end
	elseif args[1] == "sjAction" then
		if subjob_action == nil then
			add_to_chat(122, "No SubjobAction for " .. player.sub_job)
		else
			send_command('input ' .. subjob_action)
		end
	elseif args[1] == 'setWS' and args[2] then
		ws = string.sub(command, 7)
		print_current_ws()
	elseif args[1] == 'resist' and args[2] then
		if args[2] and args[3] and args[4] then
			local res1 = string.lower(args[2])
			local res2 = string.lower(args[3])
			local res3 = string.lower(args[4])
			if resist_table[res1] and resist_table[res2] and resist_table[res3] then
				local rune1 = resist_table[res1]
				local rune2 = resist_table[res2]
				local rune3 = resist_table[res3]
				if target_rune_count[rune1] and target_rune_count[rune2] and target_rune_count[rune3] then
					target_rune_count["lux"] = 0
					target_rune_count["tenebrae"] = 0
					target_rune_count["unda"] = 0
					target_rune_count["sulpor"] = 0
					target_rune_count["tellus"] = 0
					target_rune_count["flabra"] = 0
					target_rune_count["gelus"] = 0
					target_rune_count["ignis"] = 0
					target_rune_count[rune1] = target_rune_count[rune1] + 1
					target_rune_count[rune2] = target_rune_count[rune2] + 1
					target_rune_count[rune3] = target_rune_count[rune3] + 1
					rune_cast = { rune1, rune2, rune3 }
					rune_cast_index = 1
					print_current_rune()
				end
			end
		else
			local arg2 = string.lower(args[2])
			if resist_table[arg2] then 
				rune_cast = { resist_table[arg2], resist_table[arg2], resist_table[arg2] }
				target_rune_count["lux"] = 0
				target_rune_count["tenebrae"] = 0
				target_rune_count["unda"] = 0
				target_rune_count["sulpor"] = 0
				target_rune_count["tellus"] = 0
				target_rune_count["flabra"] = 0
				target_rune_count["gelus"] = 0
				target_rune_count["ignis"] = 0
				target_rune_count[resist_table[arg2]] = 3
				rune_cast_index = 1
				print_current_rune()
			end
		end
	elseif args[1] == 'autorune' then
		auto_rune = not auto_rune
		add_to_chat(122, "Autorune: " .. tostring(auto_rune))
	end
end

function sub_job_change(new, old)
	subjob_check(new)
end

function print_current_rune()
	local runeString = ""
	for k,v in pairs(rune_cast) do
		runeString = runeString .. v .. ", "
	end
	add_to_chat(122, "Current runes: " .. runeString)
end

function print_subjob_action()
	if subjob_action == nil then
	else
		add_to_chat(122, "Current Subjob Action: " .. subjob_action)
	end
end

function subjob_check(job)
	if job == "NIN" then
		subjob_action = '/ma "Utsusemi: Ni" <me>;input /ma "Utsusemi: Ichi" <me>'
	elseif job == "DNC" then
		subjob_action = nil
	elseif job == "SAM" then
		subjob_action = '/ja "Third Eye" <me>'
	elseif job == "WAR" then
		subjob_action = '/ja "Provoke" <stnpc>'
	elseif job == "DRK" then
		subjob_action = '/ma "Stun" <stnpc>'
	else
		subjob_action = nil
	end
	print_subjob_action()
end

function check_emnity(type, spellName)
	if enmity_actions[type] then
		for k,v in ipairs(enmity_actions[type]) do
			if spellName == v then 
				return true 
			end
		end
	end
	return false
end

function auto_rune(new, old)
	if auto_rune and player.in_combat then
		local recasts = windower.ffxi.get_ability_recasts()
		if recasts[10] == 0 then
			cast_rune(true)
		end
	end
end

windower.raw_register_event('time change', auto_rune)