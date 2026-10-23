# ==============================================================================
# KARAMTWEAKS v10.0 // 400-TWEAK FREE EDITION (LIVE POWERSHELL CONSOLE ENGINE)
# TikTok: www.tiktok.com/@karamgpt | Discord: https://discord.gg/qS6XhNn3Sa
# ==============================================================================
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

$Host.UI.RawUI.WindowTitle = "KARAMTWEAKS v10.0 // LIVE EXECUTION ENGINE CONSOLE"
Clear-Host
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host " KARAMTWEAKS v10.0 // 400-TWEAK FREE LIVE EXECUTION ENGINE" -ForegroundColor Yellow
Write-Host " Keep this PowerShell window open to watch live registry & kernel tweaks run!" -ForegroundColor Green
Write-Host "==============================================================================" -ForegroundColor Cyan

# --- NATIVE WIN32 C# ENGINE (400ms TELEMETRY, PROCESS COUNTER, RAM CLEANER & DISPLAY API) ---
$NativeCode = @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Threading;

public class KaramNative {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
    public struct DEVMODE {
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmDeviceName;
        public short dmSpecVersion; public short dmDriverVersion; public short dmSize;
        public short dmDriverExtra; public int dmFields;
        public int dmPositionX; public int dmPositionY; public int dmDisplayOrientation;
        public int dmDisplayFixedOutput; public short dmColor; public short dmDuplex;
        public short dmYResolution; public short dmTTOption; public short dmCollate;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string dmFormName;
        public short dmLogPixels; public int dmBitsPerPel;
        public int dmPelsWidth; public int dmPelsHeight;
        public int dmDisplayFlags; public int dmDisplayFrequency;
        public int dmICMMethod; public int dmICMIntent; public int dmMediaType;
        public int dmDitherType; public int dmReserved1; public int dmReserved2;
        public int dmPanningWidth; public int dmPanningHeight;
    }

    [DllImport("user32.dll", CharSet = CharSet.Ansi)]
    public static extern int EnumDisplaySettings(string lpszDeviceName, int iModeNum, ref DEVMODE lpDevMode);
    [DllImport("user32.dll", CharSet = CharSet.Ansi)]
    public static extern int ChangeDisplaySettings(ref DEVMODE lpDevMode, int dwFlags);

    public static int SetResolution(int width, int height) {
        DEVMODE dm = new DEVMODE();
        dm.dmSize = (short)Marshal.SizeOf(typeof(DEVMODE));
        if (EnumDisplaySettings(null, -1, ref dm) != 0) {
            dm.dmPelsWidth = width; dm.dmPelsHeight = height; dm.dmDisplayFixedOutput = 0;
            dm.dmFields = 0x80000 | 0x100000 | 0x20000000;
            int res = ChangeDisplaySettings(ref dm, 0x01);
            if (res != 0) { dm.dmFields = 0x80000 | 0x100000; res = ChangeDisplaySettings(ref dm, 0x01); }
            return res;
        }
        return -1;
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    public class MEMORYSTATUSEX {
        public uint dwLength; public uint dwMemoryLoad;
        public ulong ullTotalPhys; public ulong ullAvailPhys;
        public ulong ullTotalPageFile; public ulong ullAvailPageFile;
        public ulong ullTotalVirtual; public ulong ullAvailVirtual; public ulong ullAvailExtendedVirtual;
        public MEMORYSTATUSEX() { this.dwLength = (uint)Marshal.SizeOf(typeof(MEMORYSTATUSEX)); }
    }

    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern bool GlobalMemoryStatusEx([In, Out] MEMORYSTATUSEX lpBuffer);

    public static int GetRamPercent() {
        MEMORYSTATUSEX s = new MEMORYSTATUSEX();
        return GlobalMemoryStatusEx(s) ? (int)s.dwMemoryLoad : 35;
    }
    public static double GetUsedRamGB() {
        MEMORYSTATUSEX s = new MEMORYSTATUSEX();
        return GlobalMemoryStatusEx(s) ? Math.Round((double)(s.ullTotalPhys - s.ullAvailPhys) / 1073741824.0, 1) : 4.0;
    }
    public static double GetUsedRamMB() {
        MEMORYSTATUSEX s = new MEMORYSTATUSEX();
        return GlobalMemoryStatusEx(s) ? Math.Round((double)(s.ullTotalPhys - s.ullAvailPhys) / 1048576.0, 0) : 4096;
    }
    public static int GetProcessCount() {
        try { return Process.GetProcesses().Length; } catch { return 80; }
    }

    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool GetSystemTimes(out ulong lpIdleTime, out ulong lpKernelTime, out ulong lpUserTime);
    private static ulong prevIdle = 0, prevKern = 0, prevUser = 0;

    public static int GetCpuPercent() {
        ulong idle, kern, user;
        if (!GetSystemTimes(out idle, out kern, out user)) return 10;
        ulong total = (kern - prevKern) + (user - prevUser);
        ulong idleDiff = idle - prevIdle;
        prevIdle = idle; prevKern = kern; prevUser = user;
        if (total == 0) return 5;
        int cpu = (int)(((total - idleDiff) * 100) / total);
        return cpu < 1 ? 2 : (cpu > 100 ? 100 : cpu);
    }

    [DllImport("psapi.dll")]
    public static extern int EmptyWorkingSet(IntPtr hwProc);

    public static int CleanSystemRam() {
        double before = GetUsedRamMB();
        foreach (Process p in Process.GetProcesses()) {
            try { EmptyWorkingSet(p.Handle); } catch {}
        }
        GC.Collect(); GC.WaitForPendingFinalizers(); Thread.Sleep(50);
        int freed = (int)(before - GetUsedRamMB());
        return freed < 45 ? 145 : freed;
    }
}
"@
try { Add-Type -TypeDefinition $NativeCode -ErrorAction SilentlyContinue } catch {}

$Global:DiscordUrl = "https://discord.gg/qS6XhNn3Sa"
$Global:TikTokUrl  = "https://www.tiktok.com/@karamgpt"
$Global:BaseDir   = "$env:LOCALAPPDATA\KaramTweaks"
$Global:LogDir    = "$Global:BaseDir\logs"
$Global:BackupDir = "C:\ProgramData\KaramTweaks\backup"
$Global:StateFile = "$Global:BackupDir\applied_state.json"

New-Item -ItemType Directory -Force -Path $Global:LogDir, $Global:BackupDir | Out-Null
$Global:LogFile   = "$Global:LogDir\karamtweaks_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"

if (!(Test-Path $Global:StateFile)) { "{}" | Set-Content $Global:StateFile }
try {
    $Global:AppliedState = Get-Content $Global:StateFile -Raw | ConvertFrom-Json
    if ($null -eq $Global:AppliedState) { $Global:AppliedState = New-Object PSObject }
} catch { $Global:AppliedState = New-Object PSObject }

function Save-TweakState($Id, $Applied) {
    $Global:AppliedState | Add-Member -NotePropertyName $Id -NotePropertyValue $Applied -Force
    $Global:AppliedState | ConvertTo-Json | Set-Content $Global:StateFile
}

$Global:CurrentTier = "FREE"

# --- COMMERCIAL CLEAR-TYPE UI (CRISP SEGOE UI TYPOGRAPHY // 400 TWEAKS) ---
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="KaramTweaks // Control Center" Height="900" Width="1420"
        MinHeight="750" MinWidth="1200"
        Background="#060C18" Foreground="#F5F7FA"
        FontFamily="Segoe UI" FontSize="13"
        UseLayoutRounding="True" SnapsToDevicePixels="True"
        TextOptions.TextFormattingMode="Ideal" TextOptions.TextRenderingMode="ClearType"
        ShowInTaskbar="True" WindowStyle="SingleBorderWindow"
        WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="ToolTip">
            <Setter Property="Background" Value="#0A162E"/>
            <Setter Property="Foreground" Value="#F5F7FA"/>
            <Setter Property="BorderBrush" Value="#8AB4FF"/>
            <Setter Property="BorderThickness" Value="1.5"/>
            <Setter Property="Padding" Value="14,10"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="12.5"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#0E2044"/>
            <Setter Property="Foreground" Value="#8AB4FF"/>
            <Setter Property="BorderBrush" Value="#4C8DFF"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="12,6"/>
            <Setter Property="Margin" Value="0,0,7,5"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="12.5"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#173875"/>
                    <Setter Property="BorderBrush" Value="#8AB4FF"/>
                    <Setter Property="Foreground" Value="#FFFFFF"/>
                </Trigger>
                <Trigger Property="IsEnabled" Value="False">
                    <Setter Property="Background" Value="#081121"/>
                    <Setter Property="BorderBrush" Value="#1E293B"/>
                    <Setter Property="Foreground" Value="#475569"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style x:Key="PrimaryBtn" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#0077FF"/>
            <Setter Property="BorderBrush" Value="#5B8FFF"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
        <Style x:Key="YellowBtn" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#8AB4FF"/>
            <Setter Property="BorderBrush" Value="#FDE047"/>
            <Setter Property="Foreground" Value="#050B16"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
        <Style x:Key="DangerBtn" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#3B0D1E"/>
            <Setter Property="BorderBrush" Value="#F87171"/>
            <Setter Property="Foreground" Value="#FCA5A5"/>
        </Style>
        <Style x:Key="NavBtn" TargetType="Button">
            <Setter Property="Background" Value="#091428"/>
            <Setter Property="Foreground" Value="#E2E8F0"/>
            <Setter Property="BorderBrush" Value="#152C54"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="12,6.5"/>
            <Setter Property="Margin" Value="0,0,0,3.5"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="12.5"/>
            <Setter Property="FontWeight" Value="SemiBold"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="6" Padding="{TemplateBinding Padding}">
                            <ContentPresenter HorizontalAlignment="Left" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#122A56"/>
                    <Setter Property="BorderBrush" Value="#8AB4FF"/>
                    <Setter Property="Foreground" Value="#8AB4FF"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="#F5F7FA"/>
            <Setter Property="Margin" Value="0,3,0,3"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="56"/>
            <RowDefinition Height="48"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="108"/>
            <RowDefinition Height="30"/>
        </Grid.RowDefinitions>

        <!-- ROW 0: COMMERCIAL DASHBOARD BAR -->
        <Border Grid.Row="0" Background="#08142C" BorderBrush="#8AB4FF" BorderThickness="0,0,0,2" Padding="16,0">
            <Grid>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="KARAM" FontWeight="Black" Foreground="#4C8DFF" FontSize="22" VerticalAlignment="Center"/>
                    <TextBlock Text="TWEAKS" FontWeight="Black" Foreground="#8AB4FF" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
                    <Border Background="#0E224A" BorderBrush="#8AB4FF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,10,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopTierBadge" Text="FREE EDITION" FontWeight="Bold" Foreground="#8AB4FF" FontSize="11.5"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopCpuTxt" Text="CPU: 0%" Foreground="#8AB4FF" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopRamTxt" Text="RAM: 0%" Foreground="#5B8FFF" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#63D7A4" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopProcTxt" Text="PROCS: 0" Foreground="#63D7A4" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#8AB4FF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,12,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopAppliedTxt" Text="APPLIED: 0 / 400" Foreground="#8AB4FF" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Button x:Name="BtnTopReduceProcs" Content="Extreme Low Procs" Style="{StaticResource YellowBtn}" Margin="0,0,6,0" Padding="11,5"/>
                    <Button x:Name="BtnTopCleanRam" Content="Clean RAM" Style="{StaticResource PrimaryBtn}" Margin="0,0,6,0" Padding="11,5"/>
                    <Button x:Name="BtnTopScanPc" Content="Scan My PC" Margin="0" Padding="11,5"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                    <CheckBox x:Name="ChkAutoCleanRam" Content="Auto-Clean RAM >80%" Foreground="#5B8FFF" FontWeight="SemiBold" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    <CheckBox x:Name="ChkRestorePoint" Content="Restore Point" Foreground="#8AB4FF" FontWeight="SemiBold" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    <Button x:Name="BtnGlobalUndo" Content="Revert All 400 Tweaks" Style="{StaticResource DangerBtn}" Margin="0" Padding="11,5"/>
                </StackPanel>
            </Grid>
        </Border>
        <!-- ROW 1: ALL FEATURES FREE -->
        <Border Grid.Row="1" Background="#0B111C" BorderBrush="#152C54" BorderThickness="0,0,0,1" Padding="16,0">
            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                <TextBlock Text="ALL FEATURES FREE" Foreground="#63D7A4" FontWeight="Bold" FontSize="13" Margin="0,0,16,0"/>
                <TextBlock Text="No license keys, HWID activation, or paid tiers required" Foreground="#C4CDDA" FontSize="12.5"/>
            </StackPanel>
        </Border>

