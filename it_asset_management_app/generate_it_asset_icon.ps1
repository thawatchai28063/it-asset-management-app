Add-Type -AssemblyName System.Drawing
function New-ItAssetIcon($path, $size) {
  $bmp = New-Object System.Drawing.Bitmap $size, $size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $rect = New-Object System.Drawing.Rectangle 0,0,$size,$size
  $bg = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.Color]::FromArgb(20,68,160)), ([System.Drawing.Color]::FromArgb(37,180,166)), 45
  $g.FillRectangle($bg, $rect)

  $pad = [int]($size * 0.16)
  $monitorX = [int]($size * 0.20)
  $monitorY = [int]($size * 0.22)
  $monitorW = [int]($size * 0.60)
  $monitorH = [int]($size * 0.38)
  $radius = [int]($size * 0.05)

  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(245,255,255,255))
  $screen = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,232,246,255))
  $dark = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,23,53,112))
  $accent = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,255,205,72))
  $penWhite = New-Object System.Drawing.Pen ([System.Drawing.Color]::White), ([Math]::Max(2, [int]($size * 0.035)))

  $g.FillRoundedRectangle($white, $monitorX, $monitorY, $monitorW, $monitorH, $radius)
  $innerPad = [int]($size * 0.045)
  $g.FillRoundedRectangle($screen, $monitorX + $innerPad, $monitorY + $innerPad, $monitorW - 2*$innerPad, $monitorH - 2*$innerPad, [int]($radius*0.65))

  $standW = [int]($size * 0.18)
  $standH = [int]($size * 0.08)
  $standX = [int](($size - $standW) / 2)
  $standY = $monitorY + $monitorH
  $g.FillRectangle($white, $standX, $standY, $standW, $standH)
  $baseW = [int]($size * 0.36)
  $baseH = [int]($size * 0.055)
  $baseX = [int](($size - $baseW) / 2)
  $baseY = $standY + $standH
  $g.FillRoundedRectangle($white, $baseX, $baseY, $baseW, $baseH, [int]($size*0.025))

  $tagW = [int]($size * 0.33)
  $tagH = [int]($size * 0.18)
  $tagX = [int]($size * 0.50)
  $tagY = [int]($size * 0.58)
  $g.FillRoundedRectangle($accent, $tagX, $tagY, $tagW, $tagH, [int]($size*0.04))
  $hole = [int]($size*0.035)
  $g.FillEllipse($dark, $tagX + [int]($size*0.035), $tagY + [int]($size*0.055), $hole, $hole)
  $fontSize = [Math]::Max(8, [int]($size * 0.09))
  $font = New-Object System.Drawing.Font 'Arial', $fontSize, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
  $g.DrawString('IT', $font, $dark, ($tagX + [int]($size*0.12)), ($tagY + [int]($size*0.045)))

  $boxX = [int]($size * 0.18)
  $boxY = [int]($size * 0.62)
  $boxW = [int]($size * 0.24)
  $boxH = [int]($size * 0.18)
  $g.DrawRectangle($penWhite, $boxX, $boxY, $boxW, $boxH)
  $g.DrawLine($penWhite, $boxX, $boxY, $boxX + [int]($boxW/2), $boxY - [int]($size*0.06))
  $g.DrawLine($penWhite, $boxX + $boxW, $boxY, $boxX + [int]($boxW/2), $boxY - [int]($size*0.06))
  $g.DrawLine($penWhite, $boxX + [int]($boxW/2), $boxY - [int]($size*0.06), $boxX + [int]($boxW/2), $boxY + $boxH)

  $dir = Split-Path $path
  if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose(); $bmp.Dispose()
}

$sizes = @{
  'android/app/src/main/res/mipmap-mdpi/ic_launcher.png' = 48
  'android/app/src/main/res/mipmap-hdpi/ic_launcher.png' = 72
  'android/app/src/main/res/mipmap-xhdpi/ic_launcher.png' = 96
  'android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png' = 144
  'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png' = 192
  'web/icons/Icon-192.png' = 192
  'web/icons/Icon-maskable-192.png' = 192
  'web/icons/Icon-512.png' = 512
  'web/icons/Icon-maskable-512.png' = 512
  'web/favicon.png' = 32
}
foreach ($entry in $sizes.GetEnumerator()) { New-ItAssetIcon $entry.Key $entry.Value }
