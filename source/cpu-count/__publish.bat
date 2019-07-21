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


set "path=%util_folder%;%path%"
%~d0
cd %~dp0
del %PROJECT_NAME%.zip
7za.exe a %PROJECT_NAME%.zip *.prg *.ch *.xpj *.md *.arc     
md  ..\..\docs\%PROJECT_NAME%
del ..\..\docs\%PROJECT_NAME%\*.*  /Q
copy %PROJECT_NAME%.zip   ..\..\docs\%PROJECT_NAME%\
copy *.md   ..\..\docs\%PROJECT_NAME%\
copy *.png  ..\..\docs\%PROJECT_NAME%\
del %PROJECT_NAME%.zip  
                                         
                                         
echo # %PROJECT_NAME%  > ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md

echo download: [%PROJECT_NAME%.zip](%PROJECT_NAME%.zip) >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md


echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md         

type short.md >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md
type readme.md >> ..\..\docs\%PROJECT_NAME%\index.md


echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md

FOR /f %%G IN ('dir *.prg *.ch *.xpj *.arc /b') DO (        
echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo [%%G]^(#%%G^)  >> ..\..\docs\%PROJECT_NAME%\index.md )
                                           
                                           
FOR /f %%G IN ('dir *.prg *.ch *.xpj *.arc /b') DO (        
echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md
echo ## %%G  >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
echo ``` >> ..\..\docs\%PROJECT_NAME%\index.md
type %%G  >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
echo ``` >> ..\..\docs\%PROJECT_NAME%\index.md
echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md)
                                           
