<#
Limpia una hoja de sprites generada por IA (varios personajes en fila sobre fondo magenta):
  1. quita el fondo magenta (#FF00FF),
  2. reduce cada personaje a un lienzo pequeño (p. ej. 48x64) promediando bloques,
  3. ajusta los colores a la paleta de Ritmo (opcional),
  4. guarda un PNG por personaje y una tira de vista previa ampliada.

Uso:
  powershell -File tools\limpiar_sprites.ps1 -In hoja.png -Frames 5 -W 48 -H 64 -Out salida -Prefix cuerpo

Todos los personajes de la hoja usan la MISMA escala y se alinean por los pies y el centro,
para que las capas (ropa, pelo) encajen entre niveles.
#>
param(
  [Parameter(Mandatory)] [string]$In,
  [int]$Frames = 5,
  [int]$W = 48,
  [int]$H = 64,
  [Parameter(Mandatory)] [string]$Out,
  [string]$Prefix = "sprite",
  [int]$Margin = 1,
  [int]$Preview = 8,
  [string]$RefSheet = "",   # hoja de referencia (cuerpo base) para alinear capas sueltas
  [int]$Headroom = 0,       # píxeles libres arriba (pelo alto, gorros); usar el MISMO valor en cuerpo y capas
  [string]$Colors = "",     # colores permitidos, p. ej. "2B2340,FF8FAB,D65A7E" (aplana la pieza a esos colores)
  [switch]$NoPalette
)

Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;

public static class SpriteClean
{
    static bool IsBg(byte r, byte g, byte b) { return r > 170 && b > 150 && g < 120; }

    static int[] Box(bool[] bg, byte[] px, int w, int x0, int x1, int y0, int y1)
    {
        int minX = int.MaxValue, minY = int.MaxValue, maxX = -1, maxY = -1;
        for (int y = y0; y < y1; y++)
            for (int x = x0; x < x1; x++)
                if (!bg[y * w + x]) { if (x < minX) minX = x; if (x > maxX) maxX = x; if (y < minY) minY = y; if (y > maxY) maxY = y; }
        return new int[] { minX, minY, maxX, maxY };
    }

    // Busca 'frames' bloques de columnas con figura, separados por columnas de fondo.
    static bool Segment(bool[] bg, int w, int h, int frames, int[] xs, int[] xe)
    {
        bool[] has = new bool[w];
        for (int x = 0; x < w; x++)
        {
            int c = 0;
            for (int y = 0; y < h; y++) if (!bg[y * w + x]) c++;
            has[x] = c >= 4; // ignora ruido suelto del fondo
        }
        List<int[]> runs = new List<int[]>();
        int start = -1;
        for (int x = 0; x <= w; x++)
        {
            bool v = x < w && has[x];
            if (v && start < 0) start = x;
            if (!v && start >= 0) { runs.Add(new int[] { start, x }); start = -1; }
        }
        List<int[]> merged = new List<int[]>();
        foreach (int[] r in runs)
        {
            if (merged.Count > 0 && r[0] - merged[merged.Count - 1][1] < 6) merged[merged.Count - 1][1] = r[1];
            else merged.Add(new int[] { r[0], r[1] });
        }
        if (merged.Count != frames) return false;
        for (int f = 0; f < frames; f++) { xs[f] = merged[f][0]; xe[f] = merged[f][1]; }
        return true;
    }

    static void Load(string path, out int w, out int h, out byte[] rgb, out bool[] bg)
    {
        Bitmap src = new Bitmap(path);
        w = src.Width; h = src.Height;
        Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(bmp)) g.DrawImage(src, 0, 0, w, h);
        src.Dispose();

        BitmapData d = bmp.LockBits(new Rectangle(0, 0, w, h), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        byte[] px = new byte[d.Stride * h];
        System.Runtime.InteropServices.Marshal.Copy(d.Scan0, px, 0, px.Length);
        int stride = d.Stride;
        bmp.UnlockBits(d);
        bmp.Dispose();

        // Copia compacta RGB y máscara de fondo
        rgb = new byte[w * h * 3];
        bg = new bool[w * h];
        for (int y = 0; y < h; y++)
            for (int x = 0; x < w; x++)
            {
                int s = y * stride + x * 4;
                byte b = px[s], gr = px[s + 1], r = px[s + 2];
                int i = y * w + x;
                rgb[i * 3] = r; rgb[i * 3 + 1] = gr; rgb[i * 3 + 2] = b;
                bg[i] = IsBg(r, gr, b);
            }
    }

    public static void Run(string input, int frames, int W, int H, string outDir, string prefix,
                           int margin, int preview, int[][] palette, string refPath, int headroom)
    {
        Directory.CreateDirectory(outDir);
        int w, h; byte[] rgb; bool[] bg;
        Load(input, out w, out h, out rgb, out bg);

        // Modo "referencia": la escala, la separación y el anclaje salen de OTRA hoja (el
        // cuerpo base), no de esta (una capa suelta, como solo el pelo). Así la capa cae en
        // el mismo sitio que en el cuerpo. Ambas hojas deben tener el mismo tamaño.
        bool[] refBg = bg;
        if (!string.IsNullOrEmpty(refPath))
        {
            int rw, rh; byte[] rrgb;
            Load(refPath, out rw, out rh, out rrgb, out refBg);
            if (rw != w || rh != h) throw new Exception("La hoja de referencia debe tener el mismo tamaño que la de entrada.");
        }

        // Separa los personajes por los huecos de fondo (los brazos anchos pueden pasar
        // de una porción igual). Si no se detectan exactamente 'frames' personajes,
        // se divide la imagen en partes iguales.
        int[] xs = new int[frames], xe = new int[frames];
        bool byGaps = Segment(refBg, w, h, frames, xs, xe);
        if (!byGaps)
        {
            int fw0 = w / frames;
            for (int f = 0; f < frames; f++) { xs[f] = f * fw0; xe[f] = (f + 1) * fw0; }
        }
        Console.WriteLine("Separación de personajes: " + (byGaps ? "por huecos de fondo" : "en partes iguales (no se detectaron " + frames + " figuras separadas)"));
        int[][] boxes = new int[frames][];
        for (int f = 0; f < frames; f++) boxes[f] = Box(refBg, rgb, w, xs[f], xe[f], 0, h);

        // Escala común a partir del primer personaje (sin aura)
        double refH = boxes[0][3] - boxes[0][1] + 1;
        double refW = boxes[0][2] - boxes[0][0] + 1;
        // 'headroom' deja espacio libre arriba para pelo alto, gorros y coronas.
        double scale = Math.Min((H - 2.0 * margin - headroom) / refH, (W - 2.0 * margin) / refW);
        double block = 1.0 / scale; // píxeles de origen por píxel de destino

        Bitmap strip = new Bitmap(W * preview * frames + (frames - 1) * 8, H * preview, PixelFormat.Format32bppArgb);
        using (Graphics sg = Graphics.FromImage(strip)) sg.Clear(Color.FromArgb(255, 240, 240, 245));

        for (int f = 0; f < frames; f++)
        {
            int[] bx = boxes[f];
            double cx = (bx[0] + bx[2]) / 2.0;
            double bottom = bx[3] + 1;
            Bitmap o = new Bitmap(W, H, PixelFormat.Format32bppArgb);
            for (int ty = 0; ty < H; ty++)
                for (int tx = 0; tx < W; tx++)
                {
                    // Origen del bloque de origen que corresponde a este píxel de destino
                    double sx0 = cx + (tx - W / 2.0) * block;
                    double sy0 = bottom + (ty - (H - margin)) * block;
                    int ix0 = (int)Math.Floor(sx0), iy0 = (int)Math.Floor(sy0);
                    int ix1 = (int)Math.Ceiling(sx0 + block), iy1 = (int)Math.Ceiling(sy0 + block);
                    int cnt = 0, opaque = 0; double sr = 0, sg2 = 0, sb = 0;
                    for (int yy = iy0; yy < iy1; yy++)
                        for (int xx = ix0; xx < ix1; xx++)
                        {
                            cnt++;
                            if (xx < xs[f] || xx >= xe[f] || yy < 0 || yy >= h) continue;
                            int i = yy * w + xx;
                            if (bg[i]) continue;
                            opaque++; sr += rgb[i * 3]; sg2 += rgb[i * 3 + 1]; sb += rgb[i * 3 + 2];
                        }
                    if (cnt == 0 || opaque * 2 < cnt) { o.SetPixel(tx, ty, Color.FromArgb(0, 0, 0, 0)); continue; }
                    int R = (int)(sr / opaque), G = (int)(sg2 / opaque), B = (int)(sb / opaque);
                    if (palette != null && palette.Length > 0)
                    {
                        int best = 0; long bd = long.MaxValue;
                        for (int p = 0; p < palette.Length; p++)
                        {
                            long dr = R - palette[p][0], dg = G - palette[p][1], db = B - palette[p][2];
                            long dist = dr * dr + dg * dg + db * db;
                            if (dist < bd) { bd = dist; best = p; }
                        }
                        R = palette[best][0]; G = palette[best][1]; B = palette[best][2];
                    }
                    o.SetPixel(tx, ty, Color.FromArgb(255, R, G, B));
                }
            o.Save(Path.Combine(outDir, prefix + "_" + f + ".png"), ImageFormat.Png);

            // Vista previa ampliada con vecino más cercano
            int ox = f * (W * preview + 8);
            for (int ty = 0; ty < H; ty++)
                for (int tx = 0; tx < W; tx++)
                {
                    Color c = o.GetPixel(tx, ty);
                    if (c.A == 0) continue;
                    for (int dy = 0; dy < preview; dy++)
                        for (int dx = 0; dx < preview; dx++)
                            strip.SetPixel(ox + tx * preview + dx, ty * preview + dy, c);
                }
            o.Dispose();
        }
        strip.Save(Path.Combine(outDir, prefix + "_vista_previa.png"), ImageFormat.Png);
        strip.Dispose();
    }
}
"@

# Paleta Ritmo (24) + tono de piel de dibujo (Dorado) + gris neutro de la ropa interior
$hex = @("2B2340","4A3F6B","8C84A8","C9C4DB","FFF8F0","FF8FAB","D65A7E","F0686A","FFAA6B","FFD866","B8E986","5CC28A","2F8F6B","6ED3D0","7EC8F5","4F6AF5","3446B8","B69CF2","7C5FCF","A9714B","6E4530","FFC533","C98A1E","FFA3A3","E8B77F","D39A62","A87445")
if ($Colors -ne "") { $hex = @($Colors -split ',' | ForEach-Object { $_.Trim().TrimStart('#') } | Where-Object { $_ -ne '' }) }
$pal = $null
if (-not $NoPalette) {
  $pal = [int[][]]@($hex | ForEach-Object { ,@([Convert]::ToInt32($_.Substring(0,2),16), [Convert]::ToInt32($_.Substring(2,2),16), [Convert]::ToInt32($_.Substring(4,2),16)) })
}
$ref = ""
if ($RefSheet -ne "") { $ref = (Resolve-Path $RefSheet).Path }
[SpriteClean]::Run((Resolve-Path $In).Path, $Frames, $W, $H, $Out, $Prefix, $Margin, $Preview, $pal, $ref, $Headroom)
"Listo: $Out"
