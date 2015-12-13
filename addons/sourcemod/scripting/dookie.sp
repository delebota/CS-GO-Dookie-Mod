#include <sourcemod>
#include <sdktools>
//#include <sdktools_sound>

public Plugin myinfo =
{
	name = "CS:GO Dookie",
	author = "Tom Delebo",
	description = "Drop a steaming hot turdburger on scrubs!",
	version = "1.0",
	url = "http://www.github.com/"
};

#define DOOKIE_SOUND      "dookie/dookie.wav"
#define DOOKIE_SOUND_FULL "sound/dookie/dookie.wav"
#define DOOKIE_MODEL      "models/dookie/dookie.mdl"
#define DOOKIE_MODEL_DX80 "models/dookie/dookie.dx80.vtx"
#define DOOKIE_MODEL_DX90 "models/dookie/dookie.dx90.vtx"
#define DOOKIE_MODEL_VTX  "models/dookie/dookie.sw.vtx"
#define DOOKIE_MODEL_VVD  "models/dookie/dookie.vvd"
#define DOOKIE_MODEL_VMT  "materials/models/dookie/dookie.vmt"
#define DOOKIE_MODEL_VTF  "materials/models/dookie/dookie.vtf"

public void OnPluginStart()
{
	// Register our dookie command
	RegConsoleCmd("!dookie", Command_Dookie);
}

public void OnMapStart() 
{
	// Cache files
	PrecacheModel(DOOKIE_MODEL, true);
	PrecacheSound(DOOKIE_SOUND, true);
	
	// Set files for download
    AddFileToDownloadsTable(DOOKIE_MODEL);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX80);
    AddFileToDownloadsTable(DOOKIE_MODEL_DX90);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTX);
    AddFileToDownloadsTable(DOOKIE_MODEL_VVD);
    AddFileToDownloadsTable(DOOKIE_MODEL_VMT);
    AddFileToDownloadsTable(DOOKIE_MODEL_VTF);
    AddFileToDownloadsTable(DOOKIE_SOUND_FULL);
}

public Action Command_Dookie(int client, int args)
{
	// Create Dookie
	EmitSoundToAll(DOOKIE_SOUND);
	//CreateDookie(client);
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