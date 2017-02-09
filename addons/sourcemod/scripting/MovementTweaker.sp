#include <sourcemod>
#include <sdktools>
#include <cstrike>

#include <movement>
#include <movementtweaker>

#pragma newdecls required
#pragma semicolon 1

public Plugin myinfo = 
{
	name = "Movement Tweaker", 
	author = "DanZay", 
	description = "Tweaks CS:GO movement mechanics.", 
	version = "0.6.2", 
	url = "https://github.com/danzayau/MovementTweaker"
};



/*===============================  Definitions  ===============================*/

#define NORMAL_JUMP_VERTICAL_VELOCITY 292.54 // Found by testing until binding resulted in similar jump height to normal
#define NUMBER_OF_WEAPONS 37
#define MAX_NORMAL_SPEED 250.0 // Desired speed when just holding down W and running
#define NO_WEAPON_SPEED // Max speed with no weapon and just holding down W and running
#define MAX_PRESTRAFE_MODIFIER 1.104 	// Calculated 276/250
#define PRESTRAFE_INCREASE_RATE 0.0014
#define PRESTRAFE_DECREASE_RATE 0.0021
#define DUCK_SPEED_ONLANDING_MINIMUM 7.0



/*===============================  Global Variables  ===============================*/

MovementPlayer g_MovementPlayer[MAXPLAYERS + 1];
float gF_PrestrafeVelocityModifier[MAXPLAYERS + 1];
bool gB_HitPerf[MAXPLAYERS + 1];
char gC_PlayerModelT[256];
char gC_PlayerModelCT[256];

char gC_WeaponNames[NUMBER_OF_WEAPONS][] = 
{ "weapon_ak47", "weapon_aug", "weapon_awp", "weapon_bizon", "weapon_deagle", 
	"weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang", 
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", 
	"weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1", "weapon_mac10", 
	"weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", 
	"weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff", "weapon_scar20", 
	"weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", 
	"weapon_ump45", "weapon_xm1014" };

int gI_WeaponRunSpeeds[NUMBER_OF_WEAPONS] =  // Max movement speed of weapons (respective to gC_WeaponNames array).
{ 215, 220, 200, 240, 230, 
	245, 240, 220, 240, 245, 
	215, 215, 240, 245, 240, 
	245, 250, 195, 225, 240, 
	225, 245, 220, 240, 195, 
	220, 240, 230, 210, 215, 
	210, 245, 230, 240, 240, 
	230, 215 };



/*===============================  Includes  ===============================*/

#include "MovementTweaker/convars.sp"
#include "MovementTweaker/tweaks.sp"
#include "MovementTweaker/misc.sp"
#include "MovementTweaker/api.sp"



/*===============================  Plugin Events  ===============================*/

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max) {
	CreateNatives();
	RegPluginLibrary("MovementTweaker");
	return APLRes_Success;
}

public void OnPluginStart() {
	// Check if game is CS:GO.
	EngineVersion gameEngine = GetEngineVersion();
	if (gameEngine != Engine_CSGO) {
		SetFailState("This plugin is for CS:GO.");
	}
	CreateGlobalForwards();
	RegisterConVars();
	AutoExecConfig(true, "MovementTweaker");
	// Hooks
	HookEvent("player_spawn", OnPlayerSpawn);
	
	SetupMovementMethodmaps();
}

public void OnConfigsExecuted() {
	UpdateAccelerateUseWeaponSpeed();
}



/*===============================  Miscellaneous Events  ===============================*/

public void OnMapStart() {
	PrecacheModels();
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2]) {
	if (IsPlayerAlive(client)) {
		GeneralTweak(g_MovementPlayer[client]);
	}
}

public void OnStartTouchGround(int client) {
	LandingTweak(g_MovementPlayer[client]);
}

public void OnStopTouchGround(int client, bool jumped, bool ducked, bool landed) {
	if (jumped) {
		JumpTweak(g_MovementPlayer[client]);
		if (ducked) {
			NerfPerfectCrouchJump(g_MovementPlayer[client]);
		}
	}
	else {
		gB_HitPerf[client] = false;
	}
	gF_PrestrafeVelocityModifier[client] = 1.0; // Because it doesn't update when in the air
}

// Set player models to ones that don't have landing animations
public void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast) {
	if (gCV_SuppressLandingAnimation.IntValue) {
		UpdatePlayerModel(GetClientOfUserId(GetEventInt(event, "userid")));
	}
} 