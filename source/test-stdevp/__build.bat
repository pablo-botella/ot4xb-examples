

if exist __global_settings.bat     call __global_settings.bat
if exist __global_settings.bat     goto skip_parent_global_settings
if exist ..\__global_settings.bat  call ..\__global_settings.bat
:skip_parent_global_settings

                                                                
                                                                
if exist __project_settings.bat     call __project_settings.bat
if exist __project_settings.bat     goto skip_parent_project_settings
if exist ..\__project_settings.bat  call ..\__project_settings.bat
:skip_parent_project_settings

if exist __clean_intermediate.bat  call __clean_intermediate.bat
if exist __get_dependencies.bat    call __get_dependencies.bat

pbuild test-stdevp.xpj > error.log

if exist __clean_dependencies.bat   call __clean_dependencies.bat

start notepad.exe error.log

