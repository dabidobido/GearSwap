include("MasterGear/MasterGearLua.lua")
texts = require('texts')
require('chat')

ranger_info = [[${ammo_name}:${ammo_count}
Flurry: ${flurry|0}
Hover Shot: ${distance}
True Strike: ${distance_correction}
Last Attack: ${dmg}
Shooting Status: ${shoot_status}
]]

shoot_statuses = 
{
	["Idle"] = string.text_color("Idle", 0, 255, 0),
	["Shooting"] = string.text_color("Shooting", 255, 255, 0),
	["Interrupted"] = string.text_color("Interrupted", 255, 0, 0),
	["Shot"] = string.text_color("Shot", 0, 255, 0),
	["Wait Longer"] = string.text_color("Wait Longer", 255, 0, 0),
	["Too Far"] = string.text_color("Too Far", 255, 0, 0),
}

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
	double_shot = false
	hover_shot = false
	last_shot_position_x = 0
	last_shot_position_y = 0
	last_shot_position_valid = false
	current_position_0x015_x = 0
	current_position_0x015_y = 0
	shot_position_0x015_x = 0 
	shot_position_0x015_y = 0
	AM3Mode = false
	DT = false
	ShootNextPosUpdate = false
	AssistedShooting = false
	AssistedShootingID = nil
	RecordPosNextRangedAttack = false
	HoverShotTarget = nil
	cancel_haste = 0
	shoot_status = "Idle"
	
	setup_text_window()
		
	ws = {}
	ws["Hot Shot"] = { set = sets["Trueflight"], tp_bonus = true }
	ws["Trueflight"] = { set = sets["Trueflight"], tp_bonus = true }
	ws["Wildfire"] = { set = sets["Trueflight"], tp_bonus = false }
	ws["Split Shot"] = { set = sets["Blast Shot"], tp_bonus = false }
	ws["Slug Shot"] = { set = sets["Blast Shot"], tp_bonus = false }
	ws["Blast Shot"] = { set = sets["Blast Shot"], tp_bonus = false }
	ws["Heavy Shot"] = { set = sets["Heavy Shot"], tp_bonus = false }
	ws["Last Stand"] = { set = sets["Last Stand"], tp_bonus = true }
	ws["Sniper Shot"] = { set = sets["Sniper Shot"], tp_bonus = false }
	
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	ws["Viper Bite"] = { set = sets["Viper Bite"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["Aeolian Edge"], tp_bonus = true, hauksbok_bullet = true }
	
	ws["Burning Blade"] = { set = sets["Aeolian Edge"], tp_bonus = true, hauksbok_bullet = true }
	ws["Red Lotus Blade"] = { set = sets["Aeolian Edge"], tp_bonus = true, hauksbok_bullet = true }
	ws["Flat Blade"] = { set = sets["Savage Blade"], tp_bonus = true, hauksbok_arrow = true }
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true, hauksbok_arrow = true }
	
	ws["Smash Axe"] = { set = sets["Savage Blade"], tp_bonus = false, hauksbok_arrow = true }
	ws["Avalanche Axe"] = { set = sets["Savage Blade"], tp_bonus = true, hauksbok_arrow = true }
	ws["Raging Axe"] = { set = sets["Decimation"], tp_bonus = true, hauksbok_arrow = true }
	ws["Ruinator"] = { set = sets["Decimation"], tp_bonus = false, hauksbok_arrow = true }
	ws["Decimation"] = { set = sets["Decimation"], tp_bonus = false, hauksbok_arrow = true }
	
	ws["Blast Arrow"] = { set = sets["Dulling Arrow"], tp_bonus = false }
	ws["Dulling Arrow"] = { set = sets["Dulling Arrow"], tp_bonus = false }
	ws["Flaming Arrow"] = { set = sets["Flaming Arrow"], tp_bonus = true }
	ws["Empyreal Arrow"] = { set = sets["Apex Arrow"], tp_bonus = true }
	ws["Apex Arrow"] = { set = sets["Apex Arrow"], tp_bonus = false }
	ws["Jishnu's Radiance"] = { set = sets["Jishnu's Radiance"], tp_bonus = true }
	ws["Namas Arrow"] = { set = sets["Apex Arrow"], tp_bonus = false }
	
	check_buffs()
	update_rng_info()	
	
	send_command('@input /macro book 7;wait 1;input /macro set 1')
end

