#include <a_samp>
#include <progress>

//DEFINES ______________________
#define BENCH_PRESS_INDEX (1)
#define VER_IN "0.143 beta"
#define BUILD_TM "29.03.2013"
//Location & data
//RUNNY MACHINE



stock static Float:
	run_machine_pos[ ][ ] =
{
	{ 773.4922, -2.6016,1000.7209 ,180.00000 }, // Los Santos Gym's bench.
	{ 759.6328, -48.1250, 1000.7209,180.00000}, // San Fierro Gym's bench.
	{ 758.3828, -65.5078, 1000.7209,180.00000} // Las Venturas Gym's bench
};
//BIKE
stock static Float:
	bike_pos[ ][ ] =
{
	{772.172,9.41406,1000.0,90.0}, // Los Santos Gym's Bake
	{769.242,-47.8984,1000.0,90.0}, // San Fierro Gym's Bake
	{774.625,-68.6406,1000.0,90.0} // Las Venturas Gym's Bake
};

//Bench
stock static Float:
	bench_pos[ ][ ] =
{
	{ 773.0491,1.4285,1000.7209, 269.2024 }, // Los Santos Gym's bench.
	{ 766.3170,-47.3574,1000.5859, 179.2983 }, // San Fierro Gym's bench.
	{ 764.9001,-60.5580,1000.6563, 1.9500 } // Las Venturas Gym's bench
};
stock static Float:
	barbell_pos[ ][ ] =
{
	{ 774.42907715,1.88309872,1000.48834229,0.00000000,270.00000000,87.99966431 }, // Los Santos Gym's BarBell
	{ 765.85528564,-48.86857224,1000.64093018,0.00000000,89.49993896,0.00000000 }, // San Fierro Gym's BarBell.
	{ 765.34039307,-59.18271637,1000.63793945,0.00000000,89.49993896,181.25012207 } // Las Venturas Gym's BarBell
};

//Advanced Parts
stock static Float:
	dumb_pos[ ][ ] =
{
	{772.992,5.38281,999.727,270.0}, // Los Santos Gym's dumb
	{756.406,-47.9219,999.727,90.0}, // San Fierro Gym's dumb.
	{759.18,-60.0625,999.727,90.0} // Las Venturas Gym's dumb
};

stock static Float:
	dumb_bell_right_pos[ ][ ] =
{
	{772.992,5.18281,999.927,0.0,90.0,90.0} // Los Santos Gym's dumb right
//	{759.18,-60.0625,999.727,90} // Las Venturas Gym's dumb
};

stock static Float:
	dumb_bell_left_pos[ ][ ] =
{
	{772.992,5.62738,999.927,0.0,90.0,90.0} // Los Santos Gym's dumb left
//	{759.18,-60.0625,999.727,90} // Las Venturas Gym's dumb
};



//BOOLS
//____TREAM
new bool:TREAM_IN_USE[sizeof run_machine_pos]=false;
new PLAYER_CURRECT_TREAD[MAX_PLAYERS],
 	bool:PLAYER_INTREAM[MAX_PLAYERS]=false;
//____BIKE___
new bool:BIKE_IN_USE[sizeof bike_pos]=false;
new PLAYER_CURRECT_BIKE[MAX_PLAYERS],
 	bool:PLAYER_INBIKE[MAX_PLAYERS]=false;
//___BENCH___
new bool:BENCH_IN_USE[sizeof bench_pos]=false;
new PLAYER_CURRECT_BENCH[MAX_PLAYERS],
	bool:PLAYER_INBENCH[MAX_PLAYERS]=false;
//___DUMB_BELL___
new bool:DUMB_IN_USE[sizeof bench_pos]=false;
new PLAYER_CURRECT_DUMB[MAX_PLAYERS],
	bool:PLAYER_INDUMB[MAX_PLAYERS]=false;

//Gobale
new bool:BAR_CAN_BE_USED[MAX_PLAYERS]=false;
new barbell_objects[sizeof barbell_pos];
new dumbell_right_objects[sizeof dumb_bell_right_pos];
new dumbell_left_objects[sizeof dumb_bell_left_pos];
//TEXTDRAWS
new Bar:player_gym_progress[MAX_PLAYERS];
new Text:gym_power[ MAX_PLAYERS ];
new Text:gym_des[MAX_PLAYERS];
new Text:gym_deslabel[MAX_PLAYERS];
new Text:gym_repslabel[MAX_PLAYERS];
//TIMERS
//________TREAD____________________
new PLAYER_TREAD_TIMER[MAX_PLAYERS];
//________BIKE_____________________
new PLAYER_BIKE_TIMER[MAX_PLAYERS];
//________BENCH____________________
new PLAYER_BENCH_TIMER[MAX_PLAYERS];
//________DUMB_BELL_____________
new PLAYER_DUMB_TIMER[MAX_PLAYERS];

