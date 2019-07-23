

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


SET "PROJECT_NAME=xml-tree-view"

if exist __clean_intermediate.bat  call __clean_intermediate.bat
if exist __get_dependencies.bat    call __get_dependencies.bat
pbuild xml-tree-view.xpj > error.log
if exist __clean_dependencies.bat   call __clean_dependencies.bat
start notepad.exe error.log


