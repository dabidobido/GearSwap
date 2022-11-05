include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Impulse Drive"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["Camlann's Torment"] = { set = sets["Camlann's Torment"], tp_bonus = false }
	ws["Sonic Thrust"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	ws["Drakesbane"] = { set = sets["Drakesbane"], tp_bonus = true }
	ws["Stardiver"] = { set = sets["Stardiver"], tp_bonus = false }
	ws["Raiden Thrust"] = { set = sets["Raiden Thrust"], tp_bonus = true }
	
	ws["SO_Impulse Drive"] = { set = sets["SO_Impulse Drive"], tp_bonus = true }
	ws["SO_Camlann's Torment"] = { set = sets["SO_Camlann's Torment"], tp_bonus = true }
	ws["SO_Sonic Thrust"] = { set = sets["SO_Camlann's Torment"], tp_bonus = true }
	ws["SO_Drakesbane"] = { set = sets["SO_Drakesbane"], tp_bonus = true }
	ws["SO_Stardiver"] = { set = sets["SO_Drakesbane"], tp_bonus = true }
	
	ws["Savage Blade"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	ws["Circle Blade"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	
	ws["Earth Crusher"] = { set = sets["Raiden Thrust"], tp_bonus = true }
	ws["Cataclysm"] = { set = sets["Cataclysm"], tp_bonus = true }
	ws["Retribution"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	ws["Full Swing"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	
	sets["Precast_Jump"] = sets["Jump"]
	sets["Precast_High Jump"] = sets["Jump"]
	sets["Precast_Spirit Jump"] = set_combine(sets["Jump"], sets["Spirit Jump"])
	sets["Precast_Soul Jump"] = sets["Jump"]
	
	send_command('@input /macro book 14')
	subjob_macro_page(player.sub_job)
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function subjob_macro_page(job)
	if job == "SAM" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "RUN" then
		send_command('@wait 1;input /macro set 2')
	elseif job == "WAR" then
		send_command('@wait 1;input /macro set 3')
	elseif job == "NIN" then
		send_command('@wait 1;input /macro set 4')
	end
end

function custom_precast(spell)
	if spell.type == "WeaponSkill" then
		if player.equipment.main == "Shining One" then
			if ws["SO_" .. modes[mode].name .. spell.english] then equip(ws["SO_" .. modes[mode].name .. spell.english].set)
			elseif ws["SO_" .. spell.english] then equip(ws["SO_" .. spell.english].set)
			elseif ws[spell.english] then equip(ws[spell.english].set) end
			if player.tp < 3000 then
				equip(sets["TPBonus"])
			end
			if buffactive["Elvorseal"] then
				equip({feet = "Hervor Sollerets"})
			end
			return true
		end
	end
end

function custom_command(args)
	if args[1] == "tpja" then
		local recasts = windower.ffxi.get_ability_recasts()
		if recasts[167] and recasts[167] == 0 and pet.isvalid then
			windower.send_command('input /ja "Soul Jump" <t>')
		elseif recasts[166] and recasts[166] == 0 and pet.isvalid then
			windower.send_command('input /ja "Spirit Jump" <t>')
		elseif recasts[162] and recasts[162] == 0 and pet.isvalid and pet.tp / 2 + player.tp >= 1000 then
			windower.send_command('input /ja "Spirit Link" <me>')
		elseif recasts[159] and recasts[159] == 0 then
			windower.send_command('input /ja "High Jump" <t>')
		elseif recasts[158] and recasts[158] == 0 then
			windower.send_command('input /ja "Jump" <t>')
		else
			windower.add_to_chat(122, "No TP JA available")
		end
	end
end

function custom_aftercast(spell)
	if buffactive["Elvorseal"] then
		if combat or player.status == "Engaged" then
			equip(modes[mode].set)
			equip({hands = "Hervor Mouffles"})
		else
			equip(sets.Idle)
		end
		return true
	end
end

function pet_midcast(spell)
	if string.find(spell.english,'Healing Breath') then
		equip(sets["Healing Breath"])
	end
end