# Check Upstairs
Check Upstairs is a mod which allows users to easily verify if any zombies is at the top of stairs they are standing in. It's easily customizable with many options thanks to Mod Options, to change the keybind or with sandbox options.

# Guide to modify parameters for other modders
The code is stored in a module which you can access this way:
```lua
local CheckUpstairs = require "CheckUpstairs_module"
```
This allows you to modify existing functions, to change the behavior of the mod. This is used for example in [Zomboid Forge](https://steamcommunity.com/workshop/filedetails/?id=3243131044) to change the nametags to not just show the zombie names "zombie" (or customized like will be shown in this guide) but show the name of the custom zombie type.

## Modify lore name of zombie shown in voicelines or above head
For less drastric changes, if you want to customize the mod to be in a specific lore setting, you can instead of showing "zombie" or "zombies" in voicelines and above the head of zombies, mention a different name. For example, this is used in [The Last of Us Infected](https://steamcommunity.com/sharedfiles/filedetails/?id=3248766883) to refer to the zombies not as "zombies" but as "infected".

This can be done this way in your code:
```lua
-- patch for CheckUpstairs, changes the zombie name to show in voicelines
if getActivatedMods():contains("CheckUpstairs") then
    local CheckUpstairs = require "CheckUpstairs_module"

	CheckUpstairs.defaultZombieName = getText("IGUI_TLOU_zombieName")
	CheckUpstairs.defaultZombiesName = getText("IGUI_TLOU_zombiesName")
end
```
```java
IGUI_EN = {
    /* Zombie Name, singular and plurial */
    IGUI_TLOU_zombieName = "infected",
    IGUI_TLOU_zombiesName = "infected",
}
```

You can also not bother with translation files and directly have:
```lua
-- patch for CheckUpstairs, changes the zombie name to show in voicelines
if getActivatedMods():contains("CheckUpstairs") then
    local CheckUpstairs = require "CheckUpstairs_module"

	CheckUpstairs.defaultZombieName = "infected"
	CheckUpstairs.defaultZombiesName = "infected"
end
```

`CheckUpstairs.defaultZombieName` is the singular word, while `CheckUpstairs.defaultZombiesName` is the plurial of the lore zombie name. In the previous example, `"infected"` is used for both as `"infected"` is used for both singular and plurial.

As another example utilizing the lore name to correspond to a The Walking Dead setting:
```lua
-- patch for CheckUpstairs, changes the zombie name to show in voicelines
if getActivatedMods():contains("CheckUpstairs") then
    local CheckUpstairs = require "CheckUpstairs"

	CheckUpstairs.defaultZombieName = "walker"
	CheckUpstairs.defaultZombiesName = "walkers"
end
```

## Modify voicelines or add new ones
Voice lines are stored in two tables:
- `CheckUpstairs.Voicelines_CheckUpstairsNoZombies` when no zombie is seen upstairs
- `CheckUpstairs.Voicelines_zombieUpstairs` when zombies are detected upstairs
- `CheckUpstairs.Voicelines_CheckDownstairsNoZombies` when no zombie is seen downstairs
- `CheckUpstairs.Voicelines_zombieDownstairs` when zombies are detected downstairs

By default, these tables are:
```lua
    -- Voicelines when no zombies upstairs
    Voicelines_CheckUpstairsNoZombies = {
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies1"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies2"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies3"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies4"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies5"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies6"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies7"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies8"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies9"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies10"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies11"),
        getText("IGUI_CheckUpstairs_CheckUpstairsNoZombies12")
    },

    -- Voicelines when zombies upstairs
    Voicelines_zombieUpstairs = {
        getText("IGUI_CheckUpstairs_zombiesUpstairs1"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs2"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs3"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs4"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs5"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs6"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs7"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs8"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs9"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs10"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs11"),
        getText("IGUI_CheckUpstairs_zombiesUpstairs12")
    },

    -- Voicelines when no zombies downstairs
    Voicelines_CheckDownstairsNoZombies = {
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies1"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies2"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies3"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies4"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies5"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies6"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies7"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies8"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies9"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies10"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies11"),
        getText("IGUI_CheckUpstairs_CheckDownstairsNoZombies12")
    },

    -- Voicelines when zombies downstairs
    Voicelines_zombieDownstairs = {
        getText("IGUI_CheckUpstairs_zombiesDownstairs1"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs2"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs3"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs4"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs5"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs6"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs7"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs8"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs9"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs10"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs11"),
        getText("IGUI_CheckUpstairs_zombiesDownstairs12")
    },
```
The voicelines are stored in translation files this way:
```java
IGUI_EN = {
	/* No zombies upstairs */
	IGUI_CheckUpstairs_CheckUpstairsNoZombies1							= "I can't see any %s up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies2							= "There seems to be nothing up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies3							= "It should be safe to walk up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies4							= "Nothing suspicious up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies5							= "The upstairs is empty.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies6							= "No threats detected above.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies7							= "It's quiet up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies8							= "All's clear above.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies9							= "No signs of movement upstairs.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies10							= "I don't see any danger up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies11							= "I can't spot any %s up there.",
	IGUI_CheckUpstairs_CheckUpstairsNoZombies12							= "Looks safe up top.",

	/* Zombies upstairs */
	IGUI_CheckUpstairs_zombiesUpstairs1									= "I can see %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs2									= "There seems to be %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs3									= "%d %s spotted upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs4									= "I've spotted %d %s lurking upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs5									= "Looks like there are %d %s waiting up there.",
	IGUI_CheckUpstairs_zombiesUpstairs6									= "I can count %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs7									= "%d %s are up there, be careful!",
	IGUI_CheckUpstairs_zombiesUpstairs8									= "There are %d %s hanging around upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs9									= "I see %d %s up ahead.",
	IGUI_CheckUpstairs_zombiesUpstairs10								= "There are %d %s on the upper floor.",
	IGUI_CheckUpstairs_zombiesUpstairs11								= "I spot %d %s in the shadows above.",
	IGUI_CheckUpstairs_zombiesUpstairs12								= "Beware, %d %s are up there!",

	/* No zombies downstairs */
	IGUI_CheckUpstairs_CheckDownstairsNoZombies1						= "I can't see any %s down there.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies2						= "There seems to be nothing down there.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies3						= "It looks clear downstairs.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies4						= "Nothing suspicious below.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies5						= "The downstairs is empty.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies6						= "No threats detected below.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies7						= "It's quiet down there.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies8						= "All's clear below.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies9						= "No signs of movement downstairs.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies10						= "I don't see any danger down there.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies11						= "I can't spot any %s down there.",
	IGUI_CheckUpstairs_CheckDownstairsNoZombies12						= "Looks safe below.",

	/* Zombies downstairs */
	IGUI_CheckUpstairs_zombiesDownstairs1								= "I can see %d %s downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs2								= "There seems to be %d %s downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs3								= "%d %s spotted downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs4								= "I've spotted %d %s lurking downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs5								= "Looks like there are %d %s waiting down there.",
	IGUI_CheckUpstairs_zombiesDownstairs6								= "I can count %d %s downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs7								= "%d %s are down there, be careful!",
	IGUI_CheckUpstairs_zombiesDownstairs8								= "There are %d %s hanging around downstairs.",
	IGUI_CheckUpstairs_zombiesDownstairs9								= "I see %d %s down below.",
	IGUI_CheckUpstairs_zombiesDownstairs10								= "There are %d %s on the lower floor.",
	IGUI_CheckUpstairs_zombiesDownstairs11								= "I spot %d %s in the shadows below.",
	IGUI_CheckUpstairs_zombiesDownstairs12								= "Beware, %d %s are down there!",
}
```
Voicelines are picked randomly and use `string.format` to apply `CheckUpstairs.ZombieName` and `CheckUpstairs.ZombieNames` as well as the amount of zombies detected. 

`CheckUpstairs.Voicelines_CheckUpstairsNoZombies` formats this way:
```lua
local voiceLine = CheckUpstairs.Voicelines_noZombies[ZombRand(1,#CheckUpstairs.Voicelines_noZombies+1)]
player:Say(string.format(voiceLine,CheckUpstairs.ZombieName))
```

`CheckUpstairs.Voicelines_zombieUpstairs` formats this way:
```lua
local voiceLine = CheckUpstairs.Voicelines_zombieUpstairs[ZombRand(1,#CheckUpstairs.Voicelines_zombieUpstairs+1)]
if zombiesAmount == 1 then
    player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombieName))
else
    player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombiesName))
end
```

`CheckUpstairs.Voicelines_CheckDownstairsNoZombies` formats this way:
```lua
local voiceLine = CheckUpstairs.Voicelines_CheckDownstairsNoZombies[ZombRand(1,#CheckUpstairs.Voicelines_CheckDownstairsNoZombies+1)]
player:Say(string.format(voiceLine,CheckUpstairs.ZombieName))
```

`CheckUpstairs.Voicelines_zombieDownstairs` formats this way:
```lua
local voiceLine = CheckUpstairs.Voicelines_zombieDownstairs[ZombRand(1,#CheckUpstairs.Voicelines_zombieDownstairs+1)]
if zombiesAmount == 1 then
    player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombieName))
else
    player:Say(string.format(voiceLine,zombiesAmount,CheckUpstairs.ZombiesName))
end
```

To add your own voicelines, you can simply add new voicelines with the format strings like in the examples. You can also remove voicelines with this method. 

The formating is optional but if you plan on adding your own voicelines when zombies are detected up, it's better to follow the same format indicating the amount of zombies upstairs to stay coherent with every other voicelines. If you don't do that, it could lead to behaviors from players trying to find the right voicelines that indicates the exact amount of zombies. On the other hand, you can simply disable every voicelines that show the amount of zombies and replace with approximate amounts.