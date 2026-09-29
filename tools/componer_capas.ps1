<#
Superpone capas de sprites ya limpias (salida de limpiar_sprites.ps1) sobre un cuerpo base
y guarda un PNG por fotograma y una tira de vista previa ampliada (vecino más cercano).

Uso:
  powershell -File tools\componer_capas.ps1 -Layers "ruta\base_hombre_a\base_hombre_a", "ruta\pantalon\pantalon", ... -Frames 5 -Out salida -Prefix look

Cada elemento de -Layers es "carpeta\prefijo" (se leen prefijo_0.png, prefijo_1.png, ...).
El PRIMERO es el cuerpo base; el resto se apila en el orden dado (de abajo hacia arriba).
#>
param(
  [Parameter(Mandatory)] [string[]]$Layers,
  [int]$Frames = 5,
  [Parameter(Mandatory)] [string]$Out,
  [string]$Prefix = "look",
  [int]$Scale = 6
)
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Out | Out-Null

# Con "powershell -File", varias rutas separadas por comas llegan como un solo texto.
$Layers = @($Layers | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })

$first = [System.Drawing.Bitmap]::FromFile((Resolve-Path ($Layers[0] + "_0.png")).Path)
$w = $first.Width; $h = $first.Height; $first.Dispose()
$gap = 8
$strip = New-Object System.Drawing.Bitmap ($w * $Scale * $Frames + $gap * ($Frames - 1)), ($h * $Scale)
$sg = [System.Drawing.Graphics]::FromImage($strip)
$sg.Clear([System.Drawing.Color]::FromArgb(255, 240, 240, 245))
$sg.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::NearestNeighbor
$sg.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::Half

for ($f = 0; $f -lt $Frames; $f++) {
  $canvas = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $cg = [System.Drawing.Graphics]::FromImage($canvas)
  foreach ($l in $Layers) {
    $img = [System.Drawing.Bitmap]::FromFile((Resolve-Path ("{0}_{1}.png" -f $l, $f)).Path)
    $cg.DrawImage($img, 0, 0, $w, $h)
    $img.Dispose()
  }
  $cg.Dispose()
  $canvas.Save((Join-Path $Out ("{0}_{1}.png" -f $Prefix, $f)), [System.Drawing.Imaging.ImageFormat]::Png)
  $sg.DrawImage($canvas, ($f * ($w * $Scale + $gap)), 0, ($w * $Scale), ($h * $Scale))
  $canvas.Dispose()
}
$sg.Dispose()
$strip.Save((Join-Path $Out ($Prefix + "_vista_previa.png")), [System.Drawing.Imaging.ImageFormat]::Png)
$strip.Dispose()
"Listo: $Out"
