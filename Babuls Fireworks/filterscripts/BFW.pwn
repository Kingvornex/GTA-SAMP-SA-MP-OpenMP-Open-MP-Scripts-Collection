#include <a_samp>// credits to SAMP-Team
#include <zcmd>// credits to ZeeX
#include <sscanf>// credits to Y_Less
#include <streamer>// credits to Incognito

const Accuracy=100;//							timer(ms)
//intense CPU/bandwidth usage			<<lower					>>		raise Accuracy, if "object lag" occurs
//precise (quick) object replacing, so:	<<			/			>>		objects wont be removed quick enough, so
//more particles can spawn				<<				higher	>>		particle limit of approx. 100 will be reache d

//time in ms an object will exist
#define LifeTimeTick 1
#define LifeTimeVeryShort 150
#define LifeTimeShort 500
#define LifeTimeMedium 2000
#define LifeTimeLong 5000
#define LifeTimeVeryLong 13000
#define LifeTimeExtreme 20000
#define LifeTimeTorch 60000
#define LifeTimeLauncher 120000

#define SkyLow 20
#define SkyMed 30
#define SkyHigh 40

#define SpeedSlow 80
#define SpeedMedium 200
#define SpeedRocket 600

#define MSGTITL_COLOR 0xefdfdfff
#define MSGCMDS_COLOR 0xdfbfbfff

new Timer1;

const ObjectsMax=2000;
new Object[ObjectsMax];
new ObjectType[ObjectsMax];
new ObjectLifeTimeMS[ObjectsMax];
new ObjectEmitTimeMS[ObjectsMax];
new Float:ObjectX[ObjectsMax];
new Float:ObjectY[ObjectsMax];
new Float:ObjectZ[ObjectsMax];

enum eFireWork{
	eFW_Name[64],
	eFW_Price,
	eFW_LifeTime,
	eFW_LifeTimeRndAdd,
	eFW_ExplosionDeath,
	eFW_EmitDeath,
	eFW_EmitDeathAmount,
	eFW_EmitDeathTypeRndSel,
	eFW_EmitDeathTypeRnd[10],
	eFW_Emitter,
	eFW_EmitTime,
	eFW_EmitAmount,
	eFW_EmitterTypeRndSel,
	eFW_EmitterTypeRnd[10],
	eFW_ObjectType,
	eFW_ObjectAmount,
	Float:eFW_ObjectVelocityZ,
	Float:eFW_ObjectSpeed,
	eFW_ObjectRnd,
	eFW_ObjectRndVelX,
	eFW_ObjectRndVelY,
	eFW_ObjectRndVelZ
};
new gFireWork[ObjectsMax][eFireWork];

new aFW[ObjectsMax];

new ObjectsInUse;

enum eParticle{
	eP_ObjectID,
	Float:eP_OffsetZ
};
new gParticle[100][eParticle];

//glowing/lighting objects
#define PointLightWhite 1
#define PointLightRed 2
#define PointLightGreen 3
#define PointLightBlue 4
#define PointLightWhiteBlink 5
#define PointLightRedBlink 6
#define PointLightGreenBlink 7
#define PointLightBlueBlink 8
#define PointLightWhiteFlash 9
#define PointLightRedFlash 10
#define PointLightGreenFlash 11
#define PointLightBlueFlash 12
#define PointLightPurpleFlash 13
#define PointLightYellowFlash 14
#define PointLightWhiteXXL 15
#define PointLightRedXXL 16
#define PointLightGreenXXL 17
#define PointLightBlueXXL 18
#define PointLightMoon 19
#define PointLightRedXXLSmoke 20
//particle objects
#define FireSmall 30
#define FireMedium 31
#define FireLarge 32
#define Fire 33
#define ShootLight 34
#define SparkSmoke 35
#define Spark 36
#define SparkFalling 37
#define GunShot 38
#define CameraFlash 39
//additive objects used...
#define Barrel 50
#define Torch 51
#define CowS 52
//meat objects
#define MeatClub 60
#define MeatPart 61

//Explosion Types
#define ExpHarmless 13
#define ExpSmall 12
#define ExpTest 11

#define None 0

