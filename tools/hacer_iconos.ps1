<#
Genera todos los iconos de la app a partir del logo elegido (el brote con check).

Entradas (carpeta -Origen, salida de ChatGPT):
  02-app-icon-sprout.png             icono cuadrado completo, fondo azul
  04-adaptive-foreground-sprout.png  solo el símbolo sobre magenta #FF00FF
  06-notification-icon-sprout.png    silueta blanca sobre magenta #FF00FF

Salidas (dentro de app\):
  Android: mipmap-*\ic_launcher.png y ic_launcher_round.png, mipmap-*\ic_launcher_foreground.png,
           mipmap-anydpi-v26\ic_launcher*.xml, values\ic_launcher_background.xml, drawable-*\ic_stat_ritmo.png
  Windows: windows\runner\resources\app_icon.ico
  Web:     web\favicon.png, web\icons\Icon-*.png

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\hacer_iconos.ps1 -Origen "ruta\a\ritmo_brand_metronome_6"
#>
param(
  [Parameter(Mandatory)] [string]$Origen,
  [string]$App = 'app',
  [string]$Fondo = '4F6AF5'
)
Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = 'Stop'
$Origen = (Resolve-Path $Origen).Path
$App = (Resolve-Path $App).Path

function Load($name) {
  $src = [System.Drawing.Bitmap]::FromFile((Join-Path $Origen $name))
  $b = New-Object System.Drawing.Bitmap $src.Width, $src.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($b); $g.DrawImage($src, 0, 0, $src.Width, $src.Height); $g.Dispose(); $src.Dispose()
  return $b
}

# Quita el magenta de fondo (con margen, porque la imagen tiene algo de ruido).
function ClearMagenta($b, [bool]$white) {
  for ($y = 0; $y -lt $b.Height; $y++) { for ($x = 0; $x -lt $b.Width; $x++) {
    $c = $b.GetPixel($x, $y)
    $dist = (255 - $c.R) + $c.G + (255 - $c.B)
    if ($dist -lt 180) { $b.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0)) }
    elseif ($white) { $b.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(255, 255, 255, 255)) }
  } }
}

function BBox($b) {
  $x0 = $b.Width; $y0 = $b.Height; $x1 = -1; $y1 = -1
  for ($y = 0; $y -lt $b.Height; $y++) { for ($x = 0; $x -lt $b.Width; $x++) {
    if ($b.GetPixel($x, $y).A -gt 0) { if ($x -lt $x0) { $x0 = $x }; if ($x -gt $x1) { $x1 = $x }; if ($y -lt $y0) { $y0 = $y }; if ($y -gt $y1) { $y1 = $y } }
  } }
  return @($x0, $y0, ($x1 - $x0 + 1), ($y1 - $y0 + 1))
}

function Resize($b, $size) {
  $o = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($o)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.DrawImage($b, 0, 0, $size, $size); $g.Dispose(); return $o
}

# Pone el símbolo (ya recortado) centrado en un lienzo transparente, ocupando [frac] del lado.
function Place($sym, $bb, $size, $frac) {
  $crop = $sym.Clone((New-Object System.Drawing.Rectangle $bb[0], $bb[1], $bb[2], $bb[3]), $sym.PixelFormat)
  $k = ($size * $frac) / [Math]::Max($bb[2], $bb[3])
  $w = [int][Math]::Round($bb[2] * $k); $h = [int][Math]::Round($bb[3] * $k)
  $o = New-Object System.Drawing.Bitmap $size, $size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($o)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.DrawImage($crop, [int](($size - $w) / 2), [int](($size - $h) / 2), $w, $h); $g.Dispose(); $crop.Dispose()
  return $o
}

function Circle($b) {
  $o = New-Object System.Drawing.Bitmap $b.Width, $b.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($o)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath; $path.AddEllipse(0, 0, $b.Width - 1, $b.Height - 1)
  $g.SetClip($path); $g.DrawImage($b, 0, 0, $b.Width, $b.Height); $g.Dispose(); return $o
}

function SavePng($b, $path) { New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null; $b.Save($path, [System.Drawing.Imaging.ImageFormat]::Png) }

