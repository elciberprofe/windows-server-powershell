# Título: Asignar una IP estática para el equipo
# Fecha: 28/09/2022
# Autor: Xavi García (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

# 1.2 - Asignar una IP estática para el equipo

#Mejora el SCRIPT para que permita escoger al usuario la tarjeta de red que desea modificar

$separador = "-"*50

$interfazID = Get-NetConnectionProfile | Select -ExpandProperty InterfaceIndex

$IP = Get-NetIPAddress -InterfaceIndex $interfazID -AddressFamily 'IPv4' | Select -ExpandProperty IPAddress

$gateway = Get-NetRoute | Where-Object DestinationPrefix -eq '0.0.0.0/0' | Select -ExpandProperty NextHop

$adaptador = Get-NetAdapter | Where-Object InterfaceIndex -eq $interfazID | Select -ExpandProperty Name

Write-Host $separador
Write-Host "El Adaptador de Red es : $adaptador"
Write-Host "El ID del Adaptador es : $interfazID"
Write-Host "La IP actual es        : $IP"

Write-Host $separador
$IP = Read-Host "Introduzca la nueva IP para el Equipo"
$mascara = Read-Host "Introduzca el número la Máscara de Subred"
$enlace = Read-Host "Introduzca la IP de la Puerta de Enlace"

Write-Host $separador
Write-Host "Modificando la Dirección IP por      : $IP"
Write-Host "Modificando la Máscara de Subred por : $mascara"
Write-Host "Modificando la Puerta de Enlace por  : $enlace"

if ($gateway -eq $enlace) {
    Remove-NetIPAddress -InterfaceIndex $interfazID -Confirm:$false
    New-NetIPAddress -IPAddress $IP -InterfaceIndex $interfazID -DefaultGateway $gateway > $null
    Set-NetIPAddress -IPAddress $IP -PrefixLength $mascara -InterfaceIndex $interfazID
} else {
    Remove-NetIPAddress -InterfaceIndex $interfazID -Confirm:$false
    Remove-NetRoute -DestinationPrefix '0.0.0.0/0' -Confirm:$false -ErrorAction SilentlyContinue
    New-NetIPAddress -IPAddress $IP -PrefixLength $mascara -DefaultGateway $enlace -InterfaceIndex $interfazID > $null
}

Write-Host $separador
Write-Output "Comprobando que se han realizado las modificaciones correctamente..."
Start-Sleep -Seconds 5
Write-Output "Realizando un Test de Conexión con la puerta de enlace..."

$ping = Test-NetConnection $enlace | Select -ExpandProperty PingSucceeded

if ($ping -eq "True") {
    Write-Output "El test de conexión ha sido un éxito."
} else {
    Write-Output "El test de conexión ha fallado."
}