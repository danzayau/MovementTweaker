# Movement Tweaker Sourcemod Plugin for CS:GO

Movement Tweaker is an attempt at creating a set of movement mechanics that create more consistent and more enjoyable environment for CS:GO KZ and other, low speed, movement gamemodes such as HnS.

============================

### Features

 * **Perfect b-hops adjustment** - plugin implementation that can be controlled to be made more consistent, and customised.
 * **Prestrafe** - less complex and less buggy version than the implementation found in KZTimer.
 * **Universal weapon speed** - You will move at the same speed no matter what weapon you are holding.
 * **Speed hint text** - Shows players their current speed, and the pre speed of their latest jump (also, currently, landing speed).
 
### Tested Server CVars

```
	sv_enablebunnyhopping 1
	sv_airaccelerate 100
	sv_accelerate 6.5
	sv_friction 5.0
	sv_ladder_scale_speed 1
	sv_staminamax 0
```

============================

### Perfect B-Hops Adjustment

Players will be rewarded with a certain speed if they jump within a certain timeframe after they have landed (and is what I consider to be a successful b-hop). Normally, perfect b-hops are very inconsistent. A seemingly likely theory is that a perfect b-hop requires tick perfect jump input timing in order to happen. With the ability to control the 'perf b-hop time', they are able to feel consistent without rewarding players who mistime their scroll completely.

The rewarded speed is the following (and is subject to change):

When ```landing <= 275```:```rewarded = landing```
        
When ```landing > 275```: ```rewarded = (landing - 264) / ln(1.1) + 249.8411```

![Graph of Rewarded Speed](perfspeedgraph.png?raw=true)

This aims to reward players with good strafes (when b-hopping along flat ground) with a consistent pre-speed of around 300.

============================

### Prestrafe

This implementation of prestrafe does not take into account how it worked in other Source engine games.

If the player is on the ground, pressing WA or WD or SA or SD (no other combinations of directional inputs are allowed), and turning their mouse, then the player will gain a positive speed modifier. This modifier caps out at a value that results in the maximum ground movement speed of 276.

**KZTimer 1.85_1 Prestrafe Notes**

In KZTimer 1.85_1, prestrafe can be achieved when only pressing A or D and moving the mouse. This is because instead of detecting if the player is pressing the forward or back keys, a function was used to determine if the player was moving forward or back. This function would return true even if the player wasn't actually moving forward.

Prestrafe would also not work as expected when players performed it at certain angles. This is because it incorrectly determined whether or not the player was turning right of left.

The prestrafe modifier would also not reset when in the air, meaning that when b-hopping, it was possible to get pre-speeds of higher than 250 (the key to this is to ensure that there is mouse movement when you touch the ground).

There was a 'fastrun' exploit where you could hold down WAD and move your mouse to run faster. This was because players were allowed to press both all these three inputs when prestrafing.