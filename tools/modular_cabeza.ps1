<#
Separa cabeza y cuerpo para que UNA cabeza estándar (con su pelo, ojos y gorros) sirva a varios cuerpos.

Para cada cuerpo (ya limpio a 64x96) y cada nivel:
  1. detecta el cuello (la fila más estrecha bajo las orejas),
  2. guarda el cuerpo "del cuello para abajo",
  3. calcula el ANCLAJE de la cabeza respecto al cuerpo de referencia (dx, dy),
y luego compone una prueba: cuerpo + cabeza estándar + ojos + pelo desplazados por su anclaje.

Uso:
  powershell -File tools\modular_cabeza.ps1 -Limpio referencias\arte\limpio -Cuerpos base_hombre_a,base_hombre_b,base_mujer_a,base_mujer_b `
     -CapasA referencias\arte\limpio\capas_A -Out referencias\arte\limpio\modular
El primer cuerpo de la lista es la referencia: de él se toma la cabeza estándar.
#>
param(
  [Parameter(Mandatory)] [string]$Limpio,
  [Parameter(Mandatory)] [string[]]$Cuerpos,
  [Parameter(Mandatory)] [string]$CapasA,
  [Parameter(Mandatory)] [string]$Out,
  [int]$Frames = 5,
  [int]$Zoom = 4
)
$Cuerpos = @($Cuerpos | ForEach-Object { $_ -split ',' } | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })

Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;
using System.Text;

public static class Modular
{
    // { yTop, rn (fila del cuello), minX, maxX de la cabeza, r1 (fila de las orejas) }
    static int[] Analyze(Bitmap b)
    {
        int W = b.Width, H = b.Height;
        int[] mn = new int[H], mx = new int[H];
        int yTop = -1, yBot = -1;
        for (int y = 0; y < H; y++)
        {
            mn[y] = W; mx[y] = -1;
            for (int x = 0; x < W; x++)
                if (b.GetPixel(x, y).A > 0) { if (x < mn[y]) mn[y] = x; if (x > mx[y]) mx[y] = x; }
            if (mx[y] >= 0) { if (yTop < 0) yTop = y; yBot = y; }
        }
        int total = yBot - yTop + 1;
        int[] wd = new int[H];
        for (int y = 0; y < H; y++) wd[y] = mx[y] < 0 ? 0 : mx[y] - mn[y] + 1;

        int zoneEnd = yTop + (int)(0.30 * total);
        int r1 = yTop;
        for (int y = yTop; y <= zoneEnd; y++) if (wd[y] > wd[r1]) r1 = y;

        int lim = Math.Min(yBot, r1 + (int)(0.25 * total));
        int rn = r1 + 2, best = int.MaxValue;
        for (int y = r1 + 2; y <= lim; y++) if (wd[y] < best) { best = wd[y]; rn = y; }

        int hmin = W, hmax = -1;
        for (int y = yTop; y < rn; y++) { if (mn[y] < hmin) hmin = mn[y]; if (mx[y] > hmax) hmax = mx[y]; }
        return new int[] { yTop, rn, hmin, hmax, r1 };
    }

    static Bitmap Load(string p)
    {
        Bitmap src = new Bitmap(p);
        Bitmap b = new Bitmap(src.Width, src.Height, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(b)) g.DrawImage(src, 0, 0, src.Width, src.Height);
        src.Dispose();
        return b;
    }

    static Bitmap Slice(Bitmap b, int fromRow, int toRowExclusive)
    {
        Bitmap o = new Bitmap(b.Width, b.Height, PixelFormat.Format32bppArgb);
        for (int y = fromRow; y < toRowExclusive; y++)
            for (int x = 0; x < b.Width; x++) o.SetPixel(x, y, b.GetPixel(x, y));
        return o;
    }

    public static void Run(string limpio, string[] cuerpos, string capasA, string outDir, int frames, int zoom)
    {
        Directory.CreateDirectory(outDir);
        int nb = cuerpos.Length;
        int[][][] an = new int[nb][][];
        Bitmap[][] bodies = new Bitmap[nb][];
        StringBuilder json = new StringBuilder("{\n");

        for (int c = 0; c < nb; c++)
        {
            an[c] = new int[frames][];
            bodies[c] = new Bitmap[frames];
            for (int f = 0; f < frames; f++)
            {
                Bitmap b = Load(Path.Combine(limpio, cuerpos[c], cuerpos[c] + "_" + f + ".png"));
                an[c][f] = Analyze(b);
                Console.WriteLine(cuerpos[c] + " nivel " + f + ": arriba=" + an[c][f][0] + " orejas=" + an[c][f][4] + " cuello=" + an[c][f][1] + " cabeza x " + an[c][f][2] + ".." + an[c][f][3]);
                string d = Path.Combine(outDir, cuerpos[c]);
                Directory.CreateDirectory(d);
                Bitmap neck = Slice(b, an[c][f][1], b.Height);         // cuerpo del cuello para abajo
                neck.Save(Path.Combine(d, cuerpos[c] + "_cuerpo_" + f + ".png"), ImageFormat.Png);
                bodies[c][f] = neck;
                if (c == 0)
                {
                    Bitmap head = Slice(b, 0, an[0][f][1]);            // cabeza estándar (del cuerpo de referencia)
                    head.Save(Path.Combine(outDir, "cabeza_estandar_" + f + ".png"), ImageFormat.Png);
                    head.Dispose();
                }
                b.Dispose();
            }
        }

        // Anclajes de la cabeza respecto al cuerpo de referencia (mismo nivel)
        for (int c = 0; c < nb; c++)
        {
            json.Append("  \"" + cuerpos[c] + "\": [");
            for (int f = 0; f < frames; f++)
            {
                int dy = an[c][f][1] - an[0][f][1];
                int dx = (int)Math.Round(((an[c][f][2] + an[c][f][3]) - (an[0][f][2] + an[0][f][3])) / 2.0);
                json.Append("{\"dx\":" + dx + ",\"dy\":" + dy + "}" + (f < frames - 1 ? "," : ""));
            }
            json.Append("]" + (c < nb - 1 ? "," : "") + "\n");
        }
        json.Append("}\n");
        File.WriteAllText(Path.Combine(outDir, "anclajes_cabeza.json"), json.ToString(), new UTF8Encoding(false));

        // Prueba: cuerpo + cabeza estándar + ojos + pelo, desplazados por el anclaje
        int W = 64, H = 96, gap = 8;
        Bitmap grid = new Bitmap(frames * W * zoom + (frames - 1) * gap, nb * H * zoom + (nb - 1) * gap, PixelFormat.Format32bppArgb);
        using (Graphics gg = Graphics.FromImage(grid))
        {
            gg.Clear(Color.FromArgb(255, 240, 240, 245));
            gg.InterpolationMode = InterpolationMode.NearestNeighbor;
            gg.PixelOffsetMode = PixelOffsetMode.Half;
            for (int c = 0; c < nb; c++)
                for (int f = 0; f < frames; f++)
                {
                    int dy = an[c][f][1] - an[0][f][1];
                    int dx = (int)Math.Round(((an[c][f][2] + an[c][f][3]) - (an[0][f][2] + an[0][f][3])) / 2.0);
                    Bitmap cell = new Bitmap(W, H, PixelFormat.Format32bppArgb);
                    using (Graphics cg = Graphics.FromImage(cell))
                    {
                        cg.DrawImage(bodies[c][f], 0, 0, W, H);
                        string[] headLayers = new string[] {
                            Path.Combine(outDir, "cabeza_estandar_" + f + ".png"),
                            Path.Combine(capasA, "ojos", "ojos_" + f + ".png"),
                            Path.Combine(capasA, "pelo", "pelo_" + f + ".png") };
                        foreach (string hl in headLayers)
                        {
                            if (!File.Exists(hl)) continue;
                            Bitmap li = Load(hl);
                            cg.DrawImage(li, dx, dy, W, H);
                            li.Dispose();
                        }
                    }
                    gg.DrawImage(cell, f * (W * zoom + gap), c * (H * zoom + gap), W * zoom, H * zoom);
                    cell.Save(Path.Combine(outDir, cuerpos[c], cuerpos[c] + "_vestido_" + f + ".png"), ImageFormat.Png);
                    cell.Dispose();
                }
        }
        grid.Save(Path.Combine(outDir, "prueba_modular.png"), ImageFormat.Png);
        grid.Dispose();
    }
}
"@

[Modular]::Run((Resolve-Path $Limpio).Path, [string[]]$Cuerpos, (Resolve-Path $CapasA).Path, (New-Item -ItemType Directory -Force $Out).FullName, $Frames, $Zoom)
"Listo: $Out"
