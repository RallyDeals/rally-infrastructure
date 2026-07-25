@echo off
echo Cloning all RallyDeals repositories...
echo.

set repos=^
    https://github.com/RallyDeals/rally-docs^
    https://github.com/RallyDeals/rally-order^
    https://github.com/RallyDeals/rally-payment^
    https://github.com/RallyDeals/rally-common^
    https://github.com/RallyDeals/rally-infrastructure^
    https://github.com/RallyDeals/rally-inventory^
    https://github.com/RallyDeals/rally-catalog^
    https://github.com/RallyDeals/rally-notification^
    https://github.com/RallyDeals/rally-deal^
    https://github.com/RallyDeals/rally-participation^
    https://github.com/RallyDeals/.github^
    https://github.com/RallyDeals/rally-management^
    https://github.com/RallyDeals/rally-auth^
    https://github.com/RallyDeals/rally-ui

for %%r in (%repos%) do (
    echo Cloning %%r...
    git clone %%r
    echo.
)

echo Done! All repositories have been cloned.
pause