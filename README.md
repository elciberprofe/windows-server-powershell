# WINDOWS SERVER POWERSHELL

<p>Proyecto destinado a <strong>FINES EDUCATIVOS</storng></p>

## Instalación y Ejecución

1. Clonar el repositorio
```sh
  git clone https://github.com/elciberprofe/powershell-scripts.git
  ```
2. Abrir el terminal de PowerShell como Administrador y acceder a la carpeta con todos los scripts
```sh
  cd 'C:\Users\Administrador\Desktop\windows-server-powershell'
  ```
  
3. Habilitar la ejecución de Scripts en PowerShell
```sh
  Set-ExecutionPolicy Unrestricted
  ```

4. Ejecutar los scripts para la automatización de la instalación de Windows Server
```sh
  .\NombreEquipo.ps1
  ```

## 1. SCRIPT (NombreEquipo.ps1)

<p>Script que automatiza el cambio del nombre del equipo servidor y realiza un reinicio.</p>

## 2. SCRIPT (ModificarIP.ps1)

<p>Script que automatiza la asignación de una IP estática al servidor.</p>

## 3. SCRIPT (ActiveDirectory.ps1)

<p>Automatiza la instalación del rol Directorio Activo y la promoción a Controlador de Dominio.</p>

## 4. SCRIPT (EstructuraOU.ps1)

<p>Automatiza la importación de una estructura de Unidades Organizativas a partir de un fichero Excel.</p>

## 5. SCRIPT (ImportarUsuarios.ps1)

<p>Automatiza la importación de Usuarios y sus fotos de perfil a partir de un fichero Excel.</p>

## 6. SCRIPT (Informes.ps1)

<p>Exporta información de Usuarios y Equipos en ficheros CSV y HTML.</p>