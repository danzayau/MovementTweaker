# Movement Tweaker Sourcemod Plugin for CS:GO

Movement Tweaker is an attempt at adjusting movement mechanics to create more consistent and refined gameplay for CS:GO KZ and other, low speed, movement gamemodes such as HnS.

============================

### Features

 * **Bunnyhop Tweaker** - More consistent perfect b-hops, and customised speed rewarded for hitting perfects.
 * **Prestrafe** - Less complex and less buggy version than the implementation found in KZTimer.
 * **Universal Weapon Speed** - You will move at the same speed no matter what weapon you are holding.
 * **Crouch Slowdown Tweak** - Crouching speed is reset upon landing, so consecutive crouch jumps don't feel sluggish.
 * **Perfect Crouchjump Nerf** - If players crouch and jump in the same tick, it won't result in extra height.
 * **Landing Animation Suppression** - Changes player models on spawn to ones that don't have landing animations.
 * All features configurable using convars, and with an automatically generated .cfg file.

============================

### Requirements

 * [**Movement API Plugin**](https://github.com/danzayau/MovementAPI).

### Installation

 * Extract ```MovementTweaker.zip``` to ```csgo/``` in your server directory.
 * Config file is generated and saved to ```csgo/cfg/sourcemod/MovementTweaker.cfg```.
 * This plugin doesn't mesh well with [**KZTimer**](http://github.com/klyve/kztimerglobal). If you want a compatible timer plugin, I can offer you [**SimpleKZ**](https://github.com/danzayau/SimpleKZ).
 
### Tested Server CVars

```
	sv_accelerate 6.5
	sv_enablebunnyhopping 1
	sv_staminamax 0	
	sv_minupdaterate <server tickrate>
	sv_mincmdrate <server tickrate>
```
 
============================

### Bunnyhop Tweaker

Players are able to perform a perfect b-hop if they jump in the first tick after landing. This means that, normally, perfect b-hops are very inconsistent. This plugin allows you to control the number of ticks after landing is considered a perfect b-hop, meaning they can made consistent without rewarding players who mistime their scroll completely.

The plugin is also able to adjust how much speed you keep when you hit a perfect b-hop. Normally you keep all your speed. Instead, the plugin can take the landing speed and input it into a formula to give a resulting 'rewarded' speed. With the chosen formula, players will need to strafe effectively to maintain a b-hopping speed of around 275.

The formula used is as follows (subject to change): ```500.57176 / (1 + 1.68794 * exp(-0.00208 * LandingSpeed))```

![Rewarded Speed Graph](perfspeedgraph1.png?raw=true)

![Rewarded Speed Graph (Zoomed)](perfspeedgraph2.png?raw=true)

============================

### Prestrafe

This implementation of prestrafe does not take into account how it worked in other Source engine games. It is written based on how I think prestrafe should work since it doesn't exist in CS:GO.

If the player is on the ground, pressing WA or WD or SA or SD (no other combinations of directional inputs are allowed), and turning their mouse, then the player will gain a positive speed modifier. This modifier caps out at a value that results in the maximum ground movement speed of 276.0 u/s. This does mean that players can walk diagonally and move the mouse to maintain maximum pre-strafe speed in a straight line.

Prestrafe also begins to reduce immediately if a correct key combination is not detected. This means that releasing W too early before jumping from a prestrafe is punishing (they won't get the full 276.0 u/s).