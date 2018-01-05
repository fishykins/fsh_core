class tasks {
    class baseTask
    {
        displayName = "";
        init = ""; //Code to run when group is given this task. "_this" is the array of data attached to the task. _group and _mia are both passed values
        check = "";
        checkInterval = 5;
        success = "";
        failure = "";
    }

    class patrol : baseTask
    {
        displayName = "Patrol";
        init = QUOTE(_this call COMPILE_FILE(tasks\init_patrol));
    };
};