//VALUES
//________TREAD____________________
new PLAYER_TREAM_DIS_COUNT[MAX_PLAYERS];
//________BIKE_____________________
new PLAYER_BIKE_DIS_COUNT[MAX_PLAYERS];
//_______BENCH___________________
new PLAYER_BENCH_COUNT[MAX_PLAYERS];
//________DUMB_BELL_____________
new PLAYER_DUMB_COUNT[MAX_PLAYERS];

public OnPlayerConnect( playerid )
{

//	ApplyAnimation( playerid, "GYMNASIUM", "null", 1, 0, 0, 0, 1, 0, 1 );
	player_gym_progress[playerid]=CreateProgressBar( 550.000000, 166.000000, .color = 0x00F900FF );

	gym_power[ playerid ] = TextDrawCreate(426.000000, 158.000000, "POWER:");
	TextDrawBackgroundColor(gym_power[ playerid ], 255);
	TextDrawFont(gym_power[ playerid ], 2);
	TextDrawLetterSize(gym_power[ playerid ], 0.400000, 1.800000);
	TextDrawColor(gym_power[ playerid ], -1);
	TextDrawSetOutline(gym_power[ playerid ], 0);
	TextDrawSetProportional(gym_power[ playerid ], 1);
	TextDrawSetShadow(gym_power[ playerid ], 1);

 	gym_des[ playerid ] = TextDrawCreate(426.000000, 203.000000, "DISTANCE:");
	TextDrawBackgroundColor(gym_des[ playerid ], 255);
	TextDrawFont(gym_des[ playerid ], 2);
	TextDrawLetterSize(gym_des[ playerid ], 0.509999, 1.800000);
	TextDrawColor(gym_des[ playerid ], -1);
	TextDrawSetOutline(gym_des[ playerid ], 0);
	TextDrawSetProportional(gym_des[ playerid ], 1);
	TextDrawSetShadow(gym_des[ playerid ], 1);

	gym_repslabel[ playerid ] = TextDrawCreate(426.000000, 203.000000, "REPS:");
	TextDrawBackgroundColor(gym_repslabel[ playerid ], 255);
	TextDrawFont(gym_repslabel[ playerid ], 2);
	TextDrawLetterSize(gym_repslabel[ playerid ], 0.509999, 1.800000);
	TextDrawColor(gym_repslabel[ playerid ], -1);
	TextDrawSetOutline(gym_repslabel[ playerid ], 0);
	TextDrawSetProportional(gym_repslabel[ playerid ], 1);
	TextDrawSetShadow(gym_repslabel[ playerid ], 1);
    
    
    
	gym_deslabel[ playerid ] = TextDrawCreate(557.000000, 203.000000, "0");
	TextDrawBackgroundColor(gym_deslabel[ playerid ], 255);
	TextDrawFont(gym_deslabel[ playerid ], 2);
	TextDrawLetterSize(gym_deslabel[ playerid ], 0.509999, 1.800000);
	TextDrawColor(gym_deslabel[ playerid ], -1);
	TextDrawSetOutline(gym_deslabel[ playerid ], 0);
	TextDrawSetProportional(gym_deslabel[ playerid ], 1);
	TextDrawSetShadow(gym_deslabel[ playerid ], 1);




	return true;
}

