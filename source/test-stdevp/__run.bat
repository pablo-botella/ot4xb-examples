

if exist __global_settings.bat     call __global_settings.bat
if exist __global_settings.bat     goto skip_parent_global_settings
if exist ..\__global_settings.bat  call ..\__global_settings.bat
:skip_parent_global_settings

                                                                
                                                                
if exist __project_settings.bat     call __project_settings.bat
if exist __project_settings.bat     goto skip_parent_project_settings
if exist ..\__project_settings.bat  call ..\__project_settings.bat
:skip_parent_project_settings

start test-stdevp.exe

