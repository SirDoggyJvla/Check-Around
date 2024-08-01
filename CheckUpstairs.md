# Check Upstairs
Check Upstairs is a mod which allows users to easily verify if any zombies is at the top of stairs they are standing in. It's easily customizable with many options thanks to Mod Options, to change the keybind or with sandbox options.

# Guide to modify parameters for other modders
The code is stored in a module which you can access this way:
```lua
local CheckUpstairs = require "CheckUpstairs"
```
This allows you to modify existing functions, to change the behavior of the mod. This is used for example in [Zomboid Forge](https://steamcommunity.com/workshop/filedetails/?id=3243131044) to change the nametags to not just show the zombie names "zombie" (or customized like will be shown in this guide) but show the name of the custom zombie type.

## Modify lore name of zombie shown in voicelines or above head
For less drastric changes, if you want to customize the mod to be in a specific lore setting, you can instead of showing "zombie" or "zombies" in voicelines and above the head of zombies, mention a different name. For example, this is used in [The Last of Us Infected](https://steamcommunity.com/sharedfiles/filedetails/?id=3248766883) to refer to the zombies not as "zombies" but as "infected".

This can be done this way in your code:
```lua
-- patch for CheckUpstairs, changes the zombie name to show in voicelines
if getActivatedMods():contains("CheckUpstairs") then
    local CheckUpstairs = require "CheckUpstairs"

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
    local CheckUpstairs = require "CheckUpstairs"

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
- `CheckUpstairs.Voicelines_noZombies` when no zombie is seen
- `CheckUpstairs.Voicelines_zombieUpstairs` when zombies are detected

By default, these tables are:
```lua
CheckUpstairs.Voicelines_noZombies = {
    getText("IGUI_CheckUpstairs_noZombies1"),
    getText("IGUI_CheckUpstairs_noZombies2"),
    getText("IGUI_CheckUpstairs_noZombies3"),
    getText("IGUI_CheckUpstairs_noZombies4"),
    getText("IGUI_CheckUpstairs_noZombies5"),
    getText("IGUI_CheckUpstairs_noZombies6"),
    getText("IGUI_CheckUpstairs_noZombies7"),
    getText("IGUI_CheckUpstairs_noZombies8"),
    getText("IGUI_CheckUpstairs_noZombies9"),
    getText("IGUI_CheckUpstairs_noZombies10"),
    getText("IGUI_CheckUpstairs_noZombies11"),
    getText("IGUI_CheckUpstairs_noZombies12")
}

CheckUpstairs.Voicelines_zombieUpstairs = {
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
}
```
The voicelines are stored in translation files this way:
```java
IGUI_EN = {
	/* No zombies upstairs */
	IGUI_CheckUpstairs_noZombies1		= "I can't see any %s up there.",
	IGUI_CheckUpstairs_noZombies2		= "There seems to be nothing up there.",
	IGUI_CheckUpstairs_noZombies3		= "It should be safe to walk up there.",
	IGUI_CheckUpstairs_noZombies4		= "Nothing suspicious up there.",
	IGUI_CheckUpstairs_noZombies5		= "The upstairs is empty.",
	IGUI_CheckUpstairs_noZombies6		= "No threats detected above.",
	IGUI_CheckUpstairs_noZombies7		= "It's quiet up there.",
	IGUI_CheckUpstairs_noZombies8		= "All's clear above.",
	IGUI_CheckUpstairs_noZombies9		= "No signs of movement upstairs.",
	IGUI_CheckUpstairs_noZombies10		= "I don't see any danger up there.",
	IGUI_CheckUpstairs_noZombies11		= "I can't spot any %s up there.",
	IGUI_CheckUpstairs_noZombies12		= "Looks safe up top.",

	/* Zombies upstairs */
	IGUI_CheckUpstairs_zombiesUpstairs1		= "I can see %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs2		= "There seems to be %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs3		= "%d %s spotted upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs4		= "I've spotted %d %s lurking upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs5		= "Looks like there are %d %s waiting up there.",
	IGUI_CheckUpstairs_zombiesUpstairs6		= "I can count %d %s upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs7		= "%d %s are up there, be careful!",
	IGUI_CheckUpstairs_zombiesUpstairs8		= "There are %d %s hanging around upstairs.",
	IGUI_CheckUpstairs_zombiesUpstairs9		= "I see %d %s up ahead.",
	IGUI_CheckUpstairs_zombiesUpstairs10	= "There are %d %s on the upper floor.",
	IGUI_CheckUpstairs_zombiesUpstairs11	= "I spot %d %s in the shadows above.",
	IGUI_CheckUpstairs_zombiesUpstairs12	= "Beware, %d %s are up there!",
}
```
Voicelines are picked randomly and use `string.format` to apply `CheckUpstairs.ZombieName` and `CheckUpstairs.ZombieNames` as well as the amount of zombies detected. 

`CheckUpstairs.Voicelines_noZombies` formats this way:
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

To add your own voicelines, you can simply add new voicelines with the format strings like in the examples. You can also remove voicelines with this method.