function custom_precast(spell)
	if player.equipment.ammo == "Hauksbok Arrow" then
		equip({ammo = "Chrono Arrow"})
	end
	if player.equipment.ammo == "Hauksbok Bullet" then
		equip({ammo = "Chrono Bullet"})
	end
	if spell.action_type == "Ranged Attack" then
		equip(get_preshot_set())
		return true
    elseif spell.type=="WeaponSkill" then
		if ws[spell.english] then
			local setToUse = ws[spell.english].set
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if (player.equipment.range == "Fomalhaut" and spell.skill == "Marksmanship")
				or (player.equipment.range == "Fail-Not" and spell.skill == "Archery") then
					maxTP = maxTP - 500
				end
				if player.equipment.range == "Accipiter" then
					maxTP = maxTP - 1000
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
			if (player.equipment.range == "Accipiter" or player.equipment.range == "Gandiva")
			and ws[spell.english].hauksbok_arrow
			then
				equip({ammo = "Hauksbok Arrow"})
			end
			if (player.equipment.range == "Armageddon" or player.equipment.range == "Ataktos")
			and ws[spell.english].hausbok_bullet
			then
				equip({ammo = "Hauksbok Bullet"})
			end
		end
		return true
    end
end

function custom_midcast(spell)
	if spell.action_type == "Ranged Attack" then	
		local setToUse = sets["Midshot"]
		if DT then setToUse = sets["MidshotDT"] end
		if double_shot then setToUse = set_combine(setToUse, sets["Double Shot"]) end		
		if buffactive["aftermath: lv.3"] then
			if player.equipment.range == "Armageddon" or player.equipment.range == "Gandiva" then
				if DT then 
					setToUse = set_combine(setToUse, sets["AM3DT"])
				else 
					setToUse = set_combine(setToUse, sets["AM3"])
				end
			end
		end
		if buffactive["barrage"] then setToUse = set_combine(setToUse, sets["Barrage"]) end
		equip(setToUse)
		return true
	end
end
 
function custom_aftercast(spell)
	update_rng_info()
	if player.equipment.ammo == "Hauksbok Arrow" then
		equip({ammo = "Chrono Arrow"})
	elseif player.equipment.ammo == "Hauksbok Bullet" then
		equip({ammo = "Chrono Bullet"})
	end
end
 
function get_distance_sq(playerpos)
	if last_shot_position_valid and playerpos then
		local x = math.abs(last_shot_position_x - playerpos.x)
		local y = math.abs(last_shot_position_y - playerpos.y)
		x = (x*x)
		y = (y*y)
		return x + y
	end
	return 0
end

function check_current_and_player_position(playerpos)
	local x = math.abs(last_shot_position_x - playerpos.x)
	local y = math.abs(last_shot_position_y - playerpos.y)
	x = (x*x)
	y = (y*y)
	return x + y < 0.01
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
	elseif args[1] == "ra" then
		local playerpos = windower.ffxi.get_mob_by_target('me')
		if hover_shot then
			if last_shot_position_valid then
				local distance = get_distance_sq(playerpos)
				if distance > 1 or HoverShotTarget == nil or HoverShotTarget ~= player.target.id then
					shoot_now_or_wait_for_pos_update(playerpos)
				else
					windower.add_to_chat(123,"Not far enough for hover shot!")
				end
			else
				shoot_now_or_wait_for_pos_update(playerpos)
			end
		else
			shoot_now_or_wait_for_pos_update(playerpos)
		end
	elseif args[1] == "raassist" then
		AssistedShooting = not AssistedShooting
		if AssistedShooting then
			AssistedShootingID = windower.register_event('outgoing chunk', parse_outgoing)
		else
			windower.unregister_event(AssistedShootingID)
		end
	end
end

function shoot_now_or_wait_for_pos_update(playerpos)
	local can_shoot = not AssistedShooting or check_current_and_player_position(playerpos)
	if can_shoot then
		windower.send_command('input /ra <t>')
		shot_position_0x015_x = playerpos.x
		shot_position_0x015_y = playerpos.y
		if hover_shot then
			RecordPosNextRangedAttack = true
		end
	else
		ShootNextPosUpdate = true
		RecordPosNextRangedAttack = false
	end
	shoot_status = "Shooting"
	update_rng_info()
end

