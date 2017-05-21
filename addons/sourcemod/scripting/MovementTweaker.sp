#include <sourcemod>

#include <cstrike>
#include <sdktools>

#include <movementapi>

#pragma newdecls required
#pragma semicolon 1



public Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks CS:GO movement mechanics.", 
	version = "0.7.0", 
	url = "https://github.com/danzayau/MovementTweaker"
};

ConVar gCV_AccelerateUseWeaponSpeed;
ConVar gCV_Prestrafe;
ConVar gCV_UniversalWeaponSpeed;
ConVar gCV_PerfTimingTweak;
ConVar gCV_PerfTicks;
ConVar gCV_ResetDuckSpeedOnLanding;
ConVar gCV_NerfPerfectCrouchjump;
ConVar gCV_SuppressLandingAnimation;
ConVar gCV_PlayerModelT;
ConVar gCV_PlayerModelCT;

char gC_PlayerModelT[256];
char gC_PlayerModelCT[256];

#include "movementtweaker/tweaks.sp"



public void OnPluginStart()
{
	if (GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("This plugin is for CS:GO.");
	}
	
	RegisterConVars();
	
	AutoExecConfig(true, "MovementTweaker");
	
	HookEvent("player_spawn", OnPlayerSpawn);
}

public void OnConfigsExecuted()
{
	UpdateAccelerateUseWeaponSpeed();
}

public void OnMapStart()
{
	// Setup and precache player models
	GetConVarString(gCV_PlayerModelT, gC_PlayerModelT, sizeof(gC_PlayerModelT));
	GetConVarString(gCV_PlayerModelCT, gC_PlayerModelCT, sizeof(gC_PlayerModelCT));
	
	PrecacheModel(gC_PlayerModelT, true);
	AddFileToDownloadsTable(gC_PlayerModelT);
	PrecacheModel(gC_PlayerModelCT, true);
	AddFileToDownloadsTable(gC_PlayerModelCT);
}



// =========================  CONVARS  ========================= //

void RegisterConVars()
{
	gCV_AccelerateUseWeaponSpeed = FindConVar("sv_accelerate_use_weapon_speed");
	
	gCV_Prestrafe = CreateConVar("mt_prestrafe", "1", "Sets whether prestrafe is enabled.", _, true, 0.0, true, 1.0);
	gCV_UniversalWeaponSpeed = CreateConVar("mt_universal_weapon_speed", "1", "Sets whether all weapons should have the same speed.", _, true, 0.0, true, 1.0);
	gCV_PerfTimingTweak = CreateConVar("mt_perf_timing_tweak", "1", "Sets whether to adjust the number of ticks after landing that jumping is considered a perfect b-hop.", _, true, 0.0, true, 1.0);
	gCV_PerfTicks = CreateConVar("mt_perf_ticks", "2", "Number of ticks after landing that jumping counts as a perfect bunnyhop.", _, true, 1.0, false);
	gCV_ResetDuckSpeedOnLanding = CreateConVar("mt_reset_duck_speed_on_landing", "1", "Sets whether to reset duckspeed upon landing.", _, true, 0.0, true, 1.0);
	gCV_NerfPerfectCrouchjump = CreateConVar("mt_nerf_perfect_crouchjump", "1", "Sets whether to disable perfect crouch jumps.", _, true, 0.0, true, 1.0);
	gCV_SuppressLandingAnimation = CreateConVar("mt_suppress_landing_animation", "1", "Sets whether to change player models on spawn to suppress the landing animations.", _, true, 0.0, true, 1.0);
	gCV_PlayerModelT = CreateConVar("mt_player_model_t", "models/player/tm_leet_varianta.mdl", "The model to change Terrorists to (applies after map change).");
	gCV_PlayerModelCT = CreateConVar("mt_player_model_ct", "models/player/ctm_idf_variantc.mdl", "The model to change Counter-Terrorists to (applies after map change).");
	
	gCV_UniversalWeaponSpeed.AddChangeHook(UniversalWeaponSpeedChanged);
}

public void UniversalWeaponSpeedChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	UpdateAccelerateUseWeaponSpeed();
}

void UpdateAccelerateUseWeaponSpeed()
{
	gCV_AccelerateUseWeaponSpeed.IntValue = gCV_UniversalWeaponSpeed.IntValue;
}



// =========================  CLIENT  ========================= //

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	OnPlayerRunCmd_Tweaks(client, buttons);
}

public void Movement_OnStartTouchGround(int client)
{
	OnStartTouchGround_Tweaks(client);
}

public void Movement_OnStopTouchGround(int client, bool jumped)
{
	OnStopTouchGround_Tweaks(client, jumped);
}

public void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	OnPlayerSpawn_Tweaks(GetClientOfUserId(GetEventInt(event, "userid")));
} 