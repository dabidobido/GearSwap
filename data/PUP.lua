include("Mastergear/MasterGearLua.lua")
texts = require('texts')
require('chat')

pup_help_text = [[Overrides: ${override_info}
]]

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
	
	if pup_text_hub ~= nil then
        texts.destroy(pup_text_hub)
    end
    pup_text_hub = texts.new(pup_help_text, default_settings, default_settings)
	
    pup_text_hub:show()
end

target_maneuver_count = {
	["light maneuver"] = 1,
	["dark maneuver"] = 0,
	["earth maneuver"] = 0,
	["wind maneuver"] = 1,
	["water maneuver"] = 0,
	["ice maneuver"] = 0,
	["fire maneuver"] = 1,
	["thunder maneuver"] = 0,
}
maneuver_cast = {"light maneuver", "wind maneuver", "fire maneuver"}
maneuver_recast_ids = {
	["light maneuver"] = 147,
	["dark maneuver"] = 148,
	["earth maneuver"] = 144,
	["wind maneuver"] = 143,
	["water maneuver"] = 146,
	["ice maneuver"] = 142,
	["fire maneuver"] = 141,
	["thunder maneuver"] = 145,
}
maneuver_cast_index = 1
deploy_on_engage = false
auto_maneuvers = false
auto_enmity = false

puppet_overrides = {
	["TP"] = { active = false },
	["Enmity"] = { active = false, ready_time = 
		{ 
			[1689] = 0,
			[1691] = 0,
		} 
	},
}
autoabils = {
    [1689] = {name = 'Strobe', recast = 30, maneuver = "fire maneuver" },
    [1691] = {name = 'Flashbulb', recast = 45, maneuver = "light maneuver" },
}
attachments_to_abilities = {
    [8449] = 1689,
    [8457] = 1689,
    [8642] = 1691,
}

function update_puppet_info()
	local override_info_string = ""
	for k, v in pairs(puppet_overrides) do
		if v.active == true then override_info_string = override_info_string .. "[" .. k .. "] "
		else override_info_string = override_info_string .. k .. " "
		end
	end
	pup_text_hub.override_info = override_info_string
end

