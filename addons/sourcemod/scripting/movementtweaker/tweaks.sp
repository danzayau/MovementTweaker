/*
	Tweaks

	Movement tweaks.
*/



#define SPEED_NORMAL 250.0
#define SPEED_NO_WEAPON 260.0
#define DUCK_SPEED_MINIMUM 8.0

#define PRE_VELMOD_MAX 1.104 // Calculated 276/250
#define PRE_VELMOD_INCREMENT 0.0014 // Per tick when prestrafing
#define PRE_VELMOD_DECREMENT 0.0021 // Per tick when not prestrafing

static int oldButtons[MAXPLAYERS + 1];
static float preVelMod[MAXPLAYERS + 1];

static char weaponNames[][] = 
{
	"weapon_knife", "weapon_hkp2000", "weapon_deagle", "weapon_elite", "weapon_fiveseven", 
	"weapon_glock", "weapon_p250", "weapon_tec9", "weapon_decoy", "weapon_flashbang", 
	"weapon_hegrenade", "weapon_incgrenade", "weapon_molotov", "weapon_smokegrenade", "weapon_taser", 
	"weapon_ak47", "weapon_aug", "weapon_awp", "weapon_bizon", "weapon_famas", 
	"weapon_g3sg1", "weapon_galilar", "weapon_m249", "weapon_m4a1", "weapon_mac10", 
	"weapon_mag7", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", 
	"weapon_p90", "weapon_sawedoff", "weapon_scar20", "weapon_sg556", "weapon_ssg08", 
	"weapon_ump45", "weapon_xm1014"
};

static int weaponRunSpeeds[sizeof(weaponNames)] = 
{
	250, 240, 230, 240, 240, 
	240, 240, 240, 245, 245, 
	245, 245, 245, 245, 220, 
	215, 220, 200, 240, 220, 
	215, 215, 195, 225, 240, 
	225, 220, 240, 150, 220, 
	230, 210, 215, 210, 230, 
	230, 215
};



// =========================  LISTENERS  ========================= //

void OnPlayerRunCmd_Tweaks(int client, int &buttons)
{
	if (!IsPlayerAlive(client))
	{
		return;
	}
	
	MovementAPIPlayer player = new MovementAPIPlayer(client);
	RemoveCrouchJumpBind(player, buttons);
	TweakVelMod(player);
	oldButtons[client] = buttons;
}

void OnStartTouchGround_Tweaks(int client)
{
	MovementAPIPlayer player = new MovementAPIPlayer(client);
	ReduceDuckSlowdown(player);
}

void OnStopTouchGround_Tweaks(int client, bool jumped)
{
	MovementAPIPlayer player = new MovementAPIPlayer(client);
	if (jumped)
	{
		TweakJump(player);
	}
	preVelMod[player.id] = 1.0;
}

void OnPlayerSpawn_Tweaks(int client)
{
	if (!gCV_SuppressLandingAnimation.BoolValue)
	{
		return;
	}
	
	if (GetClientTeam(client) == CS_TEAM_T)
	{
		SetEntityModel(client, gC_PlayerModelT);
	}
	else if (GetClientTeam(client) == CS_TEAM_CT)
	{
		SetEntityModel(client, gC_PlayerModelCT);
	}
}



// =========================  PRIVATE  ========================= //

static void TweakVelMod(MovementAPIPlayer player)
{
	if (!player.onGround)
	{
		return;
	}
	player.velocityModifier = CalcPrestrafeVelMod(player) * CalcWeaponVelMod(player);
}

static float CalcPrestrafeVelMod(MovementAPIPlayer player)
{
	if (!gCV_Prestrafe.BoolValue)
	{
		return 1.0;
	}
	
	if (player.turning
		 && ((player.buttons & IN_FORWARD && !(player.buttons & IN_BACK)) || (!(player.buttons & IN_FORWARD) && player.buttons & IN_BACK))
		 && ((player.buttons & IN_MOVELEFT && !(player.buttons & IN_MOVERIGHT)) || (!(player.buttons & IN_MOVELEFT) && player.buttons & IN_MOVERIGHT)))
	{
		preVelMod[player.id] += PRE_VELMOD_INCREMENT;
	}
	else
	{
		preVelMod[player.id] -= PRE_VELMOD_DECREMENT;
	}
	
	// Keep prestrafe velocity modifier within range
	if (preVelMod[player.id] < 1.0)
	{
		preVelMod[player.id] = 1.0;
	}
	else if (preVelMod[player.id] > PRE_VELMOD_MAX)
	{
		preVelMod[player.id] = PRE_VELMOD_MAX;
	}
	
	return preVelMod[player.id];
}

static float CalcWeaponVelMod(MovementAPIPlayer player)
{
	if (!gCV_UniversalWeaponSpeed.BoolValue)
	{
		return 1.0;
	}
	
	int weaponEnt = GetEntPropEnt(player.id, Prop_Data, "m_hActiveWeapon");
	if (!IsValidEntity(weaponEnt))
	{
		return SPEED_NORMAL / SPEED_NO_WEAPON; // Weapon entity not found, so no weapon
	}
	
	char weaponName[64];
	GetEntityClassname(weaponEnt, weaponName, sizeof(weaponName)); // Weapon the client is holding
	
	// Get weapon speed and work out how much to scale the modifier
	int weaponCount = sizeof(weaponNames);
	for (int weaponID = 0; weaponID < weaponCount; weaponID++)
	{
		if (StrEqual(weaponName, weaponNames[weaponID]))
		{
			return SPEED_NORMAL / weaponRunSpeeds[weaponID];
		}
	}
	
	return 1.0; // If weapon isn't found (new weapon?)
}

static void TweakJump(MovementAPIPlayer player)
{
	if (!gCV_PerfTimingTweak.BoolValue || gCV_PerfTicks.IntValue <= 1)
	{
		return;
	}
	
	if (player.takeoffTick - player.landingTick <= gCV_PerfTicks.IntValue
		 && player.takeoffTick - player.landingTick > 1)
	{
		float velocity[3], baseVelocity[3], newVelocity[3];
		player.GetVelocity(velocity);
		player.GetBaseVelocity(baseVelocity);
		player.GetLandingVelocity(newVelocity);
		newVelocity[2] = velocity[2];
		SetVectorHorizontalLength(newVelocity, player.landingSpeed);
		AddVectors(newVelocity, baseVelocity, newVelocity);
		player.SetVelocity(newVelocity);
	}
}

static void RemoveCrouchJumpBind(MovementAPIPlayer player, int &buttons)
{
	if (!gCV_NerfPerfectCrouchjump.BoolValue)
	{
		return;
	}
	
	if (player.onGround && buttons & IN_JUMP
		 && !(oldButtons[player.id] & IN_JUMP)
		 && !(oldButtons[player.id] & IN_DUCK))
	{
		buttons &= ~IN_DUCK;
	}
}

static void ReduceDuckSlowdown(MovementAPIPlayer player)
{
	if (!gCV_ResetDuckSpeedOnLanding.BoolValue)
	{
		return;
	}
	
	if (player.duckSpeed < DUCK_SPEED_MINIMUM)
	{
		player.duckSpeed = DUCK_SPEED_MINIMUM;
	}
} 