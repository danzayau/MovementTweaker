#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <movement>
#include <movementtweaker>

#pragma newdecls required
#pragma semicolon 1

Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks CS:GO movement mechanics.", 
	version = "0.4", 
	url = "https://github.com/danzayau/MovementTweaker"
};


// Global Variables
MovementPlayer g_MovementPlayer[MAXPLAYERS + 1];
float gF_PrestrafeVelocityModifier[MAXPLAYERS + 1];
bool gB_HitPerf[MAXPLAYERS + 1];


// Includes
#include "convars.sp"
#include "tweaks.sp"
#include "misc.sp"
#include "api.sp"


// Functions
public void OnPluginStart() {
	// Check if game is CS:GO.
	EngineVersion gameEngine = GetEngineVersion();
	if (gameEngine != Engine_CSGO)
	{
		SetFailState("This plugin is for CS:GO.");
	}
	
	// Forwards
	CreateGlobalForwards();
	
	// ConVars
	RegisterConVars();
	AutoExecConfig(true, "MovementTweaker");
	
	// Hooks
	HookEvent("player_spawn", OnPlayerSpawn);
	
	// Setup Movement API Methodmaps
	for (int client = 1; client <= MaxClients; client++) {
		g_MovementPlayer[client] = new MovementPlayer(client);
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNatives();
	return APLRes_Success;
}

public void OnConfigsExecuted() {
	UpdateAccelerateUseWeaponSpeed();
}

public void OnMapStart() {
	PrecacheModels();
}

public void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
	if (gCV_SuppressLandingAnimation.IntValue) {
		UpdatePlayerModel(GetClientOfUserId(GetEventInt(event, "userid")));
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	if (IsPlayerAlive(client)) {
		GeneralTweak(g_MovementPlayer[client]);
	}
}

public void OnPlayerLeaveGround(int client, bool jumped) {
	if (jumped) {
		JumpTweak(g_MovementPlayer[client]);
	}
	else {
		gB_HitPerf[client] = false;
	}
	gF_PrestrafeVelocityModifier[client] = 1.0; // Because it doesn't update when in the air
}

public void OnPlayerTouchGround(int client) {
	DuckSlowdownTweak(g_MovementPlayer[client]);
} 