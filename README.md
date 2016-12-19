# Movement Tweaker Sourcemod Plugin for CS:GO

Movement Tweaker is an attempt at adjusting movement mechanics to create more consistent and refined gameplay for CS:GO KZ and other, low speed, movement gamemodes such as HnS.

============================

### Features

 * **Bunnyhop Tweaker** - More consistent perfect b-hops, and customised speed rewarded for hitting perfects.
 * **Prestrafe** - Less complex and less buggy version than the implementation found in KZTimer.
 * **Universal Weapon Speed** - You will move at the same speed no matter what weapon you are holding.
 * **Speed Panel** - Shows players their current speed, the pre speed of latest jump, and latest landing speed.
 
### Player Commands

 * ```!speed``` - Toggles the center speed panel.

============================

### Installation

 * Extract ```MovementTweaker.zip``` to ```csgo/``` in your server directory.
 * Config file is generated and saved to ```csgo/cfg/sourcemod/MovementTweaker.cfg```.
 * This plugin doesn't mesh well with [**KZTimer**](http://github.com/klyve/kztimerglobal). If you want a compatible timer plugin, I can offer you [**SimpleKZ**](https://github.com/danzayau/MovementTweaker).
 
### Suggested Server CVars

```
	sv_accelerate 6.5
	sv_enablebunnyhopping 1
	sv_staminamax 0	
```
 
============================

### Bunnyhop Tweaker

Players are rewarded if they jump within a certain timeframe after they have landed (a perfect b-hop). Normally, perfect b-hops are very inconsistent. This plugin tries to control that certain timeframe, adjusting it so that they are able to feel consistent without rewarding players who mistime their scroll completely.

The plugin also adjusts how much speed you keep when you hit a perfect b-hop. Normally you would keep all your speed. Instead, the plugin takes your landing speed and inputs it into a formula to give a resulting 'rewarded' speed. This means that to maintain a certain 'rewarded' speed, players will need to strafe and gain enough landing speed.

The formula used is as follows (subject to change): ```500.57176 / (1 + 1.68794 * exp(-0.00208 * LandingSpeed))```

![Rewarded Speed Graph (Zoomed)](perfspeedgraph1.png?raw=true)

![Rewarded Speed Graph](perfspeedgraph2.png?raw=true)

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