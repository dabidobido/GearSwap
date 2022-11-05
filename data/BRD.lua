include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 0
	
	ws = {}
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	
	ws["Retribution"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Shattersoul"] = { set = sets["Savage Blade"], tp_bonus = true }
	
	sets["Midcast_Aero"] = sets["MagicBurst"]
	sets["Midcast_Aero II"] = sets["MagicBurst"]
	sets["Midcast_Anemohelix"] = sets["MagicBurst"]
	
	sets["Midcast_Klimaform"] = sets["EnhDuration"]
	sets["Midcast_Windstorm"] = sets["EnhDuration"]
	
	sets["Midcast_Wind Threnody II"] = sets["SongDuration"]
	
	sets["Midcast_Victory March"] = sets["SongDuration"]
	sets["Midcast_Blade Madrigal"] = sets["SongDuration"]
	sets["Midcast_Learned Etude"] = sets["SongDuration"]
	sets["Midcast_Sage Etude"] = sets["SongDuration"]
	sets["Midcast_Chocobo Mazurka"] = sets["SongDuration"]
	
	sets["Precast_Goblin Gavotte"] = sets["DummyFastcast"]
	sets["Midcast_Goblin Gavotte"] = sets["DummySong"]
	sets["Precast_Herb Pastoral"] = sets["DummyFastcast"]
	sets["Midcast_Herb Pastoral"] = sets["DummySong"]
	
	send_command('@input /macro book 23;wait 1;input /macro set 1')
end

function custom_precast(spell)
	if spell.type == "BardSong" and not sets["Precast_" .. spell.english] then
		equip(sets["SongFastcast"])
		return true
	end
end