include("MasterGear/MasterGearLua.lua")
texts = require('texts')
packets = require('packets')
require('chat')

ranger_info = [[${ammo_name}:${ammo_count}
flurry: ${flurry|0}
True Strike: ${distance_correction}
Last Attack: ${dmg}
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
	
	if not (ranger_info_hub == nil) then
        texts.destroy(ranger_info_hub)
    end
    ranger_info_hub = texts.new(ranger_info, default_settings, default_settings)

    ranger_info_hub:show()
end


function custom_get_sets()
	flurry = 0
	triple_shot = false
	AM3Mode = false
	DT = false
	cancel_haste = 1
	roll_range = true
	quick_draw = "Light Shot"
	auto_pouch = nil
	auto_pouch_time = 0
	using_pouch = false
	time_use_pouch = 0
	check_pouch_use = 0
	
	setup_text_window()
		
	ws = {}
	ws["Hot Shot"] = { set = sets["Wildfire"], tp_bonus = true }
	ws["Leaden Salute"] = { set = sets["Leaden Salute"], tp_bonus = true }
	ws["Wildfire"] = { set = sets["Wildfire"], tp_bonus = false }
	ws["Detonator"] = { set = sets["Last Stand"], tp_bonus = true }
	ws["Last Stand"] = { set = sets["Last Stand"], tp_bonus = true }
	
	ws["Shining Blade"] = { set = sets["Wildfire"], tp_bonus = true }
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	ws["Aeolian Edge"] = { set = sets["Wildfire"], tp_bonus = true }
	
	check_buffs()
	update_rng_info()	
	
	send_command('@input /macro book 6;wait 1;input /macro set 1')
end

function custom_precast(spell)
	if spell.action_type == "Ranged Attack" then
		equip(get_preshot_set())
		return true
    elseif spell.type=="WeaponSkill" then
		if ws[spell.english] then
			local setToUse = ws[spell.english].set
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				local equipment = windower.ffxi.get_items().equipment
				local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)
				if (res.items[range.id].name == "Fomalhaut" and spell.skill == "Marksmanship") then
					maxTP = maxTP - 500
				end
				if player.sub_job == "WAR" then
					maxTP = maxTP - 200
				end
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			equip(setToUse)
		end
		return true
	elseif spell.type == "CorsairRoll" then
		equip(sets["Precast_Phantom Roll"])
		if roll_range then equip(sets["Roll Range"]) end
		return true
	elseif spell.type == "CorsairShot" then
		equip(sets["Quick Draw"])
		return true
    end
end

function custom_midcast(spell)
	if spell.action_type == "Ranged Attack" then	
		local setToUse = sets["Midshot"]
		if DT then setToUse = sets["MidshotDT"] end
		if triple_shot then setToUse = set_combine(setToUse, sets["Triple Shot"]) end
		if buffactive["aftermath: lv.3"] then
			local equipment = windower.ffxi.get_items().equipment
			local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)
			if res.items[range.id].name == "Armageddon" then
				if DT then 
					setToUse = set_combine(setToUse, sets["AM3DT"])
				else 
					setToUse = set_combine(setToUse, sets["AM3"])
				end
			end
		end
		equip(setToUse)
		return true
	end
end
 
function custom_aftercast(spell)
	update_rng_info()
end
 
