@echo off
setlocal EnableExtensions
title Codex Starfield - Theme Menu
color 0B

:language
cls
echo.
echo  +----------------------------------------------+
echo  ^|          CODEX STARFIELD - LANGUAGE          ^|
echo  +----------------------------------------------+
echo  ^|  [1] English                                ^|
echo  ^|  [2] Turkce                                 ^|
echo  +----------------------------------------------+
echo.
choice /c 12 /n /m "Language / Dil: "
if errorlevel 2 (set "CODEX_LANG=TR") else set "CODEX_LANG=EN"
goto menu

:menu
cls
if "%CODEX_LANG%"=="TR" goto menu_tr
:menu_en
echo.
echo  +--------------------------------------------------+
echo  ^|             CODEX STARFIELD THEMES                ^|
echo  +--------------------------------------------------+
echo  ^|  [1] Starlight          [2] Rain on glass         ^|
echo  ^|  [3] Aurora             [4] Purple nebula        ^|
echo  ^|  [5] Meteor shower      [6] Deep ocean           ^|
echo  ^|  [7] Sunset             [8] Cyberpunk            ^|
echo  ^|  [9] Golden dust        [C] Custom theme         ^|
echo  ^|  [0] Exit                                         ^|
echo  +--------------------------------------------------+
echo.
goto choose

:menu_tr
echo.
echo  +--------------------------------------------------+
echo  ^|             CODEX YILDIZ TEMALARI                 ^|
echo  +--------------------------------------------------+
echo  ^|  [1] Yildiz Isigi        [2] Yagmurlu Cam         ^|
echo  ^|  [3] Kuzey Isiklari      [4] Mor Nebula           ^|
echo  ^|  [5] Meteor Yagmuru      [6] Derin Okyanus        ^|
echo  ^|  [7] Gun Batimi          [8] Cyberpunk            ^|
echo  ^|  [9] Altin Tozu          [C] Ozel tema            ^|
echo  ^|  [0] Cikis                                         ^|
echo  +--------------------------------------------------+
echo.

:choose
choice /c 123456789C0 /n /m "> "
if errorlevel 11 exit /b 0
if errorlevel 10 goto custom
if errorlevel 9 (set "CODEX_THEME=gold"&goto launch)
if errorlevel 8 (set "CODEX_THEME=cyberpunk"&goto launch)
if errorlevel 7 (set "CODEX_THEME=sunset"&goto launch)
if errorlevel 6 (set "CODEX_THEME=ocean"&goto launch)
if errorlevel 5 (set "CODEX_THEME=meteor"&goto launch)
if errorlevel 4 (set "CODEX_THEME=nebula"&goto launch)
if errorlevel 3 (set "CODEX_THEME=aurora"&goto launch)
if errorlevel 2 (set "CODEX_THEME=rain"&goto launch)
set "CODEX_THEME=stars"
goto launch

:custom
cls
if "%CODEX_LANG%"=="TR" goto custom_tr
:custom_en
echo.
echo  +--------------------------------------------------+
echo  ^|                  CUSTOM STAR THEME                ^|
echo  +--------------------------------------------------+
echo  Enter 6-digit HEX colors such as A8D8FF.
echo.
set /p "CODEX_CUSTOM_STAR=Star color [A8D8FF]: "
if not defined CODEX_CUSTOM_STAR set "CODEX_CUSTOM_STAR=A8D8FF"
set /p "CODEX_CUSTOM_GLOW=Glow color [5367D5]: "
if not defined CODEX_CUSTOM_GLOW set "CODEX_CUSTOM_GLOW=5367D5"
set /p "CODEX_CUSTOM_DENSITY=Star count 30-300 [150]: "
if not defined CODEX_CUSTOM_DENSITY set "CODEX_CUSTOM_DENSITY=150"
echo.
choice /c 12 /n /m "[1] Add rain  [2] No rain: "
if errorlevel 2 (set "CODEX_CUSTOM_RAIN=0") else set "CODEX_CUSTOM_RAIN=1"
choice /c 12 /n /m "[1] Shooting stars  [2] None: "
if errorlevel 2 (set "CODEX_CUSTOM_METEOR=0") else set "CODEX_CUSTOM_METEOR=1"
goto custom_launch

:custom_tr
echo.
echo  +--------------------------------------------------+
echo  ^|                  OZEL YILDIZ TEMASI               ^|
echo  +--------------------------------------------------+
echo  6 haneli HEX renk gir. Ornek: A8D8FF

