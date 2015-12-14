#include <sourcemod>
#include <sdktools>
//#include <sdktools_sound>

public Plugin myinfo =
{
	name = "CS:GO Dookie",
	author = "Tom Delebo",
	description = "Drop a steaming hot turdburger on scrubs!",
	version = "1.0",
	url = "https://github.com/delebota/CS-GO-Dookie-Mod"
};

// Sounds
#define DOOKIE_SOUND             "dookie/dookie.wav"
#define DOOKIE_SOUND_FULL        "sound/dookie/dookie.wav"
#define DOOKIE_SUPER_SOUND       "dookie/superdookie.wav"
#define DOOKIE_SUPER_SOUND_FULL  "sound/dookie/superdookie.wav"

// Models
#define DOOKIE_MODEL      "models/dookie/dookie.mdl"
#define DOOKIE_MODEL_DX80 "models/dookie/dookie.dx80.vtx"
#define DOOKIE_MODEL_DX90 "models/dookie/dookie.dx90.vtx"
#define DOOKIE_MODEL_VTX  "models/dookie/dookie.sw.vtx"
#define DOOKIE_MODEL_VVD  "models/dookie/dookie.vvd"
#define DOOKIE_MODEL_VMT  "materials/models/dookie/dookie.vmt"
#define DOOKIE_MODEL_VTF  "materials/models/dookie/dookie.vtf"

public void OnPluginStart()
{
	// Register our dookie commands
	RegConsoleCmd("!dookie", Command_Dookie);
	RegConsoleCmd("!dookie_help", Command_Dookie_Help);
}

public void OnMapStart() 
{
	// Cache files
	PrecacheModel(DOOKIE_MODEL, true);
	PrecacheSound(DOOKIE_SOUND, true);
	PrecacheSound(DOOKIE_SUPER_SOUND, true);
	
	// Set files for download
    AddFileToDownloadsTable(DOOKIE_MODEL);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX80);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX90);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTX);
    AddFileToDownloadsTable(DOOKIE_MODEL_VVD);
    AddFileToDownloadsTable(DOOKIE_MODEL_VMT);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTF);
    AddFileToDownloadsTable(DOOKIE_SOUND_FULL);
    AddFileToDownloadsTable(DOOKIE_SUPER_SOUND_FULL);
}

public Action Command_Dookie_Help(int client, int args)
{
	PrintToChat(client, " ***** CS:GO Dookie Mod Help ***** ", client);
	PrintToChat(client, "Type !dookie in the console. Bind it for easy access.", client);
	PrintToChat(client, "Kills grant dookies, use them near dead players.", client);
	PrintToChat(client, "Three headshots grant an earth shaking superdookie.", client);
 
	return Plugin_Handled;
}

public Action Command_Dookie(int client, int args)
{
	// Create Dookie
	//EmitSoundToAll(DOOKIE_SOUND);
	//CreateDookie(client);
	EmitSoundToAll(DOOKIE_SUPER_SOUND);
	CreateSuperDookie(client);
 
	return Plugin_Handled;
}

public CreateDookie(int client)
{
	// Get player position
	new Float:origin[3];
	GetClientAbsOrigin(client, origin);

	// Create dookie model
	new entDookieIndex = CreateEntityByName("prop_dynamic");
	if (entDookieIndex != -1 && IsValidEntity(entDookieIndex))
	{
		// Set dookie model values
		DispatchKeyValue(entDookieIndex, "model", DOOKIE_MODEL);
		DispatchKeyValueFloat(entDookieIndex, "solid", 4.0);
		
		// Spawn dookie model
		DispatchSpawn(entDookieIndex);
		TeleportEntity(entDookieIndex, origin, NULL_VECTOR, NULL_VECTOR);
	}
	
	// Add steam sprite
	new entSteamIndex = CreateEntityByName("env_steam");
	if (entSteamIndex != -1 && IsValidEntity(entSteamIndex))
	{
		// Set steam sprite values
		DispatchKeyValue(entSteamIndex, "SpawnFlags", "1");
		DispatchKeyValue(entSteamIndex, "RenderColor", "230 230 230");
		DispatchKeyValue(entSteamIndex, "SpreadSpeed", "1.5");
		DispatchKeyValue(entSteamIndex, "Speed", "3");
		DispatchKeyValue(entSteamIndex, "StartSize", "1");
		DispatchKeyValue(entSteamIndex, "EndSize", "2");
		DispatchKeyValue(entSteamIndex, "Rate", "1");
		DispatchKeyValue(entSteamIndex, "JetLength", "20");
		DispatchKeyValue(entSteamIndex, "RenderAmt", "128");
		DispatchKeyValue(entSteamIndex, "InitialState", "1");
		
		// Spawn steam sprite
		origin[2] += 11.0;
		new Float:angles[3];
		angles[0] = -90.0;
		angles[1] = 0.0;
		angles[2] = 0.0;
		DispatchSpawn(entSteamIndex);
		AcceptEntityInput(entSteamIndex, "TurnOn");
		TeleportEntity(entSteamIndex, origin, angles, NULL_VECTOR);
	}
}