$full = Load '02-app-icon-sprout.png'
$fg = Load '04-adaptive-foreground-sprout.png'; ClearMagenta $fg $false; $fgBox = BBox $fg
$nt = Load '06-notification-icon-sprout.png'; ClearMagenta $nt $true; $ntBox = BBox $nt

$res = "$App\android\app\src\main\res"
$dens = @{ 'mdpi' = 1.0; 'hdpi' = 1.5; 'xhdpi' = 2.0; 'xxhdpi' = 3.0; 'xxxhdpi' = 4.0 }
foreach ($d in $dens.Keys) {
  $m = $dens[$d]
  $l = Resize $full ([int](48 * $m)); SavePng $l "$res\mipmap-$d\ic_launcher.png"
  $r = Circle $l; SavePng $r "$res\mipmap-$d\ic_launcher_round.png"
  # Primer plano del icono adaptable: lienzo de 108 dp; el símbolo dentro de la zona segura (~61 %).
  $f = Place $fg $fgBox ([int](108 * $m)) 0.56; SavePng $f "$res\mipmap-$d\ic_launcher_foreground.png"
  $n = Place $nt $ntBox ([int](24 * $m)) 0.86; SavePng $n "$res\drawable-$d\ic_stat_ritmo.png"
}
New-Item -ItemType Directory -Force "$res\mipmap-anydpi-v26", "$res\values" | Out-Null
$adaptive = @'
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@color/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
'@
Set-Content "$res\mipmap-anydpi-v26\ic_launcher.xml" $adaptive -Encoding UTF8
Set-Content "$res\mipmap-anydpi-v26\ic_launcher_round.xml" $adaptive -Encoding UTF8
Set-Content "$res\values\ic_launcher_background.xml" "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<resources>`n    <color name=`"ic_launcher_background`">#$Fondo</color>`n</resources>" -Encoding UTF8

# Web
SavePng (Resize $full 32) "$App\web\favicon.png"
SavePng (Resize $full 192) "$App\web\icons\Icon-192.png"
SavePng (Resize $full 512) "$App\web\icons\Icon-512.png"
SavePng (Resize $full 192) "$App\web\icons\Icon-maskable-192.png"
SavePng (Resize $full 512) "$App\web\icons\Icon-maskable-512.png"

# Windows: .ico con varios tamaños (cada uno como PNG dentro del .ico)
$sizes = 16, 24, 32, 48, 64, 128, 256
$pngs = foreach ($s in $sizes) { $ms = New-Object System.IO.MemoryStream; (Resize $full $s).Save($ms, [System.Drawing.Imaging.ImageFormat]::Png); ,$ms.ToArray() }
$out = New-Object System.IO.MemoryStream; $bw = New-Object System.IO.BinaryWriter $out
$bw.Write([uint16]0); $bw.Write([uint16]1); $bw.Write([uint16]$sizes.Count)
$offset = 6 + 16 * $sizes.Count
for ($i = 0; $i -lt $sizes.Count; $i++) {
  $s = $sizes[$i]; $wh = if ($s -ge 256) { 0 } else { $s }
  $bw.Write([byte]$wh); $bw.Write([byte]$wh); $bw.Write([byte]0); $bw.Write([byte]0)
  $bw.Write([uint16]1); $bw.Write([uint16]32); $bw.Write([uint32]$pngs[$i].Length); $bw.Write([uint32]$offset)
  $offset += $pngs[$i].Length
}
foreach ($p in $pngs) { $bw.Write($p) }
[System.IO.File]::WriteAllBytes("$App\windows\runner\resources\app_icon.ico", $out.ToArray())

# Copia del logo elegido dentro del proyecto
$dest = (Join-Path (Split-Path $App) 'referencias\logo'); New-Item -ItemType Directory -Force $dest | Out-Null
foreach ($f in '02-app-icon-sprout.png', '04-adaptive-foreground-sprout.png', '05-ritmo-wordmark.png', '06-notification-icon-sprout.png') { Copy-Item (Join-Path $Origen $f) $dest -Force }
Write-Host 'Iconos generados.'
