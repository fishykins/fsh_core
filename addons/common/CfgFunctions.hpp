class CfgFunctions
{
    class FSH
    {
        class Objects
        {
            PATHTO_FNC(getGear);
            PATHTO_FNC(getVehicleTransport);
            PATHTO_FNC(getVehicleWeapons);
            PATHTO_FNC(getVehicleData);
            PATHTO_FNC(getWeaponData);
            PATHTO_FNC(getPlayerData);
            PATHTO_FNC(setPlayerData);
            PATHTO_FNC(getUnitMagazines);
            PATHTO_FNC(getUnitItems);
            PATHTO_FNC(getUnitWeapons);
            PATHTO_FNC(getObjectUid);
            PATHTO_FNC(getObjectRelPos);
        };
        class Groups
        {
            PATHTO_FNC(getGroupConfig);
            PATHTO_FNC(getGroupData);
        };
        class factions
        {
            PATHTO_FNC(getFactions);
            PATHTO_FNC(isFaction);
            PATHTO_FNC(factionUnits);
            PATHTO_FNC(factionVehicles);
            PATHTO_FNC(factionGroups);
            PATHTO_FNC(factionGear);
        };
    };
};
