/*	jumping.sp

	Implements customised jumping (b-hop) mechanics e.g. how much speed you lose when b-hopping.
*/


#define NORMAL_JUMP_VERTICAL_VELOCITY 292.618377


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
		
		// Perfect crouch jump detection
		if(g_cvNerfPerfectCrouchjump.IntValue && g_clientJustDucked[client]) {
			ApplyPerfectCrouchJumpPenalty(client);
		}
		
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
	return ((GetGameTime() - g_clientLandingTime[client]) < g_cvBhopGracePeriod.FloatValue);
}

float GetBhopTakeoffSpeed(int client) {
	if (g_clientLandingSpeed[client] <= 250.0) {
		return g_clientLandingSpeed[client];	
	}
	else {
		// Calculate the landing speed based on a formula
		return (500.57176 / (1 + 1.68794 * Exponential(-0.00208 * g_clientLandingSpeed[client])));
	}
}

void ApplyPerfectCrouchJumpPenalty(int client) {
	// Only affects the vertical speed of the client.
	float newVelocity[3]
	newVelocity = g_clientVelocity[client];
	newVelocity[2] = NORMAL_JUMP_VERTICAL_VELOCITY;
	TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, newVelocity);
	
	// Update velocity value so that it's accurate
	g_clientVelocity[client][2] = NORMAL_JUMP_VERTICAL_VELOCITY;
}