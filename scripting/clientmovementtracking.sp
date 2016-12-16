/*	clientmovementtracking.sp

	Several useful, non-specific global variables and functions for tracking player movement.
*/

// Global Variables

new Float:g_clientVelocity[MAXPLAYERS + 1][3];
new Float:g_clientSpeed[MAXPLAYERS + 1];
new bool:g_clientOnGround[MAXPLAYERS + 1];
new bool:g_clientJustJumped[MAXPLAYERS + 1];
new Float:g_clientLastTakeoffSpeed[MAXPLAYERS + 1];
new Float:g_clientNextTakeoffSpeed[MAXPLAYERS + 1];
new Float:g_clientLandingTime[MAXPLAYERS + 1];
new Float:g_clientLandingSpeed[MAXPLAYERS + 1];
new bool:g_clientCanPerf[MAXPLAYERS + 1];
new bool:g_clientHitPerf[MAXPLAYERS + 1];


// Functions

public void UpdateClientGlobalVariables(client) {
	if (GetEntityFlags(client) & FL_ONGROUND) {
		// Check if just landed, and record Landing Time and Landing Speed if necessary
		if (!g_clientOnGround[client]) {			
			g_clientLandingTime[client] = GetGameTime();
			g_clientLandingSpeed[client] = g_clientSpeed[client];
		}
		
		// Next Takeoff Speed & Can Perf
		if (CanBhop(client)) {
			g_clientNextTakeoffSpeed[client] = GetBhopTakeoffSpeed(client);
			g_clientCanPerf[client] = true;
		}
		else {
			g_clientNextTakeoffSpeed[client] = g_clientSpeed[client];
			g_clientCanPerf[client] = false;
		}
		
		// On Ground
		g_clientOnGround[client] = true;
	}
	else {
		g_clientOnGround[client] = false;
	}
	
	// Velocity & Speed
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", g_clientVelocity[client]);
	g_clientSpeed[client] = SquareRoot(Pow(g_clientVelocity[client][0], 2.0) + Pow(g_clientVelocity[client][1], 2.0));	
}