public OnFilterScriptInit()
{
	print("\n_______[GYM SYSTEM]_________");

	print("[VERSION]: "VER_IN"\t[BUILD TIME]: "BUILD_TM"");
	print("[PROGRAM BY]: EPISODES (KEN CAI) 2013");
	print("______________________________\n");
	for( new o; o != sizeof barbell_pos; ++ o )
	{
	barbell_objects[o] = CreateObject( 2913, barbell_pos[ o ][ 0 ], barbell_pos[ o ][ 1 ], barbell_pos[ o ][ 2 ], barbell_pos[ o ][ 3 ], barbell_pos[ o ][ 4 ], barbell_pos[ o ][ 5 ] );
	dumbell_right_objects[o] = CreateObject(3071,dumb_bell_right_pos[o][0],dumb_bell_right_pos[o][1],dumb_bell_right_pos[o][2],dumb_bell_right_pos[o][3],dumb_bell_right_pos[o][4],dumb_bell_right_pos[o][5]);
	dumbell_left_objects[o] = CreateObject(3072,dumb_bell_left_pos[o][0],dumb_bell_left_pos[o][1],dumb_bell_left_pos[o][2],dumb_bell_left_pos[o][3],dumb_bell_left_pos[o][4],dumb_bell_left_pos[o][5]);
	}
	
}

