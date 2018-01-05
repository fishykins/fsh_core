class tasks {
    class baseTask
    {
        displayName = "";
        init = ""; //Code to run when group is given this task. "_this" is the array of data attached to the task.
        exit = "";
    };

    class baseObject
    {
        isGroup = 1;
        priority = 1; //Score multiplier for things in this category
        required = 0; //If 1, thing for this task MUST be of this type
        wlTypes[] = {}; //types allowed
    };

    class patrol : baseTask
    {
        displayName = "Patrol";
        init = QUOTE(COMPILE_FILE(tasks\init_patrol));
        exit = QUOTE(COMPILE_FILE(tasks\exit_patrol));
        class infantry : baseObject
        {
            priority = 1.5;
            wlTypes[] = {"infantry"};
        };
    };

    class transport : baseTask
    {
        displayName = "Troop transport";
        init = QUOTE(COMPILE_FILE(tasks\init_transport));
        exit = QUOTE(COMPILE_FILE(tasks\exit_transport));
        class transport : baseObject
        {
            isGroup = 0;
            required = 1;
            wlTypes[] = {"transport","truck"};
        };
    };
};