echo.
set /p "CODEX_CUSTOM_STAR=Yildiz rengi [A8D8FF]: "
if not defined CODEX_CUSTOM_STAR set "CODEX_CUSTOM_STAR=A8D8FF"
set /p "CODEX_CUSTOM_GLOW=Parilti rengi [5367D5]: "
if not defined CODEX_CUSTOM_GLOW set "CODEX_CUSTOM_GLOW=5367D5"
set /p "CODEX_CUSTOM_DENSITY=Yildiz sayisi 30-300 [150]: "
if not defined CODEX_CUSTOM_DENSITY set "CODEX_CUSTOM_DENSITY=150"
echo.
choice /c 12 /n /m "[1] Yagmur ekle  [2] Yagmur yok: "
if errorlevel 2 (set "CODEX_CUSTOM_RAIN=0") else set "CODEX_CUSTOM_RAIN=1"
choice /c 12 /n /m "[1] Kayan yildiz  [2] Yok: "
if errorlevel 2 (set "CODEX_CUSTOM_METEOR=0") else set "CODEX_CUSTOM_METEOR=1"

:custom_launch
set "CODEX_THEME=custom"

:launch
set "CODEX_BAT=%~f0"
if "%CODEX_LANG%"=="TR" echo Tema baslatiliyor. CMD penceresi kucultulecek.
if "%CODEX_LANG%"=="EN" echo Starting theme. The CMD window will minimize.
echo.
powershell.exe -NoLogo -NoProfile -STA -ExecutionPolicy Bypass -Command "$raw = [System.IO.File]::ReadAllText($env:CODEX_BAT); $marker = '::CODEX_PS_PAYLOAD_BEGIN::'; $start = $raw.LastIndexOf($marker); if ($start -lt 0) { exit 1 }; $body = $raw.Substring($start + $marker.Length); & ([scriptblock]::Create($body)) -Theme $env:CODEX_THEME"
set "EXIT_CODE=%ERRORLEVEL%"
if not "%EXIT_CODE%"=="0" (
  if "%CODEX_LANG%"=="TR" (echo Efekt hata ile durdu.) else echo The effect stopped with an error.
  pause
)
exit /b %EXIT_CODE%
::CODEX_PS_PAYLOAD_BEGIN::
param(
    [ValidateSet('stars','rain','aurora','nebula','meteor','ocean','sunset','cyberpunk','gold','custom')]
    [string]$Theme = 'stars'
)

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class CodexOverlayNative {
    [StructLayout(LayoutKind.Sequential)] public struct RECT { public int Left, Top, Right, Bottom; }
    [DllImport("user32.dll")] public static extern IntPtr GetForegroundWindow();
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hwnd, int command);
    [DllImport("user32.dll")] public static extern IntPtr GetAncestor(IntPtr hwnd, uint flags);
    [DllImport("user32.dll", SetLastError=true)] public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);
    [DllImport("user32.dll", SetLastError=true)] public static extern bool SetWindowPos(IntPtr hwnd, IntPtr insertAfter, int x, int y, int cx, int cy, uint flags);
    [DllImport("user32.dll", EntryPoint="GetWindowLongPtrW", SetLastError=true)] public static extern IntPtr GetWindowLongPtr(IntPtr hwnd, int index);
    [DllImport("user32.dll", EntryPoint="SetWindowLongPtrW", SetLastError=true)] public static extern IntPtr SetWindowLongPtr(IntPtr hwnd, int index, IntPtr value);
    public const uint GA_ROOT = 2;
    public const int GWL_EXSTYLE = -20;
    public const long WS_EX_TRANSPARENT = 0x00000020L;
    public const long WS_EX_TOOLWINDOW = 0x00000080L;
    public const long WS_EX_NOACTIVATE = 0x08000000L;
    public static readonly IntPtr HWND_TOPMOST = new IntPtr(-1);
    public const uint SWP_NOACTIVATE = 0x0010;
    public const uint SWP_SHOWWINDOW = 0x0040;
    public const int SW_MINIMIZE = 6;
}
"@

