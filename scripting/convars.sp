/*	convars.sp
	
	Implements convars for server control over features of the plugin.
*/


// ConVars
ConVar g_cvPrestrafe;
ConVar g_cvUniversalWeaponSpeed;
ConVar g_cvBhopTweaker;
ConVar g_cvSpeedPanel;


void RegisterConVars() {
	g_cvPrestrafe = CreateConVar("mt_prestrafe", "1", "Sets whether prestrafe is enabled.");
	g_cvUniversalWeaponSpeed = CreateConVar("mt_universal_weapon_speed", "1", "Sets whether all weapons should have the same speed.");
	g_cvBhopTweaker = CreateConVar("mt_bhop_tweak", "1", "Sets whether running speed should be knife running speed regardless of held weapon.");
	g_cvSpeedPanel = CreateConVar("mt_speed_panel", "1", "Sets whether or not the centre speed information panel for players is enabled.");
}