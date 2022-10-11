#1.4 Genera informes en CSV y HTML con los Usuarios y Ordenadores del AD
$separador = "-"*50
#Utilizar variable de entorno $HOME
Write-Output $separador
if (Test-Path "$HOME\Desktop\Informes") {
    Write-Output "Accediendo a la carpeta Informes"
    Set-Location "$HOME\Desktop\Informes"
} else {
    Write-Output "Creando la carpeta Informes"
    New-Item -Path "$HOME\Desktop" -Name "Informes" -ItemType "directory" > $null
    Write-Output "Accediendo a la carpeta Informes"
    Set-Location "$HOME\Desktop\Informes"
}

Write-Output $separador
Start-Sleep -Seconds 1
if (Test-Path "$HOME\Desktop\Informes\CSV") { 
    Write-Output "Accediendo a la carpeta Informes CSV"
    Set-Location "$HOME\Desktop\Informes\CSV"
} else {
    Write-Output "Creando la carpeta Informes CSV"
    New-Item -Path "$HOME\Desktop\Informes" -Name "CSV" -ItemType "directory" > $null
    Write-Output "Accediendo a la carpeta Informes CSV"
    Set-Location "$HOME\Desktop\Informes\CSV"
}

Write-Output "Generando el informe de Ordenadores en CSV..."
Write-Output "Generando el informe de Usuarios en CSV..."

Get-ADComputer -Filter '*' | Export-Csv 'Ordenadores.csv'
Get-ADUser -Filter '*' | Export-Csv 'Usuarios.csv'

Start-Sleep -Seconds 1
Write-Output "¡Los informes en CSV ya estan disponibles!"

Write-Output $separador
if (Test-Path "$HOME\Desktop\Informes\HTML") { 
    Write-Output "Accediendo a la carpeta Informes HTML"
    Set-Location "$HOME\Desktop\Informes\HTML"
} else {
    Write-Output "Creando la carpeta Informes HTML"
    New-Item -Path "$HOME\Desktop\Informes" -Name "HTML" -ItemType "directory" > $null
    Write-Output "Accediendo a la carpeta Informes HTML"
    Set-Location "$HOME\Desktop\Informes\HTML"
}

Write-Output "Generando el informe de Ordenadores en HTML..."
Write-Output "Generando el informe de Usuarios en HTML..."

Get-ADComputer -Filter '*' | ConvertTo-Html | Out-File 'Ordenadores.html'
Get-ADUser -Filter '*' | ConvertTo-Html | Out-File 'Usuarios.html'

Start-Sleep -Seconds 1
Write-Output "¡Los informes en HTML ya estan disponibles!"

