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

#1.6 Importar los usuarios en el Directorio Activo a partir de un fichero Excel o CSV
$ErrorActionPreference = 'SilentlyContinue'
$ProgressPreference = 'SilentlyContinue'
$WarningPreference = 'SilentlyContinue'
$separador = "-"*50

$usuarios = Import-Csv -Path '.\Usuarios.csv' -Delimiter ';' -Encoding Default
$dominio = Get-ADDomain | Select -ExpandProperty DNSRoot
$dn = Get-ADDomain | Select -ExpandProperty DistinguishedName

$usuariosImportados = 0
$usuariosNoImportados = 0
$usuariosNoHabilitados = 0

foreach ($usuario in $usuarios) {
    Write-Host $separador
    $nombre = $usuario.Nombre
    $apellidos = $usuario.Apellidos
    $iniciales = $usuario.Iniciales
    $nombreUsuario = $usuario.Usuario
    $contrasena = $usuario.Contrasena
    $correo = $usuario.Correo
    $direccion = $usuario.Direccion
    $codigo = $usuario.CodigoPostal
    $ciudad = $usuario.Ciudad
    $provincia = $usuario.Provincia
    $pais = $usuario.Pais
    $departamento = $usuario.Departamento
    $telefono = $usuario.Telefono
    $posicion = $usuario.PuestoTrabajo
    $empresa = $usuario.Empresa
    $imagen = $usuario.Imagen
    $descripcion = $usuario.Descripcion

    if (Get-ADUser -Filter "SamAccountName -like '$nombreUsuario'") {
        Write-Host "[!]El usuario $nombreUsuario que está intentando importar ya existe en la base de datos"
        $usuariosNoImportados++
        #Remove-ADUser -Identity $nombreUsuario -Confirm:$false
    } else {
        $contrasenaSegura = ConvertTo-SecureString $contrasena -AsPlainText -Force
        New-ADUser -GivenName $nombre `
                   -Surname $apellidos `
                   -Name "$nombre $apellidos" `
                   -DisplayName "$apellidos, $nombre" `
                   -Initials $iniciales `
                   -UserPrincipalName "$nombreUsuario@$dominio" `
                   -SamAccountName $nombreUsuario `
                   -AccountPassword $contrasenaSegura `
                   -ChangePasswordAtLogon $true `
                   -EmailAddress $correo `
                   -StreetAddress $direccion `
                   -PostalCode $codigo `
                   -City $ciudad `
                   -State $provincia `
                   -Country $pais `
                   -Department $departamento `
                   -OfficePhone $telefono `
                   -Company $empresa `
                   -Title $posicion `
                   -Description $descripcion `
                   -Path "OU=$departamento,OU=$ciudad,$dn" `
                   -Enabled $true `

        if ($compruebaUsuario = Get-ADUser -Filter "SamAccountName -like '$nombreUsuario'") {
            if ($compruebaUsuario.Enabled -eq 'True') {
                Write-Host "[++]El usuario: $nombre $apellidos ($nombreUsuario) se ha creado correctamente"
            } else {
                Write-Host "[!!]El usuario: $nombre $apellidos ($nombreUsuario) se ha creado pero la cuenta está inhabilitada"
                $usuariosNoHabilitados++
            }

            Write-Host "[+]Se ha asignado a la Unidad Organizativa de $ciudad : $departamento"

            $foto = [byte[]](Get-Content ".\imgUsuarios\$nombreUsuario.jpg" -Encoding byte)
            Set-ADUser $nombreUsuario -Replace @{thumbnailPhoto=$foto}

            Write-Host "[+]Se ha asignado una foto de perfil para el usuario: $nombreUsuario"
            $usuariosImportados++
        } else {
            $usuariosNoImportados++
            "[!]ERROR: No se ha podido crear el usuario $nombre $apellidos ($nombreUsuario)"
        }
    }
}

$totalUsuarios = $usuariosImportados + $usuariosNoImportados

Write-Host $separador
Write-Host "El fichero de importación contenía un total de $totalUsuarios usuarios"
Write-Host "Se han importado correctamente un total de $usuariosImportados usuarios"
Write-Host "No se han podido habilitar la cuenta de $usuariosNoHabilitados usuarios"
Write-Host "No se han podido importar un total de $usuariosNoImportados usuarios"


$ErrorActionPreference = 'Continue'
$ProgressPreference = 'Continue'
$WarningPreference = 'Continue'