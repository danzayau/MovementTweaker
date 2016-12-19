/*	groundedmovement.sp
	
	Implements grounded movement mechanics i.e. prestrafe.
	The modifications to velocity take into account what weapon you are holding (so that it has no effect).
	
	NOTE:
	Replication of the prestrafe from other Source engine games was not the goal. This is essentially custom.
*/

#define NUMBER_OF_WEAPONS 38
#define MAX_NORMAL_SPEED 250.0
#define MAX_PRESTRAFE_MODIFIER 1.104 	// Calculated 276/250
#define PRESTRAFE_INCREASE_RATE 0.0014
#define PRESTRAFE_DECREASE_RATE 0.0021

#include "weaponspeeddata.sp"


void GroundedMovementTweak(int client, float angle, int &buttons) {
	// Don't do anything if client is in air.
	if (!g_clientOnGround[client])
	{
		return;
	}
	ApplyGroundedMovementTweak(client, angle, buttons);
}

void ApplyGroundedMovementTweak(int client, float angle, int &buttons) {
	UpdateClientVelocityModifier(client, angle, buttons);
	SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", g_clientVelocityModifier[client]);
}

void UpdateClientVelocityModifier(int client, float angle, int &buttons) {
	UpdateClientPrestrafeModifier(client, angle, buttons);
	UpdateClientWeaponModifier(client);
	g_clientVelocityModifier[client] = g_clientVelocityModifierWeapon[client] * g_clientVelocityModifierPrestrafe[client];
}

void UpdateClientPrestrafeModifier(int client, float angle, int &buttons) {
	if (g_cvPrestrafe.IntValue) {
		// Variables
		bool turning = (angle != g_clientPrestrafeLastAngle[client]);
		
		// If correct prestrafe technique is detected, increase prestrafe modifier
		if (CheckIfValidPrestrafeKeys(buttons) && turning)
		{
			g_clientVelocityModifierPrestrafe[client] += PRESTRAFE_INCREASE_RATE;
		}
		// Else not prestrafing, so decrease prestrafe modifier
		else {
			g_clientVelocityModifierPrestrafe[client] -= PRESTRAFE_DECREASE_RATE;
		}
		
		// Ensure prestrafe modifier is in range (1.0 and the defined max)
		if (g_clientVelocityModifierPrestrafe[client] < 1.0) {
			g_clientVelocityModifierPrestrafe[client] = 1.0;
		}
		else if (g_clientVelocityModifierPrestrafe[client] > MAX_PRESTRAFE_MODIFIER) {
			g_clientVelocityModifierPrestrafe[client] = MAX_PRESTRAFE_MODIFIER;
		}
		
		// Save current angle for future reference.
		g_clientPrestrafeLastAngle[client] = angle;
	}
	else {
		g_clientVelocityModifierPrestrafe[client] = 1.0; // Default to 1.0.
	}
}

bool CheckIfValidPrestrafeKeys(int &buttons) {
	// If _only_ WA or WD or SA or SD are pressed, then return true.
	if (((buttons & IN_FORWARD && !(buttons & IN_BACK)) || (!(buttons & IN_FORWARD) && buttons & IN_BACK))
		 && ((buttons & IN_MOVELEFT && !(buttons & IN_MOVERIGHT)) || (!(buttons & IN_MOVELEFT) && buttons & IN_MOVERIGHT))) {
		return true;
	}
	else {
		return false;
	}
}

void UpdateClientWeaponModifier(int client) {
	// Universal Weapon Speed
	if (g_cvUniversalWeaponSpeed.IntValue) {
		int weaponEnt = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
		
		if (IsValidEntity(weaponEnt)) {		
			char weaponName[64];
			GetEntityClassname(weaponEnt, weaponName, sizeof(weaponName)); // What weapon the client is holding.
			
			// Get weapon speed and work out how much to scale the modifier.
			for (int weaponID = 0; weaponID < NUMBER_OF_WEAPONS; weaponID++) {
				if (StrEqual(weaponName, g_weaponList[weaponID])) {
					g_clientVelocityModifierWeapon[client] = MAX_NORMAL_SPEED / g_runSpeeds[weaponID];
					return;
				}
			}
		}
		
		g_clientVelocityModifierWeapon[client] = 250.0 / 260.0; // Weapon entity not found so must have no weapon (260 u/s).
		return;
	}
	g_clientVelocityModifierWeapon[client] = 1.0; // Default to 1.0.
} 