function custom_command(args)
	if args[1] == "dt" then
		if DT == false then
			add_to_chat(122, "DT true")
			DT = true
		elseif DT == true then
			add_to_chat(122, "DT false")
			DT = false
		end
	elseif args[1] == "rollrange" then
		if args[2] then
			if args[2] == "on" then roll_range = true
			elseif args[2] == "off" then roll_range = false
			end
		else
			roll_range = not roll_range
		end
		add_to_chat(122, "Roll Range: " .. tostring(roll_range))
	elseif args[1] == "qd" then
		if args[2] then 
			if args[2] == "light" then quick_draw = "Light Shot"
			elseif args[2] == "dark" then quick_draw = "Dark Shot"
			elseif args[2] == "earth" then quick_draw = "Earth Shot"
			elseif args[2] == "wind" then quick_draw = "Wind Shot"
			elseif args[2] == "ice" then quick_draw = "Ice Shot"
			elseif args[2] == "water" then quick_draw = "Water Shot"
			elseif args[2] == "fire" then quick_draw = "Fire Shot"
			elseif args[2] == "thunder" then quick_draw = "Thunder Shot"
			end
			add_to_chat(122, "Quick Draw: " .. quick_draw)
		else
			send_command('input /ja "' .. quick_draw .. '" <stnpc>')
		end
	elseif args[1] == "autopouch" then
		if args[2] then
			local pouch = ""
			for i = 2, #args, 1 do
				pouch = pouch .. args[i] .. " "
			end
			pouch = string.sub(pouch, 1, #pouch - 1)
			auto_pouch = pouch
			add_to_chat(122, "Auto Pouch: " .. tostring(auto_pouch))
		else
			auto_pouch = nil
			add_to_chat(122, "Auto Pouch Off")
		end
	end
end

function get_preshot_set()
	local set_to_use = {}
	if flurry == 0 then set_to_use = sets["Flurry0"]
	elseif flurry == 1 then set_to_use = sets["Flurry1"]
	else set_to_use = sets["Flurry2"]
	end
	return set_to_use
end

buff_ids = 
T{
	581, -- flurry II
	265, -- flurry I
	467, -- Truple Shot
}

function check_buffs()
	local playerbuffs = windower.ffxi.get_player().buffs
	local hover_found = false
	local double_found = false
	local AM_found = false
	for k, _buff_id in pairs(playerbuffs) do
		if buff_ids:contains(_buff_id) then
			if not hover_found then
				if _buff_id == 628 then 
					hover_shot = true
					hover_found = true
				end
			end
			if not double_found then
				if _buff_id == 467 then 
					triple_shot = true
					double_found = true
				end
			end
		end
	end
	if not hover_found then hover_shot = false end
	if not double_found then triple_shot = false end
	if not AM_found then AM3Mode = false end
end

function update_rng_info()
	local items = windower.ffxi.get_items()
	if items.equipment.ammo and string.len(items.equipment.ammo) > 0 then
		ranger_info_hub.ammo_name = player.equipment.ammo
		local ammo_item = windower.ffxi.get_items(items.equipment.ammo_bag, items.equipment.ammo)
		if ammo_item and ammo_item.id ~= 65535 then 
			ranger_info_hub.ammo_count = ammo_item.count
		else
			ranger_info_hub.ammo_count = 0
		end
	else
		ranger_info_hub.ammo_count = 0
	end
	ranger_info_hub.flurry = flurry
end

function buff_change(name, gain, buff_details)
	if string.lower(name) == "flurry" and not gain then
		flurry = 0
	end
	check_buffs()
	update_rng_info()
end

local spells_started = {}

local function get_flurry_level(id)
	if id == 845 or id == 228 then return 1
	elseif id == 846 then return 2
	else return 0
	end
end

local function set_spells_started(add, id, actor_id)
	if add then
		spells_started[actor_id] = id
	else
		spells_started[actor_id] = nil
	end
end

local function set_flurry_level(actor_id)
	if spells_started[actor_id] then
		local level = get_flurry_level(spells_started[actor_id])
		if level > flurry then flurry = level end
		spells_started[actor_id] = nil
	end
end

function rng_action_helper(act)
	if act.category == 8 then
		if act.param == 24931 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_flurry_level(v2.param) > 0 then 
							set_spells_started(true, v2.param, act.actor_id)
							return
						end
					end
				end
			end
		elseif act.param == 28787 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_flurry_level(v2.param) > 0 then 
							set_spells_started(false, v2.param, act.actor_id)
							return
						end
					end
				end
			end
		end
	elseif act.category == 4 then -- finish casting spell
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				if get_flurry_level(act.param) > 0 then
					set_flurry_level(act.actor_id)
					return
				end
			end
		end
	elseif act.category == 2 then -- ranged attack
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				local dmg = 0
				local shots = 0
				for k2, v2 in pairs(v.actions) do
					dmg = dmg + v2.param
					shots = shots + 1
					if v2.message == 352 then 
						ranger_info_hub.distance_correction = "..."
					elseif v2.message == 576 then
						ranger_info_hub.distance_correction = "Squarely."
					elseif v2.message == 577 then
						ranger_info_hub.distance_correction = "True!"
					end
				end
				if shots == 1 then
					ranger_info_hub.dmg = dmg
				else
					ranger_info_hub.dmg = dmg .. "[" .. shots .. "]"
				end
			end
		end
	elseif act.category == 3 then -- ws
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				for k2, v2 in pairs(v.actions) do
					if v2.message == 188 then
						ranger_info_hub.dmg = 0
					else 
						ranger_info_hub.dmg = v2.param 
					end
				end
			end
		end
	elseif act.category == 9 and auto_pouch ~= nil then -- start usage
		if act.actor_id == player.id and act.param == 24931 then
			using_pouch = true
			time_use_pouch = os.clock()
			check_pouch_use = 0
			add_to_chat(122, "Using Pouch")
		end
	elseif act.category == 5 and using_pouch then
		if act.actor_id == player.id then
			using_pouch = false
			enable('waist')
			auto_pouch_time = os.clock()
			add_to_chat(122, "Used Pouch Success")
		end
	end
end

function parse_time_change(new, old)
	if auto_pouch ~= nil then
		local time_now = os.clock()
		if not using_pouch and (time_now - auto_pouch_time > 3720 or (check_pouch_use ~= 0 and time_now - check_pouch_use > 5)) then
			auto_pouch_time = os.clock()
			check_pouch_use = time_now + 11
			disable('waist')
			send_command('input /equip waist "' .. auto_pouch .. '";wait 11;input /item "' .. auto_pouch .. '" <me>')
		elseif using_pouch and time_now - time_use_pouch > 5 then
			add_to_chat(122, "Didn't use pouch for some reason, trying to use again")
			send_command('input /item "' .. auto_pouch .. '" <me>')
		end
	end
end

windower.raw_register_event('action', rng_action_helper)
windower.raw_register_event('time change', parse_time_change)