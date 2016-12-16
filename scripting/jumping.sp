/*	jumping.sp

	Implements customised jumping (b-hop) mechanics e.g. how much speed you lose when b-hopping.
*/

#define BHOP_TAKEOFF_TABLE_SIZE 500
#define BHOP_PERF_TIME 0.01

#include "bhoptakeofftable.sp"


// Functions

public void JumpTweak(client) {
	if (g_clientJustJumped[client]) {
		ApplyTakeoffSpeed(client);
		g_clientHitPerf[client] = g_clientCanPerf[client];
		g_clientLastTakeoffSpeed[client] = g_clientNextTakeoffSpeed[client];
		g_clientJustJumped[client] = false; // Handled
	}
}

public bool CanBhop(client) {
	if ((GetGameTime() - g_clientLandingTime[client]) < BHOP_PERF_TIME) {
		//PrintHintText(client, "Current: %f\nLanding: %f", GetGameTime(), g_clientLandingTime[client]);
		return true;
	}
	else {
		return false;
	}
}

public void ApplyTakeoffSpeed(client) {
	new Float:newVelocity[3];
	newVelocity = g_clientVelocity[client];
	newVelocity[2] = 0.0;
	NormalizeVector(newVelocity, newVelocity);
	ScaleVector(newVelocity, g_clientNextTakeoffSpeed[client]);
	newVelocity[2] = g_clientVelocity[client][2];
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, newVelocity);
}

public float GetBhopTakeoffSpeed(client) {
	new roundedLandingSpeed = RoundFloat(g_clientLandingSpeed[client]);
	if (roundedLandingSpeed < BHOP_TAKEOFF_TABLE_SIZE) {
		return g_bhopTakeoffSpeedTable[roundedLandingSpeed];
	}
	else {
		return g_bhopTakeoffSpeedTable[BHOP_TAKEOFF_TABLE_SIZE - 1];
	}
}