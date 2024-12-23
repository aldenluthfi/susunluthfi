Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

scoop install git firefox

scoop bucket add main https://github.com/ScoopInstaller/Main
scoop bucket add extras https://github.com/ScoopInstaller/Extras
scoop bucket add java https://github.com/ScoopInstaller/Java
scoop bucket add zA https://github.com/anderlli0053/DEV-tools
scoop bucket add zB https://github.com/kkzzhizhou/scoop-apps
scoop bucket add zC https://github.com/ScoopInstaller/Java
scoop bucket add zD https://github.com/FlawlessCasual17/MyScoop
scoop bucket add zE https://github.com/cmontage/scoopbucket-third

scoop install busybox fastfetch neovim powertoys windows-terminal winaero-tweaker windhawk