function get_preshot_set()
	local set_to_use = {}
	if flurry == 0 then set_to_use = sets["Flurry0"]
	elseif flurry == 1 then set_to_use = sets["Flurry1"]
	else set_to_use = sets["Flurry2"]
	end
	local equipment = windower.ffxi.get_items().equipment
	local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)		
	if res.items[range.id].skill == 25 then -- archery
		set_to_use = set_combine(set_to_use, sets["Arrow"])
	elseif res.items[range.id].skill == 26 then -- marksmanship
		if res.items[range.id].name == "Gastraphetes" then
			set_to_use = set_combine(set_to_use, sets["Bolt"])
		else
			set_to_use = set_combine(set_to_use, sets["RangedAttackBullet"])
		end
	end
	return set_to_use
end

buff_ids = 
T{
	581, -- flurry II
	265, -- flurry I
	628, -- Hover Shot
	433, -- Double Shot
	845, -- Embrava
}

function check_buffs()
	local playerbuffs = windower.ffxi.get_player().buffs
	local hover_found = false
	local double_found = false
	local AM_found = false
	flurry = 0
	for k, _buff_id in pairs(playerbuffs) do
		if buff_ids:contains(_buff_id) then
			if not hover_found then
				if _buff_id == 628 then 
					hover_shot = true
					hover_found = true
				end
			end
			if not double_found then
				if _buff_id == 433 then 
					double_shot = true
					double_found = true
				end
			end
			flurry = flurry + get_flurry_level(buff_id)
		end
	end
	if not hover_found then hover_shot = false end
	if not double_found then double_shot = false end
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
	ranger_info_hub.shoot_status = shoot_statuses[shoot_status]
end

function buff_change(name, gain, buff_details)
	check_buffs()
	update_rng_info()
end

local spells_started = {}

function get_flurry_level(id)
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
	elseif act.category == 12 then
		if act.param == 28787 then -- ranged attack interrupted
			RecordPosNextRangedAttack = false
			shoot_status = "Interrupted"
			update_rng_info()
		end
	elseif act.category == 2 then -- ranged attack
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				local dmg = 0
				local shots = 0
				if hover_shot then HoverShotTarget = v.id end
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
			if RecordPosNextRangedAttack then
				RecordPosNextRangedAttack = false
				last_shot_position_valid = true
				last_shot_position_x = shot_position_0x015_x
				last_shot_position_y = shot_position_0x015_y
			end
			shoot_status = "Shot"
			update_rng_info()
		end
	elseif act.category == 3 then -- ws
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				if hover_shot then HoverShotTarget = v.id end
				for k2, v2 in pairs(v.actions) do
					if v2.message == 188 then
						ranger_info_hub.dmg = 0
					else 
						ranger_info_hub.dmg = v2.param 
					end
				end
			end
			if hover_shot then
				local ws = res.weapon_skills[act.param]
				if ws and (ws.skill == 26 or ws.skill == 25)then
					local playerpos = windower.ffxi.get_mob_by_target('me')
					if playerpos then 
						last_shot_position_valid = true
						last_shot_position_x = playerpos.x
						last_shot_position_y = playerpos.y
					end
				end
			end
		end
	end
end

function update_hover_shot_info()
	if hover_shot then
		local playerpos = windower.ffxi.get_mob_by_target('me')
		local distance = math.sqrt(get_distance_sq(playerpos))
		local distance_string = string.format("%.2f", distance)
		if distance >= 1 or HoverShotTarget == nil then distance_string = string.text_color(distance_string, 0, 255, 0)
		else distance_string = string.text_color(distance_string, 255, 0, 0) end
		ranger_info_hub.distance = distance_string
	else
		ranger_info_hub.distance = nil
	end
end

function clear_last_shot_position()
	HoverShotTarget = nil
	last_shot_position_valid = false
end

function parse_action_message(actor_id, target_id, actor_index, target_index, message_id, param_1, param_2, param_3)
	if (message_id == 6 or message_id == 20) and HoverShotTarget ~= nil and target_id == HoverShotTarget then
		clear_last_shot_position()
	elseif shoot_status == "Shooting" then
		if message_id == 94 then
			shoot_status = "Wait Longer"
			update_rng_info()
		elseif message_id == 78 then
			shoot_status = "Too Far"
			update_rng_info()
		end
	end
end

windower.raw_register_event('action', rng_action_helper)
windower.raw_register_event('prerender', update_hover_shot_info)
windower.raw_register_event('zone change', clear_last_shot_position)
windower.raw_register_event('action message', parse_action_message)