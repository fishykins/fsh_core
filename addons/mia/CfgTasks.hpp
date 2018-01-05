class tasks {
    class baseTask
    {
        displayName = "";
        init = ""; //Code to run when group is given this task. "_this" select 0 = assigned group, _this select 1 = any passed params
        check = "";
        checkInterval = 5;
        success = "";
        failure = "";
    }

    class patrol : baseTask
    {
        displayName = "Patrol";
        description = "A basic patrol task- group will be given a few random waypoints in the passed area."
        init = QUOTE(_this call COMPILE_FILE(tasks\init_patrol));
    };
};
