include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Death Blossom"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Flat Blade"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Chant du Cygne"] = { set = sets["Chant Du Cygne"], tp_bonus = true }
	ws["Shining Blade"] = { set = sets["Shining Blade"], tp_bonus = true }
	ws["Seraph Blade"] = { set = sets["Shining Blade"], tp_bonus = true }
	ws["Red Lotus Blade"] = { set = sets["Shining Blade"], tp_bonus = true }
	ws["Sanguine Blade Blade"] = { set = sets["Sanguine Blade"], tp_bonus = false }
	
	ws["Empyreal Arrow"] = { set = sets["Empyreal Arrow"], tp_bonus = true }
	
	ws["Flash Nova"] = { set = sets["Shining Blade"], tp_bonus = false }
	ws["Shining Strike"] = { set = sets["Shining Blade"], tp_bonus = true }
	ws["Seraph Strike"] = { set = sets["Shining Blade"], tp_bonus = true }
	ws["Black Halo"] = { set = sets["Savage Blade"], tp_bonus = true }
	
	sets["Midcast_Gain-STR"] = sets["Enh500"]
	sets["Midcast_Gain-DEX"] = sets["Enh500"]
	sets["Midcast_Gain-VIT"] = sets["Enh500"]
	sets["Midcast_Gain-AGI"] = sets["Enh500"]
	sets["Midcast_Gain-INT"] = sets["Enh500"]
	sets["Midcast_Gain-MND"] = sets["Enh500"]
	sets["Midcast_Gain-CHR"] = sets["Enh500"]
	sets["Midcast_Temper"] = sets["Enh500"]
	
	sets["Midcast_Shell"] = sets["EnhDur"]
	sets["Midcast_Shell II"] = sets["EnhDur"]
	sets["Midcast_Shell III"] = sets["EnhDur"]
	sets["Midcast_Shell IV"] = sets["EnhDur"]
	sets["Midcast_Shell V"] = sets["EnhDur"]
	sets["Midcast_Protect"] = sets["EnhDur"]
	sets["Midcast_Protect II"] = sets["EnhDur"]
	sets["Midcast_Protect III"] = sets["EnhDur"]
	sets["Midcast_Protect IV"] = sets["EnhDur"]
	sets["Midcast_Protect V"] = sets["EnhDur"]
	sets["Midcast_Haste"] = sets["EnhDur"]
	sets["Midcast_Haste II"] = sets["EnhDur"]
	sets["Midcast_Flurry"] = sets["EnhDur"]
	sets["Midcast_Flurry II"] = sets["EnhDur"]
	sets["Midcast_Refresh II"] = sets["EnhDur"]
	
	sets["Midcast_Cure"] = sets["Cure"]
	sets["Midcast_Cure II"] = sets["Cure"]
	sets["Midcast_Cure III"] = sets["Cure"]
	sets["Midcast_Cure IV"] = sets["Cure"]
	sets["Midcast_Cure V"] = sets["Cure"]
	
	sets["Midcast_Dia III"] = sets["EnfDur"]
	sets["Midcast_Bio III"] = sets["EnfDur"]
	
	send_command('@input /macro book 22;wait 1;input /macro set 1')
end

function custom_midcast(spell)
	if spell.skill == "Elemental Magic" and spell.english ~= "Impact" then
		equip(sets["MagicBurst"])
		if spell.element == world.weather_element or spell.element == world.day_element then 
			equip(sets["WeatherObi"])
		end
		return true
	end
end