$presets = @{
 stars = @{ A=@(212,231,255); B=@(160,220,255); Rain=@(150,205,255); Drop=@(120,185,245); G1=@(64,116,220); G2=@(58,135,190); G3=@(104,78,190); Stars=150; Streaks=0; Drops=0; MeteorMin=6; MeteorMax=14; MeteorOn=$true }
 rain = @{ A=@(190,220,255); B=@(135,190,245); Rain=@(165,215,255); Drop=@(120,180,235); G1=@(45,95,155); G2=@(60,125,175); G3=@(70,80,150); Stars=0; Streaks=62; Drops=30; MeteorMin=0; MeteorMax=0; MeteorOn=$false }
 aurora = @{ A=@(200,255,232); B=@(120,245,205); Rain=@(110,235,205); Drop=@(90,210,190); G1=@(35,175,135); G2=@(55,145,190); G3=@(95,95,180); Stars=118; Streaks=0; Drops=0; MeteorMin=7; MeteorMax=14; MeteorOn=$true }
 nebula = @{ A=@(235,202,255); B=@(175,155,255); Rain=@(210,150,255); Drop=@(175,125,235); G1=@(125,55,190); G2=@(75,65,185); G3=@(180,65,155); Stars=180; Streaks=0; Drops=0; MeteorMin=5; MeteorMax=12; MeteorOn=$true }
 meteor = @{ A=@(225,242,255); B=@(155,215,255); Rain=@(170,220,255); Drop=@(120,190,255); G1=@(65,115,205); G2=@(60,90,170); G3=@(105,75,190); Stars=100; Streaks=0; Drops=0; MeteorMin=1; MeteorMax=3; MeteorOn=$true }
 ocean = @{ A=@(185,248,255); B=@(90,210,235); Rain=@(100,225,240); Drop=@(80,205,230); G1=@(30,145,175); G2=@(35,115,165); G3=@(40,90,155); Stars=95; Streaks=24; Drops=36; MeteorMin=8; MeteorMax=15; MeteorOn=$true }
 sunset = @{ A=@(255,228,190); B=@(255,165,125); Rain=@(255,190,145); Drop=@(245,160,130); G1=@(210,105,70); G2=@(170,65,115); G3=@(220,155,70); Stars=130; Streaks=0; Drops=0; MeteorMin=6; MeteorMax=14; MeteorOn=$true }
 cyberpunk = @{ A=@(255,190,245); B=@(105,225,255); Rain=@(255,95,220); Drop=@(95,205,255); G1=@(210,35,165); G2=@(35,125,220); G3=@(135,50,205); Stars=110; Streaks=48; Drops=14; MeteorMin=4; MeteorMax=9; MeteorOn=$true }
 gold = @{ A=@(255,239,185); B=@(255,195,105); Rain=@(255,210,130); Drop=@(235,175,85); G1=@(205,145,45); G2=@(170,95,35); G3=@(225,175,70); Stars=135; Streaks=0; Drops=0; MeteorMin=7; MeteorMax=15; MeteorOn=$true }
}
if ($Theme -eq 'custom') {
    $starHex=($env:CODEX_CUSTOM_STAR -replace '^#','');$glowHex=($env:CODEX_CUSTOM_GLOW -replace '^#','')
    if($starHex -notmatch '^[0-9a-fA-F]{6}$'){$starHex='A8D8FF'}
    if($glowHex -notmatch '^[0-9a-fA-F]{6}$'){$glowHex='5367D5'}
    $starRgb=@([Convert]::ToInt32($starHex.Substring(0,2),16),[Convert]::ToInt32($starHex.Substring(2,2),16),[Convert]::ToInt32($starHex.Substring(4,2),16))
    $glowRgb=@([Convert]::ToInt32($glowHex.Substring(0,2),16),[Convert]::ToInt32($glowHex.Substring(2,2),16),[Convert]::ToInt32($glowHex.Substring(4,2),16))
    try{$starCount=[int]$env:CODEX_CUSTOM_DENSITY}catch{$starCount=150};if($starCount -lt 30 -or $starCount -gt 300){$starCount=150}
    $addRain=$env:CODEX_CUSTOM_RAIN -eq '1';$addMeteor=$env:CODEX_CUSTOM_METEOR -eq '1'
    $streakCount=if($addRain){38}else{0};$dropCount=if($addRain){16}else{0}
    $script:cfg=@{A=$starRgb;B=$starRgb;Rain=$starRgb;Drop=$starRgb;G1=$glowRgb;G2=$glowRgb;G3=$glowRgb;Stars=$starCount;Streaks=$streakCount;Drops=$dropCount;MeteorMin=5;MeteorMax=12;MeteorOn=$addMeteor}
} else {
    $script:cfg=$presets[$Theme]
}
$script:theme = $Theme
$script:rng = [System.Random]::new()
$script:items = [System.Collections.Generic.List[object]]::new()
$script:handle = [IntPtr]::Zero
$script:lastW = 0.0; $script:lastH = 0.0; $script:elapsed = 0.0
$script:meteor = $null; $script:nextMeteor = 0.0

