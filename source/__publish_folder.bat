
 
rem   ------ 
rem    
rem   [test-WNetEnumResourceA](test-WNetEnumResourceA) 
rem    
rem   ------ 



                                         
echo # ot4xb-examples   > ..\docs\index.md
echo ------ >> ..\docs\index.md
echo. >>    ..\docs\index.md


rem    echo download: [%PROJECT_NAME%.zip](%PROJECT_NAME%.zip) >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    
rem    
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md         
rem    
rem    type readme.md >> ..\..\docs\%PROJECT_NAME%\index.md
rem    
rem    
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    
FOR /f %%G IN ('dir /ad /b') DO (
echo [%%G]^(#%%G^) >> ..\docs\index.md        
echo [%%G]^(#%%G^) )
rem                                               
rem                                               
rem    FOR /f %%G IN ('dir *.prg *.ch *.xpj *.arc /b') DO (        
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo ## %%G  >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
rem    echo ``` >> ..\..\docs\%PROJECT_NAME%\index.md
rem    type %%G  >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
rem    echo ``` >> ..\..\docs\%PROJECT_NAME%\index.md
rem    echo. >> ..\..\docs\%PROJECT_NAME%\index.md      
rem    echo ------ >> ..\..\docs\%PROJECT_NAME%\index.md)
                                           
echo ------ >> ..\docs\index.md