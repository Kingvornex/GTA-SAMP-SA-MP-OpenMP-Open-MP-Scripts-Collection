#include <a_samp>
#include <audio>

main()
{
	print("FS Online radio in cars loaded.");
	print("Author: SDraw");
}

forward PlayVehicleRadioForPlayer(playerid,online);
forward NonChangeRadio(playerid);

new VehRadio[MAX_VEHICLES];

new HandleidForPlayer[MAX_PLAYERS];
new bool:WaitForBuf[MAX_PLAYERS];

public OnFilterScriptInit()
{
	for(new i = 0; i < MAX_VEHICLES; i++) VehRadio[i] = 1;
	return 1;
}

public OnPlayerConnect(playerid)
{
    HandleidForPlayer[playerid] = 0;
    WaitForBuf[playerid] = false;
    return 0;
}

public OnPlayerStateChange(playerid,newstate,oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
	{
	    if(Audio_IsClientConnected(playerid))
	    {
	        if(HandleidForPlayer[playerid] == 0)
	        {
				Audio_StopRadio(playerid);
			    new veh = GetPlayerVehicleID(playerid);
			    PlayVehicleRadioForPlayer(playerid,VehRadio[veh]);
			}
		}
 	}
 	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
 	{
 	    if(Audio_IsClientConnected(playerid))
 	    {
 	        if(HandleidForPlayer[playerid] != 0)
	        {
		 		Audio_Stop(playerid,HandleidForPlayer[playerid]);
		 		HandleidForPlayer[playerid] = 0;
			}
		}
	}
 	return 0;
}

public PlayVehicleRadioForPlayer(playerid,online)
{
	switch(online)
	{
	    case 1:
		{
			HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://72.26.204.18:6006",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~DI Trance FM",3500,5);
		}
		case 2:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://85.214.146.14:8118",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~RS Culture FM",3500,5);
		}
		case 3:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://64.202.109.61:80",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~GotRadio FM",3500,5);
		}
		case 4:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://85.17.62.97:8036",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Radio Totaal FM",3500,5);
		}
		case 5:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://74.63.47.82:8506",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Street Lounge FM",3500,5);
		}
		case 6:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://213.133.120.70:8050",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Techno4ever Radio",3500,5);
		}
		case 7:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://193.42.152.215:8018",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Radio Redhill",3500,5);
		}
		case 8:
		{
			HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://46.105.109.142:9062",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~pLayTecH Studio",3500,5);
		}
		case 9:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://72.26.204.18:6696",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Classic R&H Sky FM",3500,5);
		}
		case 10:
		{
		    HandleidForPlayer[playerid] = Audio_PlayStreamed(playerid,"http://194.50.90.55:10005",false,false,false);
			Audio_SetVolume(playerid,HandleidForPlayer[playerid],30);
			GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~y~Real Wales Radio",3500,5);
		}
	}
	WaitForBuf[playerid] = true;
	SetTimerEx("NonChangeRadio",5000,false,"i",playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid,newkeys,oldkeys)
{
	if(newkeys == KEY_ACTION)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
		        if(Audio_IsClientConnected(playerid))
		        {
		            if(WaitForBuf[playerid]) return SendClientMessage(playerid,0xFF0000FF,"* –адио нельз€ сменить в течении 5-ти секунд");
			        new veh = GetPlayerVehicleID(playerid);
			        VehRadio[veh]++;
					if(VehRadio[veh] == 11) VehRadio[veh] = 1;
					Audio_Stop(playerid,HandleidForPlayer[playerid]);
		 			HandleidForPlayer[playerid] = 0;
		 			PlayVehicleRadioForPlayer(playerid,VehRadio[veh]);
      				for(new i = 0; i < MAX_PLAYERS; i++)
		 			{
		 			    if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(i) && playerid != i)
		 			    {
		 			        Audio_Stop(i,HandleidForPlayer[i]);
		 					HandleidForPlayer[i] = 0;
						 	PlayVehicleRadioForPlayer(i,VehRadio[veh]);
						}
					}
				}
			}
		}
	}
	if(newkeys == 132)
	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	        if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
		        if(Audio_IsClientConnected(playerid))
		        {
		            if(WaitForBuf[playerid]) return SendClientMessage(playerid,0xFF0000FF,"* –адио нельз€ сменить в течении 5-ти секунд");
			        new veh = GetPlayerVehicleID(playerid);
			        VehRadio[veh]--;
					if(VehRadio[veh] == 0) VehRadio[veh] = 10;
					Audio_Stop(playerid,HandleidForPlayer[playerid]);
		 			HandleidForPlayer[playerid] = 0;
		 			PlayVehicleRadioForPlayer(playerid,VehRadio[veh]);
		 			for(new i = 0; i < MAX_PLAYERS; i++)
		 			{
		 			    if(GetPlayerVehicleID(playerid) == GetPlayerVehicleID(i) && playerid != i)
		 			    {
		 			        Audio_Stop(i,HandleidForPlayer[i]);
		 					HandleidForPlayer[i] = 0;
						 	PlayVehicleRadioForPlayer(i,VehRadio[veh]);
						}
					}
				}
			}
		}
	}
	return 0;
}

public NonChangeRadio(playerid)
{
    WaitForBuf[playerid] = false;
    return 1;
}