$window = New-Object System.Windows.Window
$window.Title = 'Codex Starfield'
$window.WindowStyle = [System.Windows.WindowStyle]::None
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.AllowsTransparency = $true
$window.Background = [System.Windows.Media.Brushes]::Transparent
$window.ShowInTaskbar = $false
$window.ShowActivated = $false
$window.Topmost = $true
$window.IsHitTestVisible = $false
$window.Focusable = $false
$canvas = New-Object System.Windows.Controls.Canvas
$canvas.Background = [System.Windows.Media.Brushes]::Transparent
$window.Content = $canvas

function ColorFromRgb($rgb) { return [System.Windows.Media.Color]::FromRgb([byte]$rgb[0],[byte]$rgb[1],[byte]$rgb[2]) }
function Add-Particle($shape,$x,$y,$kind,$speed,$data) {
    [System.Windows.Controls.Canvas]::SetLeft($shape,$x); [System.Windows.Controls.Canvas]::SetTop($shape,$y)
    [void]$canvas.Children.Add($shape)
    $script:items.Add([pscustomobject]@{ Shape=$shape; X=$x; Y=$y; Kind=$kind; Speed=$speed; Data=$data })
}
function New-Star($w,$h) {
    $size=0.8+$script:rng.NextDouble()*1.8
    $shape=New-Object System.Windows.Shapes.Ellipse
    $shape.Width=$size; $shape.Height=$size
    $rgb=if($script:rng.NextDouble() -lt 0.7){$script:cfg.A}else{$script:cfg.B}
    $shape.Fill=New-Object System.Windows.Media.SolidColorBrush (ColorFromRgb $rgb)
    $shape.Opacity=0.10+$script:rng.NextDouble()*0.24
    $shape.Tag=$shape.Opacity
    Add-Particle $shape ($script:rng.NextDouble()*$w) ($script:rng.NextDouble()*$h) 'star' (0.02+$script:rng.NextDouble()*0.10) ($script:rng.NextDouble()*6.28)
}
function New-Rain($w,$h) {
    $length=16+$script:rng.NextDouble()*42
    $shape=New-Object System.Windows.Shapes.Rectangle
    $shape.Width=0.8+$script:rng.NextDouble()*0.8; $shape.Height=$length
    $brush=New-Object System.Windows.Media.LinearGradientBrush
    $brush.StartPoint=[System.Windows.Point]::new(0.5,0); $brush.EndPoint=[System.Windows.Point]::new(0.5,1)
    $rgb=$script:cfg.Rain
    $brush.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,$rgb[0],$rgb[1],$rgb[2]),0.0))
    $brush.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(95,$rgb[0],$rgb[1],$rgb[2]),0.45))
    $brush.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,$rgb[0],$rgb[1],$rgb[2]),1.0))
    $shape.Fill=$brush; $shape.Opacity=0.22
    $edge=[Math]::Max(48,$w*0.105); $side=if($script:rng.NextDouble() -lt 0.5){'left'}else{'right'}
    $x=if($side -eq 'left'){$script:rng.NextDouble()*$edge}else{$w-$edge+$script:rng.NextDouble()*$edge}
    Add-Particle $shape $x ($script:rng.NextDouble()*$h) 'rain' (0.35+$script:rng.NextDouble()*0.85) @{Length=$length;Side=$side}
}
function New-Drop($w,$h) {
    $shape=New-Object System.Windows.Shapes.Ellipse
    $shape.Width=2.2+$script:rng.NextDouble()*3.8; $shape.Height=4+$script:rng.NextDouble()*8
    $rgb=$script:cfg.Drop; $fill=New-Object System.Windows.Media.RadialGradientBrush
    $fill.GradientOrigin=[System.Windows.Point]::new(0.28,0.2); $fill.Center=[System.Windows.Point]::new(0.5,0.5); $fill.RadiusX=0.7; $fill.RadiusY=0.7
    $fill.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(100,235,250,255),0.0))
    $fill.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(35,$rgb[0],$rgb[1],$rgb[2]),0.55))
    $fill.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,$rgb[0],$rgb[1],$rgb[2]),1.0))
    $shape.Fill=$fill; $shape.Opacity=0.27
    $edge=[Math]::Max(36,$w*0.075); $x=if($script:rng.NextDouble() -lt 0.5){$script:rng.NextDouble()*$edge}else{$w-$edge+$script:rng.NextDouble()*$edge}
    Add-Particle $shape $x ($script:rng.NextDouble()*$h) 'drop' (0.08+$script:rng.NextDouble()*0.28) @{H=$shape.Height;Drift=(-0.12+$script:rng.NextDouble()*0.24)}
}
function Reset-Scene($w,$h) {
    $canvas.Children.Clear(); $script:items.Clear(); $script:meteor=$null
    $spots=@(
      @{X=-0.18;Y=0.16;S=0.48;C=$script:cfg.G1},
      @{X=0.92;Y=0.82;S=0.42;C=$script:cfg.G2},
      @{X=0.78;Y=-0.24;S=0.30;C=$script:cfg.G3}
    )
    foreach($spot in $spots){
      $glow=New-Object System.Windows.Shapes.Ellipse; $glow.Width=$w*$spot.S; $glow.Height=$w*$spot.S
      $b=New-Object System.Windows.Media.RadialGradientBrush
      $b.GradientOrigin=[System.Windows.Point]::new(0.35,0.35); $b.Center=[System.Windows.Point]::new(0.5,0.5); $b.RadiusX=0.5; $b.RadiusY=0.5
      $c=ColorFromRgb $spot.C
      $b.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,$c.R,$c.G,$c.B),1.0))
      $b.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(38,$c.R,$c.G,$c.B),0.58))
      $b.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,$c.R,$c.G,$c.B),0.0))
      $glow.Fill=$b; [System.Windows.Controls.Canvas]::SetLeft($glow,$w*$spot.X); [System.Windows.Controls.Canvas]::SetTop($glow,$h*$spot.Y); [void]$canvas.Children.Add($glow)
    }
    for($i=0;$i -lt $script:cfg.Stars;$i++){New-Star $w $h}
    for($i=0;$i -lt $script:cfg.Streaks;$i++){New-Rain $w $h}
    for($i=0;$i -lt $script:cfg.Drops;$i++){New-Drop $w $h}
    $script:lastW=$w; $script:lastH=$h
    $script:nextMeteor=$script:elapsed+$script:cfg.MeteorMin+$script:rng.NextDouble()*[Math]::Max(0.1,($script:cfg.MeteorMax-$script:cfg.MeteorMin))
}

