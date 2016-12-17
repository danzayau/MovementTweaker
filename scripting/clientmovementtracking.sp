/*	clientmovementtracking.sp

	Several useful, non-specific global variables and functions for tracking player movement.
*/


// Global Variables

float g_clientVelocity[MAXPLAYERS + 1][3];
float g_clientSpeed[MAXPLAYERS + 1] =  { 0.0, ... };
bool g_clientOnGround[MAXPLAYERS + 1] =  { false, ... };
bool g_clientJustJumped[MAXPLAYERS + 1] =  { false, ... };
float g_clientLastTakeoffSpeed[MAXPLAYERS + 1] =  { 0.0, ... };
float g_clientNextTakeoffSpeed[MAXPLAYERS + 1] =  { 0.0, ... };
float g_clientLandingTime[MAXPLAYERS + 1] =  { 0.0, ... };
float g_clientLandingSpeed[MAXPLAYERS + 1] =  { 0.0, ... };
bool g_clientCanPerf[MAXPLAYERS + 1] =  { false, ... };
bool g_clientHitPerf[MAXPLAYERS + 1] =  { false, ... };


// Functions

void UpdateClientGlobalVariables(int client) {
	float oldSpeed = g_clientSpeed[client]; // Speed of client in previous tick.
	bool oldOnGround = g_clientOnGround[client];
	
	// Velocity & Speed (done first because accurate calculation of other variables requires being current)
	GetEntPropVector(client, Prop_Data, "m_vecVelocity", g_clientVelocity[client]);
	g_clientSpeed[client] = SquareRoot(Pow(g_clientVelocity[client][0], 2.0) + Pow(g_clientVelocity[client][1], 2.0));
	
	// On Ground
	g_clientOnGround[client] = true;
	
	// Only bother updating certain variables if the client is on the ground.
	if (GetEntityFlags(client) & FL_ONGROUND) {
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