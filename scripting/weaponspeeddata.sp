/*	weaponspeeddata.sp

	An array containing weapon names, and their run speeds in their respective positions in a second array.
*/

// Credit: 	blacky

char g_weaponList[NUMBER_OF_WEAPONS][] =  // Weapon names.
{ "weapon_ak47", "weapon_aug", "weapon_awp", "weapon_bizon", "weapon_deagle", "weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang", 
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", "weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1", "weapon_mac10", 
	"weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff", 
	"weapon_scar20", "weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", "weapon_ump45", "weapon_xm1014", "weapon_revolver" };

int g_runSpeeds[NUMBER_OF_WEAPONS] =  // Max movement speed of weapons (respective to g_weaponList array.
{ 215, 220, 169, 240, 230, 245, 240, 220, 240, 245, 
	215, 215, 240, 245, 240, 245, 250, 195, 225, 240, 
	225, 245, 220, 240, 195, 220, 240, 230, 210, 215, 
	210, 245, 230, 240, 240, 230, 215, 220 }; 