public OnPlayerKeyStateChange( playerid, newkeys, oldkeys )
{

	if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ) )
  	{
		if(PLAYER_INTREAM[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
	  	KillTimer(PLAYER_TREAD_TIMER[playerid]);
	    GetOffTread(playerid);
	 	}

		if(PLAYER_INBIKE[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
	  	KillTimer(PLAYER_BIKE_TIMER[playerid]);
	    GetOffBIKE(playerid);
	 	}

		if(PLAYER_INBENCH[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
		KillTimer(PLAYER_BENCH_TIMER[playerid]);
		GetOffBENCH(playerid);
		
		}
		
		if(PLAYER_INDUMB[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
		{
		KillTimer(PLAYER_DUMB_TIMER[playerid]);
		PutDownDUMB(playerid);

		}

	}


	if ( ( newkeys & KEY_SECONDARY_ATTACK ) && !( oldkeys & KEY_SECONDARY_ATTACK ))
	{
		for( new o; o != sizeof run_machine_pos; o ++ )
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ], run_machine_pos[ o ][ 2 ] ) )
			{
			if(TREAM_IN_USE[o]==false && PLAYER_INTREAM[playerid]==false)
			{
			//bool
			PLAYER_INTREAM[playerid]=true;
			TREAM_IN_USE[o]=true;
			PLAYER_CURRECT_TREAD[playerid]=o;
			//clearn values
			PLAYER_TREAM_DIS_COUNT[playerid]=0;
			//Set Player Pos
			SetPlayerPos( playerid, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ]+1.3, run_machine_pos[ o ][ 2 ] );
			SetPlayerFacingAngle( playerid, run_machine_pos[ o ][ 3 ] );
			TogglePlayerControllable( playerid, 0 );//Disable Control
			ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_geton", 1, 0, 0, 0, 1, 0, 1 );
			SetTimerEx( "TREAM_START", 2000, false, "ii", playerid);

			//SETVALUES
			SetProgressBarValue(player_gym_progress[playerid],50);

			//Set Camera pos
			SetPlayerCameraPos( playerid, run_machine_pos[ o ][ 0 ] +2, run_machine_pos[ o ][ 1 ] -2, run_machine_pos[ o ][ 2 ] + 0.5 );
			SetPlayerCameraLookAt( playerid, run_machine_pos[ o ][ 0 ], run_machine_pos[ o ][ 1 ], run_machine_pos[ o ][ 2 ]);

			}else{
			GameTextForPlayer(playerid,"Sorry This Machine is currectly in used", 5000, 4);
			}


		}

	}

		for( new b; b != sizeof bike_pos; b ++ )
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, bike_pos[ b ][ 0 ], bike_pos[ b ][ 1 ], bike_pos[ b ][ 2 ] ) )
			{
				if(BIKE_IN_USE[b]==false && PLAYER_INBIKE[playerid]==false)
				{
				//Bool Here
				BIKE_IN_USE[b]=true;
				PLAYER_INBIKE[playerid]=true;
				PLAYER_CURRECT_BIKE[playerid]=b;
				//clearn values
				PLAYER_BIKE_DIS_COUNT[playerid]=0;
				//SETVALUES
				SetProgressBarValue(player_gym_progress[playerid],0);

				//SetPlayerPos
				SetPlayerPos( playerid, bike_pos[ b ][ 0 ]+0.5, bike_pos[ b ][ 1 ]-0.5, bike_pos[ b ][ 2 ] );
				SetPlayerFacingAngle( playerid, bike_pos[ b ][ 3 ] );
				TogglePlayerControllable( playerid, 0 );
				ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_geton", 1, 0, 0, 0, 1, 0, 1 );
				//Set Timer
				SetTimerEx( "BIKE_START", 2000, false, "i", playerid);
				//SetCaremaPos
				SetPlayerCameraPos( playerid, bike_pos[ b ][ 0 ] +2, bike_pos[ b ][ 1 ] -2, bike_pos[ b ][ 2 ] + 0.5 );
				SetPlayerCameraLookAt( playerid, bike_pos[ b ][ 0 ], bike_pos[ b ][ 1 ], bike_pos[ b ][ 2 ]+0.5);

				}else{
				GameTextForPlayer(playerid,"Sorry This Machine is currectly in used", 5000, 4);
				}

			}

		}
		for (new g; g != sizeof bench_pos; g ++)
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ] ) )
			{
				if(BENCH_IN_USE[g]==false && PLAYER_INBENCH[playerid]==false)
				{
				BENCH_IN_USE[g]=true;
				PLAYER_INBENCH[playerid]=true;
				PLAYER_CURRECT_BENCH[playerid]=g;
				//clearn values
				PLAYER_BENCH_COUNT[playerid]=0;
				//SETVALUES
				SetProgressBarValue(player_gym_progress[playerid],0);
				//SET POS NOW
				TogglePlayerControllable( playerid, 0 );
				SetPlayerPos( playerid, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ] );
				SetPlayerFacingAngle( playerid, bench_pos[ g ][ 3 ] );
				ApplyAnimation( playerid, "benchpress", "gym_bp_geton", 1, 0, 0, 0, 1, 0, 1 );

				SetTimerEx( "BENCH_START", 3800, 0, "ii", playerid,g);
				SetPlayerCameraPos( playerid, bench_pos[ g ][ 0 ]-1.5, bench_pos[ g ][ 1 ]+1.5, bench_pos[ g ][ 2 ] + 0.5 );
				SetPlayerCameraLookAt( playerid, bench_pos[ g ][ 0 ], bench_pos[ g ][ 1 ], bench_pos[ g ][ 2 ]);


				}else{
				GameTextForPlayer(playerid,"Sorry This Machine is currectly in used", 5000, 4);
				}



			}

		}

		for (new d; d != sizeof dumb_pos; d ++)
		{
			if( IsPlayerInRangeOfPoint( playerid, 2.0, dumb_pos[ d ][ 0 ], dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ] ) )
			{
				if(DUMB_IN_USE[d]==false && PLAYER_INDUMB[playerid]==false)
				{
				DUMB_IN_USE[d]=true;
				PLAYER_INDUMB[playerid]=true;
				PLAYER_CURRECT_DUMB[playerid]=d;
				//clearn values
				PLAYER_DUMB_COUNT[playerid]=0;
				SetProgressBarValue(player_gym_progress[playerid],0);

				//SET POS NOW
				TogglePlayerControllable( playerid, 0 );
				SetPlayerPos( playerid, dumb_pos[ d ][ 0 ]-1, dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ] +1);
				SetPlayerFacingAngle( playerid, dumb_pos[ d ][ 3 ] );
				ApplyAnimation( playerid, "Freeweights", "gym_free_pickup", 1, 0, 0, 0, 1, 0, 1 );

				SetTimerEx( "DUMB_START", 2500, 0, "ii", playerid);

				SetPlayerCameraPos( playerid, dumb_pos[ d ][ 0 ]+2.3, dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ]+0.3 );
				SetPlayerCameraLookAt( playerid, dumb_pos[ d ][ 0 ], dumb_pos[ d ][ 1 ], dumb_pos[ d ][ 2 ]+0.5);
				}

			}

		}



	}

	if ( ( newkeys & KEY_SPRINT ) && !( oldkeys & KEY_SPRINT ) )
 	{
 	if(PLAYER_INTREAM[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
 	{
	 	//Update Bar
	 	SetProgressBarValue( player_gym_progress[playerid], GetProgressBarValue( player_gym_progress[playerid] ) + 5 );
		UpdateProgressBar( player_gym_progress[playerid], playerid );
		//Anoynned Part
		new LocalLabel[10];
		PLAYER_TREAM_DIS_COUNT[playerid]++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_TREAM_DIS_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);

	

	}
	
	if(PLAYER_INBIKE[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
 	{
	 	SetProgressBarValue(player_gym_progress[playerid], GetProgressBarValue(player_gym_progress[playerid] ) + 5 );
	  	UpdateProgressBar( player_gym_progress[playerid], playerid );
		//Math Stuffs
		new LocalLabel[10];
		PLAYER_BIKE_DIS_COUNT[playerid]++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_BIKE_DIS_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);

 	}
 	
 	//Do update player bench vaules here
	if(PLAYER_INBENCH[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
 	{
 	SetProgressBarValue(player_gym_progress[playerid], GetProgressBarValue(player_gym_progress[playerid] ) + 5 );
 	UpdateProgressBar( player_gym_progress[playerid], playerid );
 	
 	}
 	
	if(PLAYER_INDUMB[playerid]==true && BAR_CAN_BE_USED[playerid]==true)
 	{
 	SetProgressBarValue(player_gym_progress[playerid], GetProgressBarValue(player_gym_progress[playerid] ) + 5 );
 	UpdateProgressBar( player_gym_progress[playerid], playerid );

 	}
 	
 	}

	return 1;
}
forward DUMB_START(playerid);
public DUMB_START(playerid)
{
BAR_CAN_BE_USED[playerid]=true;
//SET ATATCH OBJECTS
SetPlayerAttachedObject(playerid,1, 3072, 5);//left hand
SetPlayerAttachedObject(playerid,2, 3071, 6);//right hand

DestroyObject(dumbell_right_objects[PLAYER_CURRECT_DUMB[playerid]]);
DestroyObject(dumbell_left_objects[PLAYER_CURRECT_DUMB[playerid]]);

//SHOW PROGRESS BAR
ShowProgressBarForPlayer( playerid,player_gym_progress[playerid]);
TextDrawShowForPlayer( playerid, gym_power[ playerid ] );
TextDrawShowForPlayer( playerid, gym_repslabel[ playerid ] );
TextDrawShowForPlayer( playerid, gym_deslabel[ playerid ] );
PLAYER_DUMB_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500,true,"i", playerid );



}

forward BIKE_START(playerid);
public BIKE_START(playerid)
{
BAR_CAN_BE_USED[playerid]=true;
ApplyAnimation( playerid, "GYMNASIUM", "bike_start", 1, 1, 0, 0, 1, 0, 1);
//Show Progress Bar Now
ShowProgressBarForPlayer( playerid,player_gym_progress[playerid]);
TextDrawShowForPlayer( playerid, gym_power[ playerid ] );
TextDrawShowForPlayer( playerid, gym_des[ playerid ] );
TextDrawShowForPlayer( playerid, gym_deslabel[ playerid ] );
//Created Second Timer For Check
PLAYER_BIKE_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500, 1, "i", playerid );



}
forward TREAM_START(playerid);
public TREAM_START(playerid)
{

BAR_CAN_BE_USED[playerid]=true;
//Make Player Run
ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_sprint", 1, 1, 0, 0, 1, 0, 1);
//Show Progress Bar Now
ShowProgressBarForPlayer( playerid,player_gym_progress[playerid]);
TextDrawShowForPlayer( playerid, gym_power[ playerid ] );
TextDrawShowForPlayer( playerid, gym_des[ playerid ] );
TextDrawShowForPlayer( playerid, gym_deslabel[ playerid ] );
//Created Second Timer For Check
PLAYER_TREAD_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500, 1, "i", playerid );

}
forward BENCH_START(playerid,OBJ_INDEX);
public BENCH_START(playerid,OBJ_INDEX)
{
BAR_CAN_BE_USED[playerid]=true;
//SET ATATCH OBJECTS
SetPlayerAttachedObject(playerid, BENCH_PRESS_INDEX, 2913, 6);
DestroyObject(barbell_objects[OBJ_INDEX]);
//SHOW PROGRESS BAR
ShowProgressBarForPlayer( playerid,player_gym_progress[playerid]);
TextDrawShowForPlayer( playerid, gym_power[ playerid ] );
TextDrawShowForPlayer( playerid, gym_repslabel[ playerid ] );
TextDrawShowForPlayer( playerid, gym_deslabel[ playerid ] );
PLAYER_BENCH_TIMER[playerid]=SetTimerEx( "GYM_CHECK", 500,true,"i", playerid );

}

