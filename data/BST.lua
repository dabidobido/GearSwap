include("Mastergear/MasterGearLua.lua")

ready = {
	["Slug"] = {
		["Ready1"] = { name = "Purulent Ooze", set = "PetMagicalTP", cost = 2 },
		["Ready2"] = { name = "Corrosive Ooze", set = "PetMagicalTP", cost = 3 },
	},
	["Raaz"] = {
		["Ready1"] = { name = "Sweeping Gouge", set = "PetPhysicalTP", cost = 1 },
		["Ready2"] = { name = "Zealous Snort", set = "PetTP", cost = 3 },
	},
	["Tulfaire"] = {
		["Ready1"] = { name = "Molting Plumage", set = "PetPhysicalTP", cost = 1 },
		["Ready2"] = { name = "Swooping Frenzy", set = "PetPhysicalTP", cost = 2 },
		["Ready3"] = { name = "Pentapeck", set = "PetPhysicalTP", cost = 3 },
	},
	["Chapuli"] = {
		["Ready1"] = { name = "Sensilla Blades", set = "PetPhysicalTP", cost = 1 },
		["Ready2"] = { name = "Tegmina Buffet", set = "PetPhysicalTP", cost = 2 },
	},
	["Acuex"] = {
		["Ready1"] = { name = "Foul Waters", set = "PetMagicalTP", cost = 2 },
		["Ready2"] = { name = "Pestilent Plume", set = "PetMagicalTP", cost = 2 },
	},
	["Leech"] = {
		["Ready1"] = { name = "Suction", set = "PetPhysicalTP", cost = 1 },
		["Ready2"] = { name = "Drain Kiss", set = "PetMagicalTP", cost = 1 },
		["Ready3"] = { name = "Acid Mist", set = "PetMagicalTP", cost = 2 },
		["Ready4"] = { name = "TP Drainkiss", set = "PetMagicalTP", cost = 2 },
	},
	["Coeurl"] = {
		["Ready1"] = { name = "Chaotic Eye", set = "PetMagicalTP", cost = 1 },
		["Ready2"] = { name = "Blaster", set = "PetMagicalTP", cost = 2 },
		["Ready3"] = { name = "Charged Whisker", set = "PetMagicalTP", cost = 2 },
		["Ready4"] = { name = "Frenzied Rage", set = "PetMagicalTP", cost = 1 },
	},
	["Lizard"] = {
		["Ready1"] = { name = "Fireball", set = "PetMagicalTP", cost = 1 },
		["Ready2"] = { name = "Secretion", set = "PetMagicalTP", cost = 1 },
		["Ready3"] = { name = "Brain Crush", set = "PetPhysicalTP", cost = 1 },
		["Ready4"] = { name = "Blockhead", set = "PetPhysicalTP", cost = 1 },
	},
}

pets = {
	["GenerousArthur"] = "Slug",
	["CaringKiyomaro"] = "Raaz",
	["VivaciousVickie"] = "Raaz",
	["AttentiveIbuki"] = "Tulfaire",
	["SwoopingZhivago"] = "Tulfaire",
	["BouncingBertha"] = "Chapuli",
	["AcuexFamiliar"] = "Acuex",
	["FluffyBredo"] = "Acuex",
	["FatsoFargann"] = "Leech",
	["LynxFamiliar"] = "Coeurl",
	["VivaciousGaston"] = "Coeurl",
	["WarlikePatrick"] = "Lizard",
}

