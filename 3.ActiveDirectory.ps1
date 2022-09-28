# T�tulo: Instalar el rol de Directorio Activo y promocionar a Controlador de Dominio
# Fecha: 28/09/2022
# Autor: Xavi Garc�a (ElCiberProfe)
# Lenguaje: PowerShell
# Probado en: Windows PowerShell v5.1

##################################
#                                #
# CONTENIDO CON FINES EDUCATIVOS #
#                                #
##################################

#1.3 Instalar el rol de Directorio Activo y promocionar a Controlador de Dominio

$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$separador = "-"*50

# FUNCIONES
Function Instala-Bosque {
    Write-Host "Instalando un nuevo Bosque..."
    $dominio = Read-Host "Introduce el nombre del dominio. Ejemplo: elciberprofe.com"
    $netbios = Read-Host "Introduce el nombre del netbios. Ejemplo: CIBERPROFE"
    Write-Host $separador
    Write-Host "[!!]Debe introducir una nueva contrase�a para el Administrador"
    Write-Host "[!]Una vez finalizada la instalaci�n se reiniciar� el servidor"
    Write-Host "[!]El proceso de instalaci�n tardar� unos minutos..."
    Install-ADDSForest -DomainName $dominio -DomainNetbiosName $netbios -Confirm:$false > $null
    Write-Host "�La creaci�n del Bosque se ha realizado con �xito!"
    Write-Host "Reiniciando el Servidor par aplicar los cambios..."
}

Function Comprueba-Bosque {
    if (Get-Command 'Get-ADForest' -ErrorAction 'SilentlyContinue') {
        Try { 
            if (Get-ADForest) {
                $bosque = Get-ADForest | Select -ExpandProperty Name
                Write-Host "[*]Ya existe un Bosque con el nombre $bosque"
            } else {
                Instala-Bosque
            }
        } Catch {
            Instala-Bosque
        }
            
    } else {
        Write-Host "[!]No se ha podido obtener el cmdlet ADForest"
    }
}

# MAIN
Write-Host $separador
Write-Host "Obteniendo informaci�n de los roles del servidor..."
$AD = Get-WindowsFeature -Name 'AD-Domain-Services'

if ($AD.InstallState -eq 'Available') {
    Write-Host "[+]El Rol de Directorio Activo est� disponible para instalar"
    Write-Host "[+]Instalado los Servicios de Dominio de Active Directory"
    Write-Host "[!]El proceso de instalaci�n puede tardar unos minutos..."
    Install-WindowsFeature -Name 'AD-Domain-Services' -IncludeManagementTools > $null
    $AD = Get-WindowsFeature -Name 'AD-Domain-Services'
    
    if ($AD.InstallState -eq 'Installed') {
        Write-Host "�La instalaci�n del Rol de AD se ha realizado con �xito!"
        Write-Host $separador
        Comprueba-Bosque
    } else {
        Write-Host "[!]Ha habido un error durante la instalaci�n del Rol de AD"
    }

} else {
    Write-Host "[*]El Rol de Directorio Activo ya est� instalado"
    Comprueba-Bosque
}

$ErrorActionPreference = 'Continue'
$ProgressPreference = 'Continue'
$WarningPreference = 'Continue'

