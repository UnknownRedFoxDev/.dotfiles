#define NOB_IMPLEMENTATION
#define NOB_EXPERIMENTAL_DELETE_OLD
#define NOB_WARN_DEPRECATED
#include "nob.h"

#define BUILD_FOLDER "build/"


int main(int argc, char **argv)
{
    NOB_GO_REBUILD_URSELF(argc, argv);

    Nob_Cmd cmd = {0};

    nob_cc(&cmd);
    nob_cc_flags(&cmd);
    nob_cc_output(&cmd, BUILD_FOLDER"main");
    nob_cc_inputs(&cmd, "main.c");
    nob_cmd_append(&cmd, "-lraylib", "-lm");

    if (!nob_mkdir_if_not_exists(BUILD_FOLDER)) return 1;

    if (!nob_cmd_run(&cmd)) return -1;

    return 1;
}
