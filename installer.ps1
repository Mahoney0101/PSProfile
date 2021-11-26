# Run as admin
param(
[Parameter(mandatory=$true)]
[string]$uri,
[string]$out = "D:\temp\installer.msi",
[string]$log = "D:\temp"
)

function Install(){
    try{
        Write-Output("Downloading....")
        Invoke-WebRequest -uri $uri -OutFile $out
        Write-Output("Installing, installation logs can be found in $log")
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $out /quiet /norestart /l $log\installlog.txt"
    }
    catch{
        Write-Output("Script Failed Sucessfully.... run as Admin, ensuredownload and log location exist.")
        exit 1
    }
}

Install
