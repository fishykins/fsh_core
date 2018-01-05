class tasks {
    class baseTask
    {
        displayName = "";
        init = ""; //Code to run when group is given this task. "_this" is the array of data attached to the task.
        check = "";
        checkInterval = 5;
        success = "";
        failure = "";
    };

    class baseObject
    {
        isGroup = 1;
        priority = 1; //Score multiplier for things in this category
        required = 0; //If 1, thing for this task MUST be of this type
        wlTypes[] = {}; //types allowed
        blTypes[] = {}; //types not allowed
    };

    class patrol : baseTask
    {
        displayName = "Patrol";
        init = QUOTE(_this call COMPILE_FILE(tasks\init_patrol));
        class infantry : baseObject
        {
            priority = 1.5;
            wlTypes[] = {"infantry"};
        };
    };

    class transport : baseTask
    {
        displayName = "Troop transport";
        init = QUOTE(_this call COMPILE_FILE(tasks\init_patrol));
        class transport : baseObject
        {
            isGroup = 0;
            priority = 2;
            required = 1;
            wlTypes[] = {"transport"};
        };
        class truck : baseObject
        {
            isGroup = 0;
            priority = 2;
            wlTypes[] = {"truck"};
        };
    };
};
