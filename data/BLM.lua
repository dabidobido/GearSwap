include("MasterGear/MasterGearLua.lua")

mp_recover = true

function custom_get_sets()
	ws = {}
	ws["Dark Harvest"] = { set = sets["Shadow of Death"], tp_bonus = true }
	ws["Shadow of Death"] = { set = sets["Shadow of Death"], tp_bonus = true }
	ws["Infernal Scythe"] = { set = sets["Shadow of Death"], tp_bonus = false }
	ws["Slice"] = { set = sets["Slice"], tp_bonus = true }
	ws["Spinning Scythe"] = { set = sets["Slice"], tp_bonus = false }
	ws["Vorpal Scythe"] = { set = sets["Vorpal Scythe"], tp_bonus = true }
	ws["Spiral Hell"] = { set = sets["Spiral Hell"], tp_bonus = true }
	
	ws["Shining Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Seraph Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	ws["Brainshaker"] = { set = sets["Slice"], tp_bonus = false }
	ws["Skullbreaker"] = { set = sets["Slice"], tp_bonus = false }
	ws["True Strike"] = { set = sets["Vorpal Scythe"], tp_bonus = true }
	ws["Judgment"] = { set = sets["Retribution"], tp_bonus = true }
	ws["Black Halo"] = { set = sets["Retribution"], tp_bonus = true }
	
	ws["Heavy Swing"] = { set = sets["Slice"], tp_bonus = true }
	ws["Shell Crusher"] = { set = sets["Slice"], tp_bonus = true }
	ws["Full Swing"] = { set = sets["Slice"], tp_bonus = true }
	ws["Spirit Taker"] = { set = sets["Spirit Taker"], tp_bonus = true }
	ws["Retribution"] = { set = sets["Retribution"], tp_bonus = true }
	ws["Rock Crusher"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Earth Crusher"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Starburst"] = { set = sets["Shadow of Death"], tp_bonus = true }
	ws["Sunburst"] = { set = sets["Shadow of Death"], tp_bonus = true }
	ws["Cataclysm"] = { set = sets["Shadow of Death"], tp_bonus = true }
	ws["Vidohunir"] = { set = sets["Shadow of Death"], tp_bonus = false }
	ws["Myrkr"] = { set = sets["Myrkr"], tp_bonus = true }
	
	sets["Midcast_Fire VI"] = sets["MagicBurst"]
	sets["Midcast_Fire V"] = sets["MagicBurst"]
	sets["Midcast_Fire IV"] = sets["MagicBurst"]
	sets["Midcast_Fire III"] = sets["MagicBurst"]
	sets["Midcast_Fire II"] = sets["MagicBurst"]
	sets["Midcast_Fire"] = sets["MagicBurst"]
	sets["Midcast_Blizzard VI"] = sets["MagicBurst"]
	sets["Midcast_Blizzard V"] = sets["MagicBurst"]
	sets["Midcast_Blizzard IV"] = sets["MagicBurst"]
	sets["Midcast_Blizzard III"] = sets["MagicBurst"]
	sets["Midcast_Blizzard II"] = sets["MagicBurst"]
	sets["Midcast_Blizzard"] = sets["MagicBurst"]
	sets["Midcast_Aero VI"] = sets["MagicBurst"]
	sets["Midcast_Aero V"] = sets["MagicBurst"]
	sets["Midcast_Aero IV"] = sets["MagicBurst"]
	sets["Midcast_Aero III"] = sets["MagicBurst"]
	sets["Midcast_Aero II"] = sets["MagicBurst"]
	sets["Midcast_Aero"] = sets["MagicBurst"]
	sets["Midcast_Stone VI"] = sets["MagicBurst"]
	sets["Midcast_Stone V"] = sets["MagicBurst"]
	sets["Midcast_Stone IV"] = sets["MagicBurst"]
	sets["Midcast_Stone III"] = sets["MagicBurst"]
	sets["Midcast_Stone II"] = sets["MagicBurst"]
	sets["Midcast_Stone"] = sets["MagicBurst"]
	sets["Midcast_Thunder VI"] = sets["MagicBurst"]
	sets["Midcast_Thunder V"] = sets["MagicBurst"]
	sets["Midcast_Thunder IV"] = sets["MagicBurst"]
	sets["Midcast_Thunder III"] = sets["MagicBurst"]
	sets["Midcast_Thunder II"] = sets["MagicBurst"]
	sets["Midcast_Thunder"] = sets["MagicBurst"]
	sets["Midcast_Water VI"] = sets["MagicBurst"]
	sets["Midcast_Water V"] = sets["MagicBurst"]
	sets["Midcast_Water IV"] = sets["MagicBurst"]
	sets["Midcast_Water III"] = sets["MagicBurst"]
	sets["Midcast_Water II"] = sets["MagicBurst"]
	sets["Midcast_Water"] = sets["MagicBurst"]
	sets["Midcast_Meteor"] = sets["MagicBurst"]
	sets["Midcast_Firaga"] = sets["MagicBurst"]
	sets["Midcast_Firaga II"] = sets["MagicBurst"]
	sets["Midcast_Firaga III"] = sets["MagicBurst"]
	sets["Midcast_Blizzaga"] = sets["MagicBurst"]
	sets["Midcast_Blizzaga II"] = sets["MagicBurst"]
	sets["Midcast_Blizzaga III"] = sets["MagicBurst"]	
	sets["Midcast_Aeroga"] = sets["MagicBurst"]
	sets["Midcast_Aeroga II"] = sets["MagicBurst"]
	sets["Midcast_Aeroga III"] = sets["MagicBurst"]
	sets["Midcast_Stonega"] = sets["MagicBurst"]
	sets["Midcast_Stonega II"] = sets["MagicBurst"]
	sets["Midcast_Stonega III"] = sets["MagicBurst"]
	sets["Midcast_Thundaga"] = sets["MagicBurst"]
	sets["Midcast_Thundaga II"] = sets["MagicBurst"]
	sets["Midcast_Thundaga III"] = sets["MagicBurst"]
	sets["Midcast_Waterga"] = sets["MagicBurst"]
	sets["Midcast_Waterga II"] = sets["MagicBurst"]
	sets["Midcast_Waterga III"] = sets["MagicBurst"]
	sets["Midcast_Firaja"] = sets["MagicBurst"]
	sets["Midcast_Blizzaja"] = sets["MagicBurst"]
	sets["Midcast_Aeroja"] = sets["MagicBurst"]
	sets["Midcast_Stoneja"] = sets["MagicBurst"]
	sets["Midcast_Thundaja"] = sets["MagicBurst"]
	sets["Midcast_Waterja"] = sets["MagicBurst"]
	sets["Midcast_Flare"] = sets["MagicBurst"]
	sets["Midcast_Freeze"] = sets["MagicBurst"]
	sets["Midcast_Tornado"] = sets["MagicBurst"]
	sets["Midcast_Quake"] = sets["MagicBurst"]
	sets["Midcast_Burst"] = sets["MagicBurst"]
	sets["Midcast_Flood"] = sets["MagicBurst"]
	
	sets["Midcast_Comet"] = sets["CometBurst"]
	
	sets["Midcast_Aspir III"] = sets["Drain"]
	sets["Midcast_Aspir II"] = sets["Drain"]
	sets["Midcast_Aspir I"] = sets["Drain"]
	
	sets["Midcast_Drain"] = sets["Drain"]	
	
	sets["Midcast_Burn"] = sets["MagicAccuracy"]
	sets["Midcast_Frost"] = sets["MagicAccuracy"]
	sets["Midcast_Choke"] = sets["MagicAccuracy"]
	sets["Midcast_Rasp"] = sets["MagicAccuracy"]
	sets["Midcast_Shock"] = sets["MagicAccuracy"]
	sets["Midcast_Drown"] = sets["MagicAccuracy"]
	sets["Midcast_Sleep"] = sets["MagicAccuracy"]
	sets["Midcast_Sleep II"] = sets["MagicAccuracy"]
	sets["Midcast_Sleepga"] = sets["MagicAccuracy"]
	sets["Midcast_Blind"] = sets["MagicAccuracy"]
	sets["Midcast_Break"] = sets["MagicAccuracy"]
	sets["Midcast_Breakga"] = sets["MagicAccuracy"]
	sets["Midcast_Bind"] = sets["MagicAccuracy"]
	sets["Midcast_Stun"] = sets["MagicAccuracy"]
	
	sets["Midcast_Klimaform"] = sets["EnhDur"]
	sets["Midcast_Sandstorm"] = sets["EnhDur"]
	sets["Midcast_Rainstorm"] = sets["EnhDur"]
	sets["Midcast_Windstorm"] = sets["EnhDur"]
	sets["Midcast_Firestorm"] = sets["EnhDur"]
	sets["Midcast_Hailstorm"] = sets["EnhDur"]
	sets["Midcast_Thunderstorm"] = sets["EnhDur"]
	sets["Midcast_Voidstorm"] = sets["EnhDur"]
	sets["Midcast_Aurorastorm"] = sets["EnhDur"]
	
	send_command('@input /macro book 16;wait 1;input /macro set 1')
end

function custom_command(args)
	if args[1] == "mprecover" and args[2] then
		if args[2] == "off" then
			mp_recover = false
		elseif args[2] == "on" then
			mp_recover = true
		end
		add_to_chat(122, "MP Recovery: " .. tostring(mp_recover))
	elseif args[1] == "aspir" then
		local recasts = windower.ffxi.get_spell_recasts()
		if recasts[881] == 0 then send_command('input /ma "Aspir III" <t>')
		elseif recasts[248] == 0 then send_command('input /ma "Aspir II" <t>')
		elseif recasts[247] == 0 then send_command('input /ma "Aspir" <t>')
		end
	end
end

function custom_midcast(spell)
	if sets["Midcast_" .. spell.english] then 
		equip(sets["Midcast_" .. spell.english])
		if spell.element == world.weather_element or spell.element == world.day_element then 
			equip(sets["WeatherObi"])
		end
		if spell.skill == "Elemental" and mp_recover then
			equip(sets["MPRecover"])
		end
	end
end