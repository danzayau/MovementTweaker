#include <sourcemod>
#include <sdktools>
#include <cstrike>


Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks CS:GO movement mechanics.", 
	version = "0.2.1", 
	url = "https://github.com/danzayau/MovementTweaker"
};


// Global Variables
/*	clientmovementtracking	*/
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
/*	groundedmovement	*/
float g_clientPrestrafeLastAngle[MAXPLAYERS + 1] =  { 0.0, ... };
float g_clientVelocityModifierPrestrafe[MAXPLAYERS + 1] =  { 1.0, ... };
float g_clientVelocityModifierWeapon[MAXPLAYERS + 1] =  { 1.0, ... };
float g_clientVelocityModifier[MAXPLAYERS + 1] =  { 0.0, ... };
/*	speedpanel	*/
bool g_clientSpeedPanelEnabled[MAXPLAYERS + 1] =  { true, ... };
char g_clientSpeedPanelText[MAXPLAYERS + 1][512];


// Includes
#include "convars.sp"
#include "commands.sp"
#include "clientmovementtracking.sp"
#include "groundedmovement.sp"
#include "jumping.sp"
#include "misc.sp"
#include "speedpanel.sp"


// Functions

public void OnPluginStart() {
	// Check if game is CS:GO.
	EngineVersion gameEngine = GetEngineVersion();
	if (gameEngine != Engine_CSGO)
	{
		SetFailState("This plugin is for CS:GO.");
	}
	
	// ConVars
	RegisterConVars();
	AutoExecConfig(true, "MovementTweaker");	
	
	// Commands
	RegisterCommands();
	
	// Event Hooks
	HookEvent("player_jump", Event_Jump, EventHookMode_Pre);	
}

public void OnConfigsExecuted() {
	UpdateAccelerateUseWeaponSpeed();
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	// Update variables and performs routine.	
	if (IsValidClient(client)) {
		// Update variables first!
		UpdateClientGlobalVariables(client);
		
		if(IsPlayerAlive(client)) {
			TweakMovement(client, buttons, angles);
		}		
		UpdateSpeedPanel(client);
	}
}

void TweakMovement(int client, int &buttons, float angles[3]) {
	JumpTweak(client);
	GroundedMovementTweak(client, angles[1], buttons);
} 

public void Event_Jump(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	// Set the clientJustJumped flag.
	g_clientJustJumped[client] = true;
	// Reset the prestrafe modifier.
	g_clientVelocityModifierPrestrafe[client] = 1.0;
}