public OnFilterScriptInit(){
	{//particle array
		gParticle[PointLightWhite][eP_ObjectID]=19281;			gParticle[PointLightWhite][eP_OffsetZ]=0;
		gParticle[PointLightRed][eP_ObjectID]=19282;			gParticle[PointLightRed][eP_OffsetZ]=0;
		gParticle[PointLightGreen][eP_ObjectID]=19283;			gParticle[PointLightGreen][eP_OffsetZ]=0;
		gParticle[PointLightBlue][eP_ObjectID]=19284;			gParticle[PointLightBlue][eP_OffsetZ]=0;
		gParticle[PointLightWhiteBlink][eP_ObjectID]=19285;		gParticle[PointLightWhiteBlink][eP_OffsetZ]=0;
		gParticle[PointLightRedBlink][eP_ObjectID]=19286;		gParticle[PointLightRedBlink][eP_OffsetZ]=0;
		gParticle[PointLightGreenBlink][eP_ObjectID]=19287;		gParticle[PointLightGreenBlink][eP_OffsetZ]=0;
		gParticle[PointLightBlueBlink][eP_ObjectID]=19288;		gParticle[PointLightBlueBlink][eP_OffsetZ]=0;
		gParticle[PointLightWhiteFlash][eP_ObjectID]=19289;		gParticle[PointLightWhiteFlash][eP_OffsetZ]=0;
		gParticle[PointLightRedFlash][eP_ObjectID]=19290;		gParticle[PointLightRedFlash][eP_OffsetZ]=0;
		gParticle[PointLightGreenFlash][eP_ObjectID]=19291;		gParticle[PointLightGreenFlash][eP_OffsetZ]=0;
		gParticle[PointLightBlueFlash][eP_ObjectID]=19292;		gParticle[PointLightBlueFlash][eP_OffsetZ]=0;
		gParticle[PointLightPurpleFlash][eP_ObjectID]=19293;	gParticle[PointLightPurpleFlash][eP_OffsetZ]=0;
		gParticle[PointLightYellowFlash][eP_ObjectID]=19294;	gParticle[PointLightYellowFlash][eP_OffsetZ]=0;
		gParticle[PointLightWhiteXXL][eP_ObjectID]=19295;		gParticle[PointLightWhiteXXL][eP_OffsetZ]=0;
		gParticle[PointLightRedXXL][eP_ObjectID]=19296;			gParticle[PointLightRedXXL][eP_OffsetZ]=0;
		gParticle[PointLightBlueXXL][eP_ObjectID]=19297;		gParticle[PointLightBlueXXL][eP_OffsetZ]=0;
		gParticle[PointLightGreenXXL][eP_ObjectID]=19298;		gParticle[PointLightGreenXXL][eP_OffsetZ]=0;
		gParticle[PointLightMoon][eP_ObjectID]=19299;			gParticle[PointLightMoon][eP_OffsetZ]=0;
		gParticle[PointLightRedXXLSmoke][eP_ObjectID]=18728;	gParticle[PointLightRedXXLSmoke][eP_OffsetZ]=0;
		
		gParticle[FireSmall][eP_ObjectID]=18688;				gParticle[FireSmall][eP_OffsetZ]=-1.6;
		gParticle[FireMedium][eP_ObjectID]=18689;				gParticle[FireMedium][eP_OffsetZ]=-1.6;
		gParticle[FireLarge][eP_ObjectID]=18690;				gParticle[FireLarge][eP_OffsetZ]=-1.6;
		gParticle[Fire][eP_ObjectID]=18691;						gParticle[Fire][eP_OffsetZ]=-1.6;
		gParticle[ShootLight][eP_ObjectID]=18724;				gParticle[ShootLight][eP_OffsetZ]=-1.6;
		gParticle[SparkSmoke][eP_ObjectID]=18704;				gParticle[SparkSmoke][eP_OffsetZ]=-1.6;
		gParticle[Spark][eP_ObjectID]=18717;					gParticle[Spark][eP_OffsetZ]=-1.6;
		gParticle[SparkFalling][eP_ObjectID]=18718;				gParticle[SparkFalling][eP_OffsetZ]=0;
		gParticle[GunShot][eP_ObjectID]=18730;					gParticle[GunShot][eP_OffsetZ]=-1.6;
		gParticle[CameraFlash][eP_ObjectID]=18670;				gParticle[CameraFlash][eP_OffsetZ]=-1.6;
		
		gParticle[Barrel][eP_ObjectID]=3632;					gParticle[Barrel][eP_OffsetZ]=0;
		gParticle[Torch][eP_ObjectID]=3461;						gParticle[Torch][eP_OffsetZ]=-1.5;
		gParticle[CowS][eP_ObjectID]=16442;						gParticle[CowS][eP_OffsetZ]=0;
		
		gParticle[MeatClub][eP_ObjectID]=2804;					gParticle[MeatClub][eP_OffsetZ]=0;
		gParticle[MeatPart][eP_ObjectID]=2806;					gParticle[MeatPart][eP_OffsetZ]=0;
	}
/*	template for creating new effects.
	only link to lower Particle-IDs, unless you want to start an infinite chain reaction ^^
				format(gFireWork[000][eFW_Name],64,"PointLightWhite");
				gFireWork[000][eFW_ObjectType]=PointLightWhite;
				gFireWork[000][eFW_ObjectAmount]=1;
				gFireWork[000][eFW_Price]=1;
				gFireWork[000][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[000][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[000][eFW_ExplosionDeath]=None;
				gFireWork[000][eFW_EmitDeath]=None;
				gFireWork[000][eFW_EmitDeathAmount]=0;
				gFireWork[000][eFW_Emitter]=None;
				gFireWork[000][eFW_EmitTime]=None;
				gFireWork[000][eFW_EmitAmount]=0;
				gFireWork[000][eFW_EmitterTypeRndSel]=0;
				gFireWork[000][eFW_EmitterTypeRnd]={0,0,0,0,0,0,0,0,0,0};
				gFireWork[000][eFW_ObjectVelocityZ]=0;
				gFireWork[000][eFW_ObjectSpeed]=0;
				gFireWork[000][eFW_ObjectRnd]=0;
				gFireWork[000][eFW_ObjectRndVelX]=0;
				gFireWork[000][eFW_ObjectRndVelY]=0;
				gFireWork[000][eFW_ObjectRndVelZ]=0;
				gFireWork[001][eFW_ObjectExpRndVelX]=0;
				gFireWork[001][eFW_ObjectExpRndVelY]=0;
				gFireWork[001][eFW_ObjectExpRndVelZ]=0;
*/
	{//fireworks (objects/particles/explosions) array
		{//0__ = simple particles - used a LOT due its the last (lowest) IDs. therfore changes to them will affect almost each effect
			{
				format(gFireWork[001][eFW_Name],64,"ShootLight");
				gFireWork[001][eFW_ObjectType]=ShootLight;
				gFireWork[001][eFW_ObjectAmount]=1;
				gFireWork[001][eFW_Price]=0;
				gFireWork[001][eFW_LifeTime]=LifeTimeTick;
				gFireWork[001][eFW_LifeTimeRndAdd]=None;
				gFireWork[001][eFW_ExplosionDeath]=None;
				gFireWork[001][eFW_EmitDeath]=None;
				gFireWork[001][eFW_Emitter]=0;
				gFireWork[001][eFW_EmitTime]=0;
				gFireWork[001][eFW_EmitAmount]=0;
				gFireWork[001][eFW_ObjectVelocityZ]=0;
				gFireWork[001][eFW_ObjectSpeed]=0;
				
				format(gFireWork[002][eFW_Name],64,"Spark");
				gFireWork[002][eFW_ObjectType]=Spark;
				gFireWork[002][eFW_ObjectAmount]=1;
				gFireWork[002][eFW_Price]=0;
				gFireWork[002][eFW_LifeTime]=LifeTimeTick;
				gFireWork[002][eFW_LifeTimeRndAdd]=None;
				gFireWork[002][eFW_ExplosionDeath]=None;
				gFireWork[002][eFW_EmitDeath]=None;
				gFireWork[002][eFW_Emitter]=0;
				gFireWork[002][eFW_EmitTime]=0;
				gFireWork[002][eFW_EmitAmount]=0;
				gFireWork[002][eFW_ObjectVelocityZ]=0;
				gFireWork[002][eFW_ObjectSpeed]=0;
				
				format(gFireWork[003][eFW_Name],64,"Fire");
				gFireWork[003][eFW_ObjectType]=FireSmall;
				gFireWork[003][eFW_ObjectAmount]=1;
				gFireWork[003][eFW_Price]=0;
				gFireWork[003][eFW_LifeTime]=LifeTimeVeryShort;
				gFireWork[003][eFW_LifeTimeRndAdd]=None;
				gFireWork[003][eFW_ExplosionDeath]=None;
				gFireWork[003][eFW_EmitDeath]=None;
				gFireWork[003][eFW_Emitter]=0;
				gFireWork[003][eFW_EmitTime]=0;
				gFireWork[003][eFW_EmitAmount]=0;
				gFireWork[003][eFW_ObjectVelocityZ]=0;
				gFireWork[003][eFW_ObjectSpeed]=0;
				
				format(gFireWork[004][eFW_Name],64,"GunShot");
				gFireWork[004][eFW_ObjectType]=GunShot;
				gFireWork[004][eFW_ObjectAmount]=1;
				gFireWork[004][eFW_Price]=0;
				gFireWork[004][eFW_LifeTime]=LifeTimeTick;
				gFireWork[004][eFW_LifeTimeRndAdd]=None;
				gFireWork[004][eFW_ExplosionDeath]=None;
				gFireWork[004][eFW_EmitDeath]=None;
				gFireWork[004][eFW_Emitter]=0;
				gFireWork[004][eFW_EmitTime]=0;
				gFireWork[004][eFW_EmitAmount]=0;
				gFireWork[004][eFW_ObjectVelocityZ]=0;
				gFireWork[004][eFW_ObjectSpeed]=0;
				
				format(gFireWork[005][eFW_Name],64,"CameraFlash");
				gFireWork[005][eFW_ObjectType]=CameraFlash;
				gFireWork[005][eFW_ObjectAmount]=1;
				gFireWork[005][eFW_Price]=0;
				gFireWork[005][eFW_LifeTime]=LifeTimeTick;
				gFireWork[005][eFW_LifeTimeRndAdd]=None;
				gFireWork[005][eFW_ExplosionDeath]=None;
				gFireWork[005][eFW_EmitDeath]=None;
				gFireWork[005][eFW_Emitter]=0;
				gFireWork[005][eFW_EmitTime]=0;
				gFireWork[005][eFW_EmitAmount]=0;
				gFireWork[005][eFW_ObjectVelocityZ]=0;
				gFireWork[005][eFW_ObjectSpeed]=0;
			}
		}
		{//6__ = lights
			{//Normal
				format(gFireWork[601][eFW_Name],64,"PointLightWhite");
				gFireWork[601][eFW_ObjectType]=PointLightWhite;
				gFireWork[601][eFW_ObjectAmount]=2;
				gFireWork[601][eFW_Price]=0;
				gFireWork[601][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[601][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[601][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[601][eFW_EmitDeath]=None;
				gFireWork[601][eFW_Emitter]=None;
				gFireWork[601][eFW_EmitTime]=None;
				gFireWork[601][eFW_EmitAmount]=0;
				gFireWork[601][eFW_ObjectVelocityZ]=-5;
				gFireWork[601][eFW_ObjectSpeed]=100;
				gFireWork[601][eFW_ObjectRnd]=1;
				gFireWork[601][eFW_ObjectRndVelX]=4000;
				gFireWork[601][eFW_ObjectRndVelY]=4000;
				gFireWork[601][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[602][eFW_Name],64,"PointLightRed");
				gFireWork[602][eFW_ObjectType]=PointLightRed;
				gFireWork[602][eFW_ObjectAmount]=3;
				gFireWork[602][eFW_Price]=0;
				gFireWork[602][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[602][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[602][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[602][eFW_EmitDeath]=None;
				gFireWork[602][eFW_Emitter]=None;
				gFireWork[602][eFW_EmitTime]=None;
				gFireWork[602][eFW_EmitAmount]=0;
				gFireWork[602][eFW_ObjectVelocityZ]=-5;
				gFireWork[602][eFW_ObjectSpeed]=100;
				gFireWork[602][eFW_ObjectRnd]=1;
				gFireWork[602][eFW_ObjectRndVelX]=4000;
				gFireWork[602][eFW_ObjectRndVelY]=4000;
				gFireWork[602][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[603][eFW_Name],64,"PointLightGreen");
				gFireWork[603][eFW_ObjectType]=PointLightGreen;
				gFireWork[603][eFW_ObjectAmount]=3;
				gFireWork[603][eFW_Price]=0;
				gFireWork[603][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[603][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[603][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[603][eFW_EmitDeath]=None;
				gFireWork[603][eFW_Emitter]=None;
				gFireWork[603][eFW_EmitTime]=None;
				gFireWork[603][eFW_EmitAmount]=0;
				gFireWork[603][eFW_ObjectVelocityZ]=-5;
				gFireWork[603][eFW_ObjectSpeed]=100;
				gFireWork[603][eFW_ObjectRnd]=1;
				gFireWork[603][eFW_ObjectRndVelX]=4000;
				gFireWork[603][eFW_ObjectRndVelY]=4000;
				gFireWork[603][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[604][eFW_Name],64,"PointLightBlue");
				gFireWork[604][eFW_ObjectType]=PointLightBlue;
				gFireWork[604][eFW_ObjectAmount]=3;
				gFireWork[604][eFW_Price]=0;
				gFireWork[604][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[604][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[604][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[604][eFW_EmitDeath]=None;
				gFireWork[604][eFW_Emitter]=None;
				gFireWork[604][eFW_EmitTime]=None;
				gFireWork[604][eFW_EmitAmount]=0;
				gFireWork[604][eFW_ObjectVelocityZ]=-5;
				gFireWork[604][eFW_ObjectSpeed]=100;
				gFireWork[604][eFW_ObjectRnd]=1;
				gFireWork[604][eFW_ObjectRndVelX]=4000;
				gFireWork[604][eFW_ObjectRndVelY]=4000;
				gFireWork[604][eFW_ObjectRndVelZ]=4000;
			}
			{//Blink
				format(gFireWork[611][eFW_Name],64,"PointLightWhiteBlink");
				gFireWork[611][eFW_ObjectType]=PointLightWhiteBlink;
				gFireWork[611][eFW_ObjectAmount]=3;
				gFireWork[611][eFW_Price]=0;
				gFireWork[611][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[611][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[611][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[611][eFW_EmitDeath]=None;
				gFireWork[611][eFW_Emitter]=None;
				gFireWork[611][eFW_EmitTime]=None;
				gFireWork[611][eFW_EmitAmount]=0;
				gFireWork[611][eFW_ObjectVelocityZ]=-5;
				gFireWork[611][eFW_ObjectSpeed]=100;
				gFireWork[611][eFW_ObjectRnd]=1;
				gFireWork[611][eFW_ObjectRndVelX]=4000;
				gFireWork[611][eFW_ObjectRndVelY]=4000;
				gFireWork[611][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[612][eFW_Name],64,"PointLightRedBlink");
				gFireWork[612][eFW_ObjectType]=PointLightRedBlink;
				gFireWork[612][eFW_ObjectAmount]=3;
				gFireWork[612][eFW_Price]=0;
				gFireWork[612][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[612][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[612][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[612][eFW_EmitDeath]=None;
				gFireWork[612][eFW_Emitter]=None;
				gFireWork[612][eFW_EmitTime]=None;
				gFireWork[612][eFW_EmitAmount]=0;
				gFireWork[612][eFW_ObjectVelocityZ]=-5;
				gFireWork[612][eFW_ObjectSpeed]=100;
				gFireWork[612][eFW_ObjectRnd]=1;
				gFireWork[612][eFW_ObjectRndVelX]=4000;
				gFireWork[612][eFW_ObjectRndVelY]=4000;
				gFireWork[612][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[613][eFW_Name],64,"PointLightGreenBlink");
				gFireWork[613][eFW_ObjectType]=PointLightGreenBlink;
				gFireWork[613][eFW_ObjectAmount]=3;
				gFireWork[613][eFW_Price]=0;
				gFireWork[613][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[613][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[613][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[613][eFW_EmitDeath]=None;
				gFireWork[613][eFW_Emitter]=None;
				gFireWork[613][eFW_EmitTime]=None;
				gFireWork[613][eFW_EmitAmount]=0;
				gFireWork[613][eFW_ObjectVelocityZ]=-5;
				gFireWork[613][eFW_ObjectSpeed]=100;
				gFireWork[613][eFW_ObjectRnd]=1;
				gFireWork[613][eFW_ObjectRndVelX]=4000;
				gFireWork[613][eFW_ObjectRndVelY]=4000;
				gFireWork[613][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[614][eFW_Name],64,"PointLightBlueBlink");
				gFireWork[614][eFW_ObjectType]=PointLightBlueBlink;
				gFireWork[614][eFW_ObjectAmount]=3;
				gFireWork[614][eFW_Price]=0;
				gFireWork[614][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[614][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[614][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[614][eFW_EmitDeath]=001;
				gFireWork[614][eFW_Emitter]=None;
				gFireWork[614][eFW_EmitTime]=None;
				gFireWork[614][eFW_EmitAmount]=0;
				gFireWork[614][eFW_ObjectVelocityZ]=-5;
				gFireWork[614][eFW_ObjectSpeed]=100;
				gFireWork[614][eFW_ObjectRnd]=1;
				gFireWork[614][eFW_ObjectRndVelX]=4000;
				gFireWork[614][eFW_ObjectRndVelY]=4000;
				gFireWork[614][eFW_ObjectRndVelZ]=4000;
			}
			{//Flash
				format(gFireWork[621][eFW_Name],64,"PointLightWhiteFlash");
				gFireWork[621][eFW_ObjectType]=PointLightWhiteFlash;
				gFireWork[621][eFW_ObjectAmount]=3;
				gFireWork[621][eFW_Price]=0;
				gFireWork[621][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[621][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[621][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[621][eFW_EmitDeath]=None;
				gFireWork[621][eFW_Emitter]=None;
				gFireWork[621][eFW_EmitTime]=None;
				gFireWork[621][eFW_EmitAmount]=0;
				gFireWork[621][eFW_ObjectVelocityZ]=-5;
				gFireWork[621][eFW_ObjectSpeed]=100;
				gFireWork[621][eFW_ObjectRnd]=1;
				gFireWork[621][eFW_ObjectRndVelX]=4000;
				gFireWork[621][eFW_ObjectRndVelY]=4000;
				gFireWork[621][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[622][eFW_Name],64,"PointLightRedFlash");
				gFireWork[622][eFW_ObjectType]=PointLightRedFlash;
				gFireWork[622][eFW_ObjectAmount]=3;
				gFireWork[622][eFW_Price]=0;
				gFireWork[622][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[622][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[622][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[622][eFW_EmitDeath]=None;
				gFireWork[622][eFW_Emitter]=None;
				gFireWork[622][eFW_EmitTime]=None;
				gFireWork[622][eFW_EmitAmount]=0;
				gFireWork[622][eFW_ObjectVelocityZ]=-5;
				gFireWork[622][eFW_ObjectSpeed]=100;
				gFireWork[622][eFW_ObjectRnd]=1;
				gFireWork[622][eFW_ObjectRndVelX]=4000;
				gFireWork[622][eFW_ObjectRndVelY]=4000;
				gFireWork[622][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[623][eFW_Name],64,"PointLightGreenFlash");
				gFireWork[623][eFW_ObjectType]=PointLightGreenFlash;
				gFireWork[623][eFW_ObjectAmount]=3;
				gFireWork[623][eFW_Price]=0;
				gFireWork[623][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[623][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[623][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[623][eFW_EmitDeath]=None;
				gFireWork[623][eFW_Emitter]=None;
				gFireWork[623][eFW_EmitTime]=None;
				gFireWork[623][eFW_EmitAmount]=0;
				gFireWork[623][eFW_ObjectVelocityZ]=-5;
				gFireWork[623][eFW_ObjectSpeed]=100;
				gFireWork[623][eFW_ObjectRnd]=1;
				gFireWork[623][eFW_ObjectRndVelX]=4000;
				gFireWork[623][eFW_ObjectRndVelY]=4000;
				gFireWork[623][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[624][eFW_Name],64,"PointLightBlueFlash");
				gFireWork[624][eFW_ObjectType]=PointLightBlueFlash;
				gFireWork[624][eFW_ObjectAmount]=3;
				gFireWork[624][eFW_Price]=0;
				gFireWork[624][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[624][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[624][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[624][eFW_EmitDeath]=None;
				gFireWork[624][eFW_Emitter]=None;
				gFireWork[624][eFW_EmitTime]=None;
				gFireWork[624][eFW_EmitAmount]=0;
				gFireWork[624][eFW_ObjectVelocityZ]=-5;
				gFireWork[624][eFW_ObjectSpeed]=100;
				gFireWork[624][eFW_ObjectRnd]=1;
				gFireWork[624][eFW_ObjectRndVelX]=4000;
				gFireWork[624][eFW_ObjectRndVelY]=4000;
				gFireWork[624][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[625][eFW_Name],64,"PointLightPurpleFlash");
				gFireWork[625][eFW_ObjectType]=PointLightPurpleFlash;
				gFireWork[625][eFW_ObjectAmount]=3;
				gFireWork[625][eFW_Price]=0;
				gFireWork[625][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[625][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[625][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[625][eFW_EmitDeath]=None;
				gFireWork[625][eFW_Emitter]=None;
				gFireWork[625][eFW_EmitTime]=None;
				gFireWork[625][eFW_EmitAmount]=0;
				gFireWork[625][eFW_ObjectVelocityZ]=-5;
				gFireWork[625][eFW_ObjectSpeed]=100;
				gFireWork[625][eFW_ObjectRnd]=1;
				gFireWork[625][eFW_ObjectRndVelX]=4000;
				gFireWork[625][eFW_ObjectRndVelY]=4000;
				gFireWork[625][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[626][eFW_Name],64,"PointLightYellowFlash");
				gFireWork[626][eFW_ObjectType]=PointLightYellowFlash;
				gFireWork[626][eFW_ObjectAmount]=3;
				gFireWork[626][eFW_Price]=0;
				gFireWork[626][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[626][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[626][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[626][eFW_EmitDeath]=None;
				gFireWork[626][eFW_Emitter]=None;
				gFireWork[626][eFW_EmitTime]=None;
				gFireWork[626][eFW_EmitAmount]=0;
				gFireWork[626][eFW_ObjectVelocityZ]=-5;
				gFireWork[626][eFW_ObjectSpeed]=100;
				gFireWork[626][eFW_ObjectRnd]=1;
				gFireWork[626][eFW_ObjectRndVelX]=4000;
				gFireWork[626][eFW_ObjectRndVelY]=4000;
				gFireWork[626][eFW_ObjectRndVelZ]=4000;
			}
			{//XXL
				format(gFireWork[631][eFW_Name],64,"PointLightWhiteXXL");
				gFireWork[631][eFW_ObjectType]=PointLightWhiteXXL;
				gFireWork[631][eFW_ObjectAmount]=3;
				gFireWork[631][eFW_Price]=0;
				gFireWork[631][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[631][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[631][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[631][eFW_EmitDeath]=None;
				gFireWork[631][eFW_Emitter]=None;
				gFireWork[631][eFW_EmitTime]=None;
				gFireWork[631][eFW_EmitAmount]=0;
				gFireWork[631][eFW_ObjectVelocityZ]=-5;
				gFireWork[631][eFW_ObjectSpeed]=100;
				gFireWork[631][eFW_ObjectRnd]=1;
				gFireWork[631][eFW_ObjectRndVelX]=4000;
				gFireWork[631][eFW_ObjectRndVelY]=4000;
				gFireWork[631][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[632][eFW_Name],64,"PointLightRedXXL");
				gFireWork[632][eFW_ObjectType]=PointLightRedXXL;
				gFireWork[632][eFW_ObjectAmount]=3;
				gFireWork[632][eFW_Price]=0;
				gFireWork[632][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[632][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[632][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[632][eFW_EmitDeath]=None;
				gFireWork[632][eFW_Emitter]=None;
				gFireWork[632][eFW_EmitTime]=None;
				gFireWork[632][eFW_EmitAmount]=0;
				gFireWork[632][eFW_ObjectVelocityZ]=-5;
				gFireWork[632][eFW_ObjectSpeed]=100;
				gFireWork[632][eFW_ObjectRnd]=1;
				gFireWork[632][eFW_ObjectRndVelX]=4000;
				gFireWork[632][eFW_ObjectRndVelY]=4000;
				gFireWork[632][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[633][eFW_Name],64,"PointLightGreenXXL");
				gFireWork[633][eFW_ObjectType]=PointLightGreenXXL;
				gFireWork[633][eFW_ObjectAmount]=3;
				gFireWork[633][eFW_Price]=0;
				gFireWork[633][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[633][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[633][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[633][eFW_EmitDeath]=None;
				gFireWork[633][eFW_Emitter]=None;
				gFireWork[633][eFW_EmitTime]=None;
				gFireWork[633][eFW_EmitAmount]=0;
				gFireWork[633][eFW_ObjectVelocityZ]=-5;
				gFireWork[633][eFW_ObjectSpeed]=100;
				gFireWork[633][eFW_ObjectRnd]=1;
				gFireWork[633][eFW_ObjectRndVelX]=4000;
				gFireWork[633][eFW_ObjectRndVelY]=4000;
				gFireWork[633][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[634][eFW_Name],64,"PointLightBlueXXL");
				gFireWork[634][eFW_ObjectType]=PointLightBlueXXL;
				gFireWork[634][eFW_ObjectAmount]=3;
				gFireWork[634][eFW_Price]=0;
				gFireWork[634][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[634][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[634][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[634][eFW_EmitDeath]=None;
				gFireWork[634][eFW_Emitter]=None;
				gFireWork[634][eFW_EmitTime]=None;
				gFireWork[634][eFW_EmitAmount]=0;
				gFireWork[634][eFW_ObjectVelocityZ]=-5;
				gFireWork[634][eFW_ObjectSpeed]=100;
				gFireWork[634][eFW_ObjectRnd]=1;
				gFireWork[634][eFW_ObjectRndVelX]=4000;
				gFireWork[634][eFW_ObjectRndVelY]=4000;
				gFireWork[634][eFW_ObjectRndVelZ]=4000;
			}
			{//Special
				format(gFireWork[641][eFW_Name],64,"PointLightMoon");
				gFireWork[641][eFW_ObjectType]=PointLightMoon;
				gFireWork[641][eFW_ObjectAmount]=3;
				gFireWork[641][eFW_Price]=0;
				gFireWork[641][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[641][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[641][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[641][eFW_EmitDeath]=None;
				gFireWork[641][eFW_Emitter]=None;
				gFireWork[641][eFW_EmitTime]=None;
				gFireWork[641][eFW_EmitAmount]=0;
				gFireWork[641][eFW_ObjectVelocityZ]=10;
				gFireWork[641][eFW_ObjectSpeed]=400;
				gFireWork[641][eFW_ObjectRnd]=1;
				gFireWork[641][eFW_ObjectRndVelX]=4000;
				gFireWork[641][eFW_ObjectRndVelY]=4000;
				gFireWork[641][eFW_ObjectRndVelZ]=4000;
			}
		}
		{//7__ = not finished yet. look @ 8__, especially 829
			{//Normal
				format(gFireWork[701][eFW_Name],64,"PointLightWhite");
				gFireWork[701][eFW_ObjectType]=PointLightWhite;
				gFireWork[701][eFW_ObjectAmount]=6;
				gFireWork[701][eFW_Price]=0;
				gFireWork[701][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[701][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[701][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[701][eFW_EmitDeath]=None;
				gFireWork[701][eFW_EmitDeathAmount]=1;
				gFireWork[701][eFW_EmitDeathTypeRndSel]=3;
				gFireWork[701][eFW_EmitDeathTypeRnd]={001,002,005,0,0,0,0,0,0,0};
				gFireWork[701][eFW_Emitter]=None;
				gFireWork[701][eFW_EmitTime]=None;
				gFireWork[701][eFW_EmitAmount]=0;
				gFireWork[701][eFW_ObjectVelocityZ]=0;
				gFireWork[701][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[701][eFW_ObjectRnd]=1;
				gFireWork[701][eFW_ObjectRndVelX]=2000;
				gFireWork[701][eFW_ObjectRndVelY]=2000;
				gFireWork[701][eFW_ObjectRndVelZ]=2000;
				
				format(gFireWork[702][eFW_Name],64,"PointLightRed");
				gFireWork[702][eFW_ObjectType]=PointLightRed;
				gFireWork[702][eFW_ObjectAmount]=6;
				gFireWork[702][eFW_Price]=0;
				gFireWork[702][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[702][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[702][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[702][eFW_EmitDeath]=None;
				gFireWork[702][eFW_EmitDeathAmount]=1;
				gFireWork[702][eFW_EmitDeathTypeRndSel]=3;
				gFireWork[702][eFW_EmitDeathTypeRnd]={001,002,005,0,0,0,0,0,0,0};
				gFireWork[702][eFW_Emitter]=None;
				gFireWork[702][eFW_EmitTime]=None;
				gFireWork[702][eFW_EmitAmount]=0;
				gFireWork[702][eFW_ObjectVelocityZ]=0;
				gFireWork[702][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[702][eFW_ObjectRnd]=1;
				gFireWork[702][eFW_ObjectRndVelX]=2000;
				gFireWork[702][eFW_ObjectRndVelY]=2000;
				gFireWork[702][eFW_ObjectRndVelZ]=2000;
				
				format(gFireWork[703][eFW_Name],64,"PointLightGreen");
				gFireWork[703][eFW_ObjectType]=PointLightGreen;
				gFireWork[703][eFW_ObjectAmount]=6;
				gFireWork[703][eFW_Price]=0;
				gFireWork[703][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[703][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[703][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[703][eFW_EmitDeath]=0;
				gFireWork[703][eFW_EmitDeathAmount]=1;
				gFireWork[703][eFW_EmitDeathTypeRndSel]=3;
				gFireWork[703][eFW_EmitDeathTypeRnd]={001,002,005,0,0,0,0,0,0,0};
				gFireWork[703][eFW_Emitter]=None;
				gFireWork[703][eFW_EmitTime]=None;
				gFireWork[703][eFW_EmitAmount]=0;
				gFireWork[703][eFW_ObjectVelocityZ]=0;
				gFireWork[703][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[703][eFW_ObjectRnd]=1;
				gFireWork[703][eFW_ObjectRndVelX]=2000;
				gFireWork[703][eFW_ObjectRndVelY]=2000;
				gFireWork[703][eFW_ObjectRndVelZ]=2000;
				
				format(gFireWork[704][eFW_Name],64,"PointLightBlue");
				gFireWork[704][eFW_ObjectType]=PointLightBlue;
				gFireWork[704][eFW_ObjectAmount]=6;
				gFireWork[704][eFW_Price]=0;
				gFireWork[704][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[704][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[704][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[704][eFW_EmitDeath]=0;
				gFireWork[704][eFW_EmitDeathAmount]=1;
				gFireWork[704][eFW_EmitDeathTypeRndSel]=3;
				gFireWork[704][eFW_EmitDeathTypeRnd]={001,002,005,0,0,0,0,0,0,0};
				gFireWork[704][eFW_Emitter]=None;
				gFireWork[704][eFW_EmitTime]=None;
				gFireWork[704][eFW_EmitAmount]=0;
				gFireWork[704][eFW_ObjectVelocityZ]=0;
				gFireWork[704][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[704][eFW_ObjectRnd]=1;
				gFireWork[704][eFW_ObjectRndVelX]=2000;
				gFireWork[704][eFW_ObjectRndVelY]=2000;
				gFireWork[704][eFW_ObjectRndVelZ]=2000;
			}
			{//Blink
				format(gFireWork[711][eFW_Name],64,"PointLightWhiteBlink");
				gFireWork[711][eFW_ObjectType]=PointLightWhiteBlink;
				gFireWork[711][eFW_ObjectAmount]=6;
				gFireWork[711][eFW_Price]=0;
				gFireWork[711][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[711][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[711][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[711][eFW_EmitDeath]=None;
				gFireWork[711][eFW_Emitter]=None;
				gFireWork[711][eFW_EmitTime]=None;
				gFireWork[711][eFW_EmitAmount]=0;
				gFireWork[711][eFW_ObjectVelocityZ]=0;
				gFireWork[711][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[711][eFW_ObjectRnd]=1;
				gFireWork[711][eFW_ObjectRndVelX]=4000;
				gFireWork[711][eFW_ObjectRndVelY]=4000;
				gFireWork[711][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[712][eFW_Name],64,"PointLightRedBlink");
				gFireWork[712][eFW_ObjectType]=PointLightRedBlink;
				gFireWork[712][eFW_ObjectAmount]=6;
				gFireWork[712][eFW_Price]=0;
				gFireWork[712][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[712][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[712][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[712][eFW_EmitDeath]=None;
				gFireWork[712][eFW_Emitter]=None;
				gFireWork[712][eFW_EmitTime]=None;
				gFireWork[712][eFW_EmitAmount]=0;
				gFireWork[712][eFW_ObjectVelocityZ]=0;
				gFireWork[712][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[712][eFW_ObjectRnd]=1;
				gFireWork[712][eFW_ObjectRndVelX]=4000;
				gFireWork[712][eFW_ObjectRndVelY]=4000;
				gFireWork[712][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[713][eFW_Name],64,"PointLightGreenBlink");
				gFireWork[713][eFW_ObjectType]=PointLightGreenBlink;
				gFireWork[713][eFW_ObjectAmount]=6;
				gFireWork[713][eFW_Price]=0;
				gFireWork[713][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[713][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[713][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[713][eFW_EmitDeath]=None;
				gFireWork[713][eFW_Emitter]=None;
				gFireWork[713][eFW_EmitTime]=None;
				gFireWork[713][eFW_EmitAmount]=0;
				gFireWork[713][eFW_ObjectVelocityZ]=0;
				gFireWork[713][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[713][eFW_ObjectRnd]=1;
				gFireWork[713][eFW_ObjectRndVelX]=4000;
				gFireWork[713][eFW_ObjectRndVelY]=4000;
				gFireWork[713][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[714][eFW_Name],64,"PointLightBlueBlink");
				gFireWork[714][eFW_ObjectType]=PointLightBlueBlink;
				gFireWork[714][eFW_ObjectAmount]=6;
				gFireWork[714][eFW_Price]=0;
				gFireWork[714][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[714][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[714][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[714][eFW_EmitDeath]=None;
				gFireWork[714][eFW_Emitter]=None;
				gFireWork[714][eFW_EmitTime]=None;
				gFireWork[714][eFW_EmitAmount]=0;
				gFireWork[714][eFW_ObjectVelocityZ]=0;
				gFireWork[714][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[714][eFW_ObjectRnd]=1;
				gFireWork[714][eFW_ObjectRndVelX]=4000;
				gFireWork[714][eFW_ObjectRndVelY]=4000;
				gFireWork[714][eFW_ObjectRndVelZ]=4000;
			}
			{//Flash
				format(gFireWork[721][eFW_Name],64,"PointLightWhiteFlash");
				gFireWork[721][eFW_ObjectType]=PointLightWhiteFlash;
				gFireWork[721][eFW_ObjectAmount]=6;
				gFireWork[721][eFW_Price]=0;
				gFireWork[721][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[721][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[721][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[721][eFW_EmitDeath]=None;
				gFireWork[721][eFW_Emitter]=None;
				gFireWork[721][eFW_EmitTime]=None;
				gFireWork[721][eFW_EmitAmount]=0;
				gFireWork[721][eFW_ObjectVelocityZ]=0;
				gFireWork[721][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[721][eFW_ObjectRnd]=1;
				gFireWork[721][eFW_ObjectRndVelX]=5000;
				gFireWork[721][eFW_ObjectRndVelY]=5000;
				gFireWork[721][eFW_ObjectRndVelZ]=5000;
				
				format(gFireWork[722][eFW_Name],64,"PointLightRedFlash");
				gFireWork[722][eFW_ObjectType]=PointLightRedFlash;
				gFireWork[722][eFW_ObjectAmount]=6;
				gFireWork[722][eFW_Price]=0;
				gFireWork[722][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[722][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[722][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[722][eFW_EmitDeath]=None;
				gFireWork[722][eFW_Emitter]=None;
				gFireWork[722][eFW_EmitTime]=None;
				gFireWork[722][eFW_EmitAmount]=0;
				gFireWork[722][eFW_ObjectVelocityZ]=0;
				gFireWork[722][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[722][eFW_ObjectRnd]=1;
				gFireWork[722][eFW_ObjectRndVelX]=5000;
				gFireWork[722][eFW_ObjectRndVelY]=5000;
				gFireWork[722][eFW_ObjectRndVelZ]=5000;
				
				format(gFireWork[723][eFW_Name],64,"PointLightGreenFlash");
				gFireWork[723][eFW_ObjectType]=PointLightGreenFlash;
				gFireWork[723][eFW_ObjectAmount]=6;
				gFireWork[723][eFW_Price]=0;
				gFireWork[723][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[723][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[723][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[723][eFW_EmitDeath]=None;
				gFireWork[723][eFW_Emitter]=None;
				gFireWork[723][eFW_EmitTime]=None;
				gFireWork[723][eFW_EmitAmount]=0;
				gFireWork[723][eFW_ObjectVelocityZ]=0;
				gFireWork[723][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[723][eFW_ObjectRnd]=1;
				gFireWork[723][eFW_ObjectRndVelX]=5000;
				gFireWork[723][eFW_ObjectRndVelY]=5000;
				gFireWork[723][eFW_ObjectRndVelZ]=5000;
				
				format(gFireWork[724][eFW_Name],64,"PointLightBlueFlash");
				gFireWork[724][eFW_ObjectType]=PointLightBlueFlash;
				gFireWork[724][eFW_ObjectAmount]=6;
				gFireWork[724][eFW_Price]=0;
				gFireWork[724][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[724][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[724][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[724][eFW_EmitDeath]=None;
				gFireWork[724][eFW_Emitter]=None;
				gFireWork[724][eFW_EmitTime]=None;
				gFireWork[724][eFW_EmitAmount]=0;
				gFireWork[724][eFW_ObjectVelocityZ]=0;
				gFireWork[724][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[724][eFW_ObjectRnd]=1;
				gFireWork[724][eFW_ObjectRndVelX]=5000;
				gFireWork[724][eFW_ObjectRndVelY]=5000;
				gFireWork[724][eFW_ObjectRndVelZ]=5000;
				
				format(gFireWork[725][eFW_Name],64,"PointLightPurpleFlash");
				gFireWork[725][eFW_ObjectType]=PointLightPurpleFlash;
				gFireWork[725][eFW_ObjectAmount]=6;
				gFireWork[725][eFW_Price]=0;
				gFireWork[725][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[725][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[725][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[725][eFW_EmitDeath]=None;
				gFireWork[725][eFW_Emitter]=None;
				gFireWork[725][eFW_EmitTime]=None;
				gFireWork[725][eFW_EmitAmount]=0;
				gFireWork[725][eFW_ObjectVelocityZ]=0;
				gFireWork[725][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[725][eFW_ObjectRnd]=1;
				gFireWork[725][eFW_ObjectRndVelX]=5000;
				gFireWork[725][eFW_ObjectRndVelY]=5000;
				gFireWork[725][eFW_ObjectRndVelZ]=5000;
				
				format(gFireWork[726][eFW_Name],64,"PointLightYellowFlash");
				gFireWork[726][eFW_ObjectType]=PointLightYellowFlash;
				gFireWork[726][eFW_ObjectAmount]=6;
				gFireWork[726][eFW_Price]=0;
				gFireWork[726][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[726][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[726][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[726][eFW_EmitDeath]=None;
				gFireWork[726][eFW_Emitter]=None;
				gFireWork[726][eFW_EmitTime]=None;
				gFireWork[726][eFW_EmitAmount]=0;
				gFireWork[726][eFW_ObjectVelocityZ]=0;
				gFireWork[726][eFW_ObjectSpeed]=SpeedSlow;
				gFireWork[726][eFW_ObjectRnd]=1;
				gFireWork[726][eFW_ObjectRndVelX]=5000;
				gFireWork[726][eFW_ObjectRndVelY]=5000;
				gFireWork[726][eFW_ObjectRndVelZ]=5000;
			}
			{//meat parts falling down
				format(gFireWork[771][eFW_Name],64,"MeatClub");
				gFireWork[771][eFW_ObjectType]=MeatClub;
				gFireWork[771][eFW_ObjectAmount]=1;
				gFireWork[771][eFW_Price]=0;
				gFireWork[771][eFW_LifeTime]=LifeTimeLong;
				gFireWork[771][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[771][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[771][eFW_EmitDeath]=None;
				gFireWork[771][eFW_Emitter]=None;
				gFireWork[771][eFW_EmitTime]=None;
				gFireWork[771][eFW_EmitAmount]=0;
				gFireWork[771][eFW_ObjectVelocityZ]=-SkyMed;
				gFireWork[771][eFW_ObjectSpeed]=SpeedMedium;
				gFireWork[771][eFW_ObjectRnd]=1;
				gFireWork[771][eFW_ObjectRndVelX]=4000;
				gFireWork[771][eFW_ObjectRndVelY]=4000;
				gFireWork[771][eFW_ObjectRndVelZ]=0001;
				
				format(gFireWork[772][eFW_Name],64,"MeatPart");
				gFireWork[772][eFW_ObjectType]=MeatPart;
				gFireWork[772][eFW_ObjectAmount]=1;
				gFireWork[772][eFW_Price]=0;
				gFireWork[772][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[772][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[772][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[772][eFW_EmitDeath]=None;
				gFireWork[772][eFW_Emitter]=None;
				gFireWork[772][eFW_EmitTime]=None;
				gFireWork[772][eFW_EmitAmount]=0;
				gFireWork[772][eFW_ObjectVelocityZ]=-SkyMed;
				gFireWork[772][eFW_ObjectSpeed]=SpeedMedium;
				gFireWork[772][eFW_ObjectRnd]=1;
				gFireWork[772][eFW_ObjectRndVelX]=4000;
				gFireWork[772][eFW_ObjectRndVelY]=4000;
				gFireWork[772][eFW_ObjectRndVelZ]=0001;
			}
		}
		{//8__ = launched by 9__, should be the same id except the first digit (_xx)
			{//Crackers launched
				format(gFireWork[801][eFW_Name],64,"Cracker");
				gFireWork[801][eFW_ObjectType]=FireSmall;
				gFireWork[801][eFW_ObjectAmount]=1;
				gFireWork[801][eFW_Price]=0;
				gFireWork[801][eFW_LifeTime]=LifeTimeShort;
				gFireWork[801][eFW_LifeTimeRndAdd]=LifeTimeTick;
				gFireWork[801][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[801][eFW_EmitDeath]=None;
				gFireWork[801][eFW_EmitDeathAmount]=0;
				gFireWork[801][eFW_Emitter]=0;
				gFireWork[801][eFW_EmitTime]=0;
				gFireWork[801][eFW_EmitAmount]=0;
				gFireWork[801][eFW_ObjectVelocityZ]=0;
				gFireWork[801][eFW_ObjectSpeed]=0;
				
				format(gFireWork[802][eFW_Name],64,"Jumping Cracker Red");
				gFireWork[802][eFW_ObjectType]=PointLightRed;//FireSmall;
				gFireWork[802][eFW_ObjectAmount]=1;
				gFireWork[802][eFW_Price]=0;
				gFireWork[802][eFW_LifeTime]=LifeTimeShort;
				gFireWork[802][eFW_LifeTimeRndAdd]=LifeTimeTick;
				gFireWork[802][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[802][eFW_EmitDeath]=0;
				gFireWork[802][eFW_EmitDeathAmount]=2;
				gFireWork[802][eFW_EmitDeathTypeRndSel]=7;
				gFireWork[802][eFW_EmitDeathTypeRnd]={803,804,001,002,003,005,0,0,0,0};
				gFireWork[802][eFW_Emitter]=0;
				gFireWork[802][eFW_EmitTime]=0;
				gFireWork[802][eFW_EmitAmount]=0;
				gFireWork[802][eFW_ObjectVelocityZ]=0;
				gFireWork[802][eFW_ObjectSpeed]=40;
				gFireWork[802][eFW_ObjectRnd]=1;
				gFireWork[802][eFW_ObjectRndVelX]=1000;
				gFireWork[802][eFW_ObjectRndVelY]=1000;
				gFireWork[802][eFW_ObjectRndVelZ]=0001;
				
				format(gFireWork[803][eFW_Name],64,"Jumping Cracker Green");
				gFireWork[803][eFW_ObjectType]=PointLightGreen;//FireSmall;
				gFireWork[803][eFW_ObjectAmount]=1;
				gFireWork[803][eFW_Price]=0;
				gFireWork[803][eFW_LifeTime]=LifeTimeShort;
				gFireWork[803][eFW_LifeTimeRndAdd]=LifeTimeTick;
				gFireWork[803][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[803][eFW_EmitDeath]=0;
				gFireWork[803][eFW_EmitDeathAmount]=2;
				gFireWork[803][eFW_EmitDeathTypeRndSel]=7;
				gFireWork[803][eFW_EmitDeathTypeRnd]={802,804,001,002,003,005,0,0,0,0};
				gFireWork[803][eFW_Emitter]=0;
				gFireWork[803][eFW_EmitTime]=0;
				gFireWork[803][eFW_EmitAmount]=0;
				gFireWork[803][eFW_ObjectVelocityZ]=0;
				gFireWork[803][eFW_ObjectSpeed]=40;
				gFireWork[803][eFW_ObjectRnd]=1;
				gFireWork[803][eFW_ObjectRndVelX]=1000;
				gFireWork[803][eFW_ObjectRndVelY]=1000;
				gFireWork[803][eFW_ObjectRndVelZ]=0001;
				
				format(gFireWork[804][eFW_Name],64,"Jumping Cracker Green");
				gFireWork[804][eFW_ObjectType]=PointLightBlue;//FireSmall;
				gFireWork[804][eFW_ObjectAmount]=1;
				gFireWork[804][eFW_Price]=0;
				gFireWork[804][eFW_LifeTime]=LifeTimeShort;
				gFireWork[804][eFW_LifeTimeRndAdd]=LifeTimeTick;
				gFireWork[804][eFW_ExplosionDeath]=None;//ExpSmall;
				gFireWork[804][eFW_EmitDeath]=0;
				gFireWork[804][eFW_EmitDeathAmount]=2;
				gFireWork[804][eFW_EmitDeathTypeRndSel]=7;
				gFireWork[804][eFW_EmitDeathTypeRnd]={802,803,001,002,003,005,0,0,0,0};
				gFireWork[804][eFW_Emitter]=0;
				gFireWork[804][eFW_EmitTime]=0;
				gFireWork[804][eFW_EmitAmount]=0;
				gFireWork[804][eFW_ObjectVelocityZ]=0;
				gFireWork[804][eFW_ObjectSpeed]=40;
				gFireWork[804][eFW_ObjectRnd]=1;
				gFireWork[804][eFW_ObjectRndVelX]=1000;
				gFireWork[804][eFW_ObjectRndVelY]=1000;
				gFireWork[804][eFW_ObjectRndVelZ]=0001;
			}
			{//Rockets launched
				format(gFireWork[811][eFW_Name],64,"Rocket 1");
				gFireWork[811][eFW_ObjectType]=SparkSmoke;
				gFireWork[811][eFW_ObjectAmount]=1;
				gFireWork[811][eFW_Price]=0;
				gFireWork[811][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[811][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[811][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[811][eFW_EmitDeath]=0;
				gFireWork[811][eFW_EmitDeathAmount]=2;
				gFireWork[811][eFW_EmitDeathTypeRndSel]=2;
				gFireWork[811][eFW_EmitDeathTypeRnd]={702,703,0,0,0,0,0,0,0,0};
				gFireWork[811][eFW_Emitter]=0;
				gFireWork[811][eFW_EmitTime]=0;
				gFireWork[811][eFW_EmitAmount]=0;
				gFireWork[811][eFW_ObjectVelocityZ]=SkyHigh;
				gFireWork[811][eFW_ObjectSpeed]=SpeedRocket;
				gFireWork[811][eFW_ObjectRnd]=1;
				gFireWork[811][eFW_ObjectRndVelX]=4000;
				gFireWork[811][eFW_ObjectRndVelY]=4000;
				gFireWork[811][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[812][eFW_Name],64,"Rocket 2");
				gFireWork[812][eFW_ObjectType]=SparkSmoke;
				gFireWork[812][eFW_ObjectAmount]=1;
				gFireWork[812][eFW_Price]=0;
				gFireWork[812][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[812][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[812][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[812][eFW_EmitDeath]=0;
				gFireWork[812][eFW_EmitDeathAmount]=2;
				gFireWork[812][eFW_EmitDeathTypeRndSel]=2;
				gFireWork[812][eFW_EmitDeathTypeRnd]={703,704,0,0,0,0,0,0,0,0};
				gFireWork[812][eFW_Emitter]=0;
				gFireWork[812][eFW_EmitTime]=0;
				gFireWork[812][eFW_EmitAmount]=0;
				gFireWork[812][eFW_ObjectVelocityZ]=SkyHigh;
				gFireWork[812][eFW_ObjectSpeed]=300;
				gFireWork[812][eFW_ObjectRnd]=1;
				gFireWork[812][eFW_ObjectRndVelX]=4000;
				gFireWork[812][eFW_ObjectRndVelY]=4000;
				gFireWork[812][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[813][eFW_Name],64,"Rocket 3");
				gFireWork[813][eFW_ObjectType]=Spark;
				gFireWork[813][eFW_ObjectAmount]=1;
				gFireWork[813][eFW_Price]=0;
				gFireWork[813][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[813][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[813][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[813][eFW_EmitDeath]=0;
				gFireWork[813][eFW_EmitDeathAmount]=2;
				gFireWork[813][eFW_EmitDeathTypeRndSel]=2;
				gFireWork[813][eFW_EmitDeathTypeRnd]={702,704,0,0,0,0,0,0,0,0};
				gFireWork[813][eFW_Emitter]=0;
				gFireWork[813][eFW_EmitTime]=0;
				gFireWork[813][eFW_EmitAmount]=0;
				gFireWork[813][eFW_ObjectVelocityZ]=SkyHigh;
				gFireWork[813][eFW_ObjectSpeed]=350;
				gFireWork[813][eFW_ObjectRnd]=1;
				gFireWork[813][eFW_ObjectRndVelX]=4000;
				gFireWork[813][eFW_ObjectRndVelY]=4000;
				gFireWork[813][eFW_ObjectRndVelZ]=4000;
				
				format(gFireWork[829][eFW_Name],64,"Rocket 19");
				gFireWork[829][eFW_ObjectType]=PointLightPurpleFlash;
				gFireWork[829][eFW_ObjectAmount]=1;
				gFireWork[829][eFW_Price]=0;
				gFireWork[829][eFW_LifeTime]=LifeTimeLong;
				gFireWork[829][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[829][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[829][eFW_EmitDeath]=0;
				gFireWork[829][eFW_EmitDeathAmount]=2;
				gFireWork[829][eFW_EmitDeathTypeRndSel]=6;
				gFireWork[829][eFW_EmitDeathTypeRnd]={721,722,723,724,725,726,0,0,0,0};
				gFireWork[829][eFW_Emitter]=002;
				gFireWork[829][eFW_EmitTime]=800;
				gFireWork[829][eFW_EmitAmount]=1;
				gFireWork[829][eFW_ObjectVelocityZ]=SkyHigh;
				gFireWork[829][eFW_ObjectSpeed]=SpeedRocket;
				gFireWork[829][eFW_ObjectRnd]=1;
				gFireWork[829][eFW_ObjectRndVelX]=4000;
				gFireWork[829][eFW_ObjectRndVelY]=4000;
				gFireWork[829][eFW_ObjectRndVelZ]=4000;
			}
			{//Nice Effects launched
				format(gFireWork[831][eFW_Name],64,"Fountain");
				gFireWork[831][eFW_ObjectType]=ShootLight;
				gFireWork[831][eFW_ObjectAmount]=1;
				gFireWork[831][eFW_Price]=0;
				gFireWork[831][eFW_LifeTime]=LifeTimeMedium;
				gFireWork[831][eFW_LifeTimeRndAdd]=LifeTimeTick;
				gFireWork[831][eFW_ExplosionDeath]=None;
				gFireWork[831][eFW_EmitDeath]=001;
				gFireWork[831][eFW_EmitDeathAmount]=1;
				gFireWork[831][eFW_Emitter]=0;
				gFireWork[831][eFW_EmitTime]=0;
				gFireWork[831][eFW_EmitAmount]=0;
				gFireWork[831][eFW_ObjectVelocityZ]=0;
				gFireWork[831][eFW_ObjectSpeed]=0;
			}
			{//Special Rockets launched
				format(gFireWork[871][eFW_Name],64,"Cow Rocket 1");
				gFireWork[871][eFW_ObjectType]=CowS;
				gFireWork[871][eFW_ObjectAmount]=1;
				gFireWork[871][eFW_Price]=0;
				gFireWork[871][eFW_LifeTime]=LifeTimeLong;
				gFireWork[871][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[871][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[871][eFW_EmitDeath]=0;
				gFireWork[871][eFW_EmitDeathAmount]=20;
				gFireWork[871][eFW_EmitDeathTypeRndSel]=2;
				gFireWork[871][eFW_EmitDeathTypeRnd]={771,772,0,0,0,0,0,0,0,0};
				gFireWork[871][eFW_Emitter]=0;
				gFireWork[871][eFW_EmitTime]=0;
				gFireWork[871][eFW_EmitAmount]=0;
				gFireWork[871][eFW_ObjectVelocityZ]=SkyMed;
				gFireWork[871][eFW_ObjectSpeed]=SpeedRocket;
				gFireWork[871][eFW_ObjectRnd]=1;
				gFireWork[871][eFW_ObjectRndVelX]=1000;
				gFireWork[871][eFW_ObjectRndVelY]=1000;
				gFireWork[871][eFW_ObjectRndVelZ]=1000;
			}
		}
		{//9__ = main IDs (meant for public usage). after death, they spawn none or (some) other gFireWork ID, preferably with the same last 2 digits(_xx) and the first digit decreased by 1 (2__ becomes 1__)
			{//Crackers
				format(gFireWork[901][eFW_Name],64,"Cracker");
				gFireWork[901][eFW_ObjectType]=Spark;
				gFireWork[901][eFW_ObjectAmount]=1;
				gFireWork[901][eFW_Price]=3;
				gFireWork[901][eFW_LifeTime]=LifeTimeLong;
				gFireWork[901][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[901][eFW_ExplosionDeath]=None;
				gFireWork[901][eFW_EmitDeath]=801;
				gFireWork[901][eFW_EmitDeathAmount]=1;
				gFireWork[901][eFW_Emitter]=0;
				gFireWork[901][eFW_EmitTime]=0;
				gFireWork[901][eFW_EmitAmount]=0;
				gFireWork[901][eFW_ObjectVelocityZ]=0;
				gFireWork[901][eFW_ObjectSpeed]=0;
				
				format(gFireWork[902][eFW_Name],64,"Jumping Cracker Red");
				gFireWork[902][eFW_ObjectType]=Spark;
				gFireWork[902][eFW_ObjectAmount]=3;
				gFireWork[902][eFW_Price]=5;
				gFireWork[902][eFW_LifeTime]=LifeTimeLong;
				gFireWork[902][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[902][eFW_ExplosionDeath]=None;
				gFireWork[902][eFW_EmitDeath]=802;
				gFireWork[902][eFW_EmitDeathAmount]=1;
				gFireWork[902][eFW_Emitter]=0;
				gFireWork[902][eFW_EmitTime]=0;
				gFireWork[902][eFW_EmitAmount]=0;
				gFireWork[902][eFW_ObjectVelocityZ]=0;
				gFireWork[902][eFW_ObjectSpeed]=0;
				
				format(gFireWork[903][eFW_Name],64,"Jumping Cracker Green");
				gFireWork[903][eFW_ObjectType]=Spark;
				gFireWork[903][eFW_ObjectAmount]=3;
				gFireWork[903][eFW_Price]=5;
				gFireWork[903][eFW_LifeTime]=LifeTimeLong;
				gFireWork[903][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[903][eFW_ExplosionDeath]=None;
				gFireWork[903][eFW_EmitDeath]=803;
				gFireWork[903][eFW_EmitDeathAmount]=1;
				gFireWork[903][eFW_Emitter]=0;
				gFireWork[903][eFW_EmitTime]=0;
				gFireWork[903][eFW_EmitAmount]=0;
				gFireWork[903][eFW_ObjectVelocityZ]=0;
				gFireWork[903][eFW_ObjectSpeed]=0;
				
				format(gFireWork[904][eFW_Name],64,"Jumping Cracker Blue");
				gFireWork[904][eFW_ObjectType]=Spark;
				gFireWork[904][eFW_ObjectAmount]=3;
				gFireWork[904][eFW_Price]=5;
				gFireWork[904][eFW_LifeTime]=LifeTimeLong;
				gFireWork[904][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[904][eFW_ExplosionDeath]=None;
				gFireWork[904][eFW_EmitDeath]=804;
				gFireWork[904][eFW_EmitDeathAmount]=1;
				gFireWork[904][eFW_Emitter]=0;
				gFireWork[904][eFW_EmitTime]=0;
				gFireWork[904][eFW_EmitAmount]=0;
				gFireWork[904][eFW_ObjectVelocityZ]=0;
				gFireWork[904][eFW_ObjectSpeed]=0;
			}
			{//Rockets
				format(gFireWork[911][eFW_Name],64,"Rocket 1");
				gFireWork[911][eFW_ObjectType]=Spark;
				gFireWork[911][eFW_ObjectAmount]=1;
				gFireWork[911][eFW_Price]=5;
				gFireWork[911][eFW_LifeTime]=LifeTimeLong;
				gFireWork[911][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[911][eFW_ExplosionDeath]=None;
				gFireWork[911][eFW_EmitDeath]=811;
				gFireWork[911][eFW_EmitDeathAmount]=1;
				gFireWork[911][eFW_Emitter]=0;
				gFireWork[911][eFW_EmitTime]=0;
				gFireWork[911][eFW_EmitAmount]=0;
				gFireWork[911][eFW_ObjectVelocityZ]=0;
				gFireWork[911][eFW_ObjectSpeed]=0;
				
				format(gFireWork[912][eFW_Name],64,"Rocket 2");
				gFireWork[912][eFW_ObjectType]=Spark;
				gFireWork[912][eFW_ObjectAmount]=1;
				gFireWork[912][eFW_Price]=5;
				gFireWork[912][eFW_LifeTime]=LifeTimeLong;
				gFireWork[912][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[912][eFW_ExplosionDeath]=None;
				gFireWork[912][eFW_EmitDeath]=812;
				gFireWork[912][eFW_EmitDeathAmount]=1;
				gFireWork[912][eFW_Emitter]=0;
				gFireWork[912][eFW_EmitTime]=0;
				gFireWork[912][eFW_EmitAmount]=0;
				gFireWork[912][eFW_ObjectVelocityZ]=0;
				gFireWork[912][eFW_ObjectSpeed]=0;

				format(gFireWork[913][eFW_Name],64,"Rocket 3");
				gFireWork[913][eFW_ObjectType]=Spark;
				gFireWork[913][eFW_ObjectAmount]=1;
				gFireWork[913][eFW_Price]=5;
				gFireWork[913][eFW_LifeTime]=LifeTimeLong;
				gFireWork[913][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[913][eFW_ExplosionDeath]=None;
				gFireWork[913][eFW_EmitDeath]=813;
				gFireWork[913][eFW_EmitDeathAmount]=1;
				gFireWork[913][eFW_Emitter]=0;
				gFireWork[913][eFW_EmitTime]=0;
				gFireWork[913][eFW_EmitAmount]=0;
				gFireWork[913][eFW_ObjectVelocityZ]=0;
				gFireWork[913][eFW_ObjectSpeed]=0;
				
				format(gFireWork[929][eFW_Name],64,"Rocket 19");
				gFireWork[929][eFW_ObjectType]=Spark;
				gFireWork[929][eFW_ObjectAmount]=1;
				gFireWork[929][eFW_Price]=5;
				gFireWork[929][eFW_LifeTime]=LifeTimeLong;
				gFireWork[929][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[929][eFW_ExplosionDeath]=None;
				gFireWork[929][eFW_EmitDeath]=829;
				gFireWork[929][eFW_EmitDeathAmount]=1;
				gFireWork[929][eFW_Emitter]=0;
				gFireWork[929][eFW_EmitTime]=0;
				gFireWork[929][eFW_EmitAmount]=0;
				gFireWork[929][eFW_ObjectVelocityZ]=0;
				gFireWork[929][eFW_ObjectSpeed]=0;
			}
			{//Nice Effects
				format(gFireWork[931][eFW_Name],64,"Fountain");
				gFireWork[931][eFW_ObjectType]=Spark;
				gFireWork[931][eFW_ObjectAmount]=1;
				gFireWork[931][eFW_Price]=1;
				gFireWork[931][eFW_LifeTime]=LifeTimeLong;
				gFireWork[931][eFW_LifeTimeRndAdd]=LifeTimeShort;
				gFireWork[931][eFW_ExplosionDeath]=None;
				gFireWork[931][eFW_EmitDeath]=None;
				gFireWork[931][eFW_EmitDeathAmount]=None;
				gFireWork[931][eFW_Emitter]=831;
				gFireWork[931][eFW_EmitTime]=1300;
				gFireWork[931][eFW_EmitAmount]=4;
				gFireWork[931][eFW_ObjectVelocityZ]=0;
				gFireWork[931][eFW_ObjectSpeed]=0;
				
				format(gFireWork[932][eFW_Name],64,"Jumping Cracker Launcher Box");
				gFireWork[932][eFW_ObjectType]=Spark;
				gFireWork[932][eFW_ObjectAmount]=1;
				gFireWork[932][eFW_Price]=15;
				gFireWork[932][eFW_LifeTime]=LifeTimeLong;
				gFireWork[932][eFW_LifeTimeRndAdd]=LifeTimeMedium;
				gFireWork[932][eFW_ExplosionDeath]=None;
				gFireWork[932][eFW_EmitDeath]=None;
				gFireWork[932][eFW_EmitDeathAmount]=None;
				gFireWork[932][eFW_Emitter]=0;
				gFireWork[932][eFW_EmitTime]=500;
				gFireWork[932][eFW_EmitAmount]=2;
				gFireWork[932][eFW_EmitterTypeRndSel]=3;
				gFireWork[932][eFW_EmitterTypeRnd]={802,803,804,0,0,0,0,0,0,0};
				gFireWork[932][eFW_ObjectVelocityZ]=0;
				gFireWork[932][eFW_ObjectSpeed]=0;
			}
			{//Decoration
				format(gFireWork[941][eFW_Name],64,"Torch");
				gFireWork[941][eFW_ObjectType]=Torch;
				gFireWork[941][eFW_ObjectAmount]=1;
				gFireWork[941][eFW_Price]=1;
				gFireWork[941][eFW_LifeTime]=LifeTimeTorch;
				gFireWork[941][eFW_LifeTimeRndAdd]=None;
				gFireWork[941][eFW_ExplosionDeath]=None;
				gFireWork[941][eFW_EmitDeath]=None;
				gFireWork[941][eFW_EmitDeathAmount]=None;
				gFireWork[941][eFW_Emitter]=0;
				gFireWork[941][eFW_EmitTime]=0;
				gFireWork[941][eFW_EmitAmount]=1;
				gFireWork[941][eFW_ObjectVelocityZ]=0;
				gFireWork[941][eFW_ObjectSpeed]=0;
			}
			{//Rocket Launcher Boxes
				format(gFireWork[951][eFW_Name],64,"Rocket Launcher 1");
				gFireWork[951][eFW_ObjectType]=Barrel;
				gFireWork[951][eFW_ObjectAmount]=1;
				gFireWork[951][eFW_Price]=20;
				gFireWork[951][eFW_LifeTime]=LifeTimeExtreme;
				gFireWork[951][eFW_LifeTimeRndAdd]=LifeTimeLong;
				gFireWork[951][eFW_ExplosionDeath]=None;
				gFireWork[951][eFW_EmitDeath]=None;
				gFireWork[951][eFW_EmitDeathAmount]=None;
				gFireWork[951][eFW_Emitter]=0;
				gFireWork[951][eFW_EmitTime]=2400;
				gFireWork[951][eFW_EmitAmount]=1;
				gFireWork[951][eFW_EmitterTypeRndSel]=3;
				gFireWork[951][eFW_EmitterTypeRnd]={811,812,813,0,0,0,0,0,0,0};
				gFireWork[951][eFW_ObjectVelocityZ]=0;
				gFireWork[951][eFW_ObjectSpeed]=0;
				
				format(gFireWork[952][eFW_Name],64,"Rocket Launcher 2");
				gFireWork[952][eFW_ObjectType]=Barrel;
				gFireWork[952][eFW_ObjectAmount]=1;
				gFireWork[952][eFW_Price]=20;
				gFireWork[952][eFW_LifeTime]=LifeTimeExtreme;
				gFireWork[952][eFW_LifeTimeRndAdd]=LifeTimeLong;
				gFireWork[952][eFW_ExplosionDeath]=None;
				gFireWork[952][eFW_EmitDeath]=None;
				gFireWork[952][eFW_EmitDeathAmount]=None;
				gFireWork[952][eFW_Emitter]=0;
				gFireWork[952][eFW_EmitTime]=2400;
				gFireWork[952][eFW_EmitAmount]=1;
				gFireWork[952][eFW_EmitterTypeRndSel]=5;
				gFireWork[952][eFW_EmitterTypeRnd]={811,812,813,829,004,0,0,0,0,0};
				gFireWork[952][eFW_ObjectVelocityZ]=0;
				gFireWork[952][eFW_ObjectSpeed]=0;
				
				format(gFireWork[953][eFW_Name],64,"Rocket Launcher 3");
				gFireWork[953][eFW_ObjectType]=Barrel;
				gFireWork[953][eFW_ObjectAmount]=1;
				gFireWork[953][eFW_Price]=22;
				gFireWork[953][eFW_LifeTime]=LifeTimeExtreme;
				gFireWork[953][eFW_LifeTimeRndAdd]=LifeTimeLong;
				gFireWork[953][eFW_ExplosionDeath]=None;
				gFireWork[953][eFW_EmitDeath]=None;
				gFireWork[953][eFW_EmitDeathAmount]=None;
				gFireWork[953][eFW_Emitter]=813;
				gFireWork[953][eFW_EmitTime]=2400;
				gFireWork[953][eFW_EmitAmount]=2;
				gFireWork[953][eFW_EmitterTypeRndSel]=7;
				gFireWork[953][eFW_EmitterTypeRnd]={811,812,813,829,001,003,004,0,0,0};
				gFireWork[953][eFW_ObjectVelocityZ]=0;
				gFireWork[953][eFW_ObjectSpeed]=0;
				
				format(gFireWork[969][eFW_Name],64,"Rocket Launcher 19");
				gFireWork[969][eFW_ObjectType]=Barrel;
				gFireWork[969][eFW_ObjectAmount]=1;
				gFireWork[969][eFW_Price]=999;
				gFireWork[969][eFW_LifeTime]=LifeTimeExtreme;
				gFireWork[969][eFW_LifeTimeRndAdd]=LifeTimeLong;
				gFireWork[969][eFW_ExplosionDeath]=None;
				gFireWork[969][eFW_EmitDeath]=None;
				gFireWork[969][eFW_EmitDeathAmount]=None;
				gFireWork[969][eFW_Emitter]=0;
				gFireWork[969][eFW_EmitTime]=1000;
				gFireWork[969][eFW_EmitAmount]=2;
				gFireWork[969][eFW_EmitterTypeRndSel]=8;
				gFireWork[969][eFW_EmitterTypeRnd]={829,829,829,829,829,001,002,003,0,0};
				gFireWork[969][eFW_ObjectVelocityZ]=0;
				gFireWork[969][eFW_ObjectSpeed]=0;
				
				format(gFireWork[971][eFW_Name],64,"Cow Rocket Launcher 1");
				gFireWork[971][eFW_ObjectType]=CowS;
				gFireWork[971][eFW_ObjectAmount]=1;
				gFireWork[971][eFW_Price]=1337;
				gFireWork[971][eFW_LifeTime]=LifeTimeLong;
				gFireWork[971][eFW_LifeTimeRndAdd]=None;
				gFireWork[971][eFW_ExplosionDeath]=ExpSmall;
				gFireWork[971][eFW_EmitDeath]=871;
				gFireWork[971][eFW_EmitDeathAmount]=1;
				gFireWork[971][eFW_Emitter]=0;
				gFireWork[971][eFW_EmitTime]=0;
				gFireWork[971][eFW_EmitAmount]=0;
				gFireWork[971][eFW_EmitterTypeRndSel]=0;
				gFireWork[971][eFW_EmitterTypeRnd]={0,0,0,0,0,0,0,0,0,0};
				gFireWork[971][eFW_ObjectVelocityZ]=0;
				gFireWork[971][eFW_ObjectSpeed]=0;
				
				format(gFireWork[991][eFW_Name],64,"Rocket Launcher 991");
				gFireWork[991][eFW_ObjectType]=Barrel;
				gFireWork[991][eFW_ObjectAmount]=1;
				gFireWork[991][eFW_Price]=999;
				gFireWork[991][eFW_LifeTime]=LifeTimeLauncher;
				gFireWork[991][eFW_LifeTimeRndAdd]=None;
				gFireWork[991][eFW_ExplosionDeath]=None;
				gFireWork[991][eFW_EmitDeath]=None;
				gFireWork[991][eFW_EmitDeathAmount]=None;
				gFireWork[991][eFW_Emitter]=0;
				gFireWork[991][eFW_EmitTime]=300;
				gFireWork[991][eFW_EmitAmount]=3;
				gFireWork[991][eFW_EmitterTypeRndSel]=8;
				gFireWork[991][eFW_EmitterTypeRnd]={811,812,813,829,001,002,003,004,0,0};
				gFireWork[991][eFW_ObjectVelocityZ]=0;
				gFireWork[991][eFW_ObjectSpeed]=0;
			}
		}
	}
	for(new a=1;a<ObjectsMax+1;a++)
	{
		aFW[a]=a;
	}
	
	Timer1=SetTimer("Timer",Accuracy,1);
	return 1;
}

public OnFilterScriptExit(){
	KillTimer(Timer1);
	for (new p=1;p<ObjectsMax;p++)
	{
		DestroyDynamicObject(Object[p]);
	}
	return 1;
}

forward Timer();public Timer(){
//	new TimeStart=GetTickCount();//debug
	new Type,Amount;
	new EmitTime;
	new Float:PosX,Float:PosY,Float:PosZ;
	for(new o=1;o<ObjectsInUse+1;o++)
	{
		if(ObjectLifeTimeMS[aFW[o]]>0)
		{
			EmitTime=gFireWork[ObjectType[aFW[o]]][eFW_EmitTime];
			if(EmitTime>0)
			{
				Type=gFireWork[ObjectType[aFW[o]]][eFW_ObjectType];
				ObjectEmitTimeMS[aFW[o]]-=Accuracy;
				if(ObjectEmitTimeMS[aFW[o]]<1)
				{
					ObjectEmitTimeMS[aFW[o]]+=gFireWork[ObjectType[aFW[o]]][eFW_EmitTime];
					//GetDynamicObjectPos(Object[aFW[o]],ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]]);
					Amount=gFireWork[ObjectType[aFW[o]]][eFW_EmitAmount];
					if(Amount>0)
					{
						for(new e=0;e<Amount;e++)
						{
							GetDynamicObjectPos(Object[aFW[o]],PosX,PosY,PosZ);
							Type=ObjectType[aFW[o]];
							new Spawn=gFireWork[ObjectType[aFW[o]]][eFW_Emitter];
							Amount=gFireWork[ObjectType[aFW[o]]][eFW_EmitAmount];
							if(Spawn>0)
							{
								for(new a=0;a<Amount;a++)
								{
									CObject(Spawn,ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]],0,0,0);
								}
							}
							else
							{
								for(new a=0;a<Amount;a++)
								{
									new SpawnRnd=random(gFireWork[ObjectType[aFW[o]]][eFW_EmitterTypeRndSel]);
									new Q=gFireWork[ObjectType[aFW[o]]][eFW_EmitterTypeRnd][SpawnRnd];
									CObject(Q,ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]],0,0,0);
//									new string[128];//debug
//									format(string,sizeof(string),"Random Emit: %d %d",SpawnRnd,Q);
//									SendClientMessageToAll(MSGTITL_COLOR,string);
								}
							}
							CObject(gFireWork[Type][eFW_Emitter],PosX,PosY,PosZ,0,0,0);
						}
					}
				}
			}
			ObjectLifeTimeMS[aFW[o]]-=Accuracy;
		}
		else
		{
			new Explosion=gFireWork[ObjectType[aFW[o]]][eFW_ExplosionDeath];
			if(Explosion>0)
			{
				GetDynamicObjectPos(Object[aFW[o]],ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]]);
				CreateExplosion(ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]],gFireWork[ObjectType[aFW[o]]][eFW_ExplosionDeath],200);
			}
			new Spawn=gFireWork[ObjectType[aFW[o]]][eFW_EmitDeath];
			Amount=gFireWork[ObjectType[aFW[o]]][eFW_EmitDeathAmount];
			if(Spawn>0)
			{
				for(new a=0;a<Amount;a++)
				{
					GetDynamicObjectPos(Object[aFW[o]],ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]]);
					CObject(Spawn,ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]],0,0,0);
				}
			}
			else if(Amount>0)
			{
				for(new a=0;a<Amount;a++)
				{
					new SpawnRnd=random(gFireWork[ObjectType[aFW[o]]][eFW_EmitDeathTypeRndSel]);
					new Q=gFireWork[ObjectType[aFW[o]]][eFW_EmitDeathTypeRnd][SpawnRnd];
					GetDynamicObjectPos(Object[aFW[o]],ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]]);
					CObject(Q,ObjectX[aFW[o]],ObjectY[aFW[o]],ObjectZ[aFW[o]],0,0,0);
//					new string[128];//debug
//					format(string,sizeof(string),"Random Spawn: %d %d",SpawnRnd,Q);
//					SendClientMessageToAll(MSGTITL_COLOR,string);
				}
			}
			DeleteObject(o);
		}
	}
//	new TimeMiddle=GetTickCount()-TimeStart;//debug
	new MaxPlayers=GetMaxPlayers();
	for(new id=0;id<MaxPlayers;id++)
	{
		Streamer_Update(id);
	}
//	new TimeEnd=GetTickCount()-TimeStart;//debug
//	new string[64];
//	format(string,sizeof(string),"~b~M:%d E:%d OC:%d",TimeMiddle,TimeEnd,ObjectsInUse);
//	GameTextForAll(string,100,5);
	return 1;
}

forward CObject(Type,Float:PosX,Float:PosY,Float:PosZ,Float:RotX,Float:RotY,Float:RotZ);public CObject(Type,Float:PosX,Float:PosY,Float:PosZ,Float:RotX,Float:RotY,Float:RotZ){
	new Amount=gFireWork[Type][eFW_ObjectAmount];
	for(new a=0;a<Amount;a++)
	{
		ObjectsInUse++;
		ObjectType[aFW[ObjectsInUse]]=Type;
		ObjectLifeTimeMS[aFW[ObjectsInUse]]=gFireWork[Type][eFW_LifeTime];
		ObjectEmitTimeMS[aFW[ObjectsInUse]]=gFireWork[Type][eFW_EmitTime];
		new RndAdd=gFireWork[Type][eFW_LifeTimeRndAdd];
		if(RndAdd>0)
		{
			ObjectLifeTimeMS[aFW[ObjectsInUse]]+=random(RndAdd);
		}
		ObjectX[aFW[ObjectsInUse]]=PosX;
		ObjectY[aFW[ObjectsInUse]]=PosY;
		ObjectZ[aFW[ObjectsInUse]]=PosZ;
		Object[aFW[ObjectsInUse]]=CreateDynamicObject(gParticle[gFireWork[Type][eFW_ObjectType]][eP_ObjectID],PosX,PosY,PosZ+gParticle[gFireWork[Type][eFW_ObjectType]][eP_OffsetZ],RotX,RotY,RotZ,-1,-1,-1,500);
		new Float:Speed=((random(20)+70)*gFireWork[Type][eFW_ObjectSpeed])/gFireWork[Type][eFW_LifeTime];
		new Float:AddX,Float:AddY,Float:AddZ;
		if(gFireWork[Type][eFW_ObjectAmount]>0)
		{
			if(gFireWork[Type][eFW_ObjectRnd]>0)
			{
				AddX=(random(gFireWork[Type][eFW_ObjectRndVelX])-(gFireWork[Type][eFW_ObjectRndVelX]/2))/100;
				AddY=(random(gFireWork[Type][eFW_ObjectRndVelY])-(gFireWork[Type][eFW_ObjectRndVelY]/2))/100;
				AddZ=(random(gFireWork[Type][eFW_ObjectRndVelZ])-(gFireWork[Type][eFW_ObjectRndVelZ]/2))/100;
			}
			MoveDynamicObject(Object[aFW[ObjectsInUse]],ObjectX[aFW[ObjectsInUse]]+AddX,ObjectY[aFW[ObjectsInUse]]+AddY,ObjectZ[aFW[ObjectsInUse]]+AddZ+gFireWork[Type][eFW_ObjectVelocityZ],Speed);
		}
//		new string[128];//debug
//		format(string,sizeof(string),"Type:%d Speed:%2.3f VelZ:%2.3f AddX:%f AddY:%f AddZ:%f LifeTime:%5d",Type,Speed,gFireWork[Type][eFW_ObjectVelocityZ],AddX,AddY,AddZ,ObjectLifeTimeMS[aFW[ObjectsInUse]]);
//		SendClientMessageToAll(MSGCMDS_COLOR,string);
	}
	return 1;
}

forward DeleteObject(ID);public DeleteObject(ID){
	DestroyDynamicObject(Object[aFW[ID]]);
	new tmp=aFW[ID];
	aFW[ID]=aFW[ObjectsInUse];
	aFW[ObjectsInUse]=tmp;
	ObjectsInUse--;
	return 1;
}

CMD:fw(playerid,cmdtext[]){
	new Type;
	if (sscanf(cmdtext,"d",Type))
	{
		SendClientMessage(playerid,MSGCMDS_COLOR,"Usage: \"/FW <Type (901,902,903,904,911,912,913,931,932,941,951,952,953,969,991)>\"");
		return 1;
	}
//	if(Type<900 || Type>999)//players should be allowed to spawn IDs 901-999 only
	if(Type<1 || Type>999)//only admins should be allowed to spawn 1-1000
	{
		SendClientMessage(playerid,MSGCMDS_COLOR,"This ID is out of Range. Type /fw (900-999)");
		return 1;
	}
	if(gFireWork[Type][eFW_ObjectType]==0)
	{
		SendClientMessage(playerid,MSGCMDS_COLOR,"This ID doesnt exist. Type /fw to get all IDs available.");
		return 1;
	}
	new Float:X,Float:Y,Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	CObject(Type,X,Y,Z-1,0,0,0);
	return 1;
}

CMD:cmds(playerid,cmdtext[]){
	SendClientMessage(playerid,MSGTITL_COLOR,">>>Fireworks");
	SendClientMessage(playerid,MSGCMDS_COLOR,"      /fwcmds /fw /fwcredits");
}

CMD:fwcmds(playerid,cmdtext[]){
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"Commands","/cmds\n/fwcmds\n/fwcredits\n/fw (Type)\n\tTypes: 901,902,903,904,911,912,913,929,931,932,941,951,952,953,969,991","close","");
	return 1;
}

CMD:fwcredits(playerid,cmdtext[]){
	ShowPlayerDialog(playerid,1,DIALOG_STYLE_MSGBOX,"Babuls Fireworks","Credits to:\n\t   SAMP-Team\n\t  ZeeX (zcmd)\n\t Y_Less (sscanf)\n\tIncognito (streamer)","close","");
	return 1;
}
