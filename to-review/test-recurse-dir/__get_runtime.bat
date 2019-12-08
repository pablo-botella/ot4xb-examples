




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


copy  %xpp19sl1_folder_runtime%\ascom10.dll
copy  %xpp19sl1_folder_runtime%\ascom10c.dll
copy  %xpp19sl1_folder_runtime%\asrdbc10.dll
copy  %xpp19sl1_folder_runtime%\som.dll
copy  %xpp19sl1_folder_runtime%\xppnat.dll
copy  %xpp19sl1_folder_runtime%\xpprt1.dll
copy  %xpp19sl1_folder_runtime%\xppsys.dll
copy  %xpp19sl1_folder_runtime%\xppui1.dll
copy  %ot4xb_folder_runtime%\ot4xb.dll
copy  %xpp19sl1_folder_runtime%\*.dll

rem copy F:\__pbnprj\gh\_ot4xb_\master\_ot4xb_\Debug\*.dll

