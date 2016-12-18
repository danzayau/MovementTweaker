# Movement Tweaker Sourcemod Plugin for CS:GO

Movement Tweaker is an attempt at adjusting movement mechanics to create more consistent and refined gameplay for CS:GO KZ and other, low speed, movement gamemodes such as HnS.

============================

### Features

 * **Bunnyhop Tweaker** - more consistent perfect b-hops, and customised speed rewarded for hitting perfects.
 * **Prestrafe** - less complex and less buggy version than the implementation found in KZTimer 1.85_1.
 * **Universal Weapon Speed** - You will move at the same speed no matter what weapon you are holding.
 * **Speed Panel** - Shows players their current speed, the pre speed of latest jump, and latest landing speed.
 
### Player Commands

 * ```!speed``` - Toggles the center speed panel.

============================

### Installation

 * Extract and copy ```MovementTweaker.smx``` to ```csgo/addons/sourcemod/plugins```.
 * Config file is generated and saved to ```csgo/cfg/sourcemod/MovementTweaker.cfg```.
 
### Recommended Server CVars

```
	sv_enablebunnyhopping 1
	sv_staminamax 0	
```
 
============================

### Bunnyhop Tweaker

Players will be rewarded with a certain speed if they jump within a certain timeframe after they have landed (a successful b-hop). Normally, perfect b-hops are very inconsistent. With the ability to control the 'perf b-hop time', they are able to feel consistent without rewarding players who mistime their scroll completely.

The rewarded speed is the following (and is subject to change):

When ```landing <= 275```:```rewarded = landing```
        
When ```landing > 275```: ```rewarded = ln(landing - 264) / ln(1.1) + 249.8411```

![Graph of Rewarded Speed](perfspeedgraph.png?raw=true)

This aims to reward players when b-hopping along flat ground with a consistent pre-speed of around 300 (chosen arbitrarily).

============================

### Prestrafe

This implementation of prestrafe does not take into account how it worked in other Source engine games. It is written based on how I think prestrafe should work since it doesn't exist in CS:GO.

If the player is on the ground, pressing WA or WD or SA or SD (no other combinations of directional inputs are allowed), and turning their mouse, then the player will gain a positive speed modifier. This modifier caps out at a value that results in the maximum ground movement speed of 276.0 u/s. This does mean that players can walk diagonally and move the mouse to maintain maximum pre-strafe speed in a straight line.

Prestrafe also begins to reduce immediately if a correct key combination is not detected. This means that releasing W too early before jumping from a prestrafe is punishing (they won't get the full 276.0 u/s).

============================

### KZTimer 1.85_1 Prestrafe Notes

In KZTimer 1.85_1, prestrafe can be achieved when only pressing A or D and moving the mouse. This is because instead of detecting if the player is pressing the forward or back keys, a function was used to determine if the player was moving forward or back. This function would return true even if the player wasn't actually moving forward.

Prestrafe would also not work as expected when players performed it at certain angles. This is because it incorrectly determined whether or not the player was turning right of left.

The prestrafe modifier would also not reset when in the air, meaning that when b-hopping, it was possible to get pre-speeds of higher than 250 (the key to this is to ensure that there is mouse movement when you touch the ground).

There was a 'fastrun' exploit where you could hold down WAD and move your mouse to run faster. This was because players were allowed to press all these three inputs and still be able to prestrafe.