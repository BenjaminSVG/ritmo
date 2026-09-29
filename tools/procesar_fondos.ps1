<#
Reduce los fondos de ChatGPT (2:1) a 384x192 y los guarda en app\assets\pixel\bg\ con nombre estable.

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\procesar_fondos.ps1 -Origen "ruta\background_scenes_12"
#>
param(
  [Parameter(Mandatory)] [string]$Origen,
  [string]$Salida = 'app\assets\pixel\bg'
)
Add-Type -AssemblyName System.Drawing
$Origen = (Resolve-Path $Origen).Path
New-Item -ItemType Directory -Force $Salida | Out-Null
$map = [ordered]@{
  '01-gym.png' = 'gimnasio'; '02-park.png' = 'parque'; '03-beach.png' = 'playa'; '04-forest.png' = 'bosque'
  '05-night-city-rooftop.png' = 'azotea'; '06-library.png' = 'biblioteca'; '07-kitchen.png' = 'cocina'
  '08-snowy-cabin.png' = 'cabana'; '09-space-station.png' = 'estacion'; '10-japanese-garden.png' = 'jardin'
  '11-cafe.png' = 'cafe'; '12-desert-oasis.png' = 'oasis'
}
foreach ($k in $map.Keys) {
  $src = [System.Drawing.Bitmap]::FromFile((Join-Path $Origen $k))
  $o = New-Object System.Drawing.Bitmap 384, 192, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($o)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.DrawImage($src, 0, 0, 384, 192); $g.Dispose(); $src.Dispose()
  $o.Save((Join-Path (Resolve-Path $Salida).Path "$($map[$k]).png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $o.Dispose()
  Write-Host "$k -> $($map[$k]).png"
}
