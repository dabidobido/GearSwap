include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	throwing = false
	current_ws = "Rudra's Storm"
	cancel_haste = 1
	
	tp_bonus_gear = {
		["main"] = { name = "Aeneas", bonus = 500 },
		["sub"] = { name = "Centovente", bonus = 1000 },
	}
	
	sets.SATA = set_combine(sets["SneakAttack"], sets["TrickAttack"])
	
	ws = {}
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Dancing Edge"] = { set = sets["Dancing Edge"], tp_bonus = false }
	ws["Exenterator"] = { set = sets["Exenterator"], tp_bonus = false }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Circle Blade"] = { set = sets["Savage Blade"], tp_bonus = false }
	
	ws["Asuran Fists"] = { set = sets["Raging Fists"], tp_bonus = false }
	ws["Raging Fists"] = { set = sets["Raging Fists"], tp_bonus = true }
	
	sets["Midcast_Sleepga"] = sets["MagicAcc"]
	sets["Midcast_Bind"] = sets["MagicAcc"]
	
	print_current_ws()
	print_throwing()
	send_command('@input /macro book 2')
	subjob_macro_page(player.sub_job)
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["MagicAtk"])
			return true
		end
	end
end

function custom_command(args)
	if args[1] == "ws" then
		if player.equipment.main == "Naegling" then
			send_command('input /ws "Savage Blade" <t>')
		else
			send_command('input /ws "' .. current_ws .. '" <t>')
		end
	elseif args[1] == "setWS" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		current_ws = commandstring
		print_current_ws()
	end
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end

function SATA_check(set)
	SA = buffactive["Sneak Attack"]
	TA = buffactive["Trick Attack"]
	if SA or TA then
		if SA and TA then
			set = set_combine(set, sets.SATA)
		elseif SA then
			set = set_combine(set, sets["SneakAttack"])
		elseif TA then
			set = set_combine(set, sets["TrickAttack"])
		end
	end
	return set
end

function subjob_macro_page(job)
	if job == "DNC" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "NIN" then
		send_command('@wait 1;input /macro set 2')
	elseif job == "RUN" then
		send_command('@wait 1;input /macro set 3')
	elseif job == "WAR" then
		send_command('@wait 1;input /macro set 4')
	elseif job == "DRG" then
		send_command('@wait 1;input /macro set 5')
	elseif job == "BLM" then
		send_command('@wait 1;input /macro set 6')
	end
end