$window.add_SourceInitialized({
    $interop=[System.Windows.Interop.WindowInteropHelper]::new($window); $script:handle=$interop.Handle
    $style=[CodexOverlayNative]::GetWindowLongPtr($script:handle,[CodexOverlayNative]::GWL_EXSTYLE).ToInt64()
    $style=$style -bor [CodexOverlayNative]::WS_EX_TRANSPARENT -bor [CodexOverlayNative]::WS_EX_TOOLWINDOW -bor [CodexOverlayNative]::WS_EX_NOACTIVATE
    [void][CodexOverlayNative]::SetWindowLongPtr($script:handle,[CodexOverlayNative]::GWL_EXSTYLE,[IntPtr]::new($style))
    $console=[CodexOverlayNative]::GetConsoleWindow(); if($console -ne [IntPtr]::Zero){[void][CodexOverlayNative]::ShowWindow($console,[CodexOverlayNative]::SW_MINIMIZE)}
})
$timer=New-Object System.Windows.Threading.DispatcherTimer; $timer.Interval=[TimeSpan]::FromMilliseconds(33)
$timer.add_Tick({
    $script:elapsed+=0.033
    $app=Get-Process -Name ChatGPT -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowHandle -ne [IntPtr]::Zero} | Select-Object -First 1
    if($null -eq $app){if($window.IsVisible){$window.Hide()};return}
    $target=[IntPtr]$app.MainWindowHandle
    $front=[CodexOverlayNative]::GetAncestor([CodexOverlayNative]::GetForegroundWindow(),[CodexOverlayNative]::GA_ROOT)
    $root=[CodexOverlayNative]::GetAncestor($target,[CodexOverlayNative]::GA_ROOT)
    if($front -ne $root){if($window.IsVisible){$window.Hide()};return}
    $rect=New-Object CodexOverlayNative+RECT; if(-not [CodexOverlayNative]::GetWindowRect($target,[ref]$rect)){return}
    $w=[Math]::Max(1,$rect.Right-$rect.Left); $h=[Math]::Max(1,$rect.Bottom-$rect.Top)
    $window.Left=$rect.Left; $window.Top=$rect.Top; $window.Width=$w; $window.Height=$h; $canvas.Width=$w; $canvas.Height=$h
    if(-not $window.IsVisible){$window.Show()}
    [void][CodexOverlayNative]::SetWindowPos($script:handle,[CodexOverlayNative]::HWND_TOPMOST,$rect.Left,$rect.Top,$w,$h,[CodexOverlayNative]::SWP_NOACTIVATE -bor [CodexOverlayNative]::SWP_SHOWWINDOW)
    if([Math]::Abs($w-$script:lastW) -gt 2 -or [Math]::Abs($h-$script:lastH) -gt 2){Reset-Scene $w $h}
    foreach($p in $script:items){
      if($p.Kind -eq 'star'){$p.Data+=0.035; $p.Shape.Opacity=[double]$p.Shape.Tag*(0.72+0.28*[Math]::Sin($p.Data)); $p.Y-=$p.Speed; if($p.Y -lt 0){$p.Y=$h;$p.X=$script:rng.NextDouble()*$w}}
      elseif($p.Kind -eq 'rain'){$p.Y+=$p.Speed; if($p.Y -gt $h){$p.Y=-$p.Data.Length;$edge=[Math]::Max(48,$w*0.105); if($p.Data.Side -eq 'left'){$p.X=$script:rng.NextDouble()*$edge}else{$p.X=$w-$edge+$script:rng.NextDouble()*$edge}}}
      else{$p.Y+=$p.Speed;$p.X+=$p.Data.Drift;if($p.Y -gt $h){$p.Y=-$p.Data.H;$edge=[Math]::Max(36,$w*0.075);if($script:rng.NextDouble() -lt 0.5){$p.X=$script:rng.NextDouble()*$edge}else{$p.X=$w-$edge+$script:rng.NextDouble()*$edge}}}
      [System.Windows.Controls.Canvas]::SetLeft($p.Shape,$p.X);[System.Windows.Controls.Canvas]::SetTop($p.Shape,$p.Y)
    }
    if($script:cfg.MeteorOn){
      if($null -eq $script:meteor -and $script:elapsed -ge $script:nextMeteor){
        $line=New-Object System.Windows.Shapes.Line;$line.X1=0;$line.Y1=0;$line.X2=-65;$line.Y2=-18;$line.StrokeThickness=1.3
        $tb=New-Object System.Windows.Media.LinearGradientBrush;$tb.StartPoint=[System.Windows.Point]::new(1,0);$tb.EndPoint=[System.Windows.Point]::new(0,0)
        $tb.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0,210,232,255),0.0));$tb.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(220,230,243,255),1.0));$line.Stroke=$tb;$line.Opacity=0.0
        $line.Effect=New-Object System.Windows.Media.Effects.DropShadowEffect -Property @{Color=[System.Windows.Media.Color]::FromRgb(100,175,255);BlurRadius=10;ShadowDepth=0;Opacity=0.55}
        $mx=$w*(0.32+$script:rng.NextDouble()*0.48);$my=$h*(0.06+$script:rng.NextDouble()*0.28);[System.Windows.Controls.Canvas]::SetLeft($line,$mx);[System.Windows.Controls.Canvas]::SetTop($line,$my);[void]$canvas.Children.Add($line)
        $script:meteor=[pscustomobject]@{Shape=$line;X=$mx;Y=$my;Life=0.0}
      }
      if($null -ne $script:meteor){$script:meteor.Life+=0.033;$script:meteor.X+=3.0;$script:meteor.Y+=0.9;$script:meteor.Shape.Opacity=[Math]::Max(0,0.62*(1-($script:meteor.Life/1.1)));[System.Windows.Controls.Canvas]::SetLeft($script:meteor.Shape,$script:meteor.X);[System.Windows.Controls.Canvas]::SetTop($script:meteor.Shape,$script:meteor.Y);if($script:meteor.Life -gt 1.1){[void]$canvas.Children.Remove($script:meteor.Shape);$script:meteor=$null;$script:nextMeteor=$script:elapsed+$script:cfg.MeteorMin+$script:rng.NextDouble()*[Math]::Max(0.1,($script:cfg.MeteorMax-$script:cfg.MeteorMin))}}
    }
})
$window.Show();$timer.Start();[System.Windows.Threading.Dispatcher]::Run()