forward GYM_CHECK(playerid);

public GYM_CHECK(playerid)
{
	if(PLAYER_INTREAM[playerid]==true)
	{
	TREAM_CHECK(playerid);

	}

	if(PLAYER_INBIKE[playerid]==true)
	{
	BIKE_CHECK(playerid);

	}

	if(PLAYER_INBENCH[playerid]==true)
	{
	BENCH_CHECK(playerid);

	}
	if(PLAYER_INDUMB[playerid]==true)
	{
	DUMB_CHECK(playerid);

	}

}
DUMB_CHECK(playerid)
{
	SetProgressBarValue( player_gym_progress[playerid], GetProgressBarValue( player_gym_progress[playerid] ) - 2 );
	UpdateProgressBar( player_gym_progress[playerid], playerid );

	if(GetProgressBarValue( player_gym_progress[playerid] ) >=90)
	{

		//random select a amation for player
		switch( random( 2 ) )
		{
			case 0: ApplyAnimation( playerid, "freeweights", "gym_free_A", 1, 0, 0, 0, 1, 0, 1 );
  			case 1: ApplyAnimation( playerid, "freeweights", "gym_free_B", 1, 0, 0, 0, 1, 0, 1 );
		}
		new LocalLabel[10];
		PLAYER_DUMB_COUNT[playerid]++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_DUMB_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);

		SetProgressBarValue(player_gym_progress[playerid],0);
		SetTimerEx( "DUMB_SET_AIMSTOP",2000, false, "i", playerid);


	}

}
BENCH_CHECK(playerid)
{
	SetProgressBarValue( player_gym_progress[playerid], GetProgressBarValue( player_gym_progress[playerid] ) - 2 );
	UpdateProgressBar( player_gym_progress[playerid], playerid );

	if(GetProgressBarValue( player_gym_progress[playerid] ) >=90)
	{

		//random select a amation for player
		switch( random( 2 ) )
		{
			case 0: ApplyAnimation( playerid, "benchpress", "gym_bp_up_A", 1, 0, 0, 0, 1, 0, 1 );
  			case 1: ApplyAnimation( playerid, "benchpress", "gym_bp_up_B", 1, 0, 0, 0, 1, 0, 1 );
		}
		new LocalLabel[10];
		PLAYER_BENCH_COUNT[playerid]++;
		format(LocalLabel,sizeof(LocalLabel),"%d",PLAYER_BENCH_COUNT[playerid]);
		TextDrawSetString(gym_deslabel[playerid],LocalLabel);
		
		SetProgressBarValue(player_gym_progress[playerid],0);
		SetTimerEx( "BENCH_SET_AIMSTOP",2000, false, "i", playerid);


	}

}

