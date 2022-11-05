include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	tp_bonus_gear = {
		["head"] = { name = "Mpaca's Cap", bonus = 200 },
	}
	
	ws = {}
	ws["Impulse Drive"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["Sonic Thrust"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["Stardiver"] = { set = sets["Stardiver"], tp_bonus = false }
	ws["SO_Impulse Drive"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["SO_Sonic Thrust"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["SO_Stardiver"] = { set = sets["Stardiver"], tp_bonus = true }
	
	ws["Tachi: Enpi"] = { set = sets["Stardiver"], tp_bonus = true }
	ws["Tachi: Hobaku"] = { set = sets["Tachi: Fudo"], tp_bonus = false }
	ws["Tachi: Goten"] = { set = sets["Tachi: Goten"], tp_bonus = true }
	ws["Tachi: Kagero"] = { set = sets["Tachi: Goten"], tp_bonus = true }
	ws["Tachi: Koki"] = { set = sets["Tachi: Goten"], tp_bonus = true }
	ws["Tachi: Yukikaze"] = { set = sets["Tachi: Fudo"], tp_bonus = true }
	ws["Tachi: Gekko"] = { set = sets["Tachi: Fudo"], tp_bonus = true }
	ws["Tachi: Kasha"] = { set = sets["Tachi: Fudo"], tp_bonus = true }
	ws["Tachi: Rana"] = { set = sets["Stardiver"], tp_bonus = false }
	ws["Tachi: Ageha"] = { set = sets["Tachi: Fudo"], tp_bonus = false }
	ws["Tachi: Fudo"] = { set = sets["Tachi: Fudo"], tp_bonus = true }
	ws["Tachi: Shoha"] = { set = sets["Stardiver"], tp_bonus = true }
	
	send_command('@input /macro book 24;')
	sub_job_change(player.sub_job)
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function subjob_macro_page(job)
	if job == "WAR" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "DRG" then
		send_command('@wait 1;input /macro set 2')
	else
		send_command('@wait 1;input /macro set 1')
	end
end

function custom_precast(spell)
	if spell.type == "Weaponskill" then
		if player.equipment.main == "Shining One" then
			if ws["SO_" .. spell.english] then equip(ws["SO_" .. spell.english].set)
			elseif ws[spell.english] then equip(ws[spell.english].set) end
			if player.tp < 3000 then
				equip(sets["TPBonus"])
			end
			return true
		elseif buffactive["Sekkanoki"] then
			if ws and ws[spell.english] then
				local setToUse = nil
				if sets[modes[mode].name .. spell.english] then setToUse = sets[modes[mode].name .. spell.english]
				else setToUse = ws[spell.english].set end
				if ws[spell.english].tp_bonus then
					local maxTP = 3000
					if tp_bonus_gear then 
						for slot, data in pairs(tp_bonus_gear) do
							if player.equipment[slot] == data.name then
								maxTP = maxTP - data.bonus
							end
						end
					end
					if player.tp < maxTP then
						setToUse = set_combine(setToUse, sets["TPBonus"])
					end
				end
				if spell.element == world.weather_element or spell.element == world.day_element then 
					setToUse = set_combine(setToUse, sets["WeatherObi"])
				end
				if killer_effect then
					setToUse = set_combine(setToUse, sets["KillerEffect"])
				end
				setToUse = set_combine(setToUse, sets["Sekkanoki"])
				equip(setToUse)
			end
		end
	end
end