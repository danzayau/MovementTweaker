#include <sourcemod>
#include <sdktools>

#include "convars.sp"

#include "clientmovementtracking.sp"
#include "jumping.sp"
#include "groundedmovement.sp"
#include "speedpanel.sp"

#include "commands.sp"

Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks CS:GO movement mechanics.", 
	version = "0.1", 
	url = "https://github.com/danzayau/MovementTweaker"
};

public void OnPluginStart() {
	// Check if game is CS:GO.
	EngineVersion gameEngine = GetEngineVersion();
	if (gameEngine != Engine_CSGO)
	{
		SetFailState("This plugin is for CS:GO only.");
	}
	
	// ConVars
	RegisterConVars();
	AutoExecConfig(true, "MovementTweaker");
	
	// Commands
	RegisterCommands();
	
	// Event Hooks
	HookEvent("player_jump", Event_Jump, EventHookMode_Pre);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	// Update variables and perform routine.	
	if (IsPlayerAlive(client)) {
		UpdateClientGlobalVariables(client);
		TweakMovement(client, buttons, angles);
		SpeedPanel(client);
	}
}

public void Event_Jump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	// Set the clientJustJumped flag.
	g_clientJustJumped[client] = true;
	// Reset the prestrafe modifier.
	g_clientVelocityModifierPrestrafe[client] = 1.0;
}

void TweakMovement(int client, int &buttons, float angles[3]) {
	JumpTweak(client);
	GroundedMovementTweak(client, angles[1], buttons);
} 