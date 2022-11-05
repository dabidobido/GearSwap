include("MasterGear/MasterGearLua.lua")
texts = require('texts')
require('chat')

dnc_help_text = [[${combo_status}: ${combo_info}
:${disabled}, ${TP}, ${finishing_moves}, ${climactic_recast}, ${reverse_recast}, ${gp_recast}, ${tr_recast}
Box: ${box_lv}:${box_duration}
Feather: ${feather_lv}:${feather_duration}
Stutter: ${stutter_lv}:${stutter_duration}
Quick: ${quick_lv}:${quick_duration}
]]

current_ws = "Rudra's Storm"

function setup_text_window()
	local default_settings = {}
	default_settings.pos = {}
	default_settings.pos.x = 1400
	default_settings.pos.y = 700
	default_settings.bg = {}
	default_settings.bg.alpha = 255
	default_settings.bg.red = 0
	default_settings.bg.green = 0
	default_settings.bg.blue = 0
	default_settings.bg.visible = true
	default_settings.flags = {}
	default_settings.flags.right = false
	default_settings.flags.bottom = false
	default_settings.flags.bold = false
	default_settings.flags.draggable = true
	default_settings.flags.italic = false
	default_settings.padding = 0
	default_settings.text = {}
	default_settings.text.size = 12
	default_settings.text.font = 'Arial'
	default_settings.text.fonts = {}
	default_settings.text.alpha = 255
	default_settings.text.red = 255
	default_settings.text.green = 255
	default_settings.text.blue = 255
	default_settings.text.stroke = {}
	default_settings.text.stroke.width = 0
	default_settings.text.stroke.alpha = 255
	default_settings.text.stroke.red = 0
	default_settings.text.stroke.green = 0
	default_settings.text.stroke.blue = 0
	
	if dnc_text_hub ~= nil then
        texts.destroy(dnc_text_hub)
    end
    dnc_text_hub = texts.new(dnc_help_text, default_settings, default_settings)
	
    dnc_text_hub:show()
end

