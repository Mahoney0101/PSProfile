Import-Module posh-git

function ff { & "C:\Program Files\Mozilla Firefox\firefox.exe" }
function vs { & "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"}
function discord {& "C:\Users\hoooc\AppData\Local\Discord\app-0.0.309\Discord.exe" }

function touch {New-Item -ItemType File -Name ($args[0])}

function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
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

Function pubip {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

Function genpass {
-join(48..57+65..90+97..122|ForEach-Object{[char]$_}|Get-Random -C 20)
}

function unzip ($file) {
        $dirname = (Get-Item $file).Basename
        echo("Extracting", $file, "to", $dirname)
        New-Item -Force -ItemType directory -Path $dirname
        expand-archive $file -OutputPath $dirname -ShowProgress
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