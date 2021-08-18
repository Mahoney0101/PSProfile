Import-Module posh-git

function ff { & "C:\Program Files\Mozilla Firefox\firefox.exe" }
function vs { & "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"}
function discord { & "C:\Users\hoooc\AppData\Local\Discord\app-0.0.309\Discord.exe" }
function signal { & "C:\Users\hoooc\AppData\Local\Programs\signal-desktop\Signal.exe" }

function touch {New-Item -ItemType File -Name ($args[0])}

function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

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

function reloadps { $profile }

function findfile($name) 
{ 
        ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue
        | foreach{
                $placepath = $_.directory
                echo "${place_path}\${_}"
        }
}

# Linux type functions
# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function poweroff { Stop-Computer -ComputerName localhost } 

function reboot { Restart-Computer -ComputerName localhost } 

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
                ls $dir | select-string $regex
                return
        }
        $input | select-string $regex
}

function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}

function pkill($name) {
        ps $name -ErrorAction SilentlyContinue | kill
}

function pgrep($name) {
        ps | grep $name
}

function df { get-volume }

function export($name, $value) { set-item -force -path "env:$name" -value $value }

function csgrep($filetype, $searchterm) { dirs *.$filetype | Get-ChildItem -Recurse | Select-String "$searchterm" }


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
        cd d:\scm
        $responce = curl -H "Authorization: token $token" https://api.github.com/user/repos?per_page=1000 | ConvertFrom-Json
        foreach ($repo in $responce)
        {
                git clone ($repo.ssh_url)
        } 
}

function pullall {
        cd d:\scm
        Get-ChildItem | ForEach-Object -Parallel { cd $_; echo "Pulling $_"; git pull }
}

function createrepo ($token, $name, $private, $description){
        $response = curl -H "Authorization: token $token" -d "{\""name\"": \""$name\"", \""private\"": \""$private\"", \""description\"": \""$description\""}" https://api.github.com/user/repos | ConvertFrom-Json
        if($response.ssh_url){
                echo "Add this repo as origin -- git remote add origin "$response.ssh_url
        }
        else{
                echo "Error creating repository."
        }
}