pet_info = [[Pet Acc Mode: ${pet_acc_mode|Off}
${pet_name|none}
${info|}
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
	
	if pet_text_hub ~= nil then
        texts.destroy(pet_text_hub)
    end
    pet_text_hub = texts.new(pet_info, default_settings, default_settings)

    pet_text_hub:show()
end

function custom_get_sets()
	cancel_haste = 0
	auto_pet = false
	pet_acc_mode = false
	ws = {}
	ws["Raging Axe"] = { set = sets["Decimation"], tp_bonus = true }
	ws["Decimation"] = { set = sets["Decimation"], tp_bonus = false }
	ws["Ruinator"] = { set = sets["Decimation"], tp_bonus = false }
	ws["Calamity"] = { set = sets["Calamity"], tp_bonus = true }
	ws["Mistral Axe"] = { set = sets["Calamity"], tp_bonus = true }
	ws["Primal Rend"] = { set = sets["Primal Rend"], tp_bonus = true }
	ws["Cloudsplitter"] = { set = sets["Primal Rend"], tp_bonus = true }
	
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	ws["Viper Bite"] = { set = sets["Viper Bite"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["Primal Rend"], tp_bonus = true }
	
	ws["Savage Blade"] = { set = sets["Calamity"], tp_bonus = true }
	
	setup_text_window()
	if pet.isvalid then update_pet_info(pet.name) end
	send_command('@input /macro book 10;wait 1;input /macro set 1')
end

function pet_change(pet,gain)
	if gain then
		if not pets[pet.name] then
			add_to_chat(122, "Pls set up info for " .. pet.name)
		end
		update_pet_info(pet.name)
	else
		update_pet_info("none")
	end
end

function update_pet_info(name)
	pet_text_hub.pet_acc_mode = pet_acc_mode and "On" or "Off"
	pet_text_hub.pet_name = name
	if pets[name] then
		local infoString = ""
		if ready[pets[name]]["Ready1"] then 
			infoString = infoString .. "[CTRL+1] Ready1" .. ": " .. ready[pets[name]]["Ready1"].name .. "(" .. ready[pets[name]]["Ready1"].cost .. ")\n"
		end
		if ready[pets[name]]["Ready2"] then 
			infoString = infoString .. "[CTRL+2] Ready2" .. ": " .. ready[pets[name]]["Ready2"].name .. "(" .. ready[pets[name]]["Ready2"].cost .. ")\n"
		end
		if ready[pets[name]]["Ready3"] then 
			infoString = infoString .. "[CTRL+3] Ready3" .. ": " .. ready[pets[name]]["Ready3"].name .. "(" .. ready[pets[name]]["Ready3"].cost .. ")\n"
		end
		if ready[pets[name]]["Ready4"] then 
			infoString = infoString .. "[CTRL+4] Ready4" .. ": " .. ready[pets[name]]["Ready4"].name .. "(" .. ready[pets[name]]["Ready4"].cost .. ")\n"
		end
		
		pet_text_hub.info = infoString:sub(1, #infoString - 1)
	else
		pet_text_hub.info = ""
	end

end

function pretarget(spell)
	if spell.en == "Reward" then
		equip(sets["PetFood"])
	elseif spell.action_type == "Ranged Attack" then
		equip(sets["Throwing"])
	end
end

function sub_job_change(new, old)
	if new == "NIN" or new == "DNC" then
		sets["HybridSet"] = set_combine(sets["Hybrid"], sets["DW"])
	else
		sets["HybridSet"] = sets["Hybrid"]
	end
end
 
function custom_precast(spell)
	if spell.type == "Monster" then
        if buffactive['Unleash'] == nil then
            equip(sets["Ready"])
        end
		return true
	end
end

function pet_midcast(spell)
	if pet.isvalid and ready[pets[pet.name]] then
		for k,v in pairs(ready[pets[pet.name]]) do
			if v.name == spell.name then
				if pet_acc_mode then
					equip(sets[v.set .. "Acc"])
				else
					equip(sets[v.set])
				end
				return true
			end
		end
	end
end

function pet_aftercast(spell)
	aftercast(spell)
end

function custom_command(args)
	if args[1] == "ready" and args[2] then
		if pet.isvalid then
			if ready[pets[pet.name]] then
				if ready[pets[pet.name]][args[2]] then
					send_command('input /pet "' .. ready[pets[pet.name]][args[2]].name .. '" <me>')
				else
					add_to_chat(122, args[2] .. " doesn't exist in ready table")
				end
			else
				add_to_chat(122, "Please set up info for " .. pet.name)
			end
		end
	elseif args[1] == "autopet" then
		auto_pet = not auto_pet
		add_to_chat(122, "AutoPet: " .. tostring(auto_pet))
	elseif args[1] == "petacc" then
		pet_acc_mode = not pet_acc_mode
		add_to_chat(122, "Pet Acc Mode: " .. tostring(pet_acc_mode))
		if pet.isvalid then update_pet_info(pet.name)
		else update_pet_info("none")
		end
	elseif args[1] == "tpdraincooldown" then
		windower.send_command('input /p TP Drainkiss -> <t>;wait 10;input /p 10 sec after TP Drainkiss;wait 10;input /p 20 sec after TP Drainkiss')
	end
end

function file_unload(file_name)
	if pet_text_hub ~= nil then texts.destroy(pet_text_hub) end
end

function auto_pet(new, old)
	if auto_pet and player.in_combat then
		local recasts = windower.ffxi.get_ability_recasts()
		local ja_recasts = windower.ffxi.get_ability_recasts()
		if pet.isvalid then
			if pet.status ~= "Engaged" and player.target ~= nil then
				local x = math.abs(player.x - player.target.x)
				local y = math.abs(player.y - player.target.y)
				x = (x*x)
				y = (y*y)
				if x + y <= 36 then
					send_command('input /ja Fight <t>')
				end
			end
			if pet.hpp <= 10 and ja_recasts[94] > 0 then
				equip(sets["PetFood"])
				send_command('input /ja Reward <me>')
			end
		else
			if ja_recasts[94] == 0 then
				equip(sets["Raaz"])
				send_command('input /ja "Bestial Loyalty" <me>')
			end
		end
	end
end

windower.raw_register_event('time change', auto_pet)