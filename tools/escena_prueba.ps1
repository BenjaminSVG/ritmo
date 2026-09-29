<#
Prueba de escena: reduce un fondo generado por IA (p. ej. 1774x887) a 384x192, lo ajusta a la
paleta de Ritmo y coloca encima un personaje de 64x96 (centrado, con los pies a 16 px del borde).

Uso:
  powershell -File tools\escena_prueba.ps1 -Fondo fondo.png -Personaje look_a_2.png -Out carpeta
#>
param(
  [Parameter(Mandatory)] [string]$Fondo,
  [Parameter(Mandatory)] [string]$Personaje,
  [Parameter(Mandatory)] [string]$Out,
  [int]$W = 384,
  [int]$H = 192,
  [int]$Zoom = 4,
  [switch]$SinPaleta
)
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Out | Out-Null

$hex = "2B2340,4A3F6B,8C84A8,C9C4DB,FFF8F0,FF8FAB,D65A7E,F0686A,FFAA6B,FFD866,B8E986,5CC28A,2F8F6B,6ED3D0,7EC8F5,4F6AF5,3446B8,B69CF2,7C5FCF,A9714B,6E4530,FFC533,C98A1E,FFA3A3,E8B77F,D39A62,A87445" -split ','
$pal = @($hex | ForEach-Object { ,@([Convert]::ToInt32($_.Substring(0,2),16), [Convert]::ToInt32($_.Substring(2,2),16), [Convert]::ToInt32($_.Substring(4,2),16)) })

$src = [System.Drawing.Bitmap]::FromFile((Resolve-Path $Fondo).Path)
$sm = New-Object System.Drawing.Bitmap $W, $H
$g = [System.Drawing.Graphics]::FromImage($sm)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($src, 0, 0, $W, $H)
$g.Dispose(); $src.Dispose()

$bg = New-Object System.Drawing.Bitmap $W, $H
for ($y = 0; $y -lt $H; $y++) {
  for ($x = 0; $x -lt $W; $x++) {
    $c = $sm.GetPixel($x, $y)
    if ($SinPaleta) { $bg.SetPixel($x, $y, $c); continue }
    $best = 0; $bd = [long]::MaxValue
    for ($i = 0; $i -lt $pal.Count; $i++) {
      $dr = $c.R - $pal[$i][0]; $dg = $c.G - $pal[$i][1]; $db = $c.B - $pal[$i][2]
      $d = $dr*$dr + $dg*$dg + $db*$db
      if ($d -lt $bd) { $bd = $d; $best = $i }
    }
    $bg.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, $pal[$best][0], $pal[$best][1], $pal[$best][2]))
  }
}
$sm.Dispose()
$bg.Save((Join-Path $Out "fondo_limpio.png"), [System.Drawing.Imaging.ImageFormat]::Png)

$ch = [System.Drawing.Bitmap]::FromFile((Resolve-Path $Personaje).Path)
$scene = New-Object System.Drawing.Bitmap $W, $H
$sg = [System.Drawing.Graphics]::FromImage($scene)
$sg.DrawImage($bg, 0, 0, $W, $H)
$sg.DrawImage($ch, [int](($W - $ch.Width) / 2), ($H - 16 - $ch.Height), $ch.Width, $ch.Height)
$sg.Dispose()
$scene.Save((Join-Path $Out "escena.png"), [System.Drawing.Imaging.ImageFormat]::Png)

$big = New-Object System.Drawing.Bitmap ($W * $Zoom), ($H * $Zoom)
$bx = [System.Drawing.Graphics]::FromImage($big)
$bx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$bx.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half
$bx.DrawImage($scene, 0, 0, ($W * $Zoom), ($H * $Zoom))
$bx.Dispose()
$big.Save((Join-Path $Out "escena_ampliada.png"), [System.Drawing.Imaging.ImageFormat]::Png)
$big.Dispose(); $scene.Dispose(); $ch.Dispose(); $bg.Dispose()
"Listo: $Out"