public CreateSuperDookie(int client)
{
	// Get player position
	new Float:origin[3];
	GetClientAbsOrigin(client, origin);

	// Create dookie model
	new entDookieIndex = CreateEntityByName("prop_dynamic");
	if (entDookieIndex != -1 && IsValidEntity(entDookieIndex))
	{
		// Set dookie model values
		DispatchKeyValue(entDookieIndex, "model", DOOKIE_MODEL);
		DispatchKeyValueFloat(entDookieIndex, "solid", 4.0);
		
		// Spawn dookie model
		DispatchSpawn(entDookieIndex);
		TeleportEntity(entDookieIndex, origin, NULL_VECTOR, NULL_VECTOR);
	}
	
	// Add shake
	new entShakeIndex = CreateEntityByName("env_shake");
	if (entShakeIndex != -1 && IsValidEntity(entShakeIndex))
	{
		// Set shake values
		DispatchKeyValue(entShakeIndex, "SpawnFlags", "1");
		DispatchKeyValueFloat(entShakeIndex, "Amplitude", 8.0);
		DispatchKeyValueFloat(entShakeIndex, "Radius", 512.0);
		DispatchKeyValueFloat(entShakeIndex, "Duration", 2.0);
		DispatchKeyValueFloat(entShakeIndex, "Frequency", 128.0);
		
		// Spawn shake
		DispatchSpawn(entShakeIndex);
		AcceptEntityInput(entShakeIndex, "StartShake");
		TeleportEntity(entShakeIndex, origin, NULL_VECTOR, NULL_VECTOR);
	}
	
	// Add explosion
	new entExplosionIndex = CreateEntityByName("env_explosion");
	if (entExplosionIndex != -1 && IsValidEntity(entExplosionIndex))
	{
		// Set explosion values
		DispatchKeyValue(entExplosionIndex, "SpawnFlags", "1");
		DispatchKeyValue(entExplosionIndex, "iMagnitude", "1000");
		DispatchKeyValue(entExplosionIndex, "RenderMode", "0");
		
		// Spawn explosion
		DispatchSpawn(entExplosionIndex);
		TeleportEntity(entExplosionIndex, origin, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(entExplosionIndex, "Explode");
	}
	
	// Add steam sprite
	new entSteamIndex = CreateEntityByName("env_steam");
	if (entSteamIndex != -1 && IsValidEntity(entSteamIndex))
	{
		// Set steam sprite values
		DispatchKeyValue(entSteamIndex, "SpawnFlags", "1");
		DispatchKeyValue(entSteamIndex, "RenderColor", "79 141 57");
		DispatchKeyValue(entSteamIndex, "SpreadSpeed", "1.5");
		DispatchKeyValue(entSteamIndex, "Speed", "3");
		DispatchKeyValue(entSteamIndex, "StartSize", "1");
		DispatchKeyValue(entSteamIndex, "EndSize", "2");
		DispatchKeyValue(entSteamIndex, "Rate", "1");
		DispatchKeyValue(entSteamIndex, "JetLength", "20");
		DispatchKeyValue(entSteamIndex, "RenderAmt", "128");
		DispatchKeyValue(entSteamIndex, "InitialState", "1");
		
		// Spawn steam sprite
		origin[2] += 11.0;
		new Float:angles[3];
		angles[0] = -90.0;
		angles[1] = 0.0;
		angles[2] = 0.0;
		DispatchSpawn(entSteamIndex);
		AcceptEntityInput(entSteamIndex, "TurnOn");
		TeleportEntity(entSteamIndex, origin, angles, NULL_VECTOR);
	}
}