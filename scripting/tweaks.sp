/*	tweaks.sp

	Implementation of the movement tweaks.
*/

#define NORMAL_JUMP_VERTICAL_VELOCITY 292.618377
#define NUMBER_OF_WEAPONS 38
#define MAX_NORMAL_SPEED 250.0
#define MAX_PRESTRAFE_MODIFIER 1.104 	// Calculated 276/250
#define PRESTRAFE_INCREASE_RATE 0.0014
#define PRESTRAFE_DECREASE_RATE 0.0021
#define NORMAL_DUCK_SPEED 8.0

#include "weaponspeeddata.sp"


void GeneralTweak(MovementPlayer player) {
	if (player.onGround) {
		player.velocityModifier = PrestrafeVelocityModifier(player) * WeaponVelocityModifier(player);
	}
}

float PrestrafeVelocityModifier(MovementPlayer player) {
	if (gCV_Prestrafe.IntValue) {
		// If correct prestrafe technique is detected, increase prestrafe modifier
		if (CheckIfValidPrestrafeKeys(player) && player.turning) {
			gF_PrestrafeVelocityModifier[player.id] += PRESTRAFE_INCREASE_RATE;
		}
		// Else not prestrafing, so decrease prestrafe modifier
		else {
			gF_PrestrafeVelocityModifier[player.id] -= PRESTRAFE_DECREASE_RATE;
		}
		
		// Ensure prestrafe modifier is in range
		if (gF_PrestrafeVelocityModifier[player.id] < 1.0) {
			gF_PrestrafeVelocityModifier[player.id] = 1.0;
		}
		else if (gF_PrestrafeVelocityModifier[player.id] > MAX_PRESTRAFE_MODIFIER) {
			gF_PrestrafeVelocityModifier[player.id] = MAX_PRESTRAFE_MODIFIER;
		}
	}
	else {
		gF_PrestrafeVelocityModifier[player.id] = 1.0; // Default to 1.0.
	}
	return gF_PrestrafeVelocityModifier[player.id];
}

bool CheckIfValidPrestrafeKeys(MovementPlayer player) {
	int buttons = GetClientButtons(player.id);
	// If _only_ WA or WD or SA or SD are pressed, then return true.
	if (((buttons & IN_FORWARD && !(buttons & IN_BACK)) || (!(buttons & IN_FORWARD) && buttons & IN_BACK))
		 && ((buttons & IN_MOVELEFT && !(buttons & IN_MOVERIGHT)) || (!(buttons & IN_MOVELEFT) && buttons & IN_MOVERIGHT))) {
		return true;
	}
	else {
		return false;
	}
}

float WeaponVelocityModifier(MovementPlayer player) {
	// Universal Weapon Speed
	if (gCV_UniversalWeaponSpeed.IntValue) {
		int weaponEnt = GetEntPropEnt(player.id, Prop_Data, "m_hActiveWeapon");
		if (IsValidEntity(weaponEnt)) {
			char weaponName[64];
			GetEntityClassname(weaponEnt, weaponName, sizeof(weaponName)); // What weapon the client is holding.
			// Get weapon speed and work out how much to scale the modifier.
			for (int weaponID = 0; weaponID < NUMBER_OF_WEAPONS; weaponID++) {
				if (StrEqual(weaponName, g_weaponList[weaponID])) {
					return MAX_NORMAL_SPEED / g_runSpeeds[weaponID];
				}
			}
		}
		return MAX_NORMAL_SPEED / 260.0; // Weapon entity not found so must have no weapon (260 u/s).
	}
	return 1.0; // Default to 1.0.
}

void JumpTweak(MovementPlayer player) {
	if (gCV_PerfSpeedTweak.IntValue || gCV_PerfTimingTweak.IntValue) {
		TweakTakeoffSpeed(player);
	}
	if (gCV_NerfPerfectCrouchjump.IntValue && player.justDucked) {
		NerfPerfectCrouchJump(player);
	}
}

void TweakTakeoffSpeed(MovementPlayer player) {
	float oldVelocity[3];
	player.GetVelocity(oldVelocity);
	float nextTakeoffSpeed = CalculateTakeoffSpeed(player);
	
	float newVelocity[3];
	newVelocity = oldVelocity;
	newVelocity[2] = 0.0; // Only adjust horizontal speed
	NormalizeVector(newVelocity, newVelocity);
	ScaleVector(newVelocity, nextTakeoffSpeed);
	newVelocity[2] = oldVelocity[2];
	
	player.SetVelocity(newVelocity);
	player.takeoffSpeed = nextTakeoffSpeed;
}

float CalculateTakeoffSpeed(MovementPlayer player) {
	if (HitPerf(player)) {
		gB_HitPerf[player.id] = true;
		Call_OnPlayerPerfectBunnyhopMT(player.id);
		if (gCV_PerfSpeedTweak.IntValue && player.landingSpeed > 250.0) {
			// Calculate the takeoff speed based on a formula
			return (500.57176 / (1 + 1.68794 * Exponential(-0.00208 * player.landingSpeed)));
		}
		else {
			return player.landingSpeed;
		}
	}
	else {
		gB_HitPerf[player.id] = false;
		return player.speed;
	}
}

bool HitPerf(MovementPlayer player) {
	if (gCV_PerfTimingTweak.IntValue) {
		return player.takeoffTick - player.landingTick <= gCV_PerfTicks.IntValue;
	}
	else {
		return player.takeoffTick - player.landingTick <= 1;
	}
}

void NerfPerfectCrouchJump(MovementPlayer player) {
	float newVelocity[3];
	player.GetVelocity(newVelocity);
	newVelocity[2] = NORMAL_JUMP_VERTICAL_VELOCITY;
	player.SetVelocity(newVelocity);
}

void DuckSlowdownTweak(MovementPlayer player) {
	if (gCV_ResetDuckSpeedOnLanding.IntValue) {
		player.duckSpeed = NORMAL_DUCK_SPEED;
	}
} 