# Run as admin
params(
[string]$uri = "https://aka.ms/download-jdk/microsoft-jdk-11.0.13.8.1-windows-x64.msi"
[string]$out = "D:\temp\JDK.msi"
}

function Install-JDK(){
    try{
        Write-Output("Downloading JDK....")
        Invoke-WebRequest -uri $uri -OutFile $out
        Write-Output("Installing JDK....")
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i $out /quiet /norestart /l C:\Users\hoooc\Desktop\installlog.txt"
    }
    catch{
        Write-Output("Error Installing JDK!")
        exit 1
    }
    try{
        Write-Output("Setting Environment Variables....")
        [System.Environment]::SetEnvironmentVariable('JAVA_HOME','C:\Program Files\Microsoft\jdk-11.0.13.8-hotspot',[System.EnvironmentVariableTarget]::Machine)

        $oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
        $newPath = "$oldPath;C:\Program Files\Microsoft\jdk-11.0.13.8-hotspot\bin"
        Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
    }
    catch{
        Write-Output("Error Setting Environment Variables")
    }
}

Install-JDK
