# THHelper
1.0.3:
- Use windower.raw_register_event so that there are less frame drops

1.0.2:
- reset the slot disable state on job change

1.0.1:
- Unlock slots when changing from fulltime TH to other modes.

1.0
- Initial commit

# Features

- Automatically equips Treasure Hunter gear when engaging in combat and then reequip normal gear after a melee hit, ranged hit or WS 

# How to Use

- Put the following code somewhere near the top of your gearswap lua:
> include("THHelper/THHelper.lua")
- declare a sets.TH 
- call on_status_change_for_th from your gearswap status change
- parse thtagged command to equip back your normal set
- set AmmoDisabled to true if you need to use a ranged weapon and your TH set has an ammo item

# Commands:

## //gs th (num)
Changes the mode. 
- 1 = Off. Don't equip TH gear at all
- 2 = Tag. Equip TH on engage and unequip after melee hit, ranged hit or WS.
- 3 = Fulltime. Only available for THFs. Equip TH on engage and never unequip it.