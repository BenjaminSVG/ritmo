<#
Prepara los archivos de descarga en dist\ a partir de las compilaciones de release:
  dist\ritmo-android.apk   (flutter build apk --release)
  dist\ritmo-windows.zip   (flutter build windows --release, con las DLL de Visual C++ y un LEEME)

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\empaquetar.ps1
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot
$dist = Join-Path $root 'dist'
New-Item -ItemType Directory -Force $dist | Out-Null

Copy-Item (Join-Path $root 'app\build\app\outputs\flutter-apk\app-release.apk') (Join-Path $dist 'ritmo-android.apk') -Force

$stage = Join-Path $dist 'ritmo-windows'
if (Test-Path $stage) { Remove-Item $stage -Recurse -Force }
New-Item -ItemType Directory -Force $stage | Out-Null
Copy-Item (Join-Path $root 'app\build\windows\x64\runner\Release\*') $stage -Recurse -Force
# Bibliotecas de Visual C++ junto al programa (así no hace falta instalar nada aparte).
foreach ($d in 'msvcp140.dll', 'vcruntime140.dll', 'vcruntime140_1.dll') {
  $p = Join-Path $env:WINDIR "System32\$d"
  if (Test-Path $p) { Copy-Item $p $stage -Force }
}
Set-Content (Join-Path $stage 'LEEME.txt') ("Ritmo (Windows)`r`n`r`nAbre ritmo.exe. Si SmartScreen avisa, pulsa 'Mas informacion' y luego 'Ejecutar de todas formas': la app aun no esta firmada.`r`nCodigo y licencias: https://github.com/BenjaminSVG/ritmo") -Encoding ASCII

$zip = Join-Path $dist 'ritmo-windows.zip'
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -CompressionLevel Optimal
Remove-Item $stage -Recurse -Force

Get-ChildItem $dist | ForEach-Object { '{0}  {1:N1} MB' -f $_.Name, ($_.Length / 1MB) }
