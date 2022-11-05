include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 0
	
	ws = {}
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	ws["Seraph Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Hexa Strike"] = { set = sets["Hexa Strike"], tp_bonus = true }
	ws["Realmrazer"] = { set = sets["Hexa Strike"], tp_bonus = false }
	ws["Black Halo"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Mystic Boon"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Judgement"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["True Strike"] = { set = sets["Black Halo"], tp_bonus = false }
	ws["Skullbreaker"] = { set = sets["Black Halo"], tp_bonus = false }
	ws["Randgrith"] = { set = sets["Black Halo"], tp_bonus = false }
	
	ws["Cataclysm"] = { set = sets["Cataclysm"], tp_bonus = true }
	ws["Earth Crusher"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Sunburst"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Full Swing"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Retribution"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Shell Crusher"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Shattersoul"] = { set = sets["Hexa Strike"], tp_bonus = false }
	ws["Spirit Taker"] = { set = sets["Black Halo"], tp_bonus = true }
	
	sets["Midcast_Holy"] = sets["MagicBurst"]
	sets["Midcast_Holy II"] = sets["MagicBurst"]
	sets["Midcast_Banish"] = sets["MagicBurst"]
	sets["Midcast_Banish II"] = sets["MagicBurst"]
	sets["Midcast_Banish III"] = sets["MagicBurst"]
	
	sets["Midcast_Boost-STR"] = sets["Enh500"]
	sets["Midcast_Boost-DEX"] = sets["Enh500"]
	sets["Midcast_Boost-VIT"] = sets["Enh500"]
	sets["Midcast_Boost-AGI"] = sets["Enh500"]
	sets["Midcast_Boost-INT"] = sets["Enh500"]
	sets["Midcast_Boost-MND"] = sets["Enh500"]
	sets["Midcast_Boost-CHR"] = sets["Enh500"]
	
	sets["Midcast_Protectra I"] = sets["EnhDur"]
	sets["Midcast_Protectra II"] = sets["EnhDur"]
	sets["Midcast_Protectra III"] = sets["EnhDur"]
	sets["Midcast_Protectra IV"] = sets["EnhDur"]
	sets["Midcast_Protectra V"] = sets["EnhDur"]
	sets["Midcast_Shellra"] = sets["EnhDur"]
	sets["Midcast_Shellra II"] = sets["EnhDur"]
	sets["Midcast_Shellra III"] = sets["EnhDur"]
	sets["Midcast_Shellra IV"] = sets["EnhDur"]
	sets["Midcast_Shellra V"] = sets["EnhDur"]
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
	sets["Midcast_Regen IV"] = sets["EnhDur"]
	
	sets["Midcast_Cure"] = sets["Cure"]
	sets["Midcast_Cure II"] = sets["Cure"]
	sets["Midcast_Cure III"] = sets["Cure"]
	sets["Midcast_Cure IV"] = sets["Cure"]
	sets["Midcast_Cure V"] = sets["Cure"]
	sets["Midcast_Cure VI"] = sets["Cure"]
	sets["Midcast_Curaga"] = sets["Cure"]
	sets["Midcast_Curaga II"] = sets["Cure"]
	sets["Midcast_Curaga III"] = sets["Cure"]
	sets["Midcast_Curaga IV"] = sets["Cure"]
	sets["Midcast_Curaga V"] = sets["Cure"]
	sets["Midcast_Cura"] = sets["Cure"]
	sets["Midcast_Cura III"] = sets["Cure"]
	
	sets["Midcast_Barfira"] = sets["Barspells"]
	sets["Midcast_Barblizzara"] = sets["Barspells"]
	sets["Midcast_Baraera"] = sets["Barspells"]
	sets["Midcast_Barstonra"] = sets["Barspells"]
	sets["Midcast_Barthundra"] = sets["Barspells"]
	sets["Midcast_Barwatera"] = sets["Barspells"]
	sets["Midcast_Barsleepra"] = sets["Barspells"]
	sets["Midcast_Barpoisonra"] = sets["Barspells"]
	sets["Midcast_Barparalyzra"] = sets["Barspells"]
	sets["Midcast_Barblindra"] = sets["Barspells"]
	sets["Midcast_Barsilencera"] = sets["Barspells"]
	sets["Midcast_Barpetra"] = sets["Barspells"]
	sets["Midcast_Barvira"] = sets["Barspells"]
	sets["Midcast_Baramnesra"] = sets["Barspells"]
	
	sets["Midcast_Poisona"] = sets["NaSpells"]
	sets["Midcast_Paralyna"] = sets["NaSpells"]
	sets["Midcast_Blindna"] = sets["NaSpells"]
	sets["Midcast_Silena"] = sets["NaSpells"]
	sets["Midcast_Stona"] = sets["NaSpells"]
	sets["Midcast_Viruna"] = sets["NaSpells"]
	sets["Midcast_Erase"] = sets["NaSpells"]
	
	sets["Midcast_Dia"] = sets["TH"]
	sets["Midcast_Diaga"] = sets["TH"]
	
	send_command('@input /macro book 8;wait 1;input /macro set 1')
end

function custom_aftercast(spell)
	if player.equipment.main == "Yagrush" then equip({sub = "Daybreak"})
	elseif player.equipment.main == "Mjollnir" then equip({sub = "Asclepius"}) end
end