climactic_combo = { name = "CF+WS", command = 'input /ja "Climactic Flourish" <me>;wait 1;input /ws "'.. current_ws .. '" <t>' }
reverse_combo = { name = "RF+WS", command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ws "'.. current_ws .. '" <t>' }
grand_combo = { name = "RF+GP+WS", command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ja "Grand Pas" <me>;wait 1;input /ws "'.. current_ws .. '" <t>' }
trance_combo = { name = "TR+WS", command = 'input /ja "Trance" <me>;wait 1;input /ws "'.. current_ws .. '" <t>' }

combo_steps = {
	climactic_combo,
	grand_combo,
	trance_combo,
	reverse_combo,
	reverse_combo,
}

target_step_info = {}

abil_status_map = {
	[202] = 391, -- Box Step
	[312] = 448, -- Feather Step
	[203] = 396, -- Stutter Step
	[201] = 386, -- Quick Step 
}

message_id_status_map = {
	[519] = 386,
	[520] = 391,
	[521] = 396,
	[591] = 448,
}

function amount_cured(base, mod)
	-- Assume 50% waltz potency and 300 CHR + VIT combined and 20 points in Waltz Potency Job Point Category
	return math.floor(1.5 * math.floor((mod * 300) + base + 40))
end

curing_waltz_table = {
	["Curing Waltz V"] = { recast_id = 189, tp_cost = 800, amount = amount_cured(600, 1.25) },
	["Curing Waltz IV"] = { recast_id = 188, tp_cost = 650, amount = amount_cured(450, 1) },
	["Curing Waltz III"] = { recast_id = 187, tp_cost = 500, amount = amount_cured(270, 0.75) },
	["Curing Waltz II"] = { recast_id = 186, tp_cost = 350, amount = amount_cured(130, 0.5) },
	["Curing Waltz"] = { recast_id = 217, tp_cost = 200, amount = amount_cured(60, 0.25) },
}

divine_waltz_table = {
	["Divine Waltz II"] = { recast_id = 190, tp_cost = 800, amount = amount_cured(280, 0.5) },
	["Divine Waltz"] = { recast_id = 225, tp_cost = 400, amount = amount_cured(60, 0.25) },
}

function update_combo_info()
	local recasts = windower.ffxi.get_ability_recasts()
	local finishing_moves_6 = false
	local disabled = false
	if combo_step == 1 then
		local player_buffs = windower.ffxi.get_player().buffs
		for _,v in pairs(player_buffs) do
			if v == 588 then 
				finishing_moves_6 = true
			elseif v == 0 or v == 7 or v == 14 or v == 16 or v == 17 or v == 19 or v == 28 then
				disabled = true
			end
		end
		if finishing_moves_6 
		and recasts[226] == 0 -- Climactic
		and recasts[222] == 0 -- Reverse Flourish
		and recasts[254] == 0 -- Grand Pas
		and recasts[0] == 0 -- Trance
		and player.tp >= 1000
		and not disabled
		then
			can_combo = true
		else
			can_combo = false
		end
	else
		can_combo = true
	end
	
	local combo_info_string = ""
	for k,v in pairs(combo_steps) do
		if k == combo_step then combo_info_string = combo_info_string .. "[" .. v.name .. "]"
		else combo_info_string = combo_info_string .. v.name end
		if k ~= #combo_steps then combo_info_string = combo_info_string .. "," end
	end
	dnc_text_hub.combo_info = combo_info_string
	
	if can_combo then 
		dnc_text_hub.combo_status = string.text_color("Combo", 0, 255, 0)
	else 
		dnc_text_hub.combo_status  = string.text_color("Combo", 255, 0, 0)
	end
	
	if not disabled then
		dnc_text_hub.disabled = string.text_color("Status", 0, 255, 0)
	else
		dnc_text_hub.disabled = string.text_color("Status", 255, 0, 0)
	end
	
	if player.tp >= 1000 then
		dnc_text_hub.TP = string.text_color("TP", 0, 255, 0)
	else
		dnc_text_hub.TP = string.text_color("TP", 255, 0, 0)
	end
	
	if finishing_moves_6 then 
		dnc_text_hub.finishing_moves = string.text_color("FM", 0, 255, 0)
	else
		dnc_text_hub.finishing_moves = string.text_color("FM", 255, 0, 0)
	end
	
	if recasts[226] == 0 then 
		dnc_text_hub.climactic_recast = string.text_color("CF", 0, 255, 0)
	else
		dnc_text_hub.climactic_recast = string.text_color("CF", 255, 0, 0)
	end
	
	if recasts[222] == 0 then 
		dnc_text_hub.reverse_recast = string.text_color("RF", 0, 255, 0)
	else
		dnc_text_hub.reverse_recast = string.text_color("RF", 255, 0, 0)
	end
	
	if recasts[254] == 0 then 
		dnc_text_hub.gp_recast = string.text_color("GP", 0, 255, 0)
	else
		dnc_text_hub.gp_recast = string.text_color("GP", 255, 0, 0)
	end
	
	if recasts[0] == 0 then 
		dnc_text_hub.tr_recast = string.text_color("Tr", 0, 255, 0)
	else
		dnc_text_hub.tr_recast = string.text_color("Tr", 255, 0, 0)
	end
	
	update_step_info()
end

function get_duration_text(time_left)
	if time_left < 10 then
		return string.text_color(string.format("%.1f", time_left), 255, 0, 0)
	else
		return string.text_color(string.format("%.1f", time_left), 0, 255, 0)
	end
end

function update_step_info()
	if dnc_text_hub == nil then return end
	dnc_text_hub.box_lv = 0
	dnc_text_hub.feather_lv = 0
	dnc_text_hub.stutter_lv = 0
	dnc_text_hub.quick_lv = 0
	dnc_text_hub.box_duration = 0
	dnc_text_hub.feather_duration = 0
	dnc_text_hub.stutter_duration = 0
	dnc_text_hub.quick_duration = 0
	if target_step_info[player.target.id] then
		local time_now = os.clock()
		for k,v in pairs(target_step_info[player.target.id]) do
			if k == 391 then
				dnc_text_hub.box_duration = get_duration_text(v.end_time - time_now)
				dnc_text_hub.box_lv = v.lv
			elseif k == 448 then
				dnc_text_hub.feather_duration = get_duration_text(v.end_time - time_now)
				dnc_text_hub.feather_lv = v.lv
			elseif k == 396 then
				dnc_text_hub.stutter_duration = get_duration_text(v.end_time - time_now)
				dnc_text_hub.stutter_lv = v.lv
			elseif k == 386 then
				dnc_text_hub.quick_duration = get_duration_text(v.end_time - time_now)
				dnc_text_hub.quick_lv = v.lv
			end
		end
	end
end

function custom_get_sets()
	can_combo = false
	doing_combo = false
	combo_step = 1
	
	ws = {}
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Dancing Edge"] = { set = sets["Dancing Edge"], tp_bonus = false }
	ws["Exenterator"] = { set = sets["Exenterator"], tp_bonus = false }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Pyrrhic Kleos"] = { set = sets["Pyrrhic Kleos"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	cancel_haste = 1
	
	print_current_ws()
	setup_text_window()
	update_combo_info()
	update_step_info()
	send_command('@input /macro book 12;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
	if spell.type=="WeaponSkill" then
		if ws and ws[spell.english] then
			local set_to_use = nil
			if sets[modes[mode].name .. spell.english] then set_to_use = sets[modes[mode].name .. spell.english]
			else set_to_use = ws[spell.english].set end
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.equipment.main == "Aeneas" then
					maxTP = maxTP - 500
				end 
				if player.equipment.sub == "Centovente" then
					maxTP = maxTP - 1000
				end
				if player.tp < maxTP then
					set_to_use = set_combine(set_to_use, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				set_to_use = set_combine(set_to_use, sets["WeatherObi"])
			end
			if killer_effect then
				set_to_use = set_combine(set_to_use, sets["KillerEffect"])
			end
			if buffactive["Climactic Flourish"] or buffactive["Sneak Attack"] or buffactive["Trick Attack"] then
				set_to_use = set_combine(set_to_use, sets["CritDmg"])
			end
			equip(set_to_use)
		end
		return true
	elseif spell.english:contains("Samba") then
		equip(sets["Samba"])
		return true
	elseif spell.english:contains("Step") then
		equip(sets["Step"])
		if spell.english == "Feather Step" then
			equip(sets["Precast_Feather Step"])
		end
		return true
	elseif spell.english:contains("Curing Waltz") or spell.english == "Divine Waltz" then
		equip(sets["Waltz"])
		return true
	elseif spell.english:contains("Jig") then
		equip(sets["Jig"])
		return true
	elseif spell.english == "Climactic Flourish" then
		equip(sets["Climactic"])
		return true
	end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["MagicAtk"])
			return true
		end
	end
end

function get_max_missing_hp_in_party(max_distance)
	local max_missing_hp = 0
	local max_missing_hp_player_index = 1
	for i = 1, 6 do -- Get player with most missing hp
		if party[i] ~= nil and party[i].mob ~= nil and party[i].mob.distance < max_distance then 
			local missing_hp = (party[i].hp / (party[i].hpp / 100)) - party[i].hp
			if missing_hp > max_missing_hp then
				max_missing_hp = missing_hp
				max_missing_hp_player_index = i
			end
		end
	end
	return max_missing_hp, max_missing_hp_player_index
end

function get_cure_to_use(waltz_table, max_missing_hp)
	local cure_to_use = nil
	if waltz_table ~= nil then
		local recasts = windower.ffxi.get_ability_recasts()
		for ja, data in pairs(waltz_table) do
			if player.tp > data.tp_cost and recasts[data.recast_id] == 0 then
				-- Use the max Curing Waltz that will top off HP or cure as much as possible
				if data.amount >= max_missing_hp or cure_to_use == nil then
					cure_to_use = ja
				else
					break
				end
			end
		end
	end
	return cure_to_use
end
 
function custom_command(args)
	if args[1] == "ws" then
		send_command('input /ws "' .. current_ws .. '" <t>')
	elseif args[1] == "setWS" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		current_ws = commandstring
		climactic_combo.command = 'input /ja "Climactic Flourish" <me>;wait 1;input /ws "'.. current_ws .. '" <t>'
		reverse_combo.command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ws "'.. current_ws .. '" <t>'
		grand_combo.command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ja "Grand Pas" <me>;wait 1;input /ws "'.. current_ws .. '" <t>'
		trance_combo.command = 'input /ja "Trance" <me>;wait 1;input /ws "'.. current_ws .. '" <t>'
		print_current_ws()
	elseif args[1] == "combo" then
		do_combo()
	elseif args[1] == "applystep" and args[2] then
		local recasts = windower.ffxi.get_ability_recasts()
		local presto = true
		local ja_string = nil
		if recasts[220] == 0 then 
			if args[2] == "box" then
				if target_step_info[player.target.id] and 
				target_step_info[player.target.id][391] and 
				target_step_info[player.target.id][391].lv >= 9 then 
					presto = false 
				end
				ja_string = "box step"
			elseif args[2] == "feather" then
				if target_step_info[player.target.id] and 
				target_step_info[player.target.id][448] and 
				target_step_info[player.target.id][448].lv >= 9  then 
					presto = false 
				end
				ja_string = "feather step"
			elseif args[2] == "stutter" then
				if target_step_info[player.target.id] and 
				target_step_info[player.target.id][396] and 
				target_step_info[player.target.id][396].lv >= 9  then 
					presto = false 
				end
				ja_string = "stutter step"
			elseif args[2] == "quick" then
				if target_step_info[player.target.id] and 
				target_step_info[player.target.id][386] and 
				target_step_info[player.target.id][386].lv >= 9  then 
					presto = false 
				end
				ja_string = "quickstep"
			end
		end
		if ja_string ~= nil then
			local command_string = ""
			if presto and recasts[236] == 0 then command_string = 'input /ja presto <me>;wait 1;' end
			command_string = command_string .. 'input /ja "' .. ja_string .. '" <t>'
			windower.send_command(command_string)
		else
			windower.add_to_chat(122, "Step on cooldown")
		end
	elseif args[1] == "cure" then
		local max_missing_hp, max_missing_hp_player_index = get_max_missing_hp_in_party(20)
		if max_missing_hp > 0 then
			local cure_to_use = get_cure_to_use(curing_waltz_table, max_missing_hp)
			if cure_to_use ~= nil then
				windower.send_command('input /ja "' .. cure_to_use .. '" <p' .. tostring(max_missing_hp_player_index - 1) .. '>')
			else
				windower.add_to_chat("Not enough TP")
			end
		end
	elseif args[1] == "curaga" then
		local max_missing_hp, max_missing_hp_player_index = get_max_missing_hp_in_party(10)
		if max_missing_hp > 0 then
			local cure_to_use = get_cure_to_use(divine_waltz_table, max_missing_hp)
			if cure_to_use ~= nil then
				windower.send_command('input /ja "' .. cure_to_use .. '" <me>')
			else
				windower.add_to_chat("Not enough TP")
			end
		end
	elseif args[1] == 'tpitemws' then
		local temp_items = windower.ffxi.get_items(3)
		local tp_item = nil
		for k, v in pairs(temp_items) do
			if v.id ~= nil and v.id == 5834 then 
				tp_item = 5834
				break
			elseif v.id ~= nil and v.id == 6475 then
				tp_item = 6475
				break
			elseif v.id ~= nil and v.id == 4202 then
				tp_item = 4202
				break
			end
		end
		if tp_item ~= nil then
			if tp_item == 5834 then
				send_command('input /item "Lucid Wings I" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			elseif tp_item == 6475 then
				send_command('input /item "Lucid Wings II" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			elseif tp_item == 4202 then
				send_command('input /item "Daedalus Wing" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			end
		end
	end
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end

function do_combo()
	if can_combo then
		send_command(combo_steps[combo_step].command)
		combo_step = combo_step + 1
		if combo_step > #combo_steps then 
			combo_step = 1 
		end
	end
end

function parse_action(act)
	if act.category == 14 then
		local abil = act.param
		if S{201,202,203,312}:contains(abil) then
			local target = act.targets[1]
			local status_id = abil_status_map[abil]
			if status_id then
				local time_now = os.clock()
				if target_step_info[target.id] == nil then target_step_info[target.id] = {} end
				if target_step_info[target.id][status_id] then 
					target_step_info[target.id][status_id].end_time = target_step_info[target.id][status_id].end_time + 50
					if target_step_info[target.id][status_id].end_time - time_now > 140 then 
						target_step_info[target.id][status_id].end_time = time_now + 140 
					end
				else 
					target_step_info[target.id][status_id] = {}
					target_step_info[target.id][status_id].end_time = time_now + 80 
				end
				target_step_info[target.id][status_id].lv = target.actions[1].param
			end
		end
	end
end

function parse_action_message(actor_id, target_id, actor_index, target_index, message_id, param_1, param_2, param_3)
	if S{6,20,113,406,605,646}:contains(message_id) then
		target_step_info[target_id] = nil
	elseif S{64,204,206,350,531}:contains(message_id) then
		if target_step_info[target_id] and target_step_info[target_id][param_1] then
			target_step_info[target_id][param_1] = nil
		end
	elseif S{519, 520, 522, 591}:contains(message_id) then
		local time_now = os.clock()
		local status_id = message_id_status_map[message_id]
		if target_step_info[target_id] == nil then target_step_info[target_id] = {} end
		if target_step_info[target_id][status_id] then 
			target_step_info[target_id][status_id] = target_step_info[target_id][status_id] + 50
			if target_step_info[target_id][status_id] - time_now > 140 then target_step_info[target_id][status_id] = time_now + 140 end
		else 
			target_step_info[target_id][status_id] = time_now + 80 
		end
	end
end

function zone_change()
	target_step_info = {}
end

windower.raw_register_event('time change', update_combo_info)
windower.raw_register_event('action', parse_action)
windower.raw_register_event('action message', parse_action_message)
windower.raw_register_event('zone change', zone_change)