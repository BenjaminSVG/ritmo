<#
ChatGPT a veces dibuja las zapatillas unos píxeles más arriba que los pies (pasa sobre todo con los cuerpos
anchos). Este script sube o baja cada capa de zapatillas para que su borde inferior coincida con el de los
pies del cuerpo base, nivel por nivel, y las guarda en la carpeta de salida.

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\alinear_calzado.ps1
#>
param(
  [string]$Limpio = 'referencias\arte\limpio',
  [string]$Salida = 'app\assets\pixel\items\zapatillas'
)
Add-Type -AssemblyName System.Drawing
$Limpio = (Resolve-Path $Limpio).Path
New-Item -ItemType Directory -Force $Salida | Out-Null
$Salida = (Resolve-Path $Salida).Path

function Bottom($b) {
  for ($y = $b.Height - 1; $y -ge 0; $y--) { for ($x = 0; $x -lt $b.Width; $x++) { if ($b.GetPixel($x, $y).A -gt 0) { return $y } } }
  return -1
}
function Load($p) {
  $s = [System.Drawing.Bitmap]::FromFile($p)
  $b = New-Object System.Drawing.Bitmap $s.Width, $s.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($b); $g.DrawImage($s, 0, 0, $s.Width, $s.Height); $g.Dispose(); $s.Dispose(); return $b
}

foreach ($body in 'hombre_a', 'hombre_b', 'mujer_a', 'mujer_b') {
  for ($lvl = 0; $lvl -lt 5; $lvl++) {
    $base = Load "$Limpio\base_$body\base_${body}_$lvl.png"
    $shoe = Load "$Limpio\ropa\zapatillas\${body}_$lvl.png"
    $dy = (Bottom $base) - (Bottom $shoe)
    $o = New-Object System.Drawing.Bitmap $shoe.Width, $shoe.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    for ($y = 0; $y -lt $shoe.Height; $y++) {
      $ny = $y + $dy
      if ($ny -lt 0 -or $ny -ge $shoe.Height) { continue }
      for ($x = 0; $x -lt $shoe.Width; $x++) { $c = $shoe.GetPixel($x, $y); if ($c.A -gt 0) { $o.SetPixel($x, $ny, $c) } }
    }
    $o.Save("$Salida\${body}_$lvl.png", [System.Drawing.Imaging.ImageFormat]::Png)
    Write-Host "$body nivel $lvl : desplazamiento $dy"
    $base.Dispose(); $shoe.Dispose(); $o.Dispose()
  }
}
