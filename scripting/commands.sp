/*	conmands.sp
	
	Implements commands for player control over features of the plugin.
*/


void RegisterCommands() {
	RegConsoleCmd("sm_speed", Toggle_SpeedPanel, "Toggle visibility of the centre speed panel.");
}


// Command Handlers

public Action Toggle_SpeedPanel(client, args) {
	if (g_clientSpeedPanelEnabled[client]) {
		g_clientSpeedPanelEnabled[client] = false;
		PrintToChat(client, "Your centre speed panel has been disabled.");
	}
	else {
		g_clientSpeedPanelEnabled[client] = true;
		PrintToChat(client, "Your centre speed panel has been enabled.");
	}
	return Plugin_Handled;
}