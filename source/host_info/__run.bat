
SET "PROJECT_NAME=host_info"

if exist                   __global_settings.bat      call                   __global_settings.bat
if exist                   __global_settings.bat      goto                   skip_parent_global_st
if exist                ..\__global_settings.bat      call                ..\__global_settings.bat
if exist                ..\__global_settings.bat      goto                   skip_parent_global_st
if exist             ..\..\__global_settings.bat      call             ..\..\__global_settings.bat
if exist             ..\..\__global_settings.bat      goto                   skip_parent_global_st
if exist          ..\..\..\__global_settings.bat      call          ..\..\..\__global_settings.bat
if exist          ..\..\..\__global_settings.bat      goto                   skip_parent_global_st
if exist       ..\..\..\..\__global_settings.bat      call       ..\..\..\..\__global_settings.bat
if exist       ..\..\..\..\__global_settings.bat      goto                   skip_parent_global_st
if exist    ..\..\..\..\..\__global_settings.bat      call    ..\..\..\..\..\__global_settings.bat
if exist    ..\..\..\..\..\__global_settings.bat      goto                   skip_parent_global_st
:skip_parent_global_st
set "skip_parent_global_st=1"


if exist                   __project_settings.bat     call                   __project_settings.bat
if exist                   __project_settings.bat     goto                   skip_parent_project_st
if exist                ..\__project_settings.bat     call                ..\__project_settings.bat
if exist                ..\__project_settings.bat     goto                   skip_parent_project_st
if exist             ..\..\__project_settings.bat     call             ..\..\__project_settings.bat
if exist             ..\..\__project_settings.bat     goto                   skip_parent_project_st
if exist          ..\..\..\__project_settings.bat     call          ..\..\..\__project_settings.bat
if exist          ..\..\..\__project_settings.bat     goto                   skip_parent_project_st
if exist      ..\ ..\..\..\__project_settings.bat     call       ..\..\..\..\__project_settings.bat
if exist      ..\ ..\..\..\__project_settings.bat     goto                   skip_parent_project_st
if exist    ..\..\..\..\..\__project_settings.bat     call    ..\..\..\..\..\__project_settings.bat
if exist    ..\..\..\..\..\__project_settings.bat     goto                   skip_parent_project_st
:skip_parent_project_st
set "skip_parent_project_st=1"


start host_info.exe \\%computername%\c\