forward DUMB_SET_AIMSTOP(playerid);
public DUMB_SET_AIMSTOP(playerid)
{
//Apply Player pull down aim
ApplyAnimation( playerid, "freeweights", "gym_free_down", 1, 0, 0, 0, 1, 0, 1 );
//Reset the progress bar values
UpdateProgressBar(player_gym_progress[playerid],playerid);

}

forward BENCH_SET_AIMSTOP(playerid);
public BENCH_SET_AIMSTOP(playerid)
{
//Apply Player pull down aim
ApplyAnimation( playerid, "benchpress", "gym_bp_down", 1, 0, 0, 0, 1, 0, 1 );
//Reset the progress bar values

UpdateProgressBar(player_gym_progress[playerid],playerid);

}

BIKE_CHECK(playerid)
{
	SetProgressBarValue( player_gym_progress[playerid], GetProgressBarValue( player_gym_progress[playerid] ) - 8 );
	UpdateProgressBar( player_gym_progress[playerid], playerid );
	//ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_fast", 1, 0, 0, 0, 1, 0, 1 );

	if(GetProgressBarValue( player_gym_progress[playerid] ) <=0)
	{
	ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_still", 1, 1, 0, 0, 1, 0, 1);
	}else{
	ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_fast", 1, 1, 0, 0, 1, 0, 1 );
	}
	//SetProgressBarValue( player_bike_progress[playerid],50);


}
TREAM_CHECK(playerid)
{
	SetProgressBarValue( player_gym_progress[playerid], GetProgressBarValue( player_gym_progress[playerid] ) - 8 );
	UpdateProgressBar( player_gym_progress[playerid], playerid );
	//Check If Player Gonna Fall
	if(GetProgressBarValue( player_gym_progress[playerid] ) <=0)
	{
	KillTimer(PLAYER_TREAD_TIMER[playerid]);
	//then we can use our custom function
	FallOffTread(playerid);
	
	
	}

}

