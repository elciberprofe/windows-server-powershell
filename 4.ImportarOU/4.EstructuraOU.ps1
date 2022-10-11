# Título: Modificar el nombre del equipo
# Fecha: 11/10/2022
# Autor: Xavi García (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

#1.5 Crear una estructura de Unidades Organizativas importando un CSV
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$separador = "-"*50

$nombreRaiz = (Get-ADDomain).DistinguishedName

$csv = Import-Csv -Path '.\ou.csv' -Delimiter ';'

foreach ($ciudad in $csv.Ciudad) {
    if ($ciudad -ne "") {
        Write-Host $separador
        $ADOU = (Get-ADOrganizationalUnit -Filter '*').DistinguishedName
        if ($ADOU -contains "OU=$ciudad,$nombreRaiz") {
            Write-Output "[!!]La Unidad Organizativa: $ciudad ya existe"
        } else {
            Write-Output "[++]Creando la Unidad Organizativa: $ciudad"
            New-ADOrganizationalUnit -Name $ciudad -Path $nombreRaiz -Description "Contenedor de la Ciudad de $ciudad" -ProtectedFromAccidentalDeletion:$false
        }

        Write-Host $separador
        $nuevaRaiz = "OU=$ciudad,$nombreRaiz"
        $ADOU = (Get-ADOrganizationalUnit -Filter '*').DistinguishedName
        foreach ($ou in $csv.OU) {
            if ($ou -ne "") {
                if ($ADOU -contains "OU=$ou,$nuevaRaiz") {
                    Write-Output "[!]La Unidad Organizativa: $ou de la ciudad $ciudad ya existe"
                } else {
                    Write-Output "[+]Creando la Unidad Organizativa: $ou de la ciudad de $ciudad"
                    New-ADOrganizationalUnit -Name $ou -Path $nuevaRaiz -ProtectedFromAccidentalDeletion:$false
                }
            } 
        }
    }    
}

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'Continue'
$WarningPreference = 'Continue'