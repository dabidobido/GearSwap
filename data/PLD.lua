include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Savage Blade"] = { sets = sets["Savage Blade"], tp_bonus = true }
	ws["Chant Du Cygne"] = { sets = sets["Chant Du Cygne"], tp_bonus = true }
	ws["Seraph Blade"] = { sets = sets["Seraph Blade"], tp_bonus = true }
	ws["Red Lotus Blade"] = { sets = sets["Seraph Blade"], tp_bonus = true }
	ws["Sanguine Blade"] = { sets = sets["Sanguine Blade"], tp_bonus = false }
	ws["Swift Blade"] = { sets = sets["Swift Blade"], tp_bonus = false }
	ws["Requiescat"] = { sets = sets["Swift Blade"], tp_bonus = true }
	ws["Circle Blade"] = { sets = sets["Savage Blade"], tp_bonus = false }
	ws["Flat Blade"] = { sets = sets["Savage Blade"], tp_bonus = false }
	
	ws["Power Slash"] = { sets = sets["Impulse Drive"], tp_bonus = true }
	ws["Torcleaver"] = { sets = sets["Torcleaver"], tp_bonus = true }
	ws["Ground Strike"] = { sets = sets["Savage Blade"], tp_bonus = true }
	ws["Spinning Slash"] = { sets = sets["Savage Blade"], tp_bonus = true }
	ws["Scourge"] = { sets = sets["Savage Blade"], tp_bonus = false }
	ws["Resolution"] = { sets = sets["Resolution"], tp_bonus = true }
	ws["Freezebite"] = { sets = sets["Seraph Blade"], tp_bonus = true }
	ws["Herculean Slash"] = { sets = sets["Seraph Blade"], tp_bonus = false }
	
	ws["Impulse Drive"] = { sets = sets["Impulse Drive"], tp_bonus = true }
	ws["Sonic Thrust"] = { sets = sets["Impulse Drive"], tp_bonus = true }
	
	sets["Midcast_Holy II"] = sets["Midcast_Holy"] 
	sets["Midcast_Banish II"] = sets["Midcast_Holy"] 
	sets["Midcast_Banish"] = sets["Midcast_Holy"] 
	
	send_command('@input /macro book 21;wait 1;input /macro set 1')
end