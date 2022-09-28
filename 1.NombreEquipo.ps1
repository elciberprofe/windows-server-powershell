# Título: Modificar el nombre del equipo
# Fecha: 28/09/2022
# Autor: Xavi García (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

# 1.1 - Modificar el nombre del equipo y reiniciar el servidor

$separador = "-"*50

$nombrePC = Hostname
Write-Host "El Nombre del Equipo actual es: $nombrePC"

Write-Host $separador
$nombrePC = Read-Host "Introduce un nuevo nombre para el equipo"
$nombrePC = $nombrePC.ToUpper()

Write-Host $separador
Write-Output "Cambiando el nombre del equipo por: $nombrePC"
Rename-Computer -NewName $nombrePC

Write-Host $separador
Write-Output "El equipo se reiniciará en 10 segundos..."
Start-Sleep -Seconds 10
Restart-Computer