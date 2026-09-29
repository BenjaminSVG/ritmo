<#
Limpia de una vez las 36 capas de ropa y accesorios generadas con ChatGPT (carpeta capas_ropa_36).

Salida en referencias\arte\limpio\ropa\:
  - accesorios de cabeza y anteojos:  {id}\{id}_0..4.png              (sobre la cabeza estándar)
  - ropa por cuerpo:                  {id}\{cuerpo}_0..4.png            (cuerpo = hombre_a, hombre_b, mujer_a, mujer_b)

Uso (desde C:\dev\ritmo):
  powershell -ExecutionPolicy Bypass -File tools\procesar_ropa.ps1
#>
param(
  [string]$Origen = 'referencias\arte\originales\capas_ropa_36',
  [string]$Salida = 'referencias\arte\limpio\ropa',
  [string]$Bases = 'referencias\arte\originales'
)
$rosa = '2B2340,FF8FAB,D65A7E'

# carpeta, archivo, id, colores
$refA = "$Bases\A-medium-man-bald-faceless-base.png"
$jobs = @(
  @('A-head-accessories', 'A01-beanie-layer.png',      'gorro_lana',          $rosa),
  @('A-head-accessories', 'A02-bucket-hat-layer.png',  'sombrero_pescador',   "$rosa,FFF8F0"),
  @('A-head-accessories', 'A03-cat-ears-layer.png',    'orejas_gato',         $rosa),
  @('A-head-accessories', 'A04-straw-hat-layer.png',   'sombrero_paja',       "$rosa,FFD866,E0A83A"),
  @('A-head-accessories', 'A05-wizard-hat-layer.png',  'sombrero_mago',       "$rosa,FFD866"),
  @('A-head-accessories', 'A06-flower-crown-layer.png','corona_flores',       "$rosa,FFF8F0,5CC28A,2F8F6B"),
  @('A-head-accessories', 'A07-hair-bow-layer.png',    'mono_pelo',           $rosa),
  @('A-head-accessories', 'A08-sport-headband-layer.png','cinta_deportiva',   "$rosa,FFF8F0"),
  @('B-glasses', 'B01-square-glasses-layer.png',       'anteojos_cuadrados',  '2B2340,FFF8F0'),
  @('B-glasses', 'B02-cat-eye-glasses-layer.png',      'anteojos_ojo_gato',   '2B2340,FFF8F0'),
  @('B-glasses', 'B03-hexagonal-glasses-layer.png',    'anteojos_hexagonales','2B2340,FFF8F0'),
  @('B-glasses', 'B04-half-rim-glasses-layer.png',     'anteojos_medio_marco','2B2340,FFF8F0')
)
foreach ($j in $jobs) {
  Write-Host "== $($j[2])"
  powershell -NoProfile -ExecutionPolicy Bypass -File tools\limpiar_sprites.ps1 -In "$Origen\$($j[0])\$($j[1])" -RefSheet $refA `
    -Frames 5 -W 64 -H 96 -Headroom 12 -Colors $j[3] -Out "$Salida\$($j[2])" -Prefix $j[2] -Preview 4 | Select-Object -Last 1
}

# Ropa por cuerpo: carpeta, letra del archivo, cuerpo, hoja base
$bodies = @(
  @('C-medium-man-clothes', 'C', 'hombre_a', 'A-medium-man-bald-faceless-base.png'),
  @('D-broad-man-clothes',  'D', 'hombre_b', 'B-broad-man-bald-faceless-base.png'),
  @('E-medium-woman-clothes','E','mujer_a',  'C-medium-woman-bald-faceless-base.png'),
  @('F-curvy-woman-clothes','F', 'mujer_b',  'D-curvy-woman-bald-faceless-base.png')
)
$clothes = @(
  @('01-t-shirt-layer.png', 'camiseta', $rosa),
  @('02-hoodie-layer.png',  'buzo',     $rosa),
  @('03-pants-layer.png',   'pantalon', $rosa),
  @('04-shorts-layer.png',  'short',    $rosa),
  @('05-sneakers-layer.png','zapatillas', "$rosa,FFF8F0"),
  @('06-skirt-layer.png',   'pollera',  $rosa),
  @('07-dress-layer.png',   'vestido',  $rosa)
)
foreach ($b in $bodies) {
  foreach ($c in $clothes) {
    $src = "$Origen\$($b[0])\$($b[1])$($c[0])"
    if (-not (Test-Path $src)) { continue }   # pollera y vestido solo existen para las mujeres
    Write-Host "== $($c[1]) / $($b[2])"
    powershell -NoProfile -ExecutionPolicy Bypass -File tools\limpiar_sprites.ps1 -In $src -RefSheet "$Bases\$($b[3])" `
      -Frames 5 -W 64 -H 96 -Headroom 12 -Colors $c[2] -Out "$Salida\$($c[1])" -Prefix $b[2] -Preview 4 | Select-Object -Last 1
  }
}
Write-Host 'Listo'
