#include <sourcemod>
#include <sdktools>

#include "clientmovementtracking.sp"
#include "jumping.sp"
#include "groundedmovement.sp"

public Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks movement mechanics.", 
	version = "0.0.1", 
	url = ""
};


public void OnPluginStart() {
	EngineVersion gameEngine = GetEngineVersion();
	if (gameEngine != Engine_CSGO)
	{
		SetFailState("This plugin is for CS:GO only.");
	}
	
	// Event Hooks
	HookEvent("player_jump", Event_Jump, EventHookMode_Pre);
}

public void Event_Jump(Event event, const char[] name, bool dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	// Set the clientJustJumped flag.
	g_clientJustJumped[client] = true;
	// Reset the prestrafe modifier.
	g_clientPrestrafeModifier[client] = 1.0;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2]) {
	// Update variables and perform routine.	
	if (IsPlayerAlive(client)) {
		UpdateClientGlobalVariables(client);
		TweakMovement(client, buttons, angles);
		ShowSpeedPanel(client);
		//ShowDebugPanel(client);		
	}
}

public void TweakMovement(client, &buttons, Float:angles[3]) {
	JumpTweak(client);
	PrestrafeTweak(client, angles[1], buttons);
}

public ShowSpeedPanel(client) {
	// Simple centre panel to show the player some useful information regarding their speed.
	if (g_clientHitPerf[client]) {
		PrintHintText(client, "Speed: %.3f\nLanding: %.3f\nPre: %.3f (perf)", g_clientSpeed[client], g_clientLandingSpeed[client], g_clientLastTakeoffSpeed[client]);
	}
	else {
		PrintHintText(client, "Speed: %.3f\nLanding: %.3f\nPre: %.3f", g_clientSpeed[client], g_clientLandingSpeed[client], g_clientLastTakeoffSpeed[client]);
	}
}

public ShowDebugPanel(client) {
	PrintHintText(client, "%f", g_clientNextTakeoffSpeed[client]);
} 