FallOffTread(playerid)
{

	//Disabled Bar
	BAR_CAN_BE_USED[playerid]=false;
	//This one is for when player fall off the machine (when power < 0)
	ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_falloff", 1, 0, 0, 0, 1, 0, 1 );
	//Hide textdraw
	HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_des[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );
	SetTimerEx( "REST_PLAYER", 2000, false, "i", playerid);
	


}
GetOffTread(playerid)
{

	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_tread_getoff", 1, 0, 0, 0, 1, 0, 1 );
	HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_des[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );

	SetTimerEx( "REST_PLAYER", 3500, false, "i", playerid);


}

GetOffBENCH(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation(playerid, "benchpress", "gym_bp_getoff", 1, 0, 0, 0, 1, 0, 1 );
    HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	//Do something here....
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_repslabel[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );
    SetTimerEx( "REST_PLAYER", 5000, false, "i", playerid);
   
}

PutDownDUMB(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation(playerid, "freeweights", "gym_free_putdown", 1, 0, 0, 0, 1, 0, 1 );
    HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	//Do something here....
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_repslabel[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );
    SetTimerEx( "REST_PLAYER",3000, false, "i", playerid);

}
GetOffBIKE(playerid)
{
	BAR_CAN_BE_USED[playerid]=false;
	ApplyAnimation( playerid, "GYMNASIUM", "gym_bike_getoff", 1, 0, 0, 0, 1, 0, 1 );
	HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_des[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );
	SetTimerEx( "REST_PLAYER", 2000, false, "i", playerid);
}

forward REST_PLAYER(playerid);
public REST_PLAYER(playerid)
{

	//Rest Staus
	ClearAnimations( playerid, 1 );
	SetCameraBehindPlayer( playerid );
	TogglePlayerControllable( playerid, 1 );
	BAR_CAN_BE_USED[playerid]=false;
	//Reset Bool
	
	if(PLAYER_INTREAM[playerid]==true)
	{
	PLAYER_INTREAM[playerid]=false;
 	TREAM_IN_USE[PLAYER_CURRECT_TREAD[playerid]]=false;
 	}
	if(PLAYER_INBIKE[playerid]==true)
	{
	PLAYER_INBIKE[playerid]=false;
 	BIKE_IN_USE[PLAYER_CURRECT_BIKE[playerid]]=false;
 	}
  	if(PLAYER_INBENCH[playerid]==true)
  	{
  	PLAYER_INBENCH[playerid]=false;
  	BENCH_IN_USE[PLAYER_CURRECT_BENCH[playerid]]=false;
 	barbell_objects[PLAYER_CURRECT_BENCH[playerid]] = CreateObject( 2913, barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 0 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 1 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 2 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 3 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 4 ], barbell_pos[PLAYER_CURRECT_BENCH[playerid]][ 5 ] );
    RemovePlayerAttachedObject( playerid, BENCH_PRESS_INDEX );
  	}

	if(PLAYER_INDUMB[playerid]==true)
  	{
  	PLAYER_INDUMB[playerid]=false;
  	DUMB_IN_USE[PLAYER_CURRECT_DUMB[playerid]]=false;
 	dumbell_right_objects[PLAYER_CURRECT_DUMB[playerid]] = CreateObject(3071,dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][0],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][1],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][2],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][3],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][4],dumb_bell_right_pos[PLAYER_CURRECT_DUMB[playerid]][5]);
	dumbell_left_objects[PLAYER_CURRECT_DUMB[playerid]] = CreateObject(3072,dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][0],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][1],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][2],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][3],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][4],dumb_bell_left_pos[PLAYER_CURRECT_DUMB[playerid]][5]);
    RemovePlayerAttachedObject( playerid,1);
    RemovePlayerAttachedObject( playerid,2);
  	}
        
}

//ANTI DISCONNECT BUG
public OnPlayerDisconnect(playerid, reason)
{
	//Check if player disconnect wihout press F
	REST_PLAYER(playerid);

	HideProgressBarForPlayer( playerid,player_gym_progress[playerid]);
	TextDrawHideForPlayer( playerid, gym_power[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_des[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_deslabel[ playerid ] );
	TextDrawHideForPlayer( playerid, gym_repslabel[ playerid ] );
	return 1;
}

