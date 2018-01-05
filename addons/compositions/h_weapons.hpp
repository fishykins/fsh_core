#define AIUSE_NONE  0
#define AIUSE_LIGHT  1
#define AIUSE_MARKING 2
#define AIUSE_CONCEALMENT 4
#define AIUSE_COUNTERMEASURE 8
#define AIUSE_MINE 16
#define AIUSE_UNDERWATER 32
#define AIUSE_INF 64
#define AIUSE_VEH 128
#define AIUSE_AIR 256
#define AIUSE_ARMOUR 512

#define MISSILE_THRESH 300

class weapons
{
    class baseType
    {
        className = "";
        damageRange[] = {-1,-1};
        calRange[] = {-1,-1};
        simulation = "";
        aiUse = -1;
        lockingEnabled = -1;
        lockGround = -1;
        lockAir = -1;
    };

    class mainCannon: baseType
    {
        className = "cannon";
        calRange[] = {25,50};
        simulation = "shotShell";
        aiUse = AIUSE_VEH;
    };

    class lightCannon : baseType
    {
        className = "lightcannon";
        calRange[] = {15,24};
        simulation = "shotShell";
        aiUse = -1;
    };
    class lightCannonBullet : baseType
    {
        className = "minicannon";
        calRange[] = {4,15};
        simulation = "shotBullet";
        aiUse = AIUSE_VEH;
    };

    //High caliber rounds
    class antiAirRound : baseType
    {
        className = "aa";
        damageRange[] = {50,-1};
        calRange[] = {2,-1};
        aiUse = AIUSE_AIR;
        simulation = "shotBullet";
    };

    class antiVehicleRound : antiAirRound
    {
        className = "ag";
        aiUse = AIUSE_VEH;
    };

    //=============================================//
    class missile : baseType
    {
        className = "missile";
        damageRange[] = {MISSILE_THRESH,-1};
        calRange[] = {0,100};
        simulation = "shotMissile";
        lockingEnabled = 1;
    };

    class rocket : missile
    {
        className = "rocket";
        damageRange[] = {200,-1};
        lockingEnabled = 0;
    };

    class antiAirMissile : baseType
    {
        className = "aa";
        damageRange[] = {MISSILE_THRESH,-1};
        simulation = "shotMissile";
        lockingEnabled = 1;
        lockAir = 1;
    };

    class antiAirMissileType2 : antiAirMissile
    {
        aiUse = AIUSE_AIR;
        lockingEnabled = -1;
        lockAir = -1;
    };

    class antiTankMissile : antiAirMissile
    {
        className = "at";
        aiUse = AIUSE_ARMOUR;
        lockingEnabled = 1;
        lockGround = 1;
        lockAir = -1;
    };

    class antiVehicleMissile : antiTankMissile
    {
        className = "ag";
        aiUse = AIUSE_VEH;
    };

    class antiPersonelMissile : antiTankMissile
    {
        className = "ap";
        damageRange[] = {100,-1};
        aiUse = AIUSE_INF;
        locking[] = {0,1};
        lockingEnabled = -1;
    };

    class peashooter : baseType
    {
        className = "gun";
        damageRange[] = {9,60};
        calRange[] = {0,3};
        simulation = "shotBullet";
        aiUse = -1;
    };
};
