-- Version 1.0.7

haste_level = 0
cancel_haste = 0
cancel_flurry = false
debug_log = false

local spells_started = {}
local time_to_fail = 5 -- 5 seconds then considered fail if no complete message

local function get_haste_level(id)
	if id == 57 or id == 358 or id == 595 then return 1 -- 57: Haste, 358,595: Hastega,
	elseif id == 511 or id == 710 or id == 602 then return 2 -- 511: Haste II, 710: Erratic Flutter, 602: Hastega II
	else return 0
	end
end

local function set_spells_started(add, id, actor_id)
	if add then
		spells_started[actor_id] = { spell_id = id, time_started = os.time() }
	else
		spells_started[actor_id] = nil
	end
end

local function set_haste_level(actor_id)
	if spells_started[actor_id] then
		local level = get_haste_level(spells_started[actor_id].spell_id)
		if debug_log then windower.add_to_chat(122, actor_id .. " finished " .. spells_started[actor_id].spell_id) end
		if level > haste_level then haste_level = level end
		spells_started[actor_id] = nil	
	end
end

local function parse_action(act)
	if act.category == 8 or act.category == 7 then
		if act.param == 24931 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_haste_level(v2.param) > 0 then
							if debug_log then windower.add_to_chat(122,act.actor_id .. " started " .. v2.param .. " on " .. v.id) end
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
						if get_haste_level(v2.param) > 0 then
							if debug_log then windower.add_to_chat(122, act.actor_id .. " stopped " .. v2.param) end
							set_spells_started(false, v2.param, act.actor_id)
							return
						end
					end
				end
			end
		end
	elseif act.category == 4 or act.category == 13 then -- finish casting spell
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				if get_haste_level(act.param) > 0 then
					set_haste_level(act.actor_id)
					return
				end
			end
		end
	elseif act.category == 11 and act.param == 3814 then -- Ygnas Phototropic Wrath
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				haste_level = 2
				return
			end
		end
	end
end

local function cancel_buff(id)
	windower.packets.inject_outgoing(0xF1,string.char(0xF1,0x04,0,0,id%256,math.floor(id/256),0,0)) -- Inject the cancel packet
end

local function have_spells_started()
	for k,v in pairs(spells_started) do
		return true
	end
	return false
end

local function check_spell_started()
	if spells_started then
		local time_now = os.time()
		for k, v in pairs(spells_started) do
			if time_now > v.time_started +  time_to_fail then
				if debug_log then windower.add_to_chat(122, k .. " took too long for " .. v.spell_id) end
				spells_started[k] = nil -- too long already, probably failed
			end
		end
		return have_spells_started()
	end
	return false
end

local function time_change(new, old)
	if not check_spell_started() then -- if someone still casting spell on player then don't cancel
		local playerbuffs = windower.ffxi.get_player().buffs
		if cancel_haste > 0 and cancel_haste >= haste_level then
			for k, _buff_id in pairs(playerbuffs) do
				if _buff_id == 33 then
					if debug_log then windower.add_to_chat(122, "cancelling haste because of buff id ".. tostring(_buff_id)) end
					cancel_buff(_buff_id)
					haste_level = 0
					return
				end
			end
		end
		if cancel_flurry then
			for k, _buff_id in pairs(playerbuffs) do
				if (_buff_id == 265 or _buff_id == 581) then
					if debug_log then windower.add_to_chat(122, "cancelling flurry") end
					cancel_buff(_buff_id)
					return
				end
			end
		end
	end
end

local function lose_buff(id)
	if id == 33 then
		if debug_log then windower.add_to_chat(122, "lost haste buff id " .. tostring(id)) end
		haste_level = 0
	end
end

local function parse_command(...)
	local args = T{...}
	local arg1 = string.lower(args[1])
	if arg1 == "cancelhaste" and args[2] and type(tonumber(args[2])) == 'number' then
		local cancel_haste_number = tonumber(args[2])
		if cancel_haste_number >= 0 and cancel_haste_number <= 2 then
			cancel_haste = cancel_haste_number
			windower.add_to_chat(122, "Cancelling haste level " .. cancel_haste_number .. " and below.")
		else
			windower.add_to_chat(122, cancel_haste_number .. " is not between 0 and 2")
		end
		return true
	elseif arg1 == "cancelhastedebug" then
		debug_log = not debug_log
		return true
	elseif arg1 == "cancelflurry" then
		cancel_flurry = not cancel_flurry
		windower.add_to_chat(122, "Cancel Flurry " .. tostring(cancel_flurry))
		return true
	end
	return false
end

windower.raw_register_event('action', parse_action)
windower.raw_register_event('time change', time_change)
windower.raw_register_event('lose buff', lose_buff)
register_unhandled_command(parse_command)