function custom_get_sets()
	ws = {}
	ws["Combo"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["Shoulder Tackle"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["One Inch Punch"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["Backhand Blow"] = { set = sets["Dragon Kick"], tp_bonus = false }
	ws["Raging Fist"] = { set = sets["Raging Fist"], tp_bonus = true }
	ws["Spinning Attack"] = { set = sets["Dragon Kick"], tp_bonus = false }
	ws["Howling Fist"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["Dragon Kick"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["Asuran Fist"] = { set = sets["Dragon Kick"], tp_bonus = false }
	ws["Tornado Kick"] = { set = sets["Dragon Kick"], tp_bonus = true }
	ws["Shijin Spiral"] = { set = sets["Dragon Kick"], tp_bonus = false }
	ws["Victory Smite"] = { set = sets["Dragon Kick"], tp_bonus = false }
	ws["Stringing Pummel"] = { set = sets["Dragon Kick"], tp_bonus = false }
	
	ws["Aeolian Edge"] = { set = sets["Aeolian Edge"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["Aeolian Edge"], tp_bonus = true }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	ws["Wasp Sting"] = { set = sets["Wasp Sting"], tp_bonus = false }
	ws["Viper Bite"] = { set = sets["Wasp Sting"], tp_bonus = false }
	ws["Shadowstitch"] = { set = sets["Wasp Sting"], tp_bonus = false }

	print_current_maneuvers()
	send_command('@input /macro book 13;wait 1;input /macro set 1')
	setup_text_window()
	update_puppet_info()
	if pet.isvalid then 
		for ability_id, ready_time in pairs(puppet_overrides["Enmity"].ready_time) do
			puppet_overrides["Enmity"].ready_time[ability_id] = 1
		end
	end
end

function custom_command(args)
	if args[1] == "maneuver" then
		if args[2] and args[3] and args[4] then
			local ele1 = string.lower(args[2]) .. " maneuver"
			local ele2 = string.lower(args[3]) .. " maneuver"
			local ele3 = string.lower(args[4]) .. " maneuver"
			if target_maneuver_count[ele1] and target_maneuver_count[ele2] and target_maneuver_count[ele3] then
				target_maneuver_count["light maneuver"] = 0
				target_maneuver_count["dark maneuver"] = 0
				target_maneuver_count["earth maneuver"] = 0
				target_maneuver_count["wind maneuver"] = 0
				target_maneuver_count["water maneuver"] = 0
				target_maneuver_count["ice maneuver"] = 0
				target_maneuver_count["fire maneuver"] = 0
				target_maneuver_count["thunder maneuver"] = 0
				target_maneuver_count[ele1] = target_maneuver_count[ele1] + 1
				target_maneuver_count[ele2] = target_maneuver_count[ele2] + 1
				target_maneuver_count[ele3] = target_maneuver_count[ele3] + 1
				maneuver_cast = {ele1, ele2, ele3}
				maneuver_cast_index = 1
				print_current_maneuvers()
			end
		else
			do_maneuver()
		end
	elseif args[1] == "tpoverride" then
		equip(sets["PetTP"])
		puppet_overrides["TP"].active = true
	elseif args[1] == "enmityoverride" then
		equip(sets["PetEnmity"])
		puppet_overrides["Enmity"].active = true
	elseif args[1] == "autoenmity" then
		auto_enmity = not auto_enmity
		windower.add_to_chat(122, "Auto Enmity: " .. tostring(auto_enmity))
	elseif args[1] == "automaneuver" then
		if auto_maneuvers then auto_maneuvers = false 
		else auto_maneuvers = true end
		windower.add_to_chat(122, "Auto Maneuvers: " .. tostring(auto_maneuvers))
	end
end

function do_maneuver()
	local recasts = windower.ffxi.get_ability_recasts()
	for i = 1, 3 do
		local temp_index = maneuver_cast_index + i - 1
		if temp_index > 3 then temp_index = temp_index - 3 end
		local maneuver = maneuver_cast[temp_index]
		if buffactive[maneuver] == nil or buffactive[maneuver] < target_maneuver_count[maneuver] then
			if not recasts[210] or recasts[210] == 0 then
				send_command('input /ja "' .. maneuver .. '" <me>')
				maneuver_cast_index = temp_index + 1
				if maneuver_cast_index > 3 then maneuver_cast_index = 1 end
				return
			end
		end
	end
	local maneuver = maneuver_cast[maneuver_cast_index]
	if not recasts[210] or recasts[210] == 0 then 
		send_command('input /ja "' .. maneuver_cast[maneuver_cast_index] .. '" <me>')
		maneuver_cast_index = maneuver_cast_index + 1
		if maneuver_cast_index > 3 then maneuver_cast_index = 1 end
	end
end

function custom_precast(spell)
	if string.lower(spell.english):contains("maneuver") then
		equip(sets["Maneuver"])
		return true
	end
end

function custom_aftercast(spell)
	if auto_enmity then
		if combat or player.status == "Engaged" then
			equip(modes[mode].set)
		else
			equip(sets.Idle)
		end
		check_auto_enmity()
		update_puppet_info()
		return true
	end
end

function pet_aftercast(spell)
	if spell.action_type == "Monster Move" then
		if puppet_overrides["TP"].active then
			puppet_overrides["TP"].active = false
			aftercast(spell)
			check_auto_enmity()
			update_puppet_info()
		end
	end
end

function buff_change(name,gain,buff_details)
	if gain and auto_enmity and string.lower(name):contains("maneuver") then
		check_auto_enmity()
		update_puppet_info()
	end
end

function pet_change(pet,gain)
	maneuver_cast_index = 1
	if gain then
		local time_now = os.clock()
		for ability_id, ready_time in pairs(puppet_overrides["Enmity"].ready_time) do
			if autoabils[ability_id] then
				puppet_overrides["Enmity"].ready_time[ability_id] = time_now + autoabils[ability_id].recast
			end
		end
	else
		for ability_id, ready_time in pairs(puppet_overrides["Enmity"].ready_time) do
			puppet_overrides["Enmity"].ready_time[ability_id] = 0
		end
	end
	check_auto_enmity()
	update_puppet_info()
end

function print_current_maneuvers()
	local text = ""
	for k,v in pairs(maneuver_cast) do
		text = text .. v .. ", "
	end
	add_to_chat(122, "Current Maneuvers: " .. text)
end

function check_auto_enmity()
	if auto_enmity then
		local time_now = os.clock()
		for ability_id, ready_time in pairs(puppet_overrides["Enmity"].ready_time) do
			if ready_time > 0 and time_now - ready_time > -4 then
				if autoabils[ability_id] and autoabils[ability_id].maneuver == nil 
				or (autoabils[ability_id].maneuver and buffactive[autoabils[ability_id].maneuver]) then
					equip(sets["PetEnmity"])
					puppet_overrides["Enmity"].active = true
					break
				end
			end
		end
	end
end

function check_auto_stuff(new, old)
	if auto_maneuvers and player.in_combat then
		local recasts = windower.ffxi.get_ability_recasts()
		if pet.isvalid then
			if pet.status ~= "Engaged" and player.target ~= nil and player.target.x ~= nil then
				local x = math.abs(player.x - player.target.x)
				local y = math.abs(player.y - player.target.y)
				x = (x*x)
				y = (y*y)
				if x + y <= 36 then
					send_command('input /ja Deploy <t>')
				end
			elseif not recasts[210] or recasts[210] == 0 then
				for i = 1, 3 do
					local maneuver = maneuver_cast[i]
					if buffactive[maneuver] == nil or buffactive[maneuver] < target_maneuver_count[maneuver] then				
						send_command('input /ja "' .. maneuver .. '" <me>')
						return
					end
				end
			end
		else
			if not recasts[205] or recasts[205] == 0 then
				send_command('input /ja Activate <me>')
			elseif not recasts[115] or recasts[115] == 0 then
				send_command('input /ja "Deus Ex Automata" <me>')
			end
		end
	end
	check_auto_enmity()
	update_puppet_info()
end

function parse_pup_action(act)
	if pet.isvalid and puppet_overrides["Enmity"].active == true then
		local abil_ID = act['param'] - 256
		local actor_id = act['actor_id']
		local player_id = windower.ffxi.get_player().id
		local pet_index = windower.ffxi.get_mob_by_id(player_id)['pet_index']
		if autoabils[abil_ID] and windower.ffxi.get_mob_by_id(actor_id)['index'] == pet_index and pet_index ~= nil then
			puppet_overrides["Enmity"].active = false
			puppet_overrides["Enmity"].ready_time[abil_ID] = os.clock() + autoabils[abil_ID].recast
			aftercast()
		end
	end
end

windower.raw_register_event('time change', check_auto_stuff)
windower.raw_register_event('action', parse_pup_action)