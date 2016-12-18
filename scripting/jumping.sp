/*	jumping.sp

	Implements customised jumping (b-hop) mechanics e.g. how much speed you lose when b-hopping.
*/

#define BHOP_PERF_TIME 0.01

#include "bhoptakeofftable.sp"


void JumpTweak(int client) {
	// Check if the player has just jumped
	if (g_clientJustJumped[client]) {
		// B-hop (takeoff speed) tweaker
		if (g_cvBhopTweaker.IntValue) {
			// Apply the plugin controlled takeoff speed and update global variables.
			ApplyTakeoffSpeed(client);
		}
		g_clientHitPerf[client] = g_clientCanPerf[client];
		g_clientLastTakeoffSpeed[client] = g_clientNextTakeoffSpeed[client];
		g_clientJustJumped[client] = false; // Handled
	}
}

void ApplyTakeoffSpeed(int client) {
	// Only affects the horizontal speed of the client.
	float newVelocity[3];
	newVelocity = g_clientVelocity[client];
	newVelocity[2] = 0.0;
	NormalizeVector(newVelocity, newVelocity);
	ScaleVector(newVelocity, g_clientNextTakeoffSpeed[client]);
	newVelocity[2] = g_clientVelocity[client][2];
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, newVelocity);
}

bool CanPerf(int client) {
	// If the time difference between when the client landed and when they jump is short enough, it is considered a b-hop.
	return ((GetGameTime() - g_clientLandingTime[client]) < BHOP_PERF_TIME);
}

float GetBhopTakeoffSpeed(int client) {
	// Get the takeoff speed from the table, or take the last value of the table if it's out of range.
	int roundedLandingSpeed = RoundFloat(g_clientLandingSpeed[client]);
	
	if (roundedLandingSpeed < BHOP_TAKEOFF_TABLE_SIZE) {
		return g_bhopTakeoffSpeedTable[roundedLandingSpeed];
	}
	else {
		return g_bhopTakeoffSpeedTable[BHOP_TAKEOFF_TABLE_SIZE - 1];
	}
} 