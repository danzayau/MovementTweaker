/*	clientmovementtracking.sp

	Several useful, non-specific global variables and functions for tracking player movement.
*/


void UpdateClientGlobalVariables(int client) {
	float oldSpeed = g_clientSpeed[client]; // Speed of client in previous tick.
	bool oldOnGround = g_clientOnGround[client];
	
	// Velocity & Speed (done first because accurate calculation of other variables requires being current)
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", g_clientVelocity[client]);
	g_clientSpeed[client] = SquareRoot(Pow(g_clientVelocity[client][0], 2.0) + Pow(g_clientVelocity[client][1], 2.0));
	
	
	// Only bother updating certain variables if the client is on the ground.
	if (GetEntityFlags(client) & FL_ONGROUND) {
		// On Ground
		g_clientOnGround[client] = true;
		
		// Check if just landed, and record Landing Time and Landing Speed if necessary
		if (!oldOnGround) {
			g_clientCanPerf[client] = true; // First landing tick, therefore can perf.
			g_clientLandingTime[client] = GetGameTime();
			g_clientLandingSpeed[client] = oldSpeed;
		}
		else {
			g_clientCanPerf[client] = false;
		}
		
		// Next Takeoff Speed (adjusts Can Perf if using bhop tweak)
		if (g_cvBhopTweaker.IntValue) {
			if (CanPerf(client)) {
				g_clientNextTakeoffSpeed[client] = GetBhopTakeoffSpeed(client);
				g_clientCanPerf[client] = true;
			}
			else {
				g_clientNextTakeoffSpeed[client] = g_clientSpeed[client];
				g_clientCanPerf[client] = false;
			}
		}
		else {
			g_clientNextTakeoffSpeed[client] = g_clientSpeed[client];
		}
	}
	else {
		g_clientOnGround[client] = false;
	}
} 