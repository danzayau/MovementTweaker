# Movement Tweaker (CS:GO)

[![Build Status](https://travis-ci.org/danzayau/MovementTweaker.svg?branch=master)](https://travis-ci.org/danzayau/MovementTweaker)

## Features

 * **Bunnyhop Tweaker** - More consistent perfect b-hops, and customised speed rewarded for hitting perfects.
 * **Prestrafe** - Less complex and less buggy version than the implementation found in KZTimer.
 * **Universal Weapon Speed** - You will move at the same speed no matter what weapon you are holding.
 * **Crouch Slowdown Tweak** - Crouching speed is reset upon landing, so consecutive crouch jumps don't feel sluggish.
 * **Perfect Crouchjump Nerf** - If players crouch and jump in the same tick, it won't result in extra height.
 * **Landing Animation Suppression** - Changes player models on spawn to ones that don't have landing animations.
 * All features configurable using convars, and with an automatically generated .cfg file.

## Usage
 
### Requirements

 * SourceMod 1.8+
 * [**Movement API Plugin**](https://github.com/danzayau/MovementAPI) (included)

### Installation

 * Download and extract MovementTweaker-vX.X.X.zip from the latest GitHub release to csgo/ in the server directory.
 * Config file is generated and saved to ```csgo/cfg/sourcemod/MovementTweaker.cfg``` after starting the plugin.
 
### Tested Server CVars

```
	sv_accelerate 6.5
	sv_enablebunnyhopping 1
	sv_staminamax 0	
```
 
## Bunnyhop Tweaker

Players are able to perform a perfect b-hop if they jump in the first tick after landing. This means that, normally, perfect b-hops are very inconsistent. This plugin allows you to control the number of ticks after landing is considered a perfect b-hop, meaning they can made consistent without rewarding players who mistime their scroll completely.

## Prestrafe

This implementation of prestrafe does not take into account how it worked in other Source engine games. It is written based on how I think prestrafe should work since it doesn't exist in CS:GO.

If the player is on the ground, pressing WA or WD or SA or SD (no other combinations of directional inputs are allowed), and turning their mouse, then the player will gain a positive speed modifier. This modifier caps out at a value that results in the maximum ground movement speed of 276.0 u/s. The modifier will immediately begin to decrease if the player fails to prestrafe correctly.