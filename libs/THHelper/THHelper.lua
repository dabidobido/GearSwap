-- Version 1.0.3

--packets = require('packets')

MobsTagged = {}
TimeToDead = 300 -- 5mins then remove from table
THMode = 1
THModes = { 
	{ name = "Off", 		thfMain = false,	onEngage = false, 	fulltime = false },
	{ name = "Tag", 		thfMain = false, 	onEngage = true, 	fulltime = false },
	{ name = "FullTime", 	thfMain = true, 	onEngage = true, 	fulltime = true },
}

SlotsUsed = S{}
AmmoDisabled = false
THEquipped = false

function parse_th_command(...)
	local args = T{...}
	if args[1] == "th" then
		if args[2] and type(tonumber(args[2])) == 'number' then
			local nextMode = tonumber(args[2])
			if THModes[nextMode] == nil then
				add_to_chat(122, "Invalid TH mode number")
			else
				if THModes[nextMode].thfMain == false then
					THMode = nextMode
				elseif THModes[nextMode].thfMain and player.main_job == "THF" then
					THMode = nextMode
				else
					add_to_chat(122, "Invalid TH mode number")
				end
			end
			print_th_mode()
		else		
			THMode = THMode + 1		
			if THModes[THMode] == nil or (THModes[THMode].thfMain and player.main_job ~= "THF") then 
				THMode = 1
			end
			print_th_mode()
		end
		if not THModes[THMode].fulltime then unlock_th() end 
		return true
	end
	return false
end

function equip_th(id)
	if THModes[THMode].onEngage then
		if not mob_tagged(id) then
			equip(sets["TH"])
			for slot,item in pairs(sets["TH"]) do
				SlotsUsed:append(slot)
			end
			disable(SlotsUsed)
			THEquipped = true
		end
	end
end

function unlock_th()
	for index, slot in pairs(SlotsUsed) do
		if AmmoDisabled then 
			if slot ~= "ammo" then enable(slot) end
		else
			enable(slot)
		end
	end
	THEquipped = false
	SlotsUsed = S{}
end

function on_target_change_for_th(id)
	if gearswap.gearswap_disabled then return end
	if THModes[THMode].onEngage then
		equip_th(id)
	end
end

function parse_action(act)
	if not THEquipped then return end
	if not THModes[THMode].onEngage then return end	
	local player = windower.ffxi.get_player()
	if act.actor_id == player.id then -- add to MobsTagged if player initiated attack
		if act.category == 1 or act.category == 3 then -- 1 = melee, 3 = ws
			for index, target in pairs(act.targets) do				
				MobsTagged[target.id] = os.clock()
			end
		end
		if player.target_index ~= nil and player.target_index ~= 0 and mob_tagged(windower.ffxi.get_mob_by_index(player.target_index).id) and not THModes[THMode].fulltime then
			unlock_th()
			send_command('gs c thtagged')
		end
	elseif MobsTagged[act.actor_id] then -- update timeToDead
		MobsTagged[act.actor_id] = os.clock()
	end
	
end

function clear_tags()
	MobsTagged = {}
	unlock_th()
end

function mob_tagged(mobId)
	return MobsTagged[mobId] ~= nil
end

function clean_up_tags(new, old)
	-- clean up stuff that haven't done anything for 5 mins
	local timeToCheck = os.clock() - TimeToDead
	for id, timeTagged in pairs(MobsTagged) do
		if timeTagged < timeToCheck then
			MobsTagged[id] = nil
		end
	end
end

function print_th_mode()
	local printString = "Current THMode: "
	local isThfMain = player.main_job == "THF"
	for i = 1, #THModes, 1 do
		local toPrint = THModes[i].thfMain == false or (THModes[i].thfMain == true and isThfMain)
		if toPrint then
			if i == THMode then
				printString = printString .. "[" .. i .. ":" .. THModes[i].name .. "] "
			elseif THModes[i] == nil then
				break
			else
				printString = printString .. i .. ":" .. THModes[i].name .. " "
			end
		end
	end	
	add_to_chat(122, printString)
end

function check_mode(modeNumber)
	add_to_chat(122, modeNumber)
	if THModes[modeNumber] == nil then
		THMode = 1
	else
		if THModes[modeNumber].thfMain == false then 
			THMode = modeNumber
		elseif THModes[modeNumber].thfMain and player.main_job == "THF" then
			THMode = modeNumber
		else
			THMode = 1
		end
	end
end

function on_status_change_for_th(new_status, old_status)
    if new_status == "Engaged" then -- engaged
		local target_index = windower.ffxi.get_player().target_index
		if target_index then 
			local mob = windower.ffxi.get_mob_by_index(target_index)
			if mob then
				on_target_change_for_th(mob.id)
			end
		end
    elseif new_status == "Idle" then
        unlock_th()
    end
end

function parse_action_message(actor_id, target_id, actor_index, target_index, message_id, param_1, param_2, param_3)
	-- Remove mobs that die from our tagged mobs list.
	if MobsTagged[target_id] then
		-- 6 == actor defeats target
		-- 20 == target falls to the ground
		if message_id == 6 or message_id == 20 then
			MobsTagged[target_id] = nil
		end
	end
end

function reset()
	AmmoDisabled = false
	THEquipped = false
	enable("main", "sub", "range", "ammo", "head", "neck", "ear1", "ear2", "body", "hands", "ring1", "ring2", "back", "waist", "legs", "feet")
end

windower.raw_register_event('action', parse_action)
windower.raw_register_event('action message', parse_action_message)
windower.raw_register_event('zone change', clear_tags)
windower.raw_register_event('time change', clean_up_tags)
windower.raw_register_event('job change', reset)
register_unhandled_command(parse_th_command)