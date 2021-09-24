Import-Module posh-git
Import-Module oh-my-posh
Import-Module terminal-icons

$Host.UI.RawUI.ForegroundColor = “Green”
if ($host.UI.RawUI.WindowTitle -match “Administrator”) {$Host.UI.RawUI.ForegroundColor = “DarkRed”}

Set-Alias mongo "C:\Program Files\MongoDB\Server\5.0\bin\mongod.exe"

function ff { & "C:\Program Files\Mozilla Firefox\firefox.exe" }
function vs { & "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"}
function discord { & "C:\Users\hoooc\AppData\Local\Discord\app-0.0.309\Discord.exe" }
function signal { & "C:\Users\hoooc\AppData\Local\Programs\signal-desktop\Signal.exe" }

function touch {New-Item -ItemType File -Name ($args[0])}

function cd...  { Set-Location ..\.. }
function cd.... { Set-Location ..\..\.. }

function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Using Windows package manager
function upgrade { winget upgrade powershell }

Function pubip {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

Function genpass {
-join(48..57+65..90+97..122|ForEach-Object{[char]$_}|Get-Random -C 20)
}

function zip($source, $destination){
        Compress-Archive -LiteralPath $source -DestinationPath $destination
}

function unzip ($source, $destination) {
        Expand-Archive -LiteralPath $source -DestinationPath $destination
        }

function utc { [System.DateTime]::UtcNow }

function reloadps { & $profile }

function findfile($name) 
{ 
        Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue
        | ForEach-Object -Parallel{
                $placepath = $_.directory
                Write-Output "${place_path}\${_}"
        }
}

function po { Stop-Computer -ComputerName localhost } 

function rs { Restart-Computer -ComputerName localhost } 

function awk($file, $delimiter, $de, $col) {
        get-content $file | Foreach-Object {
        $data = $_ -split $delimiter
        if($col)
        {
                $column = $data -split $de
                Write-Output $column[$col]
        }
        else{
        Write-output $data
        }
        }
}

function dirs
{
    if ($args.Count -gt 0)
    {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else
    {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

function grep($regex, $dir) {
        if ( $dir ) {
        Get-ChildItem $dir | Select-String $regex
                return
        }
        $input | Select-String $regex
}

function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}

function pkill($name) {
        Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}

function pgrep($name) {
        Get-Process | grep $name
}

function df { Get-Volume }

function export($name, $value) { Set-Item -force -path "env:$name" -value $value }

function csgrep($filetype, $searchterm) { dirs *.$filetype | Get-ChildItem -Recurse | Select-String "$searchterm" }

function isadmin { [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544' }

# Git
function clone { git clone $args }
function pull { git pull }
function push { git push }
function commit { git commit -m $args}
function stash { git stash $args }
function apply { git stash apply }
function add { git add $args }
function remote { git remote add origin $args }
function status { git status }
function restore { git restore --staged $args }
function branches { git branch -a }
function checkout { git checkout $args }

function cloneall($token) { 
        Set-Location d:\scm
        $response = curl -H "Authorization: token $token" https://api.github.com/user/repos?per_page=1000 | ConvertFrom-Json
        foreach ($repo in $response)
        {
                git clone ($repo.ssh_url)
        } 
}

function pullall {
        Set-Location d:\scm
        Get-ChildItem | ForEach-Object -Parallel { Set-Location $_; Write-Output "Pulling $_"; git pull }
}

function createrepo ($token, $name, $private, $description){
        $response = curl -H "Authorization: token $token" -d "{\""name\"": \""$name\"", \""private\"": $private, \""description\"": \""$description\""}" https://api.github.com/user/repos | ConvertFrom-Json
        if($response.ssh_url){
                Write-Output "Add this repo as origin -- git remote add origin "$response.ssh_url
        }
        else{
                Write-Output "Error creating repository."
        }
}

function mongo-local {
        if(Test-Path -Path 'D:\'){
                if(Test-Path -Path 'D:\mongodb\data'){
                        mongo --dbpath D:\mongodb\data
                }
                else{
                        New-Item -Path D:\mongodb\data -Type Directory
                        mongo --dbpath 'D:\mongodb\data'
                }
        }
        else{
                Write-Output "D Drive not available"
        }
}

function sessionfunctions { Get-ChildItem function: }

function scm {
        if(Test-Path -Path 'D:\'){
                Set-Location D:\scm
                Get-ChildItem
                | Where-Object{$_.psiscontainer}| ForEach-Object { $fname = $_ -creplace '(?s)^.*\\', ''
                New-Item function:\ -name global:$fname -value "set-location d:\scm\$($fname)" } 
                | Out-Null
                Set-Location ~
        }
        else{
                Write-Output 'D:\ Drive does not exist'
        }
}
