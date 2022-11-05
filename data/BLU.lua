include("Mastergear/MasterGearLua.lua")

function custom_get_sets()
	learn_blu_mode = false
	
	tp_bonus_gear = {
		["sub"] = { name = "Thibron", bonus = 1000 },
	}
		
	ws = {}
	
	ws["True Strike"] = {set = sets["True Strike"], tp_bonus = false }
	ws["Judgment"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Black Halo"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	ws["Seraph Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	
	ws["Expiacion"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Chant du Cygne"] = { set = sets["Chant Du Cygne"], tp_bonus = false }
	ws["Requiescat"] = { set = sets["Requiescat"], tp_bonus = true }
	ws["Realmrazer"] = { set = sets["Requiescat"], tp_bonus = false }
	ws["Seraph Blade"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Red Lotus Blade"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Flat Blade"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Sanguine Blade"] = { set = sets["Sanguine Blade"], tp_bonus = false }
	
	sets["Sweeping Gouge"] = sets["BluPhysical"]
	sets["Saurian Slide"] = sets["BluPhysical"]
	sets["Absolute Terror"] = sets["BluMagicAcc"]
	sets["Sudden Lunge"] = sets["BluMagicAcc"]
	sets["Acrid Stream"] = sets["BluMagic"]
	sets["Osmosis"] = sets["BluMagicAcc"]
	sets["Dream Flower"] = sets["BluMagicAcc"]
	sets["Anvil Lightning"] = sets["BluMagic"]
	sets["Searing Tempest"] = sets["BluMagic"]
	sets["Spectral Floe"] = sets["BluMagic"]
	sets["Subduction"] = sets["BluMagic"]
	sets["Tenebral Crush"] = sets["BluMagic"]
	sets["Entomb"] = sets["BluMagic"]
	sets["Enbalming Earth"] = sets["BluMagic"]
	sets["Thunderbolt"] = sets["BluMagicAcc"]
	
	send_command('@input /macro book 9;wait 1;input /macro set 1')
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.english == "Mighty Guard" and buffactive["Diffusion"] then
			equip(sets["DiffusionBuff"])
			return true
		elseif sets[spell.english] then 
			equip(sets[spell.english])
			return true
		elseif sets["Midcast_" .. spell.english] then
			equip("Midcast_" .. spell.english)
			return true
		elseif spell.skill == "Blue Magic" then
			equip(sets["BlueMagic"])
			return true
		end
	end
end
  
function custom_command(args)
	if args[1] == "learnblu" then
		if learn_blu_mode == false then
			add_to_chat(122, "Learning BLU Spells on")
			enable('hands')
			equip(sets["LearnBlu"])
			disable('hands')
			learn_blu_mode = true
		elseif learn_blu_mode == true then
			add_to_chat(122, "Learning BLU Spells off")
			enable('hands')
			learn_blu_mode = false
		end
	end
end