@echo off
set TITLES=-window-title "FLib Reference (AS3)" -footer "Author St. Ganchev &lt; itni.cc &#64; gmail.com &gt;"
asdoc %TITLES% -source-path src -doc-sources src -output doc

echo;
echo;
echo;
pause