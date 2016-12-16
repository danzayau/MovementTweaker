/*	groundedmovement.sp
	
	Implements grounded movement mechanics i.e. prestrafe.
	The modifications to velocity take into account what weapon you are holding (so that it has no effect).
	
	NOTE:
	Replication of the prestrafe from other Source engine games was not the goal. This is essentially custom.
*/

#define NUMBER_OF_WEAPONS 38
#define MAX_NORMAL_SPEED 250.0
#define MAX_PRESTRAFE_MODIFIER 1.104 	// Calculated 276/250
#define PRESTRAFE_INCREASE_RATE 0.0015
#define PRESTRAFE_DECREASE_RATE 0.0030

#include "weaponspeeddata.sp"

// Global Variables

new Float:g_clientPrestrafeModifier[MAXPLAYERS + 1];
new Float:g_clientPrestrafeLastAngle[MAXPLAYERS + 1];


// Functions

public PrestrafeTweak(client, Float:angle, &buttons) {
	// Don't do anything if client is in air.
	if (!g_clientOnGround[client])
	{
		return;
	}
	UpdateClientPrestrafeModifier(client, angle, buttons);
	UpdateClientVelocityModifier(client);
}

public UpdateClientPrestrafeModifier(client, Float:angle, &buttons) {
	// Variables
	new bool:turning = (angle != g_clientPrestrafeLastAngle[client]);
	
	// If correct prestrafe technique is detected, increase prestrafe modifier
	if 	(CheckIfValidPrestrafeKeys(client, buttons) && turning)
	{
		g_clientPrestrafeModifier[client] += PRESTRAFE_INCREASE_RATE;
	}
	// Else not prestrafing, so decrease prestrafe modifier
	else {
		g_clientPrestrafeModifier[client] -= PRESTRAFE_DECREASE_RATE;
	}
	
	// Ensure prestrafe modifier is in range (1.0 and the defined max)
	if (g_clientPrestrafeModifier[client] < 1.0) {
		g_clientPrestrafeModifier[client] = 1.0;
	}
	else if (g_clientPrestrafeModifier[client] > MAX_PRESTRAFE_MODIFIER) {
		g_clientPrestrafeModifier[client] = MAX_PRESTRAFE_MODIFIER;
	}
	
	// Save current angle for future reference.
	g_clientPrestrafeLastAngle[client] = angle; 
}

public bool CheckIfValidPrestrafeKeys(client, &buttons) {
	// If _only_ WA or WD or SA or SD are pressed, then return true.
	if (((buttons & IN_FORWARD && !(buttons & IN_BACK)) || (!(buttons & IN_FORWARD) && buttons & IN_BACK))
		&& ((buttons & IN_MOVELEFT && !(buttons & IN_MOVERIGHT)) || (!(buttons & IN_MOVELEFT) && buttons & IN_MOVERIGHT))) {
		return true;
	}
	else {
		return false;
	}
}

public void UpdateClientVelocityModifier(client) {
	SetEntPropFloat(client, Prop_Send, "m_flVelocityModifier", CalculateClientVelocityModifier(client));
}

public float CalculateClientVelocityModifier(client) {
	new Float:velocityModifier;
	new Float:weaponScale;
	new weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
	
	char weaponName[64];
	GetEntityClassname(weapon, weaponName, sizeof(weaponName)); // What weapon the client is holding.
	
	// Get weapon speed and work out how much to scale the modifier.
	for (new weaponID; weaponID < NUMBER_OF_WEAPONS; weaponID++) {
		if (StrEqual(weaponName, g_weaponList[weaponID])) {
			weaponScale = MAX_NORMAL_SPEED / g_runSpeeds[weaponID];
			break;
		}
		else {
			weaponScale = 1.0; // Weapon not found so default to 1.
		}
	}
	
	// Calculate the resulting velocity modifier.
	velocityModifier = weaponScale * g_clientPrestrafeModifier[client];	
	return velocityModifier;
}

public void ResetPrestrafe(client) {
	
}