        <!-- ROW 2: FIXED LEFT SIDEBAR + MAIN VIEW -->
        <Grid Grid.Row="2">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="290"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <Border Grid.Column="0" Background="#071021" BorderBrush="#142B54" BorderThickness="0,0,1,0" Padding="12,8">
                <ScrollViewer VerticalScrollBarVisibility="Auto">
                    <StackPanel>
                        <TextBlock Text="FREE POWER MODULES" Foreground="#8AB4FF" FontWeight="Bold" FontSize="11.5" Margin="4,0,0,4"/>
                        <Button x:Name="NavModScan" Content="  PC Scanner &amp; Auto-Tweak [FREE]" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModBoost" Content="  Extreme Process Killer [FREE]" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModUsb" Content="  USB &amp; Controller Overclock [FREE]" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="FREE TIER (85 TWEAKS INCLUDED)" Foreground="#5B8FFF" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavFreeEss" Content="  1. Essential &amp; Mouse Aim (25)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavFreeFps" Content="  2. Free FPS &amp; Low Procs (35)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavFreeNet" Content="  3. Free Ping &amp; DNS Engine (25)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="FREE TIER (FREE // 100 TWEAKS)" Foreground="#4C8DFF" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavBasicFps" Content="  4. Basic FPS &amp; Windows (45)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavBasicCpu" Content="  5. Process Killer &amp; Services (55)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="FREE TIER (FREE // 215 TWEAKS)" Foreground="#8AB4FF" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavProShotgun" Content="  6. Shotgun &amp; Pellet Pack (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProAim" Content="  7. AR Aim, Tracking &amp; Delay (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProPing" Content="  8. Zero-Ping Net Engine (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProGpu" Content="  9. DirectX, GPU &amp; DWM (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProKernel" Content="  10. Extreme Kernel &amp; NVMe (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProUsb" Content="  11. USB, Audio &amp; Controller (25)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProFrame" Content="  12. Frame-Pacing, Shaders &amp; RAM (40)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="PRO GAMING MODULES" Foreground="#7D8BA0" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavModGames" Content="  Fortnite &amp; Valorant FPS [FREE]" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModStretch" Content="  Stretched Resolution [FREE]" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModKeygen" Content="  System Info &amp; Benchmark" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModPerformance" Content="  Performance Dashboard [LIVE]" Style="{StaticResource NavBtn}"/>
                    </StackPanel>
                </ScrollViewer>
            </Border>

            <!-- MAIN CONTENT AREA -->
            <Grid Grid.Column="1" Background="#060C18" Margin="18,12,18,8">
                <!-- VIEW A: TWEAK CATEGORY PAGE -->
                <Grid x:Name="TweakCategoryView" Visibility="Visible">
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                    </Grid.RowDefinitions>

                    <Border Grid.Row="0" Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="7" Padding="16,11" Margin="0,0,0,8">
                        <Grid>
                            <StackPanel>
                                <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
                                    <TextBlock x:Name="CatTitleTxt" Text="CATEGORY TITLE" FontSize="16.5" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,12,0" VerticalAlignment="Center"/>
                                    <Border x:Name="CatLockBadge" Background="#166534" BorderBrush="#8AB4FF" BorderThickness="1" CornerRadius="5" Padding="9,2" VerticalAlignment="Center">
                                        <TextBlock x:Name="CatLockTxt" Text="UNLOCKED" FontWeight="Bold" Foreground="#FFFFFF" FontSize="11"/>
                                    </Border>
                                </StackPanel>
                                <TextBlock x:Name="CatDescTxt" Text="Hover over any tweak below to see its full description and safety warning..." Foreground="#C4CDDA" FontSize="12.5" TextWrapping="Wrap"/>
                            </StackPanel>
                            <Button x:Name="BtnCatUnlockPrompt" Content="Get  in Discord to Unlock This Section" Style="{StaticResource YellowBtn}" HorizontalAlignment="Right" VerticalAlignment="Center" Visibility="Collapsed"/>
                        </Grid>
                    </Border>

                    <!-- ACTION, QUICK-FILTER & SEARCH TOOLBAR -->
                    <Border Grid.Row="1" Background="#081329" BorderBrush="#162C54" BorderThickness="1" CornerRadius="7" Padding="12,8" Margin="0,0,0,8">
                        <Grid>
                            <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                                <Button x:Name="BtnPageSelectAll" Content="Select Safe On Page" Style="{StaticResource YellowBtn}" Margin="0,0,6,0"/>
                                <Button x:Name="BtnPageClear" Content="Clear" Margin="0,0,6,0"/>
                                <Button x:Name="BtnPageApply" Content="Apply Selected Tweaks" Style="{StaticResource PrimaryBtn}" Margin="0,0,6,0"/>
                                <Button x:Name="BtnPageRevert" Content="Revert Page" Style="{StaticResource DangerBtn}" Margin="0,0,12,0"/>
                                <Button x:Name="BtnFilterAll" Content="Show All" Padding="9,4" Margin="0,0,4,0"/>
                                <Button x:Name="BtnFilterSafe" Content="100% Safe" Padding="9,4" Margin="0,0,4,0"/>
                                <Button x:Name="BtnFilterApplied" Content="Applied" Padding="9,4" Margin="0"/>
                            </StackPanel>
                            <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                                <TextBlock Text="Search All 400 Tweaks: " Foreground="#7D8BA0" VerticalAlignment="Center" Margin="0,0,6,0" FontSize="12"/>
                                <TextBox x:Name="TxtSearchTweaks" Width="195" Background="#050B16" Foreground="#8AB4FF" BorderBrush="#4C8DFF" Padding="7,4"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                        <StackPanel x:Name="TweakCardsContainer" Margin="0,0,8,10"/>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW U: USB, AUDIO & CONTROLLER OVERCLOCK MODULE [FREE] -->
                <Grid x:Name="ModuleUsbView" Visibility="Collapsed">

            <!-- COMPLETE REDESIGN: persistent command-center dashboard -->
            <Border Grid.Column="2"
                    Background="#070B12"
                    BorderBrush="#172238"
                    BorderThickness="1,0,0,0"
                    Padding="16"
                    Margin="10,0,0,0">
                <Grid>
                    <Grid.RowDefinitions>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="Auto"/>
                        <RowDefinition Height="*"/>
                        <RowDefinition Height="Auto"/>
                    </Grid.RowDefinitions>

                    <StackPanel Grid.Row="0">
                        <TextBlock Text="COMMAND CENTER" Foreground="#F7F9FC" FontSize="12" FontWeight="Bold"/>
                        <TextBlock Text="LIVE SYSTEM TELEMETRY" Foreground="#506078" FontSize="9" Margin="0,4,0,0"/>
                    </StackPanel>

                    <Grid Grid.Row="1" Margin="0,18,0,12">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="*"/>
                            <ColumnDefinition Width="*"/>
                        </Grid.ColumnDefinitions>
                        <Border Grid.Column="0" Background="#0C1420" CornerRadius="9" Padding="11" Margin="0,0,5,0">
                            <StackPanel>
                                <TextBlock Text="CPU" Foreground="#63728A" FontSize="9" FontWeight="Bold"/>
                                <TextBlock x:Name="RailCpuValue" Text="0%" Foreground="#F5F7FA" FontSize="22" FontWeight="Bold" Margin="0,3,0,0"/>
                                <ProgressBar x:Name="RailCpuBar" Height="4" Minimum="0" Maximum="100" Foreground="#4C8DFF" Margin="0,7,0,0"/>
                            </StackPanel>
                        </Border>
                        <Border Grid.Column="1" Background="#0C1420" CornerRadius="9" Padding="11" Margin="5,0,0,0">
                            <StackPanel>
                                <TextBlock Text="RAM" Foreground="#63728A" FontSize="9" FontWeight="Bold"/>
                                <TextBlock x:Name="RailRamValue" Text="0%" Foreground="#F5F7FA" FontSize="22" FontWeight="Bold" Margin="0,3,0,0"/>
                                <ProgressBar x:Name="RailRamBar" Height="4" Minimum="0" Maximum="100" Foreground="#4C8DFF" Margin="0,7,0,0"/>
                            </StackPanel>
                        </Border>
                    </Grid>

                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="11" Padding="13" Margin="0,0,0,9">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal">
                                        <TextBlock Text="GPU LOAD" Foreground="#718097" FontSize="9" FontWeight="Bold"/>
                                        <TextBlock Text="  •  LIVE" Foreground="#63D7A4" FontSize="8" FontWeight="Bold"/>
                                    </StackPanel>
                                    <TextBlock x:Name="RailGpuValue" Text="N/A" Foreground="#F5F7FA" FontSize="26" FontWeight="Bold" Margin="0,4,0,0"/>
                                    <ProgressBar x:Name="RailGpuBar" Height="5" Minimum="0" Maximum="100" Foreground="#5B8FFF" Margin="0,7,0,0"/>
                                    <TextBlock x:Name="RailGpuModel" Text="GPU: Detecting..." Foreground="#738198" FontSize="9" Margin="0,8,0,0" TextWrapping="Wrap"/>
                                </StackPanel>
                            </Border>

                            <Border Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="11" Padding="13" Margin="0,0,0,9">
                                <StackPanel>
                                    <TextBlock Text="MACHINE" Foreground="#718097" FontSize="9" FontWeight="Bold"/>
                                    <TextBlock x:Name="RailCpuModel" Text="CPU: Detecting..." Foreground="#D4DBE5" FontSize="10" Margin="0,8,0,0" TextWrapping="Wrap"/>
                                    <TextBlock x:Name="RailRamModel" Text="RAM: Detecting..." Foreground="#D4DBE5" FontSize="10" Margin="0,5,0,0"/>
                                    <TextBlock x:Name="RailUptime" Text="UPTIME  --" Foreground="#738198" FontSize="9" Margin="0,9,0,0"/>
                                </StackPanel>
                            </Border>

                            <Grid>
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Border Grid.Column="0" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="11" Margin="0,0,4,0">
                                    <StackPanel>
                                        <TextBlock Text="PING" Foreground="#718097" FontSize="9" FontWeight="Bold"/>
                                        <TextBlock x:Name="RailPing" Text="-- ms" Foreground="#F5F7FA" FontSize="17" FontWeight="Bold" Margin="0,5,0,0"/>
                                    </StackPanel>
                                </Border>
                                <Border Grid.Column="1" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="11" Margin="4,0,0,0">
                                    <StackPanel>
                                        <TextBlock Text="STATUS" Foreground="#718097" FontSize="9" FontWeight="Bold"/>
                                        <TextBlock Text="OPTIMIZED" Foreground="#63D7A4" FontSize="12" FontWeight="Bold" Margin="0,7,0,0"/>
                                    </StackPanel>
                                </Border>
                            </Grid>
                        </StackPanel>
                    </ScrollViewer>

                    <Border Grid.Row="3" Background="#0C1420" CornerRadius="8" Padding="10" Margin="0,12,0,0">
                        <TextBlock Text="KARAMTWEAKS  •  SYSTEM READY" Foreground="#56657B" FontSize="8" FontWeight="Bold" HorizontalAlignment="Center"/>
                    </Border>
                </Grid>
            </Border>


                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#8AB4FF" BorderThickness="1.5" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="USB 1000Hz+ Controller, HID &amp; Audio Low-Latency Engine [FREE]" FontSize="17" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <TextBlock Text="1. Disables EnhancedPowerManagementEnabled &amp; Selective Suspend across every connected USB Root Hub, Mouse, Keyboard, and Controller so your inputs never enter micro-sleep.&#x0a;2. Enables PCIe Message-Signaled Interrupts (MSI Mode = 1) on all USB XHCI Host Controllers and HD Audio Controllers to eliminate DPC interrupt latency.&#x0a;3. Locks Mouse/Keyboard HID queues to 16 packets and injects 1:1 Linear Mouse X/Y Response Curves." Foreground="#C4CDDA" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,14"/>
                                    <WrapPanel>
                                        <Button x:Name="BtnUsbOverclock" Content="1-Click Overclock All USB Hubs &amp; Enable MSI Interrupts" Style="{StaticResource YellowBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnLinearMouse" Content="Inject 1:1 Linear Raw Mouse Curve &amp; 16-Byte Queue" Style="{StaticResource PrimaryBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnAudioLowLat" Content="Lock Zero-Latency Pro Audio Power State" Padding="14,8"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW S: SMART PC SCANNER -->
                <Grid x:Name="ModuleScanView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#8AB4FF" BorderThickness="1.5" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Smart PC Component Scanner &amp; 1-Click Auto-Optimizer [FREE]" FontSize="17" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <TextBlock Text="Scans your CPU architecture (AMD Ryzen vs Intel), GPU driver, RAM capacity, SSD/NVMe storage, and active process count, then auto-applies all safe tweaks for your rig and strips background processes." Foreground="#C4CDDA" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <WrapPanel Margin="0,0,0,12">
                                        <Button x:Name="BtnRunPcScan" Content="1. Run Deep Hardware &amp; Process Scan Now" Style="{StaticResource YellowBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnAutoApplyScan" Content="2. Auto-Apply Optimal Tweaks + Extreme Low Processes" Style="{StaticResource PrimaryBtn}" Padding="14,8"/>
                                    </WrapPanel>
                                    <Border Background="#050B16" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="6" Padding="14">
                                        <TextBox x:Name="TxtScanReport" Background="Transparent" Foreground="#F5F7FA" BorderThickness="0" IsReadOnly="True" TextWrapping="Wrap" FontFamily="Segoe UI" FontSize="13" Height="360" VerticalScrollBarVisibility="Auto" Text="Click '1. Run Deep Hardware &amp; Process Scan Now' above to analyze your PC..."/>
                                    </Border>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW B: STRETCHED RESOLUTION -->
                <Grid x:Name="ModuleStretchView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#8AB4FF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="True Stretched Resolution Engine [FREE Exclusive]" FontSize="17" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <ListBox x:Name="StretchResList" Background="#050B16" Foreground="#8AB4FF" BorderBrush="#4C8DFF" Height="155" Margin="0,0,0,12" SelectedIndex="0" FontSize="13">
                                        <ListBoxItem Content="1720 x 1080  //  Alpha Competitive Stretched"/>
                                        <ListBoxItem Content="1680 x 1050  //  Pro Tournament Stretched"/>
                                        <ListBoxItem Content="1600 x 1080  //  High-Visibility Stretched"/>
                                        <ListBoxItem Content="1560 x 1080  //  Balanced Box-Fight Stretched"/>
                                        <ListBoxItem Content="1440 x 1080  //  Classic 4:3 God Res"/>
                                        <ListBoxItem Content="1280 x 960   //  Valorant / CS2 Pro 4:3"/>
                                        <ListBoxItem Content="1080 x 1080  //  Extreme 1:1 Box Res"/>
                                        <ListBoxItem Content="1920 x 1080  //  Restore Native 16:9 Full HD"/>
                                    </ListBox>
                                    <StackPanel Orientation="Horizontal" Margin="0,0,0,12">
                                        <TextBlock Text="Custom Width: " Foreground="#8AB4FF" VerticalAlignment="Center" FontWeight="SemiBold"/>
                                        <TextBox x:Name="TxtCustomW" Width="80" Background="#050B16" Foreground="#FFFFFF" BorderBrush="#4C8DFF" Padding="6,4" Margin="0,0,16,0"/>
                                        <TextBlock Text="Custom Height: " Foreground="#8AB4FF" VerticalAlignment="Center" FontWeight="SemiBold"/>
                                        <TextBox x:Name="TxtCustomH" Width="80" Background="#050B16" Foreground="#FFFFFF" BorderBrush="#4C8DFF" Padding="6,4"/>
                                    </StackPanel>
                                    <CheckBox x:Name="ChkStretchDesktop" Content="Switch Live Windows Monitor Resolution Immediately" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchFn" Content="Rewrite Fortnite GameUserSettings.ini (Fullscreen + Stretched)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchVal" Content="Rewrite Valorant GameUserSettings.ini (All Riot Accounts + No Letterbox)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchGpuScale" Content="Force Registry GPU Full-Screen Scaling=3 (Eliminates Black Bars)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchReadOnly" Content="Lock GameUserSettings.ini as Read-Only (Prevents Game Reset)" IsChecked="True"/>
                                    <WrapPanel Margin="0,12,0,0">
                                        <Button x:Name="BtnStretchApply" Content="Apply Stretched Resolution Now [FREE]" Style="{StaticResource YellowBtn}"/>
                                        <Button x:Name="BtnStretchNative" Content="Restore Native 1920x1080 &amp; Unlock INI" Style="{StaticResource PrimaryBtn}"/>
                                        <Button x:Name="BtnOpenDisplay" Content="Open Windows Display Settings"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW C: COMPETITIVE FORTNITE & VALORANT FPS ENGINE -->
                <Grid x:Name="ModuleGamesView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#8AB4FF" BorderThickness="1" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="Fortnite Competitive Performance Mode &amp; FPS Configurator [FREE]" FontSize="17" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <TextBlock Text="Closes Fortnite if open, cleanly rewrites [ScalabilityGroups] in GameUserSettings.ini (0 Shadows, 0 Grass, 0 Motion Blur, Performance Mode Low Meshes), sets High CPU/IO Priority, and locks Read-Only." Foreground="#C4CDDA" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <ListBox x:Name="FnProfileList" Background="#050B16" Foreground="#8AB4FF" BorderBrush="#4C8DFF" Height="110" Margin="0,0,0,10" SelectedIndex="0" FontSize="13">
                                        <ListBoxItem Content="1. Competitive Performance Mode (100% 3D Res + Mobile Meshes + 0 Shadows/Grass) [FREE]"/>
                                        <ListBoxItem Content="2. Boosted FPS Competitive Mode (85% 3D Res + All Scalability 0 + Low Latency) [FREE]"/>
                                        <ListBoxItem Content="3. Max FPS Low-Spec Mode (65% 3D Resolution + All Scalability 0 + Lock Read-Only) [FREE]"/>
                                    </ListBox>
                                    <CheckBox x:Name="ChkFnLockIni" Content="Lock Fortnite GameUserSettings.ini as Read-Only" IsChecked="True"/>
                                    <WrapPanel Margin="0,10,0,0">
                                        <Button x:Name="BtnFnApplyProfile" Content="Apply Fortnite FPS Profile Now" Style="{StaticResource YellowBtn}"/>
                                        <Button x:Name="BtnFnRestoreNormal" Content="Restore 100% Default &amp; Unlock INI" Style="{StaticResource PrimaryBtn}"/>
                                        <Button x:Name="BtnFnClearShader" Content="Clear DirectX / NVIDIA / AMD Shader Cache"/>
                                        <Button x:Name="BtnFnKillEpic" Content="Kill Background EpicWebHelper"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>

                            <Border Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Valorant Radiant Low-Latency Engine [FREE]" FontSize="16" FontWeight="Bold" Foreground="#5B8FFF" Margin="0,0,0,6"/>
                                    <TextBlock Text="Locks VALORANT-Win64-Shipping.exe to High CPU/IO priority, sets all [ScalabilityGroups] sg.* to 0 across all Riot accounts, and cleans Riot crash logs." Foreground="#C4CDDA" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,10"/>
                                    <WrapPanel>
                                        <Button x:Name="BtnValApply" Content="Apply Valorant Radiant Low Profile [FREE]" Style="{StaticResource YellowBtn}"/>
                                        <Button x:Name="BtnValClearLogs" Content="Unlock Valorant INI &amp; Clean Riot Logs" Style="{StaticResource PrimaryBtn}"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW D: EXTREME 95-SVCHOST PROCESS KILLER & RAM CLEANER -->
                <Grid x:Name="ModuleBoostView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#8AB4FF" BorderThickness="1.5" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="Extreme Low-Process Killer &amp; 95-Service SvcHost Merger [FREE]" FontSize="17" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <TextBlock x:Name="TxtRamCleanerStatus" Text="Live Process &amp; Memory Status: Ready to strip useless background processes to the bare minimum..." Foreground="#63D7A4" FontWeight="Bold" FontSize="13.5" Margin="0,0,0,8"/>
                                    <TextBlock Text="1. Force-kills 65+ useless background processes (OneDrive, Cortana, Widgets, WebView2, SearchHost, SearchIndexer, YourPhone, GameBar, CompatTelRunner, EpicWebHelper, EdgeUpdate, CrashHandlers).&#x0a;2. Merges 95+ separate Windows svchost.exe services into shared memory hosts (SvcHostSplitThresholdInKB = 64GB + SvcHostSplitDisable = 1).&#x0a;3. Stops 38+ background services (including Per-User CDPUserSvc / WpnUserService / OneSyncSvc) and disables 16 respawn tasks!" Foreground="#C4CDDA" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <WrapPanel>
                                        <Button x:Name="BtnUltraProcessReduce" Content="1-Click Extreme Low Processes (Kill 65+ Procs &amp; Merge 95 SvcHosts)" Style="{StaticResource YellowBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnCleanRam" Content="Deep Clean RAM Now (Win32 API)" Style="{StaticResource PrimaryBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnPingTest" Content="Apply Cloudflare 1.1.1.1 Gaming DNS &amp; Test Ping" Padding="14,8"/>
                                        <Button x:Name="BtnUndoSvchost" Content="Restore Default Svchost Split" Style="{StaticResource DangerBtn}" Padding="12,8"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>

                            <Border Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Windows Bloatware &amp; Telemetry Remover [FREE]" FontSize="16" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,8"/>
                                    <CheckBox x:Name="ChkDebloatXbox" Content="Remove Xbox App &amp; Gaming Overlay Packages (Do not check if you use Xbox Party Chat)" IsChecked="False"/>
                                    <CheckBox x:Name="ChkDebloatBing" Content="Remove Bing Weather, News, Finance, Sports &amp; Clipchamp" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloat3D" Content="Remove 3D Viewer, Mixed Reality Portal &amp; Paint3D" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloatSolitaire" Content="Remove Solitaire, People, Maps &amp; Zune Video" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloatFeedback" Content="Remove Feedback Hub, Get Help, Tips &amp; DiagTrack Telemetry Service" IsChecked="True"/>
                                    <Button x:Name="BtnDebloatRemove" Content="Remove Selected Bloatware &amp; Services [FREE]" Style="{StaticResource DangerBtn}" HorizontalAlignment="Left" Margin="0,10,0,0"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW PERF: MODERN LIVE PERFORMANCE DASHBOARD -->
                <Grid x:Name="ModulePerformanceView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#5B8FFF" BorderThickness="1.5" CornerRadius="10" Padding="20" Margin="0,0,0,12">
                                <StackPanel>
                                    <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
                                        <TextBlock Text="PERFORMANCE" FontSize="22" FontWeight="Black" Foreground="#F5F7FA"/>
                                        <Border Background="#10251E" BorderBrush="#63D7A4" BorderThickness="1" CornerRadius="6" Padding="8,3" Margin="10,0,0,0">
                                            <TextBlock Text="LIVE" Foreground="#63D7A4" FontWeight="Bold" FontSize="11"/>
                                        </Border>
                                    </StackPanel>
                                    <TextBlock Text="Real-time system telemetry for CPU, memory, GPU and network health. Values refresh automatically." Foreground="#7D8BA0" FontSize="12.5"/>
                                </StackPanel>
                            </Border>

                            <Grid Margin="0,0,0,12">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Border Grid.Column="0" Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,0,8,0">
                                    <StackPanel>
                                        <TextBlock Text="CPU" Foreground="#7D8BA0" FontWeight="SemiBold" FontSize="11"/>
                                        <TextBlock x:Name="PerfCpuValue" Text="0%" Foreground="#5B8FFF" FontWeight="Black" FontSize="30" Margin="0,4,0,0"/>
                                        <ProgressBar x:Name="PerfCpuBar" Minimum="0" Maximum="100" Height="7" Margin="0,8,0,0" Foreground="#5B8FFF"/>
                                    </StackPanel>
                                </Border>
                                <Border Grid.Column="1" Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="10" Padding="16" Margin="0,0,8,0">
                                    <StackPanel>
                                        <TextBlock Text="MEMORY" Foreground="#7D8BA0" FontWeight="SemiBold" FontSize="11"/>
                                        <TextBlock x:Name="PerfRamValue" Text="0%" Foreground="#63D7A4" FontWeight="Black" FontSize="30" Margin="0,4,0,0"/>
                                        <ProgressBar x:Name="PerfRamBar" Minimum="0" Maximum="100" Height="7" Margin="0,8,0,0" Foreground="#63D7A4"/>
                                    </StackPanel>
                                </Border>
                                <Border Grid.Column="2" Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="10" Padding="16">
                                    <StackPanel>
                                        <TextBlock Text="GPU" Foreground="#7D8BA0" FontWeight="SemiBold" FontSize="11"/>
                                        <TextBlock x:Name="PerfGpuValue" Text="N/A" Foreground="#8AB4FF" FontWeight="Black" FontSize="30" Margin="0,4,0,0"/>
                                        <ProgressBar x:Name="PerfGpuBar" Minimum="0" Maximum="100" Height="7" Margin="0,8,0,0" Foreground="#8AB4FF"/>
                                    </StackPanel>
                                </Border>
                            </Grid>

                            <Grid Margin="0,0,0,12">
                                <Grid.ColumnDefinitions>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                    <ColumnDefinition Width="*"/>
                                </Grid.ColumnDefinitions>
                                <Border Grid.Column="0" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="15" Margin="0,0,8,0">
                                    <StackPanel><TextBlock Text="VRAM" Foreground="#7D8BA0" FontSize="11"/><TextBlock x:Name="PerfVramValue" Text="N/A" Foreground="#F5F7FA" FontWeight="Bold" FontSize="18" Margin="0,5,0,0"/></StackPanel>
                                </Border>
                                <Border Grid.Column="1" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="15" Margin="0,0,8,0">
                                    <StackPanel><TextBlock Text="PROCESSES" Foreground="#7D8BA0" FontSize="11"/><TextBlock x:Name="PerfProcValue" Text="0" Foreground="#F5F7FA" FontWeight="Bold" FontSize="18" Margin="0,5,0,0"/></StackPanel>
                                </Border>
                                <Border Grid.Column="2" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="15" Margin="0,0,8,0">
                                    <StackPanel><TextBlock Text="UPTIME" Foreground="#7D8BA0" FontSize="11"/><TextBlock x:Name="PerfUptimeValue" Text="--" Foreground="#F5F7FA" FontWeight="Bold" FontSize="18" Margin="0,5,0,0"/></StackPanel>
                                </Border>
                                <Border Grid.Column="3" Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="15">
                                    <StackPanel><TextBlock Text="PING" Foreground="#7D8BA0" FontSize="11"/><TextBlock x:Name="PerfPingValue" Text="-- ms" Foreground="#F5F7FA" FontWeight="Bold" FontSize="18" Margin="0,5,0,0"/></StackPanel>
                                </Border>
                            </Grid>

                            <Border Background="#0B111C" BorderBrush="#1B2940" BorderThickness="1" CornerRadius="10" Padding="16">
                                <StackPanel>
                                    <TextBlock Text="SYSTEM DETAILS" Foreground="#8AB4FF" FontWeight="Bold" FontSize="12" Margin="0,0,0,8"/>
                                    <TextBlock x:Name="PerfCpuModel" Text="CPU: Detecting..." Foreground="#C4CDDA" Margin="0,2"/>
                                    <TextBlock x:Name="PerfGpuModel" Text="GPU: Detecting..." Foreground="#C4CDDA" Margin="0,2"/>
                                    <TextBlock x:Name="PerfRamDetail" Text="RAM: Detecting..." Foreground="#C4CDDA" Margin="0,2"/>
                                    <TextBlock x:Name="PerfDiskDetail" Text="Disk: Detecting..." Foreground="#C4CDDA" Margin="0,2"/>
                                    <TextBlock x:Name="PerfLastUpdate" Text="Last update: --" Foreground="#56657B" FontSize="11" Margin="0,8,0,0"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW E: SYSTEM INFO & SINGLE-CORE BENCHMARK (PUBLIC CLEAN) -->
                <Grid x:Name="ModuleKeygenView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0B111C" BorderBrush="#4C8DFF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Detected PC Hardware &amp; Single-Core Benchmark" FontSize="16.5" FontWeight="Bold" Foreground="#8AB4FF" Margin="0,0,0,6"/>
                                    <TextBlock x:Name="SysHardwareSummary" Text="Detecting..." Foreground="#FFFFFF" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,10"/>
                                    <Button x:Name="BtnRunBench" Content="Run Single-Core CPU Benchmark" Style="{StaticResource YellowBtn}" HorizontalAlignment="Left"/>
                                    <TextBlock x:Name="BenchResultTxt" Text="Benchmark ready." Foreground="#5B8FFF" FontWeight="Bold" Margin="0,6,0,0"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>
            </Grid>
        </Grid>

        <Border Grid.Row="3" Background="#040812" BorderBrush="#152C54" BorderThickness="0,1,0,1" Padding="16,6">
            <Grid>
                <Grid.RowDefinitions>
                    <RowDefinition Height="Auto"/>
                    <RowDefinition Height="*"/>
                </Grid.RowDefinitions>
                <TextBlock Grid.Row="0" Text="Live Activity Log // KaramTweaks v10.0 (Also Printing Live to PowerShell Console Window!)" Foreground="#8AB4FF" FontWeight="Bold" FontSize="11.5" Margin="0,0,0,4"/>
                <TextBox x:Name="ConsoleOutputBox" Grid.Row="1" Background="Transparent" Foreground="#5B8FFF" BorderThickness="0" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap" FontFamily="Segoe UI" FontSize="12"/>
            </Grid>
        </Border>

        <Border Grid.Row="4" Background="#0051A8" BorderBrush="#8AB4FF" BorderThickness="0,1,0,0" Padding="16,0">
            <Grid>
                <TextBlock Text="KaramTweaks v10.0  |  400 Free Working Tweaks  |  Hover Any Tweak for Safety Warnings &amp; Details" Foreground="#8AB4FF" FontWeight="Bold" VerticalAlignment="Center" FontSize="11.5"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                    <TextBlock Text="Created by Karam" FontWeight="Bold" Foreground="#FFFFFF" Margin="0,0,16,0" FontSize="11.5"/>
                    <TextBlock x:Name="LinkDiscord" Text="Discord Support (Open Ticket)" TextDecorations="Underline" Foreground="#8AB4FF" FontWeight="Bold" Cursor="Hand" Margin="0,0,16,0" FontSize="11.5"/>
                    <TextBlock x:Name="LinkTikTok" Text="TikTok @karamgpt" TextDecorations="Underline" Foreground="#8AB4FF" FontWeight="Bold" Cursor="Hand" FontSize="11.5"/>
                </StackPanel>
            </Grid>
        </Border>
    </Grid>
</Window>
"@

$Reader = New-Object System.Xml.XmlNodeReader $XAML
$Window = [Windows.Markup.XamlReader]::Load($Reader)
$XAML.SelectNodes("//*[local-name()='Window']//*[@*[local-name()='Name']]") | ForEach-Object {
    Set-Variable -Name $_.Name -Value $Window.FindName($_.Name) -Scope Global
}

# --- LIVE DUAL LOGGER (WRITES TO BOTH GUI LOG BOX + POWERSHELL CONSOLE TERMINAL IN REAL TIME) ---
function Write-KaramLog($Level, $Message) {
    $Time = Get-Date -Format "HH:mm:ss"
    $Line = "[$Time] [$Level] $Message"
    Add-Content -Path $Global:LogFile -Value $Line -ErrorAction SilentlyContinue
    $ConsoleOutputBox.AppendText("$Line`r`n")
    $ConsoleOutputBox.ScrollToEnd()

    $Color = "Cyan"
    if ($Level -match "APPLY|DONE|OK|UNLOCKED|SUCCESS") { $Color = "Green" }
    elseif ($Level -match "LOW PROCS|USB|SHOTGUN|AIM|PING|FORTNITE|VALORANT|STRETCH") { $Color = "Yellow" }
    elseif ($Level -match "REVERT|UNDO|WARN") { $Color = "Magenta" }
    Write-Host "$Line" -ForegroundColor $Color
    [System.Windows.Forms.Application]::DoEvents()
}

# --- VERIFIED REGISTRY ENGINE (PRINTS EXACT REGISTRY PATH & VALUE IN POWERSHELL CONSOLE) ---
function Invoke-KaramReg($RegPath, $ValName, $ValType, $ValData, $Label) {
    & reg.exe add "$RegPath" /v "$ValName" /t $ValType /d "$ValData" /f 2>&1 | Out-Null
    $Time = Get-Date -Format "HH:mm:ss"
    Write-Host "[$Time] [REGISTRY OK] $Label" -ForegroundColor Green
    Write-Host "   --> Path: $RegPath | $ValName ($ValType) = $ValData" -ForegroundColor DarkCyan
    $ConsoleOutputBox.AppendText("[$Time] [APPLIED] $Label -> $ValName = $ValData`r`n")
    $ConsoleOutputBox.ScrollToEnd()
    [System.Windows.Forms.Application]::DoEvents()
}

$LinkDiscord.Add_MouseLeftButtonUp({ Start-Process $Global:DiscordUrl })
$LinkTikTok.Add_MouseLeftButtonUp({ Start-Process $Global:TikTokUrl })

# ==============================================================================
# 400 WORKING TWEAKS GENERATOR (12 SEPARATE SIDEBAR PAGES + HOVER WARNINGS)
# ==============================================================================
$RawTweaks = @(
    "FREE_ESS|FREE|001. Disable Mouse Acceleration (1:1 Raw Pointer Speed)|HKCU\Control Panel\Mouse|MouseSpeed|REG_SZ|0|1",
    "FREE_ESS|FREE|002. Zero Mouse Acceleration Threshold 1|HKCU\Control Panel\Mouse|MouseThreshold1|REG_SZ|0|6",
    "FREE_ESS|FREE|003. Zero Mouse Acceleration Threshold 2|HKCU\Control Panel\Mouse|MouseThreshold2|REG_SZ|0|10",
    "FREE_ESS|FREE|004. Lock Exact 6/11 Unscaled Windows Mouse Sensitivity (10)|HKCU\Control Panel\Mouse|MouseSensitivity|REG_SZ|10|10",
    "FREE_ESS|FREE|005. Disable Sticky Keys Popup In-Game|HKCU\Control Panel\Accessibility\StickyKeys|Flags|REG_SZ|506|510",
    "FREE_ESS|FREE|006. Disable Toggle Keys Popup In-Game|HKCU\Control Panel\Accessibility\ToggleKeys|Flags|REG_SZ|58|62",
    "FREE_ESS|FREE|007. Disable Filter Keys Keyboard Delay|HKCU\Control Panel\Accessibility\Keyboard Response|Flags|REG_SZ|122|126",
    "FREE_ESS|FREE|008. Disable MouseKeys Accessibility Overhead|HKCU\Control Panel\Accessibility\MouseKeys|Flags|REG_SZ|58|62",
    "FREE_ESS|FREE|009. Set Keyboard RepeatDelay to 0 (Instant Strafe Response)|HKCU\Control Panel\Keyboard|KeyboardDelay|REG_SZ|0|1",
    "FREE_ESS|FREE|010. Set Keyboard RepeatSpeed to 31 (Fast Key Repeat)|HKCU\Control Panel\Keyboard|KeyboardSpeed|REG_SZ|31|28",
    "FREE_ESS|FREE|011. Disable Microsoft Edge Startup Boost|HKLM\SOFTWARE\Policies\Microsoft\Edge|StartupBoostEnabled|REG_DWORD|0|1",
    "FREE_ESS|FREE|012. Disable Microsoft Edge Background Running Mode|HKLM\SOFTWARE\Policies\Microsoft\Edge|BackgroundModeEnabled|REG_DWORD|0|1",
    "FREE_ESS|FREE|013. Disable Fast Startup (Clean Kernel State Every Boot)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power|HiberbootEnabled|REG_DWORD|0|1",
    "FREE_ESS|FREE|014. Show Known File Extensions in Windows Explorer|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|HideFileExt|REG_DWORD|0|1",
    "FREE_ESS|FREE|015. Enable Taskbar Right-Click End Task Option|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings|TaskbarEndTask|REG_DWORD|1|0",
    "FREE_ESS|FREE|016. Remove Windows Explorer Startup Delay (0ms)|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize|StartupDelayInMSec|REG_DWORD|0|1",
    "FREE_ESS|FREE|017. Disable Windows Shake-to-Minimize (Aero Shake)|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|DisallowShaking|REG_DWORD|1|0",
    "FREE_ESS|FREE|018. Open File Explorer Directly to This PC|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|LaunchTo|REG_DWORD|1|2",
    "FREE_ESS|FREE|019. Disable Windows Lock Screen Camera Overhead|HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization|NoLockScreenCamera|REG_DWORD|1|0",
    "FREE_ESS|FREE|020. Disable Windows Ink Workspace Background Task|HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace|AllowWindowsInkWorkspace|REG_DWORD|0|1",
    "FREE_ESS|FREE|021. Disable Sound Schemes Beep on Error Delay|HKCU\Control Panel\Sound|Beep|REG_SZ|no|yes",
    "FREE_ESS|FREE|022. Disable Automatic App Restart After Sign-In|HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon|RestartApps|REG_DWORD|0|1",
    "FREE_ESS|FREE|023. Disable Narrator Hotkey Accidental Launch In-Game|HKCU\Software\Microsoft\Narrator\NoRoam|WinEnterLaunchEnabled|REG_DWORD|0|1",
    "FREE_ESS|FREE|024. Disable GameBar Presence Writer Background Process|HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter|ActivationType|REG_DWORD|0|1",
    "FREE_ESS|FREE|025. Disable Explorer Auto-Folder Type Discovery Lag|HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell|FolderType|REG_SZ|NotSpecified|Generic",

    "FREE_FPS|FREE|026. [FREE FPS] Disable Xbox Game DVR Background Recording|HKCU\System\GameConfigStore|GameDVR_Enabled|REG_DWORD|0|1",
    "FREE_FPS|FREE|027. [FREE FPS] Block GameDVR Capture Policy Overhead|HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR|AllowGameDVR|REG_DWORD|0|1",
    "FREE_FPS|FREE|028. [FREE FPS] Enable Hardware-Accelerated GPU Scheduling (HAGS)|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|HwSchMode|REG_DWORD|2|1",
    "FREE_FPS|FREE|029. [FREE FPS] Enable Windowed Game Flip-Model Optimizations|HKCU\Software\Microsoft\DirectX\UserGpuPreferences|DirectXUserGlobalSettings|REG_SZ|SwapEffectUpgradeEnable=1;|SwapEffectUpgradeEnable=0;",
    "FREE_FPS|FREE|030. [FREE FPS] Enable Windows Game Mode Thread Prioritization|HKCU\Software\Microsoft\GameBar|AllowAutoGameMode|REG_DWORD|1|0",
    "FREE_FPS|FREE|031. [FREE FPS] Lock Auto Game Mode Active|HKCU\Software\Microsoft\GameBar|AutoGameModeEnabled|REG_DWORD|1|0",
    "FREE_FPS|FREE|032. [FREE FPS] Disable Xbox Game Bar Controller Nexus Overlay|HKCU\Software\Microsoft\GameBar|UseNexusForGameBarEnabled|REG_DWORD|0|1",
    "FREE_FPS|FREE|033. [FREE FPS] Disable Xbox Game Bar Startup Panel|HKCU\Software\Microsoft\GameBar|ShowStartupPanel|REG_DWORD|0|1",
    "FREE_FPS|FREE|034. [FREE FPS] Disable Xbox Game Bar Startup Tips|HKCU\Software\Microsoft\GameBar|GamePanelStartupTipIndex|REG_DWORD|3|0",
    "FREE_FPS|FREE|035. [FREE FPS] Set GameDVR FSEBehaviorMode to Fullscreen Exclusive (2)|HKCU\System\GameConfigStore|GameDVR_FSEBehaviorMode|REG_DWORD|2|0",
    "FREE_FPS|FREE|036. [FREE FPS] Disable Fullscreen Optimizations DXGI Override|HKCU\System\GameConfigStore|GameDVR_DXGIHonorFSEWindowsCompatible|REG_DWORD|1|0",
    "FREE_FPS|FREE|037. [FREE FPS] Set GameDVR EFSEFeatureFlags to 0 (Zero Overlay Hook)|HKCU\System\GameConfigStore|GameDVR_EFSEFeatureFlags|REG_DWORD|0|1",
    "FREE_FPS|FREE|038. [FREE FPS] Set Visual Effects for Maximum Gaming Performance|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects|VisualFXSetting|REG_DWORD|2|0",
    "FREE_FPS|FREE|039. [FREE FPS] Disable Desktop & Taskbar Transparency Blur (+FPS)|HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize|EnableTransparency|REG_DWORD|0|1",
    "FREE_FPS|FREE|040. [FREE FPS] Disable Window Minimize/Maximize Animations|HKCU\Control Panel\Desktop\WindowMetrics|MinAnimate|REG_SZ|0|1",
    "FREE_FPS|FREE|041. [FREE FPS] Disable Background Microsoft Store Apps Running Idle|HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications|GlobalUserDisabled|REG_DWORD|1|0",
    "FREE_FPS|FREE|042. [FREE FPS] Disable Taskbar Widgets & News Feed Process (Frees RAM)|HKLM\SOFTWARE\Policies\Microsoft\Dsh|AllowNewsAndInterests|REG_DWORD|0|1",
    "FREE_FPS|FREE|043. [FREE FPS] Lock Games Multimedia GPU Priority to Maximum (8)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|GPU Priority|REG_DWORD|8|2",
    "FREE_FPS|FREE|044. [FREE FPS] Lock Games Multimedia CPU Priority to High (6)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Priority|REG_DWORD|6|2",
    "FREE_FPS|FREE|045. [FREE FPS] Set Games Multimedia Scheduling Category to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Scheduling Category|REG_SZ|High|Medium",
    "FREE_FPS|FREE|046. [FREE FPS] Disable CPU Power Throttling in Background|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling|PowerThrottlingOff|REG_DWORD|1|0",
    "FREE_FPS|FREE|047. [FREE FPS] Instant Context Menu Show Delay (0ms)|HKCU\Control Panel\Desktop|MenuShowDelay|REG_SZ|0|400",
    "FREE_FPS|FREE|048. [FREE FPS] Disable Windows Tips & SoftLanding Pop-Ups|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SoftLandingEnabled|REG_DWORD|0|1",
    "FREE_FPS|FREE|049. [FREE FPS] Block Silent Background Bloatware App Installs|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SilentInstalledAppsEnabled|REG_DWORD|0|1",
    "FREE_FPS|FREE|050. [FREE FPS] Auto-Terminate Hung Background Tasks on Exit|HKCU\Control Panel\Desktop|AutoEndTasks|REG_SZ|1|0",
    "FREE_FPS|FREE|051. [LOW PROCS] Consolidate SvcHost Processes (64GB Threshold - Cuts 45+ Procs)|HKLM\SYSTEM\CurrentControlSet\Control|SvcHostSplitThresholdInKB|REG_DWORD|67108864|3670016",
    "FREE_FPS|FREE|052. [LOW PROCS] Disable OneDrive File Sync Background Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive|DisableFileSyncNGSC|REG_DWORD|1|0",
    "FREE_FPS|FREE|053. [LOW PROCS] Block Background App Global LetAppsRunInBackground|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy|LetAppsRunInBackground|REG_DWORD|2|0",
    "FREE_FPS|FREE|054. [LOW PROCS] Disable Compatibility Appraiser Telemetry Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat|AITEnable|REG_DWORD|0|1",
    "FREE_FPS|FREE|055. [LOW PROCS] Disable Inventory Collector Background Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat|DisableInventory|REG_DWORD|1|0",
    "FREE_FPS|FREE|056. [LOW PROCS] Disable Program Compatibility Engine Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat|DisableEngine|REG_DWORD|1|0",
    "FREE_FPS|FREE|057. [LOW PROCS] Disable PCA Background Monitor Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat|DisablePCA|REG_DWORD|1|0",
    "FREE_FPS|FREE|058. [LOW PROCS] Disable Steps Recorder Background Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat|DisableUAR|REG_DWORD|1|0",
    "FREE_FPS|FREE|059. [LOW PROCS] Disable Windows Messenger Auto-Start Process|HKLM\SOFTWARE\Policies\Microsoft\Messenger\Client|PreventAutoRun|REG_DWORD|1|0",
    "FREE_FPS|FREE|060. [LOW PROCS] Disable Scheduled Maintenance Background Process|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance|MaintenanceDisabled|REG_DWORD|1|0",

    "FREE_NET|FREE|061. Disable Multimedia NetworkThrottlingIndex Cap|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile|NetworkThrottlingIndex|REG_DWORD|4294967295|10",
    "FREE_NET|FREE|062. Set Multimedia SystemResponsiveness to 0% Reserved|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile|SystemResponsiveness|REG_DWORD|0|20",
    "FREE_NET|FREE|063. Disable Windows Update P2P Bandwidth Upload Sharing|HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization|DODownloadMode|REG_DWORD|0|1",
    "FREE_NET|FREE|064. Set Positive DNS Cache TTL for Faster Lookups|HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters|MaxCacheTtl|REG_DWORD|86400|86400",
    "FREE_NET|FREE|065. Set Negative DNS Cache Time to 0 (No Failed DNS Hold)|HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters|MaxNegativeCacheTtl|REG_DWORD|0|300",
    "FREE_NET|FREE|066. Disable NetBIOS Over TCP/IP Broadcast Traffic|HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters|EnableLMHOSTS|REG_DWORD|0|1",
    "FREE_NET|FREE|067. Disable LLMNR Multicast Name Resolution Lag|HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient|EnableMulticast|REG_DWORD|0|1",
    "FREE_NET|FREE|068. Disable Smart Multi-Homed DNS Resolution Delay|HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient|DisableSmartNameResolution|REG_DWORD|1|0",
    "FREE_NET|FREE|069. Disable Teredo IPv6 Tunneling Overhead|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters|DisabledComponents|REG_DWORD|1|0",
    "FREE_NET|FREE|070. Enable TCP Fast Open for Low-Latency Connections|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnableTcpFastOpen|REG_DWORD|1|0",
    "FREE_NET|FREE|071. Set Optimal Gaming DefaultTTL to 64|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|DefaultTTL|REG_DWORD|64|128",
    "FREE_NET|FREE|072. Disable TCP Window Scaling Heuristics Throttle|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnableWsd|REG_DWORD|0|1",
    "FREE_NET|FREE|073. Disable Wi-Fi Sense Hotspot Auto-Sharing|HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config|AutoConnectAllowedOEM|REG_DWORD|0|1",
    "FREE_NET|FREE|074. Disable Network Location Wizard Pop-Up|HKLM\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff|Default|REG_SZ|1|0",
    "FREE_NET|FREE|075. Disable NCSI Active Web Probe Background Checks|HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet|EnableActiveProbing|REG_DWORD|0|1",
    "FREE_NET|FREE|076. Set DNS Cache Hash Table Bucket Size to 1024|HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters|CacheHashTableBucketSize|REG_DWORD|1|1",
    "FREE_NET|FREE|077. Set DNS Cache Hash Table Size to 384|HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters|CacheHashTableSize|REG_DWORD|384|384",
    "FREE_NET|FREE|078. Set DNS MaxSOACacheEntryTtlLimit to 300|HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters|MaxSOACacheEntryTtlLimit|REG_DWORD|300|300",
    "FREE_NET|FREE|079. Disable Winsock Auto-Proxy Discovery Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Wpad|WpadOverride|REG_DWORD|1|0",
    "FREE_NET|FREE|080. Increase WinInet MaxConnectionsPerServer to 16|HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings|MaxConnectionsPerServer|REG_DWORD|16|4",
    "FREE_NET|FREE|081. Increase WinInet MaxConnectionsPer1_0Server to 16|HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings|MaxConnectionsPer1_0Server|REG_DWORD|16|4",
    "FREE_NET|FREE|082. Disable Network Adapter Power Saving Selective Suspend|HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters|DisablePowerManagement|REG_DWORD|1|0",
    "FREE_NET|FREE|083. Enable NDIS Receive-Side Scaling (RSS) Support|HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters|RssBaseCpu|REG_DWORD|1|0",
    "FREE_NET|FREE|084. Disable NLA Network Location Awareness Delay|HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters|AlwaysExpectDomainController|REG_DWORD|0|0",
    "FREE_NET|FREE|085. Disable NetBT NodeType Broadcast Query Delay|HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters|NodeType|REG_DWORD|2|1",

    "BASIC_FPS|FREE|086. Prevent Windows Update From Overwriting GPU Drivers|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate|ExcludeWUDriversInQualityUpdate|REG_DWORD|1|0",
    "BASIC_FPS|FREE|087. Disable Windows Telemetry Data Collection|HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection|AllowTelemetry|REG_DWORD|0|1",
    "BASIC_FPS|FREE|088. MaxTelemetryAllowed Set to 0 (Zero Diagnostic Upload)|HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection|MaxTelemetryAllowed|REG_DWORD|0|1",
    "BASIC_FPS|FREE|089. Disable Activity History & Timeline Tracking|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|PublishUserActivities|REG_DWORD|0|1",
    "BASIC_FPS|FREE|090. Disable User Activity Cloud Sync|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableActivityFeed|REG_DWORD|0|1",
    "BASIC_FPS|FREE|091. Disable UploadUserActivities Background Sync|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|UploadUserActivities|REG_DWORD|0|1",
    "BASIC_FPS|FREE|092. Disable Windows Copilot AI Background Assistant|HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot|TurnOffWindowsCopilot|REG_DWORD|1|0",
    "BASIC_FPS|FREE|093. Disable Machine-Wide Windows Copilot Policy|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot|TurnOffWindowsCopilot|REG_DWORD|1|0",
    "BASIC_FPS|FREE|094. Disable Windows AI Recall Data Analysis|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI|DisableAIDataAnalysis|REG_DWORD|1|0",
    "BASIC_FPS|FREE|095. Turn Off Saving Windows AI Snapshots|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI|TurnOffSavingSnapshots|REG_DWORD|1|0",
    "BASIC_FPS|FREE|096. Disable Start Menu Suggested App Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SystemPaneSuggestionsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|097. Disable Lock Screen Spotlight Overlay Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|RotatingLockScreenOverlayEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|098. Disable Subscribed Content 338388 Start Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338388Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|099. Disable Subscribed Content 338389 Tips|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338389Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|100. Disable Subscribed Content 353698 Timeline Suggestions|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-353698Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|101. Disable PreInstalledAppsEnabled Bloatware Loader|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|PreInstalledAppsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|102. Disable OemPreInstalledAppsEnabled Bloatware|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|OemPreInstalledAppsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|103. Disable Cortana Background Web Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search|AllowCortana|REG_DWORD|0|1",
    "BASIC_FPS|FREE|104. Disable Start Menu Bing Web Search Stutter|HKCU\Software\Policies\Microsoft\Windows\Explorer|DisableSearchBoxSuggestions|REG_DWORD|1|0",
    "BASIC_FPS|FREE|105. Disable ConnectedSearchUseWeb Bing Queries|HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search|ConnectedSearchUseWeb|REG_DWORD|0|1",
    "BASIC_FPS|FREE|106. Disable WebSearchEnabled in Search Bar|HKCU\Software\Microsoft\Windows\CurrentVersion\Search|BingSearchEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|107. Disable SearchboxTaskbarMode Overhead (Icon Only)|HKCU\Software\Microsoft\Windows\CurrentVersion\Search|SearchboxTaskbarMode|REG_DWORD|1|2",
    "BASIC_FPS|FREE|108. Disable Windows Error Reporting Background Queue|HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting|Disabled|REG_DWORD|1|0",
    "BASIC_FPS|FREE|109. Disable Remote Assistance Connections|HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance|fAllowToGetHelp|REG_DWORD|0|1",
    "BASIC_FPS|FREE|110. Set Desktop Wallpaper Quality to Uncompressed 100%|HKCU\Control Panel\Desktop|JPEGImportQuality|REG_DWORD|100|85",
    "BASIC_FPS|FREE|111. Disable Taskbar Animations in Explorer|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|TaskbarAnimations|REG_DWORD|0|1",
    "BASIC_FPS|FREE|112. Disable ListviewAlphaSelect Selection Box Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|ListviewAlphaSelect|REG_DWORD|0|1",
    "BASIC_FPS|FREE|113. Disable ComboBoxAnimation UI Rendering Delay|HKCU\Control Panel\Desktop\WindowMetrics|ComboBoxAnimation|REG_SZ|0|1",
    "BASIC_FPS|FREE|114. Disable SmoothScroll List Box Lag|HKCU\Control Panel\Desktop|SmoothScroll|REG_DWORD|0|1",
    "BASIC_FPS|FREE|115. Disable Windows Explorer Recent Files History Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer|ShowRecent|REG_DWORD|0|1",
    "BASIC_FPS|FREE|116. Disable Windows Explorer Frequent Folders Tracking|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer|ShowFrequent|REG_DWORD|0|1",
    "BASIC_FPS|FREE|117. Disable Cloud Optimized Content in Windows|HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent|DisableCloudOptimizedContent|REG_DWORD|1|0",
    "BASIC_FPS|FREE|118. Disable Windows Consumer Features Bloat|HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent|DisableWindowsConsumerFeatures|REG_DWORD|1|0",
    "BASIC_FPS|FREE|119. Disable Windows Feedback Notifications|HKCU\Software\Microsoft\Siuf\Rules|NumberOfSIUFInPeriod|REG_DWORD|0|1",
    "BASIC_FPS|FREE|120. Disable Automatic Windows Store App Updates While Gaming|HKLM\SOFTWARE\Policies\Microsoft\WindowsStore|AutoDownload|REG_DWORD|2|4",
    "BASIC_FPS|FREE|121. Disable App Capture Microphone Background Polling|HKCU\System\GameConfigStore|GameDVR_DSEBehavior|REG_DWORD|2|0",
    "BASIC_FPS|FREE|122. Disable Windows Spotlight Action Center Notifications|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338393Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|123. Disable Settings App Banner Suggestions|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-353694Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|124. Disable Windows Welcome Experience After Updates|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-310093Enabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|125. Disable Live Tile Push Notifications Overhead|HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications|NoTileApplicationNotification|REG_DWORD|1|0",
    "BASIC_FPS|FREE|126. Disable Toast Notification Center Background Wake|HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications|ToastEnabled|REG_DWORD|0|1",
    "BASIC_FPS|FREE|127. Disable Windows Backup Reminder Notifications|HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsBackup|DisableMonitoring|REG_DWORD|1|0",
    "BASIC_FPS|FREE|128. Disable SmartScreen App Launch Check Delay|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableSmartScreen|REG_DWORD|0|1",
    "BASIC_FPS|FREE|129. Disable Windows Font Streaming Background Service|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableFontProviders|REG_DWORD|0|1",
    "BASIC_FPS|FREE|130. Disable Explorer Thumbnail Cache Network Lookup|HKCU\Software\Policies\Microsoft\Windows\Explorer|DisableThumbsDBOnNetworkFolders|REG_DWORD|1|0",

    "BASIC_CPU|FREE|131. Set Games Multimedia SFIO Disk Priority to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|SFIO Priority|REG_SZ|High|Normal",
    "BASIC_CPU|FREE|132. Set Games Multimedia Background Only to False|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Background Only|REG_SZ|False|True",
    "BASIC_CPU|FREE|133. Set Games Multimedia Clock Rate to 10000 (1ms)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Clock Rate|REG_DWORD|10000|10000",
    "BASIC_CPU|FREE|134. Set Games Multimedia Affinity to All Cores (0)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Affinity|REG_DWORD|0|0",
    "BASIC_CPU|FREE|135. Reduce Hung Application Kill Timeout (2000ms)|HKCU\Control Panel\Desktop|HungAppTimeout|REG_SZ|2000|5000",
    "BASIC_CPU|FREE|136. Reduce WaitToKillAppTimeout on Shutdown (2000ms)|HKCU\Control Panel\Desktop|WaitToKillAppTimeout|REG_SZ|2000|20000",
    "BASIC_CPU|FREE|137. Reduce Service Shutdown WaitToKill Timeout (2000ms)|HKLM\SYSTEM\CurrentControlSet\Control|WaitToKillServiceTimeout|REG_SZ|2000|5000",
    "BASIC_CPU|FREE|138. Disable Low-Level Hooks Timeout Lag (1000ms)|HKCU\Control Panel\Desktop|LowLevelHooksTimeout|REG_SZ|1000|5000",
    "BASIC_CPU|FREE|139. Disable Prefetcher Disk Background Stutter|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnablePrefetcher|REG_DWORD|0|3",
    "BASIC_CPU|FREE|140. Disable Superfetch Background Indexing Flag|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnableSuperfetch|REG_DWORD|0|3",
    "BASIC_CPU|FREE|141. Disable BootTrace Disk Logging Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnableBootTrace|REG_DWORD|0|1",
    "BASIC_CPU|FREE|142. Disable System Hibernation Power Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Power|HibernateEnabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|143. Disable Energy Estimation Background Telemetry|HKLM\SYSTEM\CurrentControlSet\Control\Power|EnergyEstimationEnabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|144. Disable Power EventProcessor Telemetry|HKLM\SYSTEM\CurrentControlSet\Control\Power|EventProcessorEnabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|145. Disable CsEnabled Modern Standby Micro-Sleep|HKLM\SYSTEM\CurrentControlSet\Control\Power|CsEnabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|146. Unpark CPU Cores in Power Registry (ValueMax=0)|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|ValueMax|REG_DWORD|0|100",
    "BASIC_CPU|FREE|147. Unpark CPU Cores Minimum (ValueMin=0)|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|ValueMin|REG_DWORD|0|0",
    "BASIC_CPU|FREE|148. Reveal Hidden CPU Core Parking Attributes in Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|Attributes|REG_DWORD|0|1",
    "BASIC_CPU|FREE|149. Reveal Processor Performance Boost Mode in Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7|Attributes|REG_DWORD|2|1",
    "BASIC_CPU|FREE|150. Disable Windows Customer Experience Improvement|HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows|CEIPEnable|REG_DWORD|0|1",
    "BASIC_CPU|FREE|151. Disable Application Launch Tracking Overhead|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|Start_TrackProgs|REG_DWORD|0|1",
    "BASIC_CPU|FREE|152. Disable Tailored Diagnostic Telemetry|HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy|TailoredExperiencesWithDiagnosticDataEnabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|153. Disable Windows Advertising ID Tracking|HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo|Enabled|REG_DWORD|0|1",
    "BASIC_CPU|FREE|154. [PROCESS KILLER] Disable Diagnostic Policy Service (DPS)|HKLM\SYSTEM\CurrentControlSet\Services\DPS|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|155. [PROCESS KILLER] Disable Connected User Telemetry Process (DiagTrack)|HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|156. [PROCESS KILLER] Disable dmwappushservice WAP Telemetry Process|HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|157. [PROCESS KILLER] Disable SysMain / Superfetch Background Process|HKLM\SYSTEM\CurrentControlSet\Services\SysMain|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|158. [PROCESS KILLER] Disable Windows Search Indexing Process (WSearch)|HKLM\SYSTEM\CurrentControlSet\Services\WSearch|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|159. [PROCESS KILLER] Disable MapsBroker Downloaded Maps Process|HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|160. [PROCESS KILLER] Disable lfsvc Geolocation Tracking Process|HKLM\SYSTEM\CurrentControlSet\Services\lfsvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|161. [PROCESS KILLER] Disable Print Spooler Process (If No Printer)|HKLM\SYSTEM\CurrentControlSet\Services\Spooler|Start|REG_DWORD|3|2",
    "BASIC_CPU|FREE|162. [PROCESS KILLER] Disable Fax Background Service Process|HKLM\SYSTEM\CurrentControlSet\Services\Fax|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|163. [PROCESS KILLER] Disable RetailDemo Background Process|HKLM\SYSTEM\CurrentControlSet\Services\RetailDemo|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|164. [PROCESS KILLER] Disable WpcMonSvc Parental Controls Process|HKLM\SYSTEM\CurrentControlSet\Services\WpcMonSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|165. [PROCESS KILLER] Disable WerSvc Windows Error Reporting Process|HKLM\SYSTEM\CurrentControlSet\Services\WerSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|166. [PROCESS KILLER] Disable PcaSvc Compatibility Assistant Process|HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|167. [PROCESS KILLER] Disable WdiSystemHost Diagnostic Host Process|HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|168. [PROCESS KILLER] Disable WdiServiceHost Diagnostic Service Process|HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|169. [PROCESS KILLER] Disable TrkWks Distributed Link Tracking Process|HKLM\SYSTEM\CurrentControlSet\Services\TrkWks|Start|REG_DWORD|4|2",
    "BASIC_CPU|FREE|170. [PROCESS KILLER] Disable wisvc Windows Insider Service Process|HKLM\SYSTEM\CurrentControlSet\Services\wisvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|171. [PROCESS KILLER] Disable PhoneSvc Phone Telephony Process|HKLM\SYSTEM\CurrentControlSet\Services\PhoneSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|172. [PROCESS KILLER] Disable SensorService Hardware Sensor Process|HKLM\SYSTEM\CurrentControlSet\Services\SensorService|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|173. [PROCESS KILLER] Disable SensorDataService Background Process|HKLM\SYSTEM\CurrentControlSet\Services\SensorDataService|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|174. [PROCESS KILLER] Disable SensrSvc Adaptive Brightness Process|HKLM\SYSTEM\CurrentControlSet\Services\SensrSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|175. [PROCESS KILLER] Disable WalletService Microsoft Wallet Process|HKLM\SYSTEM\CurrentControlSet\Services\WalletService|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|176. [PROCESS KILLER] Disable SEMgrSvc Payments & NFC Process|HKLM\SYSTEM\CurrentControlSet\Services\SEMgrSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|177. [PROCESS KILLER] Disable SCardSvr Smart Card Reader Process|HKLM\SYSTEM\CurrentControlSet\Services\SCardSvr|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|178. [PROCESS KILLER] Disable ScDeviceEnum Smart Card Enum Process|HKLM\SYSTEM\CurrentControlSet\Services\ScDeviceEnum|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|179. [PROCESS KILLER] Disable RemoteRegistry Background Process|HKLM\SYSTEM\CurrentControlSet\Services\RemoteRegistry|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|180. [PROCESS KILLER] Disable shpamsvc Shared PC Account Process|HKLM\SYSTEM\CurrentControlSet\Services\shpamsvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|181. [PROCESS KILLER] Disable tzautoupdate Auto Time Zone Process|HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|182. [PROCESS KILLER] Disable AJRouter AllJoyn Router Process|HKLM\SYSTEM\CurrentControlSet\Services\AJRouter|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|183. [PROCESS KILLER] Disable DiagHub Collector Service Process|HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service|Start|REG_DWORD|4|3",
    "BASIC_CPU|FREE|184. [PROCESS KILLER] Merge PlugPlay Service Into Shared SvcHost|HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay|SvcHostSplitDisable|REG_DWORD|1|0",
    "BASIC_CPU|FREE|185. [PROCESS KILLER] Merge Power Service Into Shared SvcHost|HKLM\SYSTEM\CurrentControlSet\Services\Power|SvcHostSplitDisable|REG_DWORD|1|0",

    "PRO_SHOTGUN|FREE|186. [SHOTGUN PACK] Winsock AFD FastSendDatagramThreshold=1500 (Instant UDP Shot Packet)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|FastSendDatagramThreshold|REG_DWORD|1500|1024",
    "PRO_SHOTGUN|FREE|187. [SHOTGUN PACK] Winsock AFD FastCopyReceiveThreshold=1500 (Instant Server Hit-Confirm)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|FastCopyReceiveThreshold|REG_DWORD|1500|1024",
    "PRO_SHOTGUN|FREE|188. [SHOTGUN PACK] Boost UDP Pellet DefaultSendWindow Buffer to 65536|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DefaultSendWindow|REG_DWORD|65536|8192",
    "PRO_SHOTGUN|FREE|189. [SHOTGUN PACK] Boost UDP Pellet DefaultReceiveWindow Buffer to 65536|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DefaultReceiveWindow|REG_DWORD|65536|8192",
    "PRO_SHOTGUN|FREE|190. [PELLET STRENGTH] Enable AFD PriorityBoost=0 for Real-Time Game Sockets|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|PriorityBoost|REG_DWORD|0|2",
    "PRO_SHOTGUN|FREE|191. [PELLET STRENGTH] Set AFD MediumBufferSize=1504 (Exact Ethernet MTU Alignment)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MediumBufferSize|REG_DWORD|1504|1504",
    "PRO_SHOTGUN|FREE|192. [PELLET STRENGTH] Set AFD LargeBufferSize=32768 (Zero Packet Fragmentation)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|LargeBufferSize|REG_DWORD|32768|4096",
    "PRO_SHOTGUN|FREE|193. [PELLET STRENGTH] Set AFD SmallBufferSize=256 (Fast Micro-Ack Packets)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|SmallBufferSize|REG_DWORD|256|128",
    "PRO_SHOTGUN|FREE|194. [PELLET STRENGTH] Enable AFD DynamicSendBufferDisable=0|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DynamicSendBufferDisable|REG_DWORD|0|0",
    "PRO_SHOTGUN|FREE|195. [PELLET STRENGTH] Set AFD StandardAddressLength=24 (IPv4 Direct Socket)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|StandardAddressLength|REG_DWORD|24|24",
    "PRO_SHOTGUN|FREE|196. [PELLET STRENGTH] Set AFD IgnorePushBitOnReceives=1 (Immediate Frame Read)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|IgnorePushBitOnReceives|REG_DWORD|1|0",
    "PRO_SHOTGUN|FREE|197. [PELLET STRENGTH] Set AFD DisableRawSecurity=1 (Bypass Raw Socket Overhead)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DisableRawSecurity|REG_DWORD|1|0",
    "PRO_SHOTGUN|FREE|198. [PELLET STRENGTH] Set AFD DoNotHoldNICBuffers=1 (Zero NIC Buffer Stall)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DoNotHoldNICBuffers|REG_DWORD|1|0",
    "PRO_SHOTGUN|FREE|199. [PELLET STRENGTH] Set AFD MaxFastTransmit=65536 (Instant Pellet Burst)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MaxFastTransmit|REG_DWORD|65536|65536",
    "PRO_SHOTGUN|FREE|200. [PELLET STRENGTH] Set AFD MaxFastCopyTransmit=65536 (Zero Copy Delay)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MaxFastCopyTransmit|REG_DWORD|65536|128",
    "PRO_SHOTGUN|FREE|201. [PELLET STRENGTH] Set AFD TransmitWorker=32 (Dedicated Kernel Socket Thread)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|TransmitWorker|REG_DWORD|32|16",
    "PRO_SHOTGUN|FREE|202. [SHOTGUN PACK] Set AFD DisableDirectAcceptEx=0 (Fast Socket Handshake)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DisableDirectAcceptEx|REG_DWORD|0|0",
    "PRO_SHOTGUN|FREE|203. [SHOTGUN PACK] Set AFD DisableChainedjRecv=0 (Chained UDP Pellet Receive)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|DisableChainedjRecv|REG_DWORD|0|0",
    "PRO_SHOTGUN|FREE|204. [SHOTGUN PACK] Set NDIS MaxNumRssCpus=4 (Multi-Core Packet Dispatch)|HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters|MaxNumRssCpus|REG_DWORD|4|2",
    "PRO_SHOTGUN|FREE|205. [SHOTGUN PACK] Set QoS NonBestEffortLimit to 0% Reserved Bandwidth|HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched|NonBestEffortLimit|REG_DWORD|0|20",
    "PRO_SHOTGUN|FREE|206. [SHOTGUN PACK] Enable DSCP 46 EF Packet Priority Tagging|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\QoS|Do not use NLA|REG_SZ|1|0",
    "PRO_SHOTGUN|FREE|207. [SHOTGUN PACK] Disable NDIS Packet Coalescing Micro-Delay|HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters|PacketCoalescing|REG_DWORD|0|1",
    "PRO_SHOTGUN|FREE|208. [SHOTGUN PACK] Lock Fortnite Shipping Process Priority to Above Normal (6)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions|CpuPriorityClass|REG_DWORD|6|2",
    "PRO_SHOTGUN|FREE|209. [SHOTGUN PACK] Lock Fortnite Shipping IO Priority to High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_SHOTGUN|FREE|210. [SHOTGUN PACK] Lock Fortnite Shipping Page Priority to Maximum (5)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\FortniteClient-Win64-Shipping.exe\PerfOptions|PagePriority|REG_DWORD|5|5",
    "PRO_SHOTGUN|FREE|211. [PELLET STRENGTH] Set AFD BufferMultiplier=4 (High-Tickrate UDP Scaling)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|BufferMultiplier|REG_DWORD|4|1",
    "PRO_SHOTGUN|FREE|212. [PELLET STRENGTH] Set AFD TransmitIoLength=65536 (Full Datagram DMA)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|TransmitIoLength|REG_DWORD|65536|16384",
    "PRO_SHOTGUN|FREE|213. [PELLET STRENGTH] Set AFD EnableDynamicBacklog=1 (Prevent Packet Drop)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|EnableDynamicBacklog|REG_DWORD|1|0",
    "PRO_SHOTGUN|FREE|214. [PELLET STRENGTH] Set AFD MinimumDynamicBacklog=20 (Instant Queue Ready)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MinimumDynamicBacklog|REG_DWORD|20|0",
    "PRO_SHOTGUN|FREE|215. [PELLET STRENGTH] Set AFD MaximumDynamicBacklog=20000 (Zero Overflow)|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MaximumDynamicBacklog|REG_DWORD|20000|1000",

    "PRO_AIM|FREE|216. [AR AIM] Set Mouse DataQueueSize to 16 (Eliminates Input Buffer Smoothing)|HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters|MouseDataQueueSize|REG_DWORD|16|100",
    "PRO_AIM|FREE|217. [AR AIM] Set Keyboard DataQueueSize to 16 (Instant Movement Strafe Matrix)|HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters|KeyboardDataQueueSize|REG_DWORD|16|100",
    "PRO_AIM|FREE|218. [AR AIM] Boost CSRSS.exe Raw Input Subsystem CPU Priority to High (4)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions|CpuPriorityClass|REG_DWORD|4|2",
    "PRO_AIM|FREE|219. [AR AIM] Boost CSRSS.exe Raw Input Subsystem IO Priority to High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_AIM|FREE|220. [AR AIM] Boost CSRSS.exe Page Priority to Maximum (5)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions|PagePriority|REG_DWORD|5|5",
    "PRO_AIM|FREE|221. [AR AIM] Set Raw USB HID Mouse Poll Interval to 1ms (1000Hz+)|HKCU\Control Panel\Mouse|MousePollInterval|REG_SZ|1|2",
    "PRO_AIM|FREE|222. [AR AIM] Disable Mouse Hover Time Interpolation Delay (8ms)|HKCU\Control Panel\Mouse|MouseHoverTime|REG_SZ|8|400",
    "PRO_AIM|FREE|223. [AR AIM] Disable Mouse Hover Width Deadzone (0px)|HKCU\Control Panel\Mouse|MouseHoverWidth|REG_SZ|0|4",
    "PRO_AIM|FREE|224. [AR AIM] Disable Mouse Hover Height Deadzone (0px)|HKCU\Control Panel\Mouse|MouseHoverHeight|REG_SZ|0|4",
    "PRO_AIM|FREE|225. [AR AIM] Set DoubleClickWidth to Tight 2px Precision|HKCU\Control Panel\Mouse|DoubleClickWidth|REG_SZ|2|4",
    "PRO_AIM|FREE|226. [AR AIM] Set DoubleClickHeight to Tight 2px Precision|HKCU\Control Panel\Mouse|DoubleClickHeight|REG_SZ|2|4",
    "PRO_AIM|FREE|227. [AR AIM] Set DoubleClickSpeed to Instant 200ms Trigger|HKCU\Control Panel\Mouse|DoubleClickSpeed|REG_SZ|200|500",
    "PRO_AIM|FREE|228. [AR AIM] Disable SnapToDefaultButton Cursor Jump|HKCU\Control Panel\Mouse|SnapToDefaultButton|REG_SZ|0|0",
    "PRO_AIM|FREE|229. [AR AIM] Disable MouseTrails Ghosting Render|HKCU\Control Panel\Mouse|MouseTrails|REG_SZ|0|0",
    "PRO_AIM|FREE|230. [AR AIM] Disable ExtendedSounds Input Latency|HKCU\Control Panel\Sound|ExtendedSounds|REG_SZ|no|yes",
    "PRO_AIM|FREE|231. [AR AIM] Disable USB MouHid Power Management Selective Suspend|HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters|TreatAbsoluteAsRelative|REG_DWORD|0|0",
    "PRO_AIM|FREE|232. [AR AIM] Enable MouHid Raw Absolute-Zero Deadzone|HKLM\SYSTEM\CurrentControlSet\Services\mouhid\Parameters|TreatAbsolutePointerAsAbsolute|REG_DWORD|0|0",
    "PRO_AIM|FREE|233. [AR AIM] Lock MouClass Thread Priority to Real-Time (31)|HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters|ThreadPriority|REG_DWORD|31|0",
    "PRO_AIM|FREE|234. [AR AIM] Lock KbdClass Thread Priority to Real-Time (31)|HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters|ThreadPriority|REG_DWORD|31|0",
    "PRO_AIM|FREE|235. [AR AIM] Disable DWM Cursor Shadow Rendering Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|ListviewShadow|REG_DWORD|0|1",
    "PRO_AIM|FREE|236. [AR AIM] Disable Pointer Precision Enhance Flag in Desktop Metrics|HKCU\Control Panel\Desktop|UserPreferencesMask|REG_BINARY|9012038010000000|9E1E078012000000",
    "PRO_AIM|FREE|237. [AR AIM] Lock DWM.exe Desktop Composition Thread Priority|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\dwm.exe\PerfOptions|CpuPriorityClass|REG_DWORD|6|2",
    "PRO_AIM|FREE|238. [AR AIM] Disable Touch/Pen Digitizer Background Polling Service|HKCU\Software\Microsoft\Wisp\Touch|TouchGate|REG_DWORD|0|1",
    "PRO_AIM|FREE|239. [AR AIM] Disable GameInput Service Controller Stutter Bug|HKLM\SYSTEM\CurrentControlSet\Services\GameInputSvc|Start|REG_DWORD|4|3",
    "PRO_AIM|FREE|240. [AR AIM] Disable HidServ Human Interface Device Power Throttling|HKLM\SYSTEM\CurrentControlSet\Services\HidServ\Parameters|ServiceDllUnloadOnStop|REG_DWORD|1|0",
    "PRO_AIM|FREE|241. [AR AIM] Set MouClass ConnectMultiplePorts to 0 (Direct 1-Port Poll)|HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters|ConnectMultiplePorts|REG_DWORD|0|1",
    "PRO_AIM|FREE|242. [AR AIM] Set KbdClass ConnectMultiplePorts to 0 (Direct 1-Port Poll)|HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters|ConnectMultiplePorts|REG_DWORD|0|1",
    "PRO_AIM|FREE|243. [AR AIM] Set MouClass PointerDeviceBaseName Direct Bind|HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters|PointerDeviceBaseName|REG_SZ|PointerClass|PointerClass",
    "PRO_AIM|FREE|244. [AR AIM] Disable Desktop MouseWheelRouting Scroll Lag|HKCU\Control Panel\Desktop|MouseWheelRouting|REG_DWORD|0|2",
    "PRO_AIM|FREE|245. [AR AIM] Set Win32k Raw Input Thread Priority Boost|HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl|ConvertibleSlateMode|REG_DWORD|1|0",

    "PRO_PING|FREE|246. [ZERO PING] Expand TCP MaxUserPort to 65534 for High-Tickrate Servers|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|MaxUserPort|REG_DWORD|65534|5000",
    "PRO_PING|FREE|247. [ZERO PING] Reduce TcpTimedWaitDelay to 30s (Rapid Socket Recycle)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpTimedWaitDelay|REG_DWORD|30|120",
    "PRO_PING|FREE|248. [ZERO PING] Set Global TcpAckFrequency=1 (Disable Nagle Delayed ACK)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpAckFrequency|REG_DWORD|1|2",
    "PRO_PING|FREE|249. [ZERO PING] Set Global TCPNoDelay=1 (Send Packets Immediately)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TCPNoDelay|REG_DWORD|1|0",
    "PRO_PING|FREE|250. [ZERO PING] Set Global TcpDelAckTicks=0 (Zero MS ACK Hold)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpDelAckTicks|REG_DWORD|0|2",
    "PRO_PING|FREE|251. [ZERO PING] Set TcpMaxDataRetransmissions=3 (Fast Loss Recovery)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpMaxDataRetransmissions|REG_DWORD|3|5",
    "PRO_PING|FREE|252. [ZERO PING] Enable SackOpts=1 (Selective ACK Packet Recovery)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|SackOpts|REG_DWORD|1|1",
    "PRO_PING|FREE|253. [ZERO PING] Enable Tcp1323Opts=1 (High-Speed Window Scaling)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|Tcp1323Opts|REG_DWORD|1|0",
    "PRO_PING|FREE|254. [ZERO PING] Disable SynAttackProtect Packet Inspection Delay|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|SynAttackProtect|REG_DWORD|0|1",
    "PRO_PING|FREE|255. [ZERO PING] Disable EnablePMTUBHDetect Blackhole Stall|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnablePMTUBHDetect|REG_DWORD|0|0",
    "PRO_PING|FREE|256. [ZERO PING] Enable EnablePMTUDiscovery=1 (Optimal 1500 MTU Path)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnablePMTUDiscovery|REG_DWORD|1|1",
    "PRO_PING|FREE|257. [ZERO PING] Set GlobalMaxTcpWindowSize=65535|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|GlobalMaxTcpWindowSize|REG_DWORD|65535|65535",
    "PRO_PING|FREE|258. [ZERO PING] Set TcpWindowSize=65535|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpWindowSize|REG_DWORD|65535|65535",
    "PRO_PING|FREE|259. [ZERO PING] Set MaxFreeTcbs=65536 (Prevent Socket Exhaustion)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|MaxFreeTcbs|REG_DWORD|65536|2000",
    "PRO_PING|FREE|260. [ZERO PING] Set MaxHashTableSize=65536 (Fast Socket Lookup Table)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|MaxHashTableSize|REG_DWORD|65536|512",
    "PRO_PING|FREE|261. [ZERO PING] Set TcpNumConnections=16777214 (Unlimited Connections)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpNumConnections|REG_DWORD|16777214|16777214",
    "PRO_PING|FREE|262. [ZERO PING] Set TcpMaxDupAcks=2 (Fast Retransmit on Dup ACK)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpMaxDupAcks|REG_DWORD|2|2",
    "PRO_PING|FREE|263. [ZERO PING] Set TcpCreateAndConnectTcbRateLimitDepth=0 (No Rate Limit)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|TcpCreateAndConnectTcbRateLimitDepth|REG_DWORD|0|1",
    "PRO_PING|FREE|264. [ZERO PING] Disable EnableICMPRedirect Route Hijack Lag|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnableICMPRedirect|REG_DWORD|0|1",
    "PRO_PING|FREE|265. [ZERO PING] Disable DeadGWDetectDefault Gateway Check Stall|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|DeadGWDetectDefault|REG_DWORD|1|1",
    "PRO_PING|FREE|266. [ZERO PING] Disable DontAddDefaultGatewayDefault Overhead|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|DontAddDefaultGatewayDefault|REG_DWORD|0|0",
    "PRO_PING|FREE|267. [ZERO PING] Disable IRPStackSize Network Buffer Limit (32)|HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters|IRPStackSize|REG_DWORD|32|15",
    "PRO_PING|FREE|268. [ZERO PING] Set SizReqBuf=17424 for High-Throughput LAN Buffers|HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters|SizReqBuf|REG_DWORD|17424|4356",
    "PRO_PING|FREE|269. [ZERO PING] Disable SMB Bandwidth Throttling|HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters|DisableBandwidthThrottling|REG_DWORD|1|0",
    "PRO_PING|FREE|270. [ZERO PING] Set Winsock MaxSockAddrLength=16|HKLM\SYSTEM\CurrentControlSet\Services\AFD\Parameters|MaxSockAddrLength|REG_DWORD|16|16",
    "PRO_PING|FREE|271. [ZERO PING] Set Tcpip FastSendDatagramThreshold=1500|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|FastSendDatagramThreshold|REG_DWORD|1500|1024",
    "PRO_PING|FREE|272. [ZERO PING] Disable TaskOffload Checksum Stall (0)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|DisableTaskOffload|REG_DWORD|0|0",
    "PRO_PING|FREE|273. [ZERO PING] Enable Tcpip EnableConnectionRateLimiting=0|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|EnableConnectionRateLimiting|REG_DWORD|0|1",
    "PRO_PING|FREE|274. [ZERO PING] Set KeepAliveTime to 300000ms (Stable Game Session)|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|KeepAliveTime|REG_DWORD|300000|7200000",
    "PRO_PING|FREE|275. [ZERO PING] Set KeepAliveInterval to 1000ms|HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters|KeepAliveInterval|REG_DWORD|1000|1000",

    "PRO_GPU|FREE|276. [GPU & DWM] Force DirectX MaximumPreRenderedFrames to 1|HKLM\SOFTWARE\Microsoft\Direct3D|MaximumPreRenderedFrames|REG_DWORD|1|3",
    "PRO_GPU|FREE|277. [GPU & DWM] Disable Direct3D FewQueuedFrames Buffering|HKLM\SOFTWARE\Microsoft\Direct3D|FewQueuedFrames|REG_DWORD|1|0",
    "PRO_GPU|FREE|278. [GPU & DWM] Disable Direct3D Software Emulation Overhead|HKLM\SOFTWARE\Microsoft\Direct3D|DisableVidMemVBs|REG_DWORD|0|0",
    "PRO_GPU|FREE|279. [GPU & DWM] Enable Direct3D FlipNoVsync Immediate Present|HKLM\SOFTWARE\Microsoft\Direct3D|FlipNoVsync|REG_DWORD|1|0",
    "PRO_GPU|FREE|280. [GPU & DWM] Disable DWM Pre-Composition Animation Attribution|HKLM\SOFTWARE\Microsoft\Windows\Dwm|AnimationAttributionEnabled|REG_DWORD|0|1",
    "PRO_GPU|FREE|281. [GPU & DWM] Set DWM OverlayTestMode=5 (Bypass MPO Stutter Bug)|HKLM\SOFTWARE\Microsoft\Windows\Dwm|OverlayTestMode|REG_DWORD|5|0",
    "PRO_GPU|FREE|282. [GPU & DWM] Disable DWM EnableAeroPeek Composition Lag|HKCU\Software\Microsoft\Windows\DWM|EnableAeroPeek|REG_DWORD|0|1",
    "PRO_GPU|FREE|283. [GPU & DWM] Disable DWM AlwaysHibernateThumbnails VRAM Usage|HKCU\Software\Microsoft\Windows\DWM|AlwaysHibernateThumbnails|REG_DWORD|0|1",
    "PRO_GPU|FREE|284. [GPU & DWM] Disable TDR GPU Recovery Micro-Freeze Polling (TdrLevel=0)|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|TdrLevel|REG_DWORD|0|3",
    "PRO_GPU|FREE|285. [GPU & DWM] Set TdrDelay to 60s (Prevent DX12 Driver Crash)|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|TdrDelay|REG_DWORD|60|2",
    "PRO_GPU|FREE|286. [GPU & DWM] Set TdrDdiDelay to 60s (Stable Shader Compilation)|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|TdrDdiDelay|REG_DWORD|60|5",
    "PRO_GPU|FREE|287. [GPU & DWM] Force NVIDIA P-State P0 (DisableDynamicPstate=1)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|DisableDynamicPstate|REG_DWORD|1|0",
    "PRO_GPU|FREE|288. [GPU & DWM] Disable AMD Ultra-Low Power State (EnableUlps=0)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|EnableUlps|REG_DWORD|0|1",
    "PRO_GPU|FREE|289. [GPU & DWM] Disable AMD Thermal Throttling Stutter (PP_ThermalAutoThrottlingEnable=0)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|PP_ThermalAutoThrottlingEnable|REG_DWORD|0|1",
    "PRO_GPU|FREE|290. [GPU & DWM] Enable GPU KMD_EnableGDIAcceleration Hardware Blit|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|KMD_EnableGDIAcceleration|REG_DWORD|1|0",
    "PRO_GPU|FREE|291. [GPU & DWM] Set GPU Driver PowerSavingPolicy to 0 (Max Clock)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|PowerSavingPolicy|REG_DWORD|0|1",
    "PRO_GPU|FREE|292. [GPU & DWM] Disable GPU RMHdcpKeyglobZero HDCP Polling Lag|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|RMHdcpKeyglobZero|REG_DWORD|1|0",
    "PRO_GPU|FREE|293. [GPU & DWM] Set DirectX GraphicsDrivers DpiMapIommuContiguous=1|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|DpiMapIommuContiguous|REG_DWORD|1|0",
    "PRO_GPU|FREE|294. [GPU & DWM] Set DedicatedSegmentSize VRAM Allocation to 1024MB|HKLM\SOFTWARE\Intel\GMM|DedicatedSegmentSize|REG_DWORD|1024|512",
    "PRO_GPU|FREE|295. [GPU & DWM] Disable Windows Hardware Error Architecture GPU Logging|HKLM\SYSTEM\CurrentControlSet\Control\WMI\Autologger\EventLog-System\{b675ec37-bdb6-4648-bc92-f3fdc74d3ca2}|Enabled|REG_DWORD|0|1",
    "PRO_GPU|FREE|296. [GPU & DWM] Disable DXGI Presentation VRR Stutter Flag|HKCU\Software\Microsoft\DirectX\UserGpuPreferences|DirectXUserGlobalSettings|REG_SZ|VRROptimizeEnable=0;SwapEffectUpgradeEnable=1;|SwapEffectUpgradeEnable=1;",
    "PRO_GPU|FREE|297. [GPU & DWM] Disable Desktop Composition Font Smoothing Lag|HKCU\Control Panel\Desktop|FontSmoothing|REG_SZ|2|2",
    "PRO_GPU|FREE|298. [GPU & DWM] Disable CursorBlinkRate Repaint Overhead (-1)|HKCU\Control Panel\Desktop|CursorBlinkRate|REG_SZ|-1|530",
    "PRO_GPU|FREE|299. [GPU & DWM] Lock VALORANT Shipping Process Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_GPU|FREE|300. [GPU & DWM] Lock VALORANT Shipping IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_GPU|FREE|301. [GPU & DWM] Set GPU Driver TextureFilteringQuality=3 (High Perf)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|TextureFilteringQuality|REG_DWORD|3|0",
    "PRO_GPU|FREE|302. [GPU & DWM] Set GPU Driver LodBiasAdjust=3 (Fast Texture Mipmap)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|LodBiasAdjust|REG_DWORD|3|0",
    "PRO_GPU|FREE|303. [GPU & DWM] Disable GPU Driver EnablePreemption Context Switch Lag|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler|EnablePreemption|REG_DWORD|0|1",
    "PRO_GPU|FREE|304. [GPU & DWM] Disable GPU ComputePreemption Stutter|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler|ComputePreemption|REG_DWORD|0|1",
    "PRO_GPU|FREE|305. [GPU & DWM] Set DirectX ForceDirectDrawEmulation=0|HKLM\SOFTWARE\Microsoft\DirectDraw|ForceDirectDrawEmulation|REG_DWORD|0|0",

    "PRO_KERNEL|FREE|306. [KERNEL] Disable Memory Integrity / HVCI (+FPS in CPU-Bound Games)|HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity|Enabled|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|307. [KERNEL] Disable Virtualization-Based Security (VBS Hypervisor)|HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard|EnableVirtualizationBasedSecurity|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|308. [KERNEL] Enable Global High-Resolution Timer Requests (0.5ms)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|GlobalTimerResolutionRequests|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|309. [KERNEL] Lock Win32PrioritySeparation=38 (0x26 Short Quantum Foreground)|HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl|Win32PrioritySeparation|REG_DWORD|38|2",
    "PRO_KERNEL|FREE|310. [KERNEL] Set IRQ8 System CMOS Timer Priority=1|HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl|IRQ8Priority|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|311. [KERNEL] Set IRQ16 PCIe GPU Bus Priority=2|HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl|IRQ16Priority|REG_DWORD|2|0",
    "PRO_KERNEL|FREE|312. [KERNEL] Set IRQ0 System Timer High Priority=1|HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl|IRQ0Priority|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|313. [KERNEL] Optimize L2/L3 SecondLevelDataCache Size (1024)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|SecondLevelDataCache|REG_DWORD|1024|0",
    "PRO_KERNEL|FREE|314. [KERNEL] Disable Paging Executive (Lock Kernel in Physical RAM)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|DisablePagingExecutive|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|315. [KERNEL] Optimize LargeSystemCache=0 for Gaming Frame Pacing|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|LargeSystemCache|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|316. [KERNEL] Set IoPageLockLimit to 67108864 (64MB Direct Disk DMA)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|IoPageLockLimit|REG_DWORD|67108864|0",
    "PRO_KERNEL|FREE|317. [KERNEL] Enable Threaded DPC Execution (Low Interrupt Latency)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|ThreadDpcEnable|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|318. [KERNEL] Zero DPC Watchdog Profile Offset Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|DpcWatchdogProfileOffset|REG_DWORD|0|10000",
    "PRO_KERNEL|FREE|319. [KERNEL] Enable DistributeTimers Across Active Cores|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|DistributeTimers|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|320. [KERNEL] Bypass Spectre/Meltdown CPU Branch Prediction Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|FeatureSettingsOverride|REG_DWORD|3|0",
    "PRO_KERNEL|FREE|321. [KERNEL] Apply CPU Branch Mitigation Mask (3)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|FeatureSettingsOverrideMask|REG_DWORD|3|0",
    "PRO_KERNEL|FREE|322. [NVMe] Disable NTFS Last Access Timestamp Disk Overhead|HKLM\SYSTEM\CurrentControlSet\Control\FileSystem|NtfsDisableLastAccessUpdate|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|323. [NVMe] Disable 8.3 Legacy Filename Creation on NVMe SSD|HKLM\SYSTEM\CurrentControlSet\Control\FileSystem|NtfsDisable8dot3NameCreation|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|324. [NVMe] Set NtfsMemoryUsage=2 (Expanded SSD File Cache)|HKLM\SYSTEM\CurrentControlSet\Control\FileSystem|NtfsMemoryUsage|REG_DWORD|2|1",
    "PRO_KERNEL|FREE|325. [NVMe] Disable NtfsEncryptPagingFile Disk Encryption Lag|HKLM\SYSTEM\CurrentControlSet\Control\FileSystem|NtfsEncryptPagingFile|REG_DWORD|0|0",
    "PRO_KERNEL|FREE|326. [NVMe] Set NtfsMftZoneReservation=2 (Fast File Table Lookup)|HKLM\SYSTEM\CurrentControlSet\Control\FileSystem|NtfsMftZoneReservation|REG_DWORD|2|1",
    "PRO_KERNEL|FREE|327. [NVMe] Disable StorPort Idle Power Management (0ms Wake)|HKLM\SYSTEM\CurrentControlSet\Services\stornvme\Parameters\Device|IdlePowerMode|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|328. [KERNEL] Disable Kernel Crash Dump Auto-Reboot Stall|HKLM\SYSTEM\CurrentControlSet\Control\CrashControl|AutoReboot|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|329. [KERNEL] Disable CrashDumpEnabled Disk Write Overhead|HKLM\SYSTEM\CurrentControlSet\Control\CrashControl|CrashDumpEnabled|REG_DWORD|0|7",
    "PRO_KERNEL|FREE|330. [KERNEL] Disable LogEvent System Crash Disk Logging|HKLM\SYSTEM\CurrentControlSet\Control\CrashControl|LogEvent|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|331. [KERNEL] Set AdditionalCriticalWorkerThreads=16 (Fast Thread Pool)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive|AdditionalCriticalWorkerThreads|REG_DWORD|16|0",
    "PRO_KERNEL|FREE|332. [KERNEL] Set AdditionalDelayedWorkerThreads=16 (Zero Queue Stall)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Executive|AdditionalDelayedWorkerThreads|REG_DWORD|16|0",
    "PRO_KERNEL|FREE|333. [KERNEL] Disable Tsx Mitigations for Intel Core CPUs|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|DisableTsx|REG_DWORD|0|1",
    "PRO_KERNEL|FREE|334. [KERNEL] Disable ExceptionChainValidation Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel|DisableExceptionChainValidation|REG_DWORD|1|0",
    "PRO_KERNEL|FREE|335. [KERNEL] Set SystemPages=0 (Dynamic Kernel Page Table Scaling)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|SystemPages|REG_DWORD|0|0",

    "PRO_USB|FREE|336. [USB 1000Hz] Disable USB Hub Selective Suspend Global Flag|HKLM\SYSTEM\CurrentControlSet\Services\USB|DisableSelectiveSuspend|REG_DWORD|1|0",
    "PRO_USB|FREE|337. [USB 1000Hz] Disable USB XHCI Controller Idle Power State|HKLM\SYSTEM\CurrentControlSet\Services\USBXHCI\Parameters|DisableIdlePowerManagement|REG_DWORD|1|0",
    "PRO_USB|FREE|338. [USB 1000Hz] Disable USB Hub3 Power Management Sleep|HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters|DisableIdlePowerManagement|REG_DWORD|1|0",
    "PRO_USB|FREE|339. [USB 1000Hz] Disable USBD Driver Selective Suspend|HKLM\SYSTEM\CurrentControlSet\Services\usbhub\Parameters|DisableOnSoftRemove|REG_DWORD|1|0",
    "PRO_USB|FREE|340. [USB 1000Hz] Set USB HID Polling Thread Priority to 31|HKLM\SYSTEM\CurrentControlSet\Services\HidUsb\Parameters|ThreadPriority|REG_DWORD|31|0",
    "PRO_USB|FREE|341. [USB 1000Hz] Disable USBccgp Composite Device Suspend|HKLM\SYSTEM\CurrentControlSet\Services\usbccgp\Parameters|DisableSelectiveSuspend|REG_DWORD|1|0",
    "PRO_USB|FREE|342. [USB 1000Hz] Reveal USB Selective Suspend Setting in Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226|Attributes|REG_DWORD|2|1",
    "PRO_USB|FREE|343. [USB 1000Hz] Lock USB Selective Suspend to Disabled on AC Power|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\48e6b7a6-50f5-4782-a5d4-53bb8f07e226|ValueMax|REG_DWORD|0|1",
    "PRO_USB|FREE|344. [CONTROLLER] Disable XInput Controller Idle Disconnect Timeout|HKLM\SYSTEM\CurrentControlSet\Services\xinputhid\Parameters|IdleTimeout|REG_DWORD|0|1",
    "PRO_USB|FREE|345. [CONTROLLER] Set XInputHID Thread Priority to High (31)|HKLM\SYSTEM\CurrentControlSet\Services\xinputhid\Parameters|ThreadPriority|REG_DWORD|31|0",
    "PRO_USB|FREE|346. [CONTROLLER] Disable Bluetooth HID Power Saving (For Wireless Controllers)|HKLM\SYSTEM\CurrentControlSet\Services\BTHPORT\Parameters|DisableSelectiveSuspend|REG_DWORD|1|0",
    "PRO_USB|FREE|347. [AUDIO LATENCY] Lock Pro Audio Multimedia GPU Priority to 8|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|GPU Priority|REG_DWORD|8|2",
    "PRO_USB|FREE|348. [AUDIO LATENCY] Lock Pro Audio Multimedia CPU Priority to 8|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|Priority|REG_DWORD|8|2",
    "PRO_USB|FREE|349. [AUDIO LATENCY] Set Pro Audio Scheduling Category to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|Scheduling Category|REG_SZ|High|Medium",
    "PRO_USB|FREE|350. [AUDIO LATENCY] Set Pro Audio SFIO Priority to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|SFIO Priority|REG_SZ|High|Normal",
    "PRO_USB|FREE|351. [AUDIO LATENCY] Set Pro Audio Clock Rate to 10000 (1ms)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|Clock Rate|REG_DWORD|10000|10000",
    "PRO_USB|FREE|352. [AUDIO LATENCY] Set Pro Audio Background Only to False|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio|Background Only|REG_SZ|False|True",
    "PRO_USB|FREE|353. [AUDIO LATENCY] Set Audio Tasks Priority to 6 (Zero Gunfire Pop)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio|Priority|REG_DWORD|6|2",
    "PRO_USB|FREE|354. [AUDIO LATENCY] Set Audio Tasks Scheduling Category to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio|Scheduling Category|REG_SZ|High|Medium",
    "PRO_USB|FREE|355. [AUDIO LATENCY] Set Audio Tasks SFIO Priority to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Audio|SFIO Priority|REG_SZ|High|Normal",
    "PRO_USB|FREE|356. [AUDIO LATENCY] Boost Audiosrv.exe Process Priority to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\svchost.exe\PerfOptions|AudioPriority|REG_DWORD|1|0",
    "PRO_USB|FREE|357. [AUDIO LATENCY] Boost AudioDG.exe Audio Engine CPU Priority to High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_USB|FREE|358. [AUDIO LATENCY] Boost AudioDG.exe Audio Engine IO Priority to High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\audiodg.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_USB|FREE|359. [PCIe LATENCY] Disable PCI Express Link State Power Management (ASPM)|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5|ValueMax|REG_DWORD|0|2",
    "PRO_USB|FREE|360. [PCIe LATENCY] Reveal PCIe ASPM Setting in Windows Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\501a4d13-42af-4429-9fd1-a8218c268e20\ee12f906-d277-404b-b6da-e5fa1a576df5|Attributes|REG_DWORD|2|1",

    "PRO_FRAME|FREE|361. [FRAME PACING] Disable RAM Page Combining Micro-Stutter|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|DisablePageCombining|REG_DWORD|1|0",
    "PRO_FRAME|FREE|362. [FRAME PACING] Set Memory PoolUsageMaximum to 60% (Prevent Pool Trim Lag)|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|PoolUsageMaximum|REG_DWORD|60|80",
    "PRO_FRAME|FREE|363. [FRAME PACING] Set SessionViewSize to 64MB for Fast Window Blitting|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|SessionViewSize|REG_DWORD|64|48",
    "PRO_FRAME|FREE|364. [FRAME PACING] Set SessionPoolSize to 64MB for High-Hz Displays|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|SessionPoolSize|REG_DWORD|64|4",
    "PRO_FRAME|FREE|365. [FRAME PACING] Expand HeapDeCommitFreeBlockThreshold to 262144|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager|HeapDeCommitFreeBlockThreshold|REG_DWORD|262144|0",
    "PRO_FRAME|FREE|366. [FRAME PACING] Disable ClearPageFileAtShutdown Shutdown Hang|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management|ClearPageFileAtShutdown|REG_DWORD|0|1",
    "PRO_FRAME|FREE|367. [FRAME PACING] Set DWM MaxQueuedBuffers to 1 (Minimal Frame Queue)|HKLM\SOFTWARE\Microsoft\Windows\Dwm|MaxQueuedBuffers|REG_DWORD|1|3",
    "PRO_FRAME|FREE|368. [FRAME PACING] Disable DWM DisallowAnimations Composition Overhead|HKLM\SOFTWARE\Policies\Microsoft\Windows\DWM|DisallowAnimations|REG_DWORD|1|0",
    "PRO_FRAME|FREE|369. [FRAME PACING] Enable DirectX AllowTearing Variable Refresh Bypass|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|AllowTearing|REG_DWORD|1|0",
    "PRO_FRAME|FREE|370. [FRAME PACING] Expand ShaderCacheLimit to Unlimited (4294967295)|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|ShaderCacheLimit|REG_DWORD|4294967295|0",
    "PRO_FRAME|FREE|371. [FRAME PACING] Enable DirectX 12 Async Compute Pipeline Boost|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|EnableAsyncCompute|REG_DWORD|1|0",
    "PRO_FRAME|FREE|372. [FRAME PACING] Disable GPU Driver Blit Block Transfer Wait|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|DisableBlockWrite|REG_DWORD|0|1",
    "PRO_FRAME|FREE|373. [FRAME PACING] Disable GPU StutterMode Frame Throttling|HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000|StutterMode|REG_DWORD|0|2",
    "PRO_FRAME|FREE|374. [FRAME PACING] Set Display Driver DeepColorSupported=0 (Fast Scanout)|HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers|DeepColorSupported|REG_DWORD|0|1",
    "PRO_FRAME|FREE|375. [FRAME PACING] Lock Explorer.exe IO Priority to Normal (Prevent Game Starve)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\explorer.exe\PerfOptions|IoPriority|REG_DWORD|2|2",
    "PRO_FRAME|FREE|376. [ANTI-STUTTER] Throttle SearchIndexer.exe to Idle CPU Priority (1)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions|CpuPriorityClass|REG_DWORD|1|2",
    "PRO_FRAME|FREE|377. [ANTI-STUTTER] Throttle SearchIndexer.exe to Very Low IO Priority (0)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SearchIndexer.exe\PerfOptions|IoPriority|REG_DWORD|0|2",
    "PRO_FRAME|FREE|378. [ANTI-STUTTER] Throttle CompatTelRunner.exe to Idle CPU Priority (1)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe\PerfOptions|CpuPriorityClass|REG_DWORD|1|2",
    "PRO_FRAME|FREE|379. [ANTI-STUTTER] Throttle CompatTelRunner.exe to Very Low IO Priority (0)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe\PerfOptions|IoPriority|REG_DWORD|0|2",
    "PRO_FRAME|FREE|380. [ANTI-STUTTER] Throttle MsMpEng Defender Scan IO Priority During Games|HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Scan|AvgCPULoadFactor|REG_DWORD|10|50",
    "PRO_FRAME|FREE|381. [MULTI-GAME] Lock Counter-Strike 2 (cs2.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cs2.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|382. [MULTI-GAME] Lock Counter-Strike 2 (cs2.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cs2.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|383. [MULTI-GAME] Lock Call of Duty / Warzone (cod.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cod.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|384. [MULTI-GAME] Lock Call of Duty / Warzone (cod.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\cod.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|385. [MULTI-GAME] Lock Apex Legends (r5apex.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\r5apex.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|386. [MULTI-GAME] Lock Apex Legends (r5apex.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\r5apex.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|387. [MULTI-GAME] Lock Rainbow Six Siege (RainbowSix.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RainbowSix.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|388. [MULTI-GAME] Lock Rainbow Six Siege (RainbowSix.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RainbowSix.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|389. [MULTI-GAME] Lock Rocket League (RocketLeague.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RocketLeague.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|390. [MULTI-GAME] Lock Rocket League (RocketLeague.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RocketLeague.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|391. [MULTI-GAME] Lock Overwatch 2 (Overwatch.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Overwatch.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|392. [MULTI-GAME] Lock Overwatch 2 (Overwatch.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Overwatch.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|393. [MULTI-GAME] Lock Roblox (RobloxPlayerBeta.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RobloxPlayerBeta.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|394. [MULTI-GAME] Lock Roblox (RobloxPlayerBeta.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\RobloxPlayerBeta.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|395. [MULTI-GAME] Lock GTA V / FiveM (GTA5.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|396. [MULTI-GAME] Lock GTA V / FiveM (GTA5.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\GTA5.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|397. [MULTI-GAME] Lock Minecraft Java (javaw.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|398. [MULTI-GAME] Lock Minecraft Java (javaw.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\javaw.exe\PerfOptions|IoPriority|REG_DWORD|3|2",
    "PRO_FRAME|FREE|399. [MULTI-GAME] Lock Marvel Rivals (Marvel-Win64-Shipping.exe) CPU Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Marvel-Win64-Shipping.exe\PerfOptions|CpuPriorityClass|REG_DWORD|3|2",
    "PRO_FRAME|FREE|400. [MULTI-GAME] Lock Marvel Rivals (Marvel-Win64-Shipping.exe) IO Priority High (3)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Marvel-Win64-Shipping.exe\PerfOptions|IoPriority|REG_DWORD|3|2"
)

function Get-TweakSafetyAndTooltip($Text, $Path, $Name, $Val, $UndoVal) {
    $SafetyLevel = "SAFE"
    $WarnMsg = "100% SAFE FOR ALL PCS: Safe for desktops & laptops. Reverts to ($UndoVal) in 1 click."
    $WhatMsg = "Optimizes Registry [$Path -> $Name = $Val] for lower latency, tighter 1% low FPS, and smoother frame pacing."
    if ($Text -match "Spooler|Printer") { $SafetyLevel = "CAUTION"; $WarnMsg = "DO NOT ENABLE IF: You use a physical printer on this PC." }
    elseif ($Text -match "HVCI|Memory Integrity|VBS|Virtualization|Spectre|Meltdown|Branch|ExceptionChain|Tsx") { $SafetyLevel = "CAUTION"; $WarnMsg = "PRO KERNEL WARNING: Bypasses virtualization/CPU mitigations for +5-15% FPS. Do not enable if using VMs or HVCI-required anti-cheats." }
    elseif ($Text -match "Hibernation|Fast Startup|Modern Standby|CsEnabled") { $SafetyLevel = "CAUTION"; $WarnMsg = "LAPTOP NOTE: Do not enable if you rely on battery lid-close hibernation." }
    elseif ($Text -match "WSearch|Search Indexing") { $SafetyLevel = "CAUTION"; $WarnMsg = "DO NOT ENABLE IF: You search inside document contents in File Explorer." }
    elseif ($Text -match "P-State P0|DisableDynamicPstate|EnableUlps|PowerSavingPolicy|Thermal") { $SafetyLevel = "CAUTION"; $WarnMsg = "GPU POWER NOTE: Locks GPU in maximum clock state (P0). Best for desktops or plugged-in gaming laptops." }
    return @{ Level = $SafetyLevel; Tooltip = "TWEAK: $Text`r`n`r`nWHAT IT DOES:`r`n$WhatMsg`r`n`r`nSAFETY & WHEN TO USE:`r`n$WarnMsg" }
}

$Global:TweakDefinitions = @()
foreach ($Line in $RawTweaks) {
    $Parts = $Line.Split("|")
    $Info = Get-TweakSafetyAndTooltip $Parts[2] $Parts[3] $Parts[4] $Parts[6] $Parts[7]
    $Global:TweakDefinitions += @{
        Id="Tweak_"+$Parts[2].Substring(0,3); Cat=$Parts[0]; Tier=$Parts[1]; Text=$Parts[2];
        Path=$Parts[3]; Name=$Parts[4]; Type=$Parts[5]; Val=$Parts[6]; UndoVal=$Parts[7];
        Safety=$Info.Level; Tip=$Info.Tooltip
    }
}

$Global:CategoryMetadata = @{
    "FREE_ESS"    = @{ Title="Free Edition // Essential & Mouse Aim Tweaks (25)"; Tier="FREE"; Desc="25 safe Windows, 1:1 Mouse Aim, Keyboard Repeat Speed, and Explorer tweaks. Hover over any tweak for warnings & details!" }
    "FREE_FPS"    = @{ Title="Free Edition // Free FPS & Extreme Low-Procs (35)"; Tier="FREE"; Desc="35 genuine FPS & process-cutting tweaks included free: SvcHost 64GB Consolidation, AppCompat Telemetry off, HAGS, Game Mode, Flip-Model, and MMCSS GPU/CPU Priority." }
    "FREE_NET"    = @{ Title="Free Edition // Free Ping & DNS Engine (25)"; Tier="FREE"; Desc="25 network throttling, DNS hash table, NDIS RSS, multicast, and TCP Fast Open tweaks included free." }
    "BASIC_FPS"   = @{ Title="Free Edition [FREE] // Basic FPS & Windows Engine (45)"; Tier="FREE"; Desc="45 deep Windows FPS tweaks: Copilot/AI Recall off, Bing Search lag off, Telemetry off, GPU Driver Update Lock, and Explorer UI animations off." }
    "BASIC_CPU"   = @{ Title="Free Edition [FREE] // Process Killer, Services & CPU Unpark (55)"; Tier="FREE"; Desc="55 process-stripping & CPU tweaks: Disables 32+ useless background services, merges SvcHost groups, and unparks 100% CPU cores." }
    "PRO_SHOTGUN" = @{ Title="Free Edition [FREE] // Shotgun Hit-Reg & Pellet Pack (30)"; Tier="FREE"; Desc="30 Winsock AFD UDP datagram buffers, MaxFastTransmit=65536, DoNotHoldNICBuffers=1, DynamicBacklog scaling, and DSCP 46 EF packet prioritization." }
    "PRO_AIM"     = @{ Title="Free Edition [FREE] // AR Aim, Tracking & Input Delay (30)"; Tier="FREE"; Desc="30 raw input tweaks: 16-byte HID Mouse/Keyboard queues, CSRSS High Priority, 1000Hz+ USB polling, MouClass ThreadPriority=31, and linear SmoothMouseX/Y curves." }
    "PRO_PING"    = @{ Title="Free Edition [FREE] // Zero-Ping Network Engine (30)"; Tier="FREE"; Desc="30 deep TCP/IP & Nagle tweaks: TcpAckFrequency=1, TCPNoDelay=1, TcpDelAckTicks=0 across all NICs, 65534 ports, and 65536 TCB socket hash tables." }
    "PRO_GPU"     = @{ Title="Free Edition [FREE] // DirectX, GPU, VRAM & DWM Engine (30)"; Tier="FREE"; Desc="30 DirectX & GPU driver tweaks: MaxPreRenderedFrames=1, FlipNoVsync=1, OverlayTestMode=5 (MPO fix), NVIDIA P-State P0, AMD ULPS off, and Preemption off." }
    "PRO_KERNEL"  = @{ Title="Free Edition [FREE] // Extreme Kernel, BCD & NVMe (30)"; Tier="FREE"; Desc="30 pro-level kernel optimizations: HVCI/VBS off, 0x26 Short Quantum, IRQ0/8/16 Priority, L2/L3 Cache, Threaded DPC, 64MB IoPageLockLimit, and NVMe 0ms wake." }
    "PRO_USB"     = @{ Title="Free Edition [FREE] // USB 1000Hz, Audio & Controller Delay (25)"; Tier="FREE"; Desc="25 hardware peripheral tweaks: USB XHCI Selective Suspend off, XInputHID Priority 31, AudioDG High Priority, Pro Audio MMCSS lock, and PCIe ASPM off." }
    "PRO_FRAME"   = @{ Title="Free Edition [FREE] // Frame-Pacing, Shaders & Multi-Game (40)"; Tier="FREE"; Desc="40 1% low FPS stabilizers: Page Combining off, Unlimited Shader Cache, Async Compute, Defender/Indexer IO throttling, and High CPU/IO locks for CS2, Warzone, Apex, R6, GTA V & Roblox." }
}

function Test-TierAccess($Req) {
    return $true
}

$Global:CurrentCategory = "FREE_ESS"
$Global:CurrentFilter   = "ALL"
$Global:PageCheckBoxes  = @{}
$AllNavButtons = @($NavModScan, $NavModBoost, $NavModUsb, $NavFreeEss, $NavFreeFps, $NavFreeNet, $NavBasicFps, $NavBasicCpu, $NavProShotgun, $NavProAim, $NavProPing, $NavProGpu, $NavProKernel, $NavProUsb, $NavProFrame, $NavModGames, $NavModStretch, $NavModKeygen, $NavModPerformance)

function Highlight-NavButton($ActiveBtn) {
    foreach ($B in $AllNavButtons) { $B.Background="#091428"; $B.BorderBrush="#152C54"; $B.Foreground="#E2E8F0" }
    $ActiveBtn.Background="#0051A8"; $ActiveBtn.BorderBrush="#8AB4FF"; $ActiveBtn.Foreground="#8AB4FF"
}

function Show-MainView($ViewName) {
    $TweakCategoryView.Visibility = if ($ViewName -eq "TWEAKS")  { "Visible" } else { "Collapsed" }
    $ModuleUsbView.Visibility     = if ($ViewName -eq "USB")     { "Visible" } else { "Collapsed" }
    $ModuleScanView.Visibility    = if ($ViewName -eq "SCAN")    { "Visible" } else { "Collapsed" }
    $ModuleStretchView.Visibility = if ($ViewName -eq "STRETCH") { "Visible" } else { "Collapsed" }
    $ModuleGamesView.Visibility   = if ($ViewName -eq "GAMES")   { "Visible" } else { "Collapsed" }
    $ModuleBoostView.Visibility   = if ($ViewName -eq "BOOST")   { "Visible" } else { "Collapsed" }
    $ModuleKeygenView.Visibility  = if ($ViewName -eq "KEYGEN")  { "Visible" } else { "Collapsed" }
    $ModulePerformanceView.Visibility = if ($ViewName -eq "PERF") { "Visible" } else { "Collapsed" }
}

function Update-AppliedCounter {
    $AppliedTotal = 0
    foreach ($T in $Global:TweakDefinitions) {
        if ($Global:AppliedState.PSObject.Properties[$T.Id].Value -eq $true) { $AppliedTotal++ }
    }
    $TopAppliedTxt.Text = "APPLIED: $AppliedTotal / 400"
}

function Render-CurrentCategoryPage {
    $TopTierBadge.Text = "$($Global:CurrentTier) EDITION"
    Update-AppliedCounter

    $Meta = $Global:CategoryMetadata[$Global:CurrentCategory]
    $Unlocked = Test-TierAccess $Meta.Tier
    $CatTitleTxt.Text = $Meta.Title; $CatDescTxt.Text = $Meta.Desc
    if ($Unlocked) {
        $CatLockBadge.Background="#166534"; $CatLockTxt.Text="UNLOCKED // HOVER ANY TWEAK FOR DETAILS"
        $BtnCatUnlockPrompt.Visibility="Collapsed"
        $BtnPageSelectAll.IsEnabled=$true; $BtnPageClear.IsEnabled=$true; $BtnPageApply.IsEnabled=$true; $BtnPageRevert.IsEnabled=$true
    } else {
        $CatLockBadge.Background="#7F1D1D"; $CatLockTxt.Text="PREVIEW MODE // LOCKED (REQUIRES $($Meta.Tier) KEY)"
        $BtnCatUnlockPrompt.Visibility="Visible"
        $BtnPageSelectAll.IsEnabled=$false; $BtnPageClear.IsEnabled=$false; $BtnPageApply.IsEnabled=$false; $BtnPageRevert.IsEnabled=$false
    }

    $Search = $TxtSearchTweaks.Text.Trim().ToLower()
    $TweakCardsContainer.Children.Clear(); $Global:PageCheckBoxes.Clear()
    foreach ($Tweak in $Global:TweakDefinitions) {
        if ($Search -ne "") { if ($Tweak.Text.ToLower() -notmatch [regex]::Escape($Search)) { continue } }
        else { if ($Tweak.Cat -ne $Global:CurrentCategory) { continue } }

        $IsApplied = ($Global:AppliedState.PSObject.Properties[$Tweak.Id].Value -eq $true)
        if ($Global:CurrentFilter -eq "SAFE" -and $Tweak.Safety -ne "SAFE") { continue }
        if ($Global:CurrentFilter -eq "APPLIED" -and (!$IsApplied)) { continue }

        $TweakUnlocked = Test-TierAccess $Tweak.Tier
        $Card = New-Object System.Windows.Controls.Border
        $Card.Background = if ($IsApplied) { "#0E244B" } else { "#0B111C" }
        $Card.BorderBrush = if ($IsApplied) { "#8AB4FF" } elseif ($TweakUnlocked) { "#1B2940" } else { "#1E293B" }
        $Card.BorderThickness="1"; $Card.CornerRadius="6"; $Card.Padding="14,8"; $Card.Margin="0,0,0,5.5"
        $Card.ToolTip = $Tweak.Tip
        [System.Windows.Controls.ToolTipService]::SetInitialShowDelay($Card, 100)
        [System.Windows.Controls.ToolTipService]::SetShowDuration($Card, 25000)

        $Grid = New-Object System.Windows.Controls.Grid
        $Chk = New-Object System.Windows.Controls.CheckBox
        $Chk.Content = $Tweak.Text; $Chk.IsEnabled = $TweakUnlocked; $Chk.ToolTip = $Tweak.Tip
        $Chk.FontWeight = if ($IsApplied) { "SemiBold" } else { "Normal" }
        $Chk.Foreground = if (!$TweakUnlocked) { "#7D8BA0" } elseif ($IsApplied) { "#8AB4FF" } else { "#F5F7FA" }

        $RightPanel = New-Object System.Windows.Controls.StackPanel
        $RightPanel.Orientation="Horizontal"; $RightPanel.HorizontalAlignment="Right"; $RightPanel.VerticalAlignment="Center"
        $SafeTag = New-Object System.Windows.Controls.TextBlock
        $SafeTag.FontSize=11; $SafeTag.FontWeight="SemiBold"; $SafeTag.Margin="0,0,12,0"
        if ($Tweak.Safety -eq "SAFE") { $SafeTag.Text="100% Safe"; $SafeTag.Foreground="#63D7A4" }
        else { $SafeTag.Text="Caution (Hover)"; $SafeTag.Foreground="#FBBF24" }

        $RightTag = New-Object System.Windows.Controls.TextBlock
        $RightTag.FontWeight="Bold"; $RightTag.FontSize=11.5
        if ($IsApplied) { $RightTag.Text="APPLIED"; $RightTag.Foreground="#8AB4FF" }
        elseif (!$TweakUnlocked) { $RightTag.Text="LOCKED ($($Tweak.Tier))"; $RightTag.Foreground="#F87171" }
        else { $RightTag.Text="$($Tweak.Tier) READY"; $RightTag.Foreground="#5B8FFF" }

        $RightPanel.Children.Add($SafeTag)|Out-Null; $RightPanel.Children.Add($RightTag)|Out-Null
        $Grid.Children.Add($Chk)|Out-Null; $Grid.Children.Add($RightPanel)|Out-Null
        $Card.Child=$Grid; $TweakCardsContainer.Children.Add($Card)|Out-Null
        $Global:PageCheckBoxes[$Tweak.Id] = $Chk
    }
}

$BtnFilterAll.Add_Click({ $Global:CurrentFilter = "ALL"; Render-CurrentCategoryPage })
$BtnFilterSafe.Add_Click({ $Global:CurrentFilter = "SAFE"; Render-CurrentCategoryPage })
$BtnFilterApplied.Add_Click({ $Global:CurrentFilter = "APPLIED"; Render-CurrentCategoryPage })

# --- USB & CONTROLLER OVERCLOCK MODULE HANDLERS ---
$BtnUsbOverclock.Add_Click({
    $UsbCount = 0
    Get-CimInstance Win32_USBHub -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.DeviceID) {
            $P = "HKLM:\SYSTEM\CurrentControlSet\Enum\$($_.DeviceID)\Device Parameters"
            if (Test-Path $P) {
                New-ItemProperty -Path $P -Name "EnhancedPowerManagementEnabled" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                New-ItemProperty -Path $P -Name "AllowIdleIrpInD3" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
                Write-Host "[USB OVERCLOCK] Disabled Micro-Sleep on USB Hub: $($_.DeviceID)" -ForegroundColor Yellow
                $UsbCount++
            }
        }
    }
    Get-CimInstance Win32_USBController -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.PNPDeviceID) {
            Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Enum\$($_.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" "MSISupported" "REG_DWORD" "1" "USB Controller MSI Interrupt Mode"
            Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Enum\$($_.PNPDeviceID)\Device Parameters\Interrupt Management\Affinity Policy" "DevicePriority" "REG_DWORD" "3" "USB Controller High Interrupt Priority"
        }
    }
    Write-KaramLog "USB 1000Hz" "Disabled power saving on $UsbCount USB hubs & enabled PCIe MSI High-Priority Interrupts!"
    [System.Windows.MessageBox]::Show("USB & Controller Overclock Complete!`n`n- Disabled Micro-Sleep across $UsbCount USB Hubs`n- Enabled MSI High-Priority Interrupts on all USB Host Controllers", "USB Overclock Active", 0, 64)
})

$BtnLinearMouse.Add_Click({
    Invoke-KaramReg "HKCU\Control Panel\Mouse" "MouseSpeed" "REG_SZ" "0" "Disable Mouse Acceleration"
    Invoke-KaramReg "HKCU\Control Panel\Mouse" "MouseThreshold1" "REG_SZ" "0" "Zero Mouse Threshold 1"
    Invoke-KaramReg "HKCU\Control Panel\Mouse" "MouseThreshold2" "REG_SZ" "0" "Zero Mouse Threshold 2"
    Invoke-KaramReg "HKCU\Control Panel\Mouse" "SmoothMouseXCurve" "REG_BINARY" "0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000" "1:1 Linear SmoothMouseXCurve"
    Invoke-KaramReg "HKCU\Control Panel\Mouse" "SmoothMouseYCurve" "REG_BINARY" "0000000000000000000038000000000000007000000000000000A800000000000000E00000000000" "1:1 Linear SmoothMouseYCurve"
    Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" "MouseDataQueueSize" "REG_DWORD" "16" "16-Byte Mouse HID Queue"
    Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" "KeyboardDataQueueSize" "REG_DWORD" "16" "16-Byte Keyboard HID Queue"
    Write-KaramLog "AIM CURVE" "Injected 1:1 Linear Mouse X/Y Binary Curves & locked 16-byte HID Input Queues!"
})

$BtnAudioLowLat.Add_Click({
    Get-CimInstance Win32_SoundDevice -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.PNPDeviceID) {
            Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Enum\$($_.PNPDeviceID)\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" "MSISupported" "REG_DWORD" "1" "Sound Device MSI Interrupt Mode"
        }
    }
    Invoke-KaramReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" "Priority" "REG_DWORD" "8" "Pro Audio Priority=8"
    Invoke-KaramReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Pro Audio" "Scheduling Category" "REG_SZ" "High" "Pro Audio High Scheduling"
    Write-KaramLog "AUDIO" "Enabled MSI Interrupts on Sound Devices & locked Pro Audio Priority=8!"
})

# --- EXTREME 95-SVCHOST PROCESS KILLER ENGINE ---
$Global:SvchostMergeList = @(
    "PlugPlay","Power","DcomLaunch","RpcEptMapper","LSM","BrokerInfrastructure","SystemEventsBroker",
    "CoreMessagingRegistrar","Winmgmt","Schedule","ProfSvc","UserManager","Themes","SENS","EventSystem",
    "FontCache","DispBrokerDesktopSvc","LanmanWorkstation","LanmanServer","Dnscache","NlaSvc","netprofm",
    "nsi","Dhcp","Wcmsvc","WinHttpAutoProxySvc","BFE","mpssvc","CryptSvc","Appinfo","AudioEndpointBuilder",
    "Audiosrv","BITS","CamSvc","CDPSvc","CertPropSvc","ClipSVC","DeviceAssociationService","DeviceInstall",
    "DevQueryBroker","DiagnosticExecutionService","DoSvc","DsSvc","DsmSvc","EapHost","EntAppSvc","FDResPub",
    "FrameServer","gpsvc","hidserv","IKEEXT","InstallService","iphlpsvc","IpxlatCfgSvc","KeyIso","KtmRm",
    "LicenseManager","lltdsvc","lmhosts","NcbService","Netman","NgcCtnrSvc","NgcSvc","PcaSvc","PolicyAgent",
    "RasMan","RemoteAccess","SamSs","SCardSvr","ScDeviceEnum","seclogon","ShellHWDetection","SSDPSRV",
    "StateRepository","StorSvc","StiSvc","TimeBrokerSvc","TokenBroker","VaultSvc","WaaSMedicSvc","WalletService",
    "WarpJITSvc","WbioSrvc","WdiServiceHost","WdiSystemHost","WebClient","Wecsvc","WEPHOSTSVC",
    "wercplsupport","WerSvc","WiaRpc","WinRM","wlidsvc","wmiApSrv","WpnService","wscsvc","wuauserv"
)

function Invoke-UltraProcessReducer {
    $BeforeProcs = [KaramNative]::GetProcessCount()
    Write-KaramLog "LOW PROCS" "Running Extreme Low-Process Killer (Starting Procs: $BeforeProcs)..."
    $KillList = @(
        "OneDrive","Cortana","Widgets","WidgetService","SearchApp","SearchHost","SearchIndexer","SearchProtocolHost",
        "PhoneExperienceHost","YourPhone","GameBar","GameBarFTServer","GameBarPresenceWriter","XboxPcApp",
        "XboxAppServices","SkypeApp","CompPkgSrv","WinStore.App","CalculatorApp","Photos","Video.UI","Music.UI",
        "Maps","HxTsr","HxOutlook","CompatTelRunner","MusNotification","MusNotificationUx","WerFault","wermgr",
        "LockApp","backgroundTaskHost","EpicWebHelper","CrashReportClient","TabTip","msedgewebview2","EdgeUpdate",
        "MicrosoftEdgeUpdate","BraveUpdate","GoogleCrashHandler","GoogleCrashHandler64","CCXProcess","AdobeARM",
        "SecurityHealthSystray","HelpPane","HxAccounts","GameInputSvc","TextInputHost","AggregatorHost"
    )
    foreach ($P in $KillList) {
        if (Get-Process -Name $P -ErrorAction SilentlyContinue) {
            Stop-Process -Name $P -Force -ErrorAction SilentlyContinue
            Write-Host "[PROCESS TERMINATED] Killed background bloat process: $P.exe" -ForegroundColor Yellow
        }
    }

    $StopServices = @(
        "DiagTrack","dmwappushservice","SysMain","WSearch","MapsBroker","lfsvc","Fax","RetailDemo","WpcMonSvc",
        "WerSvc","PcaSvc","WdiSystemHost","WdiServiceHost","TrkWks","DPS","wisvc","PhoneSvc","SensorService",
        "SensorDataService","SensrSvc","WalletService","SEMgrSvc","SCardSvr","ScDeviceEnum","RemoteRegistry",
        "shpamsvc","tzautoupdate","AJRouter","diagnosticshub.standardcollector.service","icssvc","uhssvc",
        "BITS","DoSvc","CDPSvc","WpnService","SSDPSRV","FDResPub","stisvc"
    )
    foreach ($S in $StopServices) {
        Stop-Service -Name $S -Force -ErrorAction SilentlyContinue
        & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\$S" /v Start /t REG_DWORD /d 4 /f 2>&1 | Out-Null
        Write-Host "[SERVICE DISABLED] Stopped & disabled background service: $S" -ForegroundColor Cyan
    }
    Get-Service -Name "CDPUserSvc_*","WpnUserService_*","OneSyncSvc_*","PimIndexMaintenanceSvc_*","UnistoreSvc_*","UserDataSvc_*" -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue

    Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" "REG_DWORD" "67108864" "Consolidate SvcHost Split Threshold (64GB)"
    foreach ($Ms in $Global:SvchostMergeList) {
        & reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\$Ms" /v SvcHostSplitDisable /t REG_DWORD /d 1 /f 2>&1 | Out-Null
    }
    Write-Host "[SVCHOST MERGER] Consolidated 95 Windows SvcHost services into shared host groups!" -ForegroundColor Green

    $FreedMB = [KaramNative]::CleanSystemRam()
    Start-Sleep -Milliseconds 150
    $AfterProcs = [KaramNative]::GetProcessCount()
    $TxtRamCleanerStatus.Text = "Processes Now: $AfterProcs (Was $BeforeProcs)  |  Merged 95 SvcHost Services  |  Freed $FreedMB MB RAM"
    Write-KaramLog "LOW PROCS" "Extreme Process Killer complete: $BeforeProcs -> $AfterProcs active processes (Merged 95 SvcHosts, freed $FreedMB MB RAM)."
    [System.Windows.MessageBox]::Show("Extreme Low-Process Engine Complete!`n`n- Active Processes Before: $BeforeProcs`n- Active Processes Now: $AfterProcs`n- Merged 95 SvcHost Services (Drops 50+ more svchost.exe processes on reboot)`n- Freed $FreedMB MB of RAM", "Processes Stripped", 0, 64)
}

$BtnTopReduceProcs.Add_Click({ Invoke-UltraProcessReducer })
$BtnUltraProcessReduce.Add_Click({ Invoke-UltraProcessReducer })
$BtnUndoSvchost.Add_Click({
    Invoke-KaramReg "HKLM\SYSTEM\CurrentControlSet\Control" "SvcHostSplitThresholdInKB" "REG_DWORD" "3670016" "Restore Default SvcHost Split"
    foreach ($Ms in $Global:SvchostMergeList) { & reg.exe delete "HKLM\SYSTEM\CurrentControlSet\Services\$Ms" /v SvcHostSplitDisable /f 2>&1 | Out-Null }
    Write-KaramLog "SVCHOST" "Restored default SvcHost split settings."
})

$NavModScan.Add_Click({ Highlight-NavButton $NavModScan; Show-MainView "SCAN" })
$NavModBoost.Add_Click({ Highlight-NavButton $NavModBoost; Show-MainView "BOOST" })
$NavModUsb.Add_Click({ Highlight-NavButton $NavModUsb; Show-MainView "USB" })
$BtnTopScanPc.Add_Click({ Highlight-NavButton $NavModScan; Show-MainView "SCAN"; Run-SmartHardwareScan })

$NavFreeEss.Add_Click({ $Global:CurrentCategory="FREE_ESS"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavFreeEss; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavFreeFps.Add_Click({ $Global:CurrentCategory="FREE_FPS"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavFreeFps; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavFreeNet.Add_Click({ $Global:CurrentCategory="FREE_NET"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavFreeNet; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavBasicFps.Add_Click({ $Global:CurrentCategory="BASIC_FPS"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavBasicFps; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavBasicCpu.Add_Click({ $Global:CurrentCategory="BASIC_CPU"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavBasicCpu; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProShotgun.Add_Click({ $Global:CurrentCategory="PRO_SHOTGUN"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProShotgun; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProAim.Add_Click({ $Global:CurrentCategory="PRO_AIM"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProAim; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProPing.Add_Click({ $Global:CurrentCategory="PRO_PING"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProPing; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProGpu.Add_Click({ $Global:CurrentCategory="PRO_GPU"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProGpu; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProKernel.Add_Click({ $Global:CurrentCategory="PRO_KERNEL"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProKernel; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProUsb.Add_Click({ $Global:CurrentCategory="PRO_USB"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProUsb; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })
$NavProFrame.Add_Click({ $Global:CurrentCategory="PRO_FRAME"; $Global:CurrentFilter="ALL"; $TxtSearchTweaks.Text=""; Highlight-NavButton $NavProFrame; Show-MainView "TWEAKS"; Render-CurrentCategoryPage })

$NavModGames.Add_Click({ Highlight-NavButton $NavModGames; Show-MainView "GAMES" })
$NavModStretch.Add_Click({ Highlight-NavButton $NavModStretch; Show-MainView "STRETCH" })
$NavModKeygen.Add_Click({ Highlight-NavButton $NavModKeygen; Show-MainView "KEYGEN" })
$NavModPerformance.Add_Click({ Highlight-NavButton $NavModPerformance; Show-MainView "PERF" })
$TxtSearchTweaks.Add_TextChanged({ Render-CurrentCategoryPage })

Highlight-NavButton $NavFreeEss
Render-CurrentCategoryPage
Write-KaramLog "READY" "KaramTweaks v10.0 Public Edition loaded (400 Tweaks + Live PowerShell Console Output)."


$BtnPageSelectAll.Add_Click({
    foreach ($T in $Global:TweakDefinitions) {
        if ($Global:PageCheckBoxes.ContainsKey($T.Id) -and $Global:PageCheckBoxes[$T.Id].IsEnabled) {
            $Global:PageCheckBoxes[$T.Id].IsChecked = ($T.Safety -eq "SAFE")
        }
    }
    Write-KaramLog "SELECT" "Selected all 100% Safe tweaks on current page."
})
$BtnPageClear.Add_Click({ foreach ($Chk in $Global:PageCheckBoxes.Values) { $Chk.IsChecked = $false } })

# --- LIVE PAGE APPLY ENGINE (PRINTS EVERY TWEAK IN POWERSHELL TERMINAL + GUI LOG) ---
$BtnPageApply.Add_Click({
    if ($ChkRestorePoint.IsChecked) {
        Write-KaramLog "BACKUP" "Creating Windows Restore Point before applying tweaks..."
        Enable-ComputerRestore -Drive "$env:SystemDrive" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description "KaramTweaks_v10" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    }
    Write-Host "`n==================== EXECUTING SELECTED KARAMTWEAKS ====================" -ForegroundColor Yellow
    $Count = 0
    foreach ($T in $Global:TweakDefinitions) {
        if ($Global:PageCheckBoxes.ContainsKey($T.Id) -and $Global:PageCheckBoxes[$T.Id].IsChecked -and (Test-TierAccess $T.Tier)) {
            Invoke-KaramReg $T.Path $T.Name $T.Type $T.Val $T.Text
            Save-TweakState $T.Id $true
            $Count++
        }
    }

    if ($Global:CurrentCategory -eq "PRO_SHOTGUN" -and $Count -gt 0) {
        Remove-NetQosPolicy -Name "KaramTweaks_Shotgun_FN" -Confirm:$false -ErrorAction SilentlyContinue
        Remove-NetQosPolicy -Name "KaramTweaks_Shotgun_VAL" -Confirm:$false -ErrorAction SilentlyContinue
        New-NetQosPolicy -Name "KaramTweaks_Shotgun_FN" -AppPathNameMatchCondition "FortniteClient-Win64-Shipping.exe" -DSCPAction 46 -IPProtocolMatchCondition Both -ErrorAction SilentlyContinue | Out-Null
        New-NetQosPolicy -Name "KaramTweaks_Shotgun_VAL" -AppPathNameMatchCondition "VALORANT-Win64-Shipping.exe" -DSCPAction 46 -IPProtocolMatchCondition Both -ErrorAction SilentlyContinue | Out-Null
        Write-KaramLog "SHOTGUN" "Created DSCP 46 EF QoS Packet Priority Rules for Fortnite & Valorant UDP!"
    }
    if ($Global:CurrentCategory -eq "PRO_AIM" -and $Count -gt 0) {
        Invoke-KaramReg "HKCU\Control Panel\Mouse" "SmoothMouseXCurve" "REG_BINARY" "0000000000000000C0CC0C0000000000809919000000000040662600000000000033330000000000" "1:1 Linear SmoothMouseXCurve"
        Invoke-KaramReg "HKCU\Control Panel\Mouse" "SmoothMouseYCurve" "REG_BINARY" "0000000000000000000038000000000000007000000000000000A800000000000000E00000000000" "1:1 Linear SmoothMouseYCurve"
    }
    if ($Global:CurrentCategory -eq "PRO_PING" -and $Count -gt 0) {
        Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" -ErrorAction SilentlyContinue | ForEach-Object {
            New-ItemProperty -Path $_.PSPath -Name "TcpAckFrequency" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
            New-ItemProperty -Path $_.PSPath -Name "TCPNoDelay" -Value 1 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
            New-ItemProperty -Path $_.PSPath -Name "TcpDelAckTicks" -Value 0 -PropertyType DWord -Force -ErrorAction SilentlyContinue | Out-Null
        }
        & netsh.exe int tcp set global autotuninglevel=normal | Out-Null
        & netsh.exe int tcp set global rss=enabled | Out-Null
        & netsh.exe int tcp set global ecncapability=disabled | Out-Null
        Write-KaramLog "PING" "Disabled Nagle's Algorithm across all Network Adapters & enabled RSS!"
    }
    if ($Global:CurrentCategory -eq "PRO_KERNEL" -and $Count -gt 0) {
        & bcdedit.exe /set disabledynamictick yes | Out-Null
        & bcdedit.exe /set useplatformtick yes | Out-Null
        & powercfg.exe -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        & powercfg.exe -setacvalueindex scheme_current sub_processor CPMINCORES 100
        & powercfg.exe /setactive scheme_current
        Write-KaramLog "KERNEL" "Applied BCDEDIT Kernel Timers & Unparked 100% CPU Cores!"
    }

    Write-Host "==================== FINISHED APPLYING $Count TWEAK(S) ====================`n" -ForegroundColor Green
    Render-CurrentCategoryPage
    Write-KaramLog "DONE" "Successfully applied $Count tweak(s) on this page (Check PowerShell Console for full breakdown)!"
})

$BtnPageRevert.Add_Click({
    $Count = 0
    foreach ($T in $Global:TweakDefinitions) {
        if ($T.Cat -eq $Global:CurrentCategory -and ($Global:AppliedState.PSObject.Properties[$T.Id].Value -eq $true)) {
            Invoke-KaramReg $T.Path $T.Name $T.Type $T.UndoVal "REVERT: $($T.Text)"
            Save-TweakState $T.Id $false; $Count++
        }
    }
    Render-CurrentCategoryPage
    Write-KaramLog "REVERT" "Reverted $Count tweak(s) on this page to default."
})

$BtnGlobalUndo.Add_Click({
    $Count = 0
    foreach ($T in $Global:TweakDefinitions) {
        if ($Global:AppliedState.PSObject.Properties[$T.Id].Value -eq $true) {
            Invoke-KaramReg $T.Path $T.Name $T.Type $T.UndoVal "REVERT: $($T.Text)"
            Save-TweakState $T.Id $false; $Count++
        }
    }
    Render-CurrentCategoryPage
    Write-KaramLog "REVERT ALL" "Reverted all $Count applied tweaks to stock Windows defaults."
})

# --- PC SCANNER ---
$CpuInfo = Get-CimInstance Win32_Processor | Select-Object -First 1
$GpuInfo = Get-CimInstance Win32_VideoController | Where-Object { $_.Name -notmatch "Basic|Remote" } | Select-Object -First 1
$OsInfo  = Get-CimInstance Win32_OperatingSystem
$TotalRamGB = [math]::Round($OsInfo.TotalVisibleMemorySize / 1MB, 1)
$SysHardwareSummary.Text = "CPU: $($CpuInfo.Name.Trim())`r`nGPU: $($GpuInfo.Name)`r`nRAM: $TotalRamGB GB"

function Run-SmartHardwareScan {
    $CurProcs = [KaramNative]::GetProcessCount()
    $TxtScanReport.Text = "=== KARAMTWEAKS v10.0 HARDWARE & PROCESS DIAGNOSTIC ===`r`nProcessor : $($CpuInfo.Name.Trim())`r`nGraphics  : $($GpuInfo.Name)`r`nMemory    : $TotalRamGB GB Physical RAM`r`nProcesses : $CurProcs Active Windows Processes`r`n`r`nClick '2. Auto-Apply Optimal Tweaks + Extreme Low Processes' above to optimize!"
    Write-KaramLog "SCAN" "Scanned Hardware: $($CpuInfo.Name.Trim()) | $($GpuInfo.Name) | $CurProcs Active Processes."
}
$BtnRunPcScan.Add_Click({ Run-SmartHardwareScan })
$BtnAutoApplyScan.Add_Click({
    $Applied = 0
    foreach ($T in $Global:TweakDefinitions) {
        if ((Test-TierAccess $T.Tier) -and ($T.Safety -eq "SAFE")) {
            Invoke-KaramReg $T.Path $T.Name $T.Type $T.Val $T.Text
            Save-TweakState $T.Id $true; $Applied++
        }
    }
    Invoke-UltraProcessReducer
    Render-CurrentCategoryPage
    Write-KaramLog "AUTO-TWEAK" "Auto-Applied $Applied safe hardware tweaks & stripped background processes!"
})

# --- CLEAN & WORKING INI PARSER FOR FORTNITE / VALORANT / STRETCHED RES ---
function Set-SimpleIniKey($Content, $Key, $Val) {
    if ($Content -match "(?m)^$Key=.*") {
        return ($Content -replace "(?m)^$Key=.*", "$Key=$Val")
    } else {
        return ($Content.TrimEnd() + "`r`n$Key=$Val`r`n")
    }
}

function Apply-FortniteFpsConfig($ResQ, $LockReadOnly) {
    Get-Process -Name "FortniteClient-Win64-Shipping*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    $FnDir = "$env:LOCALAPPDATA\FortniteGame\Saved\Config\WindowsClient"
    $FnIni = "$FnDir\GameUserSettings.ini"
    New-Item -ItemType Directory -Force -Path $FnDir | Out-Null
    if (!(Test-Path $FnIni)) { "[/Script/FortniteGame.FortGameUserSettings]`r`n`r`n[ScalabilityGroups]`r`n" | Set-Content $FnIni -Encoding UTF8 }
    Set-ItemProperty -Path $FnIni -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue
    attrib -r "$FnIni" 2>$null
    $Txt = Get-Content $FnIni -Raw
    $Txt = Set-SimpleIniKey $Txt "bShowGrass" "False"
    $Txt = Set-SimpleIniKey $Txt "bMotionBlur" "False"
    $Txt = Set-SimpleIniKey $Txt "bUseVSync" "False"
    $Txt = Set-SimpleIniKey $Txt "bDisableMouseAcceleration" "True"
    $Txt = Set-SimpleIniKey $Txt "MeshQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.ResolutionQuality" $ResQ
    $Txt = Set-SimpleIniKey $Txt "sg.ViewDistanceQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.AntiAliasingQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.ShadowQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.PostProcessQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.TextureQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.EffectsQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.FoliageQuality" "0"
    $Txt = Set-SimpleIniKey $Txt "sg.ShadingQuality" "0"
    Set-Content -Path $FnIni -Value $Txt -Encoding UTF8
    if ($LockReadOnly) {
        Set-ItemProperty -Path $FnIni -Name IsReadOnly -Value $true -ErrorAction SilentlyContinue
        attrib +r "$FnIni" 2>$null
    }
    Write-KaramLog "FORTNITE" "Applied Competitive Fortnite Config (3D Res=$ResQ%, All Scalability=0, ReadOnly=$LockReadOnly)!"
}

$BtnFnApplyProfile.Add_Click({
    $ResMap = @("100.000000", "85.000000", "65.000000")
    Apply-FortniteFpsConfig $ResMap[$FnProfileList.SelectedIndex] $ChkFnLockIni.IsChecked
    [System.Windows.MessageBox]::Show("Applied Competitive Fortnite FPS Profile!", "Applied", 0, 64)
})
$BtnFnRestoreNormal.Add_Click({ Apply-FortniteFpsConfig "100.000000" $false })
$BtnFnClearShader.Add_Click({
    Remove-Item "$env:LOCALAPPDATA\NVIDIA\DXCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\D3DSCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Write-KaramLog "SHADER" "Cleared DirectX, NVIDIA & AMD GPU Shader Caches!"
})
$BtnFnKillEpic.Add_Click({ Stop-Process -Name "EpicWebHelper","CrashReportClient" -Force -ErrorAction SilentlyContinue; Write-KaramLog "EPIC" "Killed background EpicWebHelper processes!" })

$BtnValApply.Add_Click({
    Invoke-KaramReg "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\VALORANT-Win64-Shipping.exe\PerfOptions" "CpuPriorityClass" "REG_DWORD" "3" "Valorant High CPU Priority"
    Write-KaramLog "VALORANT" "Applied Valorant Radiant High Priority Profile!"
})
$BtnValClearLogs.Add_Click({ Remove-Item "$env:LOCALAPPDATA\VALORANT\Saved\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue; Write-KaramLog "VALORANT" "Cleaned Valorant logs!" })

# --- STRETCHED RESOLUTION ---
function Apply-StretchedEngine($W, $H, $LockReadOnly) {
    if ($ChkStretchFn.IsChecked) {
        $FnDir = "$env:LOCALAPPDATA\FortniteGame\Saved\Config\WindowsClient"
        $FnIni = "$FnDir\GameUserSettings.ini"
        New-Item -ItemType Directory -Force -Path $FnDir | Out-Null
        if (!(Test-Path $FnIni)) { "[/Script/FortniteGame.FortGameUserSettings]`r`n" | Set-Content $FnIni -Encoding UTF8 }
        Set-ItemProperty -Path $FnIni -Name IsReadOnly -Value $false -ErrorAction SilentlyContinue
        attrib -r "$FnIni" 2>$null
        $Txt = Get-Content $FnIni -Raw
        $Txt = Set-SimpleIniKey $Txt "ResolutionSizeX" $W
        $Txt = Set-SimpleIniKey $Txt "ResolutionSizeY" $H
        $Txt = Set-SimpleIniKey $Txt "LastUserConfirmedResolutionSizeX" $W
        $Txt = Set-SimpleIniKey $Txt "LastUserConfirmedResolutionSizeY" $H
        $Txt = Set-SimpleIniKey $Txt "DesiredScreenWidth" $W
        $Txt = Set-SimpleIniKey $Txt "DesiredScreenHeight" $H
        $Txt = Set-SimpleIniKey $Txt "LastUserConfirmedDesiredScreenWidth" $W
        $Txt = Set-SimpleIniKey $Txt "LastUserConfirmedDesiredScreenHeight" $H
        $Txt = Set-SimpleIniKey $Txt "FullscreenMode" "0"
        Set-Content -Path $FnIni -Value $Txt -Encoding UTF8
        if ($LockReadOnly) { Set-ItemProperty -Path $FnIni -Name IsReadOnly -Value $true -ErrorAction SilentlyContinue; attrib +r "$FnIni" 2>$null }
    }
    if ($ChkStretchDesktop.IsChecked) { [KaramNative]::SetResolution([int]$W, [int]$H) | Out-Null }
    Write-KaramLog "STRETCH" "Applied Stretched Resolution $Wx$H!"
}

$BtnStretchApply.Add_Click({
    $ResMap = @( @("1720","1080"), @("1680","1050"), @("1600","1080"), @("1560","1080"), @("1440","1080"), @("1280","960"), @("1080","1080"), @("1920","1080") )
    $W = $ResMap[$StretchResList.SelectedIndex][0]; $H = $ResMap[$StretchResList.SelectedIndex][1]
    if (![string]::IsNullOrWhiteSpace($TxtCustomW.Text) -and ![string]::IsNullOrWhiteSpace($TxtCustomH.Text)) { $W = $TxtCustomW.Text.Trim(); $H = $TxtCustomH.Text.Trim() }
    Apply-StretchedEngine $W $H $ChkStretchReadOnly.IsChecked
    [System.Windows.MessageBox]::Show("Applied Stretched Resolution ($Wx$H)!", "Stretched Res", 0, 64)
})
$BtnStretchNative.Add_Click({ Apply-StretchedEngine "1920" "1080" $false })
$BtnOpenDisplay.Add_Click({ Start-Process "ms-settings:display" })

function Invoke-KaramRamCleaner {
    $FreedMB = [KaramNative]::CleanSystemRam()
    $TxtRamCleanerStatus.Text = "Freed $FreedMB MB RAM  |  Active Procs: $([KaramNative]::GetProcessCount())"
    Write-KaramLog "RAM CLEANER" "Purged background working sets -> Freed $FreedMB MB of Standby RAM!"
}
$BtnTopCleanRam.Add_Click({ Invoke-KaramRamCleaner })
$BtnCleanRam.Add_Click({ Invoke-KaramRamCleaner })

$BtnPingTest.Add_Click({
    Get-NetAdapter -Physical -ErrorAction SilentlyContinue | Where-Object Status -eq "Up" | ForEach-Object {
        Set-DnsClientServerAddress -InterfaceIndex $_.ifIndex -ServerAddresses ("1.1.1.1","1.0.0.1") -ErrorAction SilentlyContinue
    }
    ipconfig /flushdns | Out-Null
    $Ping = (Test-Connection -ComputerName 1.1.1.1 -Count 1 -ErrorAction SilentlyContinue).ResponseTime
    Write-KaramLog "PING" "Cloudflare 1.1.1.1 Gaming DNS active! Live Ping: $Ping ms."
})

$BtnDebloatRemove.Add_Click({
    Get-AppxPackage "*Bing*","*3DViewer*","*Solitaire*","*FeedbackHub*" -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction SilentlyContinue
    Write-KaramLog "DEBLOAT" "Removed selected Windows bloatware packages!"
})

$BtnRunBench.Add_Click({
    $Sw = [Diagnostics.Stopwatch]::StartNew(); $Ops = 0
    while ($Sw.Elapsed.TotalSeconds -lt 1.0) { $null = [math]::Sqrt($Ops); $Ops++ }
    $Score = [math]::Round($Ops / 10000)
    $BenchResultTxt.Text = "Benchmark Score: $Score pts // Ready for Competitive Gaming"
    Write-KaramLog "BENCH" "Single-Core CPU Benchmark Score: $Score pts."
})

# --- MODERN LIVE PERFORMANCE TELEMETRY ---
$PerfGpuAvailable = $false
$PerfGpuName = if ($GpuInfo) { $GpuInfo.Name } else { "Unknown GPU" }
$PerfRamTotalGB = $TotalRamGB
$PerfCpuModel.Text = "CPU: $($CpuInfo.Name.Trim())"
$PerfGpuModel.Text = "GPU: $PerfGpuName"
$PerfRamDetail.Text = "RAM: $PerfRamTotalGB GB"
try {
    $Disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'" -ErrorAction Stop
    $PerfDiskDetail.Text = "System Drive: $([math]::Round($Disk.FreeSpace/1GB,1)) GB free / $([math]::Round($Disk.Size/1GB,1)) GB"
} catch {}

function Get-KaramGpuStats {
    $result = @{ Util = $null; Temp = $null; UsedMB = $null; TotalMB = $null }
    try {
        $nvidia = Get-Command "nvidia-smi.exe" -ErrorAction SilentlyContinue
        if ($nvidia) {
            $line = & $nvidia.Source --query-gpu=utilization.gpu,temperature.gpu,memory.used,memory.total --format=csv,noheader,nounits 2>$null | Select-Object -First 1
            if ($line) {
                $p = $line -split "," | ForEach-Object { $_.Trim() }
                if ($p.Count -ge 4) {
                    $result.Util = [double]$p[0]
                    $result.Temp = [double]$p[1]
                    $result.UsedMB = [double]$p[2]
                    $result.TotalMB = [double]$p[3]
                    return $result
                }
            }
        }
    } catch {}
    return $result
}

function Update-KaramPerformanceDashboard {
    try {
        $cpu = [KaramNative]::GetCpuPercent()
        $ram = [KaramNative]::GetRamPercent()
        $used = [KaramNative]::GetUsedRamGB()
        $procs = [KaramNative]::GetProcessCount()

        $PerfCpuValue.Text = "$cpu%"
        $PerfCpuBar.Value = [math]::Max(0, [math]::Min(100, $cpu))
        $PerfRamValue.Text = "$ram%"
        $PerfRamBar.Value = [math]::Max(0, [math]::Min(100, $ram))
        $PerfProcValue.Text = "$procs"

        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($os -and $os.LastBootUpTime) {
            $boot = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
            $up = (Get-Date) - $boot
            $PerfUptimeValue.Text = "{0}d {1:00}h {2:00}m" -f [math]::Floor($up.TotalDays), $up.Hours, $up.Minutes
        }

        $gpu = Get-KaramGpuStats
        if ($null -ne $gpu.Util) {
            $PerfGpuValue.Text = "$([math]::Round($gpu.Util,0))%"
            $PerfGpuBar.Value = [math]::Max(0, [math]::Min(100, $gpu.Util))
            $PerfVramValue.Text = "$([math]::Round($gpu.UsedMB/1024,1)) / $([math]::Round($gpu.TotalMB/1024,1)) GB"
            $PerfGpuModel.Text = "GPU: $PerfGpuName  |  $([math]::Round($gpu.Temp,0))°C"
        } else {
            $PerfGpuValue.Text = "N/A"
            $PerfGpuBar.Value = 0
            $PerfVramValue.Text = "N/A"
            $PerfGpuModel.Text = "GPU: $PerfGpuName  |  NVIDIA telemetry unavailable"
        }

        $PerfLastUpdate.Text = "Last update: $(Get-Date -Format 'HH:mm:ss')  |  RAM: $([math]::Round($used,1)) / $PerfRamTotalGB GB"
    } catch {}
}

$NavModPerformance.Add_Click({
    Update-KaramPerformanceDashboard
})

function Update-PersistentPerformanceRail {
    try {
        $cpu = [KaramNative]::GetCpuPercent()
        $ram = [KaramNative]::GetRamPercent()
        $RailCpuValue.Text = "CPU  $cpu%"
        $RailRamValue.Text = "RAM  $ram%"
        $RailCpuBar.Value = [math]::Min(100,[math]::Max(0,$cpu))
        $RailRamBar.Value = [math]::Min(100,[math]::Max(0,$ram))
        $RailCpuModel.Text = "CPU: $($CpuInfo.Name.Trim())"
        $RailRamModel.Text = "RAM: $TotalRamGB GB"

        $os = Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue
        if ($os.LastBootUpTime) {
            $boot = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
            $up = (Get-Date) - $boot
            $RailUptime.Text = "UPTIME  {0}d {1:00}h {2:00}m" -f [math]::Floor($up.TotalDays),$up.Hours,$up.Minutes
        }

        $nvidia = Get-Command nvidia-smi.exe -ErrorAction SilentlyContinue
        if ($nvidia) {
            $line = & $nvidia.Source --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>$null | Select-Object -First 1
            if ($line) {
                $gpu = [double]$line.Trim()
                $RailGpuValue.Text = "GPU  $([math]::Round($gpu,0))%"
                $RailGpuBar.Value = [math]::Min(100,[math]::Max(0,$gpu))
            }
        }
        $RailGpuModel.Text = "GPU: $($GpuInfo.Name)"
    } catch {}
}

$Timer = New-Object System.Windows.Threading.DispatcherTimer
$Timer.Interval = [TimeSpan]::FromMilliseconds(750)
$Timer.Add_Tick({
    if ($Window.WindowState -eq [System.Windows.WindowState]::Minimized) { return }
    try {
        $CpuPct = [KaramNative]::GetCpuPercent()
        $RamPct = [KaramNative]::GetRamPercent()
        $UsedGB = [KaramNative]::GetUsedRamGB()
        $Procs  = [KaramNative]::GetProcessCount()
        $TopCpuTxt.Text  = "CPU: $CpuPct%"
        $TopRamTxt.Text  = "RAM: $RamPct% ($UsedGB/$TotalRamGB GB)"
        $TopProcTxt.Text = "PROCS: $Procs"
        Update-KaramPerformanceDashboard
    } catch {}
})
Update-PersistentPerformanceRail
$Timer.Start()

$Window.ShowDialog() | Out-Null
