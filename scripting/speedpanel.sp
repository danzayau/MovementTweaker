/*	speedpanel.sp
	
	Implementation of speed panel that shows players their current speed, landing speed,
	pre (takeoff) speed, and whether or not they hit a perfect b-hop.
*/


void UpdateSpeedPanel(int client) {
	if (g_cvSpeedPanel.IntValue) {
		if (IsPlayerAlive(client)) {
			UpdateSpeedPanelText(client);
		}
		if (g_clientSpeedPanelEnabled[client]) {
			ShowSpeedPanel(client);
		}
	}
}

void UpdateSpeedPanelText(int client) {
	if (g_clientHitPerf[client]) {
		Format(g_clientSpeedPanelText[client], 512, 
			"<font color='#948d8d'><b>Speed</b>: %.1f (<font color='#21982a'>%.1f</font>)\n<b>Landing:</b> %.1f", 
			g_clientSpeed[client], g_clientLastTakeoffSpeed[client], g_clientLandingSpeed[client]);
	}
	else {
		Format(g_clientSpeedPanelText[client], 512, 
			"<font color='#948d8d'><b>Speed</b>: %.1f (%.1f)\n<b>Landing:</b> %.1f", 
			g_clientSpeed[client], g_clientLastTakeoffSpeed[client], g_clientLandingSpeed[client]);
	}
}

void ShowSpeedPanel(int client) {
	if (IsPlayerAlive(client)) {
		PrintHintText(client, "%s", g_clientSpeedPanelText[client]);
	}
	else {
		int spectatedPlayer = GetSpectatedPlayer(client)
		if (IsValidClient(spectatedPlayer)) {
			PrintHintText(client, "%s", g_clientSpeedPanelText[spectatedPlayer]);
		}
	}
} 