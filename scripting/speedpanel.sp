/*	speedpanel.sp
	
	Implementation of speed panel that shows players their current speed, landing speed,
	pre (takeoff) speed, and whether or not they hit a perfect b-hop.
*/


bool g_clientSpeedPanelEnabled[MAXPLAYERS + 1] =  { true, ... };

void SpeedPanel(int client) {
	if (g_cvSpeedPanel.IntValue && g_clientSpeedPanelEnabled[client]) {
		ShowSpeedPanel(client);
	}
}

void ShowSpeedPanel(int client) {
	// Simple centre panel to show the player some useful information regarding their speed.
	if (g_clientHitPerf[client]) {
		PrintHintText(client, "<font color='#948d8d'><b>Speed</b>: %.1f (<font color='#21982a'>%.1f</font>)\n<b>Landing:</b> %.1f", g_clientSpeed[client], g_clientLastTakeoffSpeed[client], g_clientLandingSpeed[client]);
	}
	else {
		PrintHintText(client, "<font color='#948d8d'><b>Speed</b>: %.1f (<font color='#9a0909'>%.1f</font>)\n<b>Landing:</b> %.1f", g_clientSpeed[client], g_clientLastTakeoffSpeed[client], g_clientLandingSpeed[client]);
	}
} 