<#
Limpia los 8 estilos de ojos (con cejas) generados con ChatGPT y los deja en app\assets\pixel\eyes\.
También separa la boca de los ojos originales: filas 0-37 = ojos (ojos_clasicos_N), filas 38 en adelante =
sonrisa (mouth\sonrisa_N), porque los estilos nuevos no traen boca.

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\procesar_ojos.ps1 -Origen "ruta\capas_cara_cabello_45\A-eyes-eyebrows"
#>
param(
  [Parameter(Mandatory)] [string]$Origen,
  [string]$Bases = 'referencias\arte\originales',
  [string]$Limpio = 'referencias\arte\limpio\ojos_estilos',
  [string]$Assets = 'app\assets\pixel'
)
Add-Type -AssemblyName System.Drawing
$Origen = (Resolve-Path $Origen).Path
$ref = (Resolve-Path "$Bases\A-medium-man-bald-faceless-base.png").Path
$r = [System.Drawing.Image]::FromFile($ref); $rw = $r.Width; $rh = $r.Height; $r.Dispose()
New-Item -ItemType Directory -Force $Limpio, "$Assets\eyes", "$Assets\mouth" | Out-Null

$styles = [ordered]@{
  'A01-big-round.png' = 'grandes'; 'A02-sleepy.png' = 'sonolientos'; 'A03-happy.png' = 'felices'
  'A04-almond.png' = 'almendrados'; 'A05-dots.png' = 'puntitos'; 'A06-sparkle.png' = 'brillantes'
  'A07-sweet.png' = 'dulces'; 'A08-determined.png' = 'decididos'
}
foreach ($k in $styles.Keys) {
  $id = $styles[$k]
  # Algunas hojas miden 1 píxel más o menos que la de referencia: se ajustan al mismo tamaño.
  $s = [System.Drawing.Image]::FromFile("$Origen\$k")
  $b = New-Object System.Drawing.Bitmap $rw, $rh
  $g = [System.Drawing.Graphics]::FromImage($b); $g.InterpolationMode = 'NearestNeighbor'; $g.DrawImage($s, 0, 0, $rw, $rh); $g.Dispose(); $s.Dispose()
  $tmp = Join-Path $env:TEMP "ojos_$id.png"; $b.Save($tmp); $b.Dispose()
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\limpiar_sprites.ps1 -In $tmp -RefSheet $ref -Frames 5 -W 64 -H 96 -Headroom 12 `
    -Colors '2B2340,4F6AF5,3446B8,FFF8F0' -Out "$Limpio\$id" -Prefix $id -Preview 4 | Select-Object -Last 1
  for ($i = 0; $i -lt 5; $i++) { Copy-Item "$Limpio\$id\${id}_$i.png" "$Assets\eyes\${id}_$i.png" -Force }
}

# Separar ojos y boca de los ojos originales
for ($i = 0; $i -lt 5; $i++) {
  $src = [System.Drawing.Bitmap]::FromFile((Resolve-Path "$Assets\eyes\ojos_1_$i.png").Path)
  $eyes = New-Object System.Drawing.Bitmap 64, 96, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $mouth = New-Object System.Drawing.Bitmap 64, 96, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  for ($y = 0; $y -lt 96; $y++) { for ($x = 0; $x -lt 64; $x++) {
    $c = $src.GetPixel($x, $y)
    if ($c.A -gt 0) { if ($y -lt 38) { $eyes.SetPixel($x, $y, $c) } else { $mouth.SetPixel($x, $y, $c) } }
  } }
  $eyes.Save((Join-Path (Resolve-Path "$Assets\eyes").Path "clasicos_$i.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $mouth.Save((Join-Path (Resolve-Path "$Assets\mouth").Path "sonrisa_$i.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $src.Dispose(); $eyes.Dispose(); $mouth.Dispose()
}
Write-Host 'Ojos y boca listos.'
