                                         
echo # ot4xb-examples   > ..\docs\index.md
echo ------ >> ..\docs\index.md
echo. >>    ..\docs\index.md



FOR /f %%G IN ('dir /ad /b') DO (            
echo ## [%%G]^(%%G^) >> ..\docs\index.md        
echo.  >> ..\docs\index.md        
type %%G\short.md  >> ..\docs\index.md        
echo.  >> ..\docs\index.md        
echo ----  >> ..\docs\index.md        
echo [%%G]^(#%%G^) )

                                           
echo ------ >> ..\docs\index.md