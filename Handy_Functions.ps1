<#
.SYNOPSIS

Function that checks if a any file in a folder is in use
.DESCRIPTION

.PARAMETER folderPath
The path you whanna test

#>
function checkIfFolderInUse( [String]$folderPath){ 
    if($folderPath[$folderPath.Length-1] -eq "\"){
      $folderPath = $folderPath.Substring(0,$folderPath.Length-1) 
    }
    $isInUse = 0
    Try{
        Rename-Item -path $folderPath -newName $($folderPath+"_") -erroraction 'Stop'               
    }Catch{
      $isInUse = 1  
    }
    if($isInUse -eq 0 ){
        Rename-Item -path $($folderPath+"_") -newName $folderPath
        return $false
    }else{
        return $true
    }
}

<#
.SYNOPSIs
Restarts a SQL instance

.PARAMETER server
The server the SQL-instance is running on
.PARAMETER instance
The name of the SQL-instace

#>
function restartSQLInstance($server, $instance){
    $sericeName = "MSSQL`$"+$instance
    Write-Host "Restarting service $sericeName on $($server)... "

    (get-service -name $sericeName -computername $server).Stop()
            while((get-service $sericeName -ComputerName $server).Status -eq "StopPending"){
                sleep 1
            }
           (get-service -name $sericeName -computername $server).Start()
           while((get-service $sericeName -ComputerName $server).Status -ne "Running"){
                sleep 1
            }
    Write-Host "Serverice $sericeName re-started "
}