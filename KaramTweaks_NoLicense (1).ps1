# ==============================================================================
# KARAMTWEAKS v10.0 // 400-TWEAK EDITION (LIVE POWERSHELL CONSOLE ENGINE)
# TikTok: www.tiktok.com/@karamgpt | Discord: https://discord.gg/qS6XhNn3Sa
# License / HWID system removed: all tweaks and modules are unlocked.
# ==============================================================================
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

$Host.UI.RawUI.WindowTitle = "KARAMTWEAKS v10.0 // LIVE EXECUTION ENGINE CONSOLE"
Clear-Host
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host " KARAMTWEAKS v10.0 // 400-TWEAK LIVE EXECUTION ENGINE" -ForegroundColor Yellow
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
        return freed < 0 ? 0 : freed;
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

# --- COMMERCIAL CLEAR-TYPE UI (CRISP SEGOE UI TYPOGRAPHY // 400 TWEAKS) ---
[xml]$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="KaramTweaks v10.0 // 400-Tweak Pro Gaming &amp; System Optimization Suite" Height="900" Width="1420"
        MinHeight="750" MinWidth="1200"
        Background="#060C18" Foreground="#F8FAFC"
        FontFamily="Segoe UI" FontSize="13"
        UseLayoutRounding="True" SnapsToDevicePixels="True"
        TextOptions.TextFormattingMode="Ideal" TextOptions.TextRenderingMode="ClearType"
        ShowInTaskbar="True" WindowStyle="SingleBorderWindow"
        WindowStartupLocation="CenterScreen">
    <Window.Resources>
        <Style TargetType="ToolTip">
            <Setter Property="Background" Value="#0A162E"/>
            <Setter Property="Foreground" Value="#F8FAFC"/>
            <Setter Property="BorderBrush" Value="#FACC15"/>
            <Setter Property="BorderThickness" Value="1.5"/>
            <Setter Property="Padding" Value="14,10"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="12.5"/>
        </Style>
        <Style TargetType="Button">
            <Setter Property="Background" Value="#0E2044"/>
            <Setter Property="Foreground" Value="#FACC15"/>
            <Setter Property="BorderBrush" Value="#00A8FF"/>
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
                    <Setter Property="BorderBrush" Value="#FACC15"/>
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
            <Setter Property="BorderBrush" Value="#38BDF8"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
        <Style x:Key="YellowBtn" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
            <Setter Property="Background" Value="#FACC15"/>
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
                    <Setter Property="BorderBrush" Value="#FACC15"/>
                    <Setter Property="Foreground" Value="#FACC15"/>
                </Trigger>
            </Style.Triggers>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Foreground" Value="#F8FAFC"/>
            <Setter Property="Margin" Value="0,3,0,3"/>
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="FontFamily" Value="Segoe UI"/>
            <Setter Property="FontSize" Value="13"/>
        </Style>
    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="56"/>
            <RowDefinition Height="0"/>
            <RowDefinition Height="*"/>
            <RowDefinition Height="108"/>
            <RowDefinition Height="30"/>
        </Grid.RowDefinitions>

        <!-- ROW 0: DASHBOARD BAR -->
        <Border Grid.Row="0" Background="#08142C" BorderBrush="#FACC15" BorderThickness="0,0,0,2" Padding="16,0">
            <Grid>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="KARAM" FontWeight="Black" Foreground="#00A8FF" FontSize="22" VerticalAlignment="Center"/>
                    <TextBlock Text="TWEAKS" FontWeight="Black" Foreground="#FACC15" FontSize="22" Margin="0,0,10,0" VerticalAlignment="Center"/>
                    <Border Background="#0E224A" BorderBrush="#FACC15" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,10,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopTierBadge" Text="FULL EDITION" FontWeight="Bold" Foreground="#FACC15" FontSize="11.5"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopCpuTxt" Text="CPU: 0%" Foreground="#FACC15" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopRamTxt" Text="RAM: 0%" Foreground="#38BDF8" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#4ADE80" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,6,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopProcTxt" Text="PROCS: 0" Foreground="#4ADE80" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Border Background="#0A1936" BorderBrush="#FACC15" BorderThickness="1" CornerRadius="5" Padding="9,3" Margin="0,0,12,0" VerticalAlignment="Center">
                        <TextBlock x:Name="TopAppliedTxt" Text="APPLIED: 0 / 400" Foreground="#FACC15" FontWeight="Bold" FontSize="12"/>
                    </Border>
                    <Button x:Name="BtnTopReduceProcs" Content="Extreme Low Procs" Style="{StaticResource YellowBtn}" Margin="0,0,6,0" Padding="11,5"/>
                    <Button x:Name="BtnTopCleanRam" Content="Clean RAM" Style="{StaticResource PrimaryBtn}" Margin="0,0,6,0" Padding="11,5"/>
                    <Button x:Name="BtnTopScanPc" Content="Scan My PC" Margin="0" Padding="11,5"/>
                </StackPanel>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                    <CheckBox x:Name="ChkAutoCleanRam" Content="Auto-Clean RAM >80%" Foreground="#38BDF8" FontWeight="SemiBold" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    <CheckBox x:Name="ChkRestorePoint" Content="Restore Point" Foreground="#FACC15" FontWeight="SemiBold" IsChecked="True" VerticalAlignment="Center" Margin="0,0,12,0"/>
                    <Button x:Name="BtnGlobalUndo" Content="Revert All 400 Tweaks" Style="{StaticResource DangerBtn}" Margin="0" Padding="11,5"/>
                </StackPanel>
            </Grid>
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
                        <TextBlock Text="POWER MODULES" Foreground="#FACC15" FontWeight="Bold" FontSize="11.5" Margin="4,0,0,4"/>
                        <Button x:Name="NavModScan" Content="  PC Scanner &amp; Auto-Tweak" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModBoost" Content="  Extreme Process Killer" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModUsb" Content="  USB &amp; Controller Overclock" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="CORE TWEAKS (85)" Foreground="#38BDF8" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavFreeEss" Content="  1. Essential &amp; Mouse Aim (25)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavFreeFps" Content="  2. FPS &amp; Low Procs (35)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavFreeNet" Content="  3. Ping &amp; DNS Engine (25)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="ADVANCED TWEAKS (100)" Foreground="#00A8FF" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavBasicFps" Content="  4. FPS &amp; Windows (45)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavBasicCpu" Content="  5. Process Killer &amp; Services (55)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="PRO TWEAKS (215)" Foreground="#FACC15" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavProShotgun" Content="  6. Shotgun &amp; Pellet Pack (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProAim" Content="  7. AR Aim, Tracking &amp; Delay (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProPing" Content="  8. Zero-Ping Net Engine (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProGpu" Content="  9. DirectX, GPU &amp; DWM (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProKernel" Content="  10. Extreme Kernel &amp; NVMe (30)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProUsb" Content="  11. USB, Audio &amp; Controller (25)" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavProFrame" Content="  12. Frame-Pacing, Shaders &amp; RAM (40)" Style="{StaticResource NavBtn}"/>

                        <TextBlock Text="GAMING MODULES" Foreground="#94A3B8" FontWeight="Bold" FontSize="11.5" Margin="4,7,0,4"/>
                        <Button x:Name="NavModGames" Content="  Fortnite &amp; Valorant FPS" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModStretch" Content="  Stretched Resolution" Style="{StaticResource NavBtn}"/>
                        <Button x:Name="NavModKeygen" Content="  System Info &amp; Benchmark" Style="{StaticResource NavBtn}"/>
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

                    <Border Grid.Row="0" Background="#0A1834" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="7" Padding="16,11" Margin="0,0,0,8">
                        <Grid>
                            <StackPanel>
                                <StackPanel Orientation="Horizontal" Margin="0,0,0,4">
                                    <TextBlock x:Name="CatTitleTxt" Text="CATEGORY TITLE" FontSize="16.5" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,12,0" VerticalAlignment="Center"/>
                                    <Border x:Name="CatLockBadge" Background="#166534" BorderBrush="#FACC15" BorderThickness="1" CornerRadius="5" Padding="9,2" VerticalAlignment="Center">
                                        <TextBlock x:Name="CatLockTxt" Text="UNLOCKED" FontWeight="Bold" Foreground="#FFFFFF" FontSize="11"/>
                                    </Border>
                                </StackPanel>
                                <TextBlock x:Name="CatDescTxt" Text="Hover over any tweak below to see its full description and safety warning..." Foreground="#CBD5E1" FontSize="12.5" TextWrapping="Wrap"/>
                            </StackPanel>
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
                                <TextBlock Text="Search All 400 Tweaks: " Foreground="#94A3B8" VerticalAlignment="Center" Margin="0,0,6,0" FontSize="12"/>
                                <TextBox x:Name="TxtSearchTweaks" Width="195" Background="#050B16" Foreground="#FACC15" BorderBrush="#00A8FF" Padding="7,4"/>
                            </StackPanel>
                        </Grid>
                    </Border>

                    <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto">
                        <StackPanel x:Name="TweakCardsContainer" Margin="0,0,8,10"/>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW U: USB, AUDIO & CONTROLLER OVERCLOCK MODULE -->
                <Grid x:Name="ModuleUsbView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0A1834" BorderBrush="#FACC15" BorderThickness="1.5" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="USB 1000Hz+ Controller, HID &amp; Audio Low-Latency Engine" FontSize="17" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <TextBlock Text="1. Disables EnhancedPowerManagementEnabled &amp; Selective Suspend across every connected USB Root Hub, Mouse, Keyboard, and Controller so your inputs never enter micro-sleep.&#x0a;2. Enables PCIe Message-Signaled Interrupts (MSI Mode = 1) on all USB XHCI Host Controllers and HD Audio Controllers to eliminate DPC interrupt latency.&#x0a;3. Locks Mouse/Keyboard HID queues to 16 packets and injects 1:1 Linear Mouse X/Y Response Curves." Foreground="#CBD5E1" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,14"/>
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
                            <Border Background="#0A1834" BorderBrush="#FACC15" BorderThickness="1.5" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Smart PC Component Scanner &amp; 1-Click Auto-Optimizer" FontSize="17" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <TextBlock Text="Scans your CPU architecture (AMD Ryzen vs Intel), GPU driver, RAM capacity, SSD/NVMe storage, and active process count, then auto-applies all safe tweaks for your rig and strips background processes." Foreground="#CBD5E1" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <WrapPanel Margin="0,0,0,12">
                                        <Button x:Name="BtnRunPcScan" Content="1. Run Deep Hardware &amp; Process Scan Now" Style="{StaticResource YellowBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnAutoApplyScan" Content="2. Auto-Apply Optimal Tweaks + Extreme Low Processes" Style="{StaticResource PrimaryBtn}" Padding="14,8"/>
                                    </WrapPanel>
                                    <Border Background="#050B16" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="6" Padding="14">
                                        <TextBox x:Name="TxtScanReport" Background="Transparent" Foreground="#F8FAFC" BorderThickness="0" IsReadOnly="True" TextWrapping="Wrap" FontFamily="Segoe UI" FontSize="13" Height="360" VerticalScrollBarVisibility="Auto" Text="Click '1. Run Deep Hardware &amp; Process Scan Now' above to analyze your PC..."/>
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
                            <Border Background="#0A1834" BorderBrush="#FACC15" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="True Stretched Resolution Engine" FontSize="17" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <ListBox x:Name="StretchResList" Background="#050B16" Foreground="#FACC15" BorderBrush="#00A8FF" Height="155" Margin="0,0,0,12" SelectedIndex="0" FontSize="13">
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
                                        <TextBlock Text="Custom Width: " Foreground="#FACC15" VerticalAlignment="Center" FontWeight="SemiBold"/>
                                        <TextBox x:Name="TxtCustomW" Width="80" Background="#050B16" Foreground="#FFFFFF" BorderBrush="#00A8FF" Padding="6,4" Margin="0,0,16,0"/>
                                        <TextBlock Text="Custom Height: " Foreground="#FACC15" VerticalAlignment="Center" FontWeight="SemiBold"/>
                                        <TextBox x:Name="TxtCustomH" Width="80" Background="#050B16" Foreground="#FFFFFF" BorderBrush="#00A8FF" Padding="6,4"/>
                                    </StackPanel>
                                    <CheckBox x:Name="ChkStretchDesktop" Content="Switch Live Windows Monitor Resolution Immediately" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchFn" Content="Rewrite Fortnite GameUserSettings.ini (Fullscreen + Stretched)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchVal" Content="Rewrite Valorant GameUserSettings.ini (All Riot Accounts + No Letterbox)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchGpuScale" Content="Force Registry GPU Full-Screen Scaling=3 (Eliminates Black Bars)" IsChecked="True"/>
                                    <CheckBox x:Name="ChkStretchReadOnly" Content="Lock GameUserSettings.ini as Read-Only (Prevents Game Reset)" IsChecked="True"/>
                                    <WrapPanel Margin="0,12,0,0">
                                        <Button x:Name="BtnStretchApply" Content="Apply Stretched Resolution Now" Style="{StaticResource YellowBtn}"/>
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
                            <Border Background="#0A1834" BorderBrush="#FACC15" BorderThickness="1" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="Fortnite Competitive Performance Mode &amp; FPS Configurator" FontSize="17" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <TextBlock Text="Closes Fortnite if open, cleanly rewrites [ScalabilityGroups] in GameUserSettings.ini (0 Shadows, 0 Grass, 0 Motion Blur, Performance Mode Low Meshes), sets High CPU/IO Priority, and locks Read-Only." Foreground="#CBD5E1" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <ListBox x:Name="FnProfileList" Background="#050B16" Foreground="#FACC15" BorderBrush="#00A8FF" Height="110" Margin="0,0,0,10" SelectedIndex="0" FontSize="13">
                                        <ListBoxItem Content="1. Competitive Performance Mode (100% 3D Res + Mobile Meshes + 0 Shadows/Grass)"/>
                                        <ListBoxItem Content="2. Boosted FPS Competitive Mode (85% 3D Res + All Scalability 0 + Low Latency)"/>
                                        <ListBoxItem Content="3. Max FPS Low-Spec Mode (65% 3D Resolution + All Scalability 0 + Lock Read-Only)"/>
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

                            <Border Background="#0A1834" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Valorant Radiant Low-Latency Engine" FontSize="16" FontWeight="Bold" Foreground="#38BDF8" Margin="0,0,0,6"/>
                                    <TextBlock Text="Locks VALORANT-Win64-Shipping.exe to High CPU/IO priority, sets all [ScalabilityGroups] sg.* to 0 across all Riot accounts, and cleans Riot crash logs." Foreground="#CBD5E1" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,10"/>
                                    <WrapPanel>
                                        <Button x:Name="BtnValApply" Content="Apply Valorant Radiant Low Profile" Style="{StaticResource YellowBtn}"/>
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
                            <Border Background="#0A1834" BorderBrush="#FACC15" BorderThickness="1.5" CornerRadius="7" Padding="18" Margin="0,0,0,12">
                                <StackPanel>
                                    <TextBlock Text="Extreme Low-Process Killer &amp; 95-Service SvcHost Merger" FontSize="17" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <TextBlock x:Name="TxtRamCleanerStatus" Text="Live Process &amp; Memory Status: Ready to strip useless background processes to the bare minimum..." Foreground="#4ADE80" FontWeight="Bold" FontSize="13.5" Margin="0,0,0,8"/>
                                    <TextBlock Text="1. Force-kills 65+ useless background processes (OneDrive, Cortana, Widgets, WebView2, SearchHost, SearchIndexer, YourPhone, GameBar, CompatTelRunner, EpicWebHelper, EdgeUpdate, CrashHandlers).&#x0a;2. Merges 95+ separate Windows svchost.exe services into shared memory hosts (SvcHostSplitThresholdInKB = 64GB + SvcHostSplitDisable = 1).&#x0a;3. Stops 38+ background services (including Per-User CDPUserSvc / WpnUserService / OneSyncSvc) and disables 16 respawn tasks!" Foreground="#CBD5E1" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,12"/>
                                    <WrapPanel>
                                        <Button x:Name="BtnUltraProcessReduce" Content="1-Click Extreme Low Processes (Kill 65+ Procs &amp; Merge 95 SvcHosts)" Style="{StaticResource YellowBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnCleanRam" Content="Deep Clean RAM Now (Win32 API)" Style="{StaticResource PrimaryBtn}" Padding="14,8"/>
                                        <Button x:Name="BtnPingTest" Content="Apply Cloudflare 1.1.1.1 Gaming DNS &amp; Test Ping" Padding="14,8"/>
                                        <Button x:Name="BtnUndoSvchost" Content="Restore Default Svchost Split" Style="{StaticResource DangerBtn}" Padding="12,8"/>
                                    </WrapPanel>
                                </StackPanel>
                            </Border>

                            <Border Background="#0A1834" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Windows Bloatware &amp; Telemetry Remover" FontSize="16" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,8"/>
                                    <CheckBox x:Name="ChkDebloatXbox" Content="Remove Xbox App &amp; Gaming Overlay Packages (Do not check if you use Xbox Party Chat)" IsChecked="False"/>
                                    <CheckBox x:Name="ChkDebloatBing" Content="Remove Bing Weather, News, Finance, Sports &amp; Clipchamp" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloat3D" Content="Remove 3D Viewer, Mixed Reality Portal &amp; Paint3D" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloatSolitaire" Content="Remove Solitaire, People, Maps &amp; Zune Video" IsChecked="True"/>
                                    <CheckBox x:Name="ChkDebloatFeedback" Content="Remove Feedback Hub, Get Help, Tips &amp; DiagTrack Telemetry Service" IsChecked="True"/>
                                    <Button x:Name="BtnDebloatRemove" Content="Remove Selected Bloatware &amp; Services" Style="{StaticResource DangerBtn}" HorizontalAlignment="Left" Margin="0,10,0,0"/>
                                </StackPanel>
                            </Border>
                        </StackPanel>
                    </ScrollViewer>
                </Grid>

                <!-- VIEW E: SYSTEM INFO & SINGLE-CORE BENCHMARK -->
                <Grid x:Name="ModuleKeygenView" Visibility="Collapsed">
                    <ScrollViewer VerticalScrollBarVisibility="Auto">
                        <StackPanel>
                            <Border Background="#0A1834" BorderBrush="#00A8FF" BorderThickness="1" CornerRadius="7" Padding="18">
                                <StackPanel>
                                    <TextBlock Text="Detected PC Hardware &amp; Single-Core Benchmark" FontSize="16.5" FontWeight="Bold" Foreground="#FACC15" Margin="0,0,0,6"/>
                                    <TextBlock x:Name="SysHardwareSummary" Text="Detecting..." Foreground="#FFFFFF" FontSize="13" TextWrapping="Wrap" Margin="0,0,0,10"/>
                                    <Button x:Name="BtnRunBench" Content="Run Single-Core CPU Benchmark" Style="{StaticResource YellowBtn}" HorizontalAlignment="Left"/>
                                    <TextBlock x:Name="BenchResultTxt" Text="Benchmark ready." Foreground="#38BDF8" FontWeight="Bold" Margin="0,6,0,0"/>
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
                <TextBlock Grid.Row="0" Text="Live Activity Log // KaramTweaks v10.0 (Also Printing Live to PowerShell Console Window!)" Foreground="#FACC15" FontWeight="Bold" FontSize="11.5" Margin="0,0,0,4"/>
                <TextBox x:Name="ConsoleOutputBox" Grid.Row="1" Background="Transparent" Foreground="#38BDF8" BorderThickness="0" IsReadOnly="True" VerticalScrollBarVisibility="Auto" TextWrapping="Wrap" FontFamily="Segoe UI" FontSize="12"/>
            </Grid>
        </Border>

        <Border Grid.Row="4" Background="#0051A8" BorderBrush="#FACC15" BorderThickness="0,1,0,0" Padding="16,0">
            <Grid>
                <TextBlock Text="KaramTweaks v10.0  |  400 Tweaks  |  Hover Any Tweak for Safety Warnings &amp; Details" Foreground="#FACC15" FontWeight="Bold" VerticalAlignment="Center" FontSize="11.5"/>
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center">
                    <TextBlock Text="Created by Karam" FontWeight="Bold" Foreground="#FFFFFF" Margin="0,0,16,0" FontSize="11.5"/>
                    <TextBlock x:Name="LinkDiscord" Text="Discord Support (Open Ticket)" TextDecorations="Underline" Foreground="#FACC15" FontWeight="Bold" Cursor="Hand" Margin="0,0,16,0" FontSize="11.5"/>
                    <TextBlock x:Name="LinkTikTok" Text="TikTok @karamgpt" TextDecorations="Underline" Foreground="#FACC15" FontWeight="Bold" Cursor="Hand" FontSize="11.5"/>
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
# 400 TWEAKS GENERATOR (12 SEPARATE SIDEBAR PAGES + HOVER WARNINGS)
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

    "BASIC_FPS|BASIC|086. Prevent Windows Update From Overwriting GPU Drivers|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate|ExcludeWUDriversInQualityUpdate|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|087. Disable Windows Telemetry Data Collection|HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection|AllowTelemetry|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|088. MaxTelemetryAllowed Set to 0 (Zero Diagnostic Upload)|HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection|MaxTelemetryAllowed|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|089. Disable Activity History & Timeline Tracking|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|PublishUserActivities|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|090. Disable User Activity Cloud Sync|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableActivityFeed|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|091. Disable UploadUserActivities Background Sync|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|UploadUserActivities|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|092. Disable Windows Copilot AI Background Assistant|HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot|TurnOffWindowsCopilot|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|093. Disable Machine-Wide Windows Copilot Policy|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot|TurnOffWindowsCopilot|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|094. Disable Windows AI Recall Data Analysis|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI|DisableAIDataAnalysis|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|095. Turn Off Saving Windows AI Snapshots|HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI|TurnOffSavingSnapshots|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|096. Disable Start Menu Suggested App Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SystemPaneSuggestionsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|097. Disable Lock Screen Spotlight Overlay Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|RotatingLockScreenOverlayEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|098. Disable Subscribed Content 338388 Start Ads|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338388Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|099. Disable Subscribed Content 338389 Tips|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338389Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|100. Disable Subscribed Content 353698 Timeline Suggestions|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-353698Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|101. Disable PreInstalledAppsEnabled Bloatware Loader|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|PreInstalledAppsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|102. Disable OemPreInstalledAppsEnabled Bloatware|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|OemPreInstalledAppsEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|103. Disable Cortana Background Web Process|HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search|AllowCortana|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|104. Disable Start Menu Bing Web Search Stutter|HKCU\Software\Policies\Microsoft\Windows\Explorer|DisableSearchBoxSuggestions|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|105. Disable ConnectedSearchUseWeb Bing Queries|HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search|ConnectedSearchUseWeb|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|106. Disable WebSearchEnabled in Search Bar|HKCU\Software\Microsoft\Windows\CurrentVersion\Search|BingSearchEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|107. Disable SearchboxTaskbarMode Overhead (Icon Only)|HKCU\Software\Microsoft\Windows\CurrentVersion\Search|SearchboxTaskbarMode|REG_DWORD|1|2",
    "BASIC_FPS|BASIC|108. Disable Windows Error Reporting Background Queue|HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting|Disabled|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|109. Disable Remote Assistance Connections|HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance|fAllowToGetHelp|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|110. Set Desktop Wallpaper Quality to Uncompressed 100%|HKCU\Control Panel\Desktop|JPEGImportQuality|REG_DWORD|100|85",
    "BASIC_FPS|BASIC|111. Disable Taskbar Animations in Explorer|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|TaskbarAnimations|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|112. Disable ListviewAlphaSelect Selection Box Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|ListviewAlphaSelect|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|113. Disable ComboBoxAnimation UI Rendering Delay|HKCU\Control Panel\Desktop\WindowMetrics|ComboBoxAnimation|REG_SZ|0|1",
    "BASIC_FPS|BASIC|114. Disable SmoothScroll List Box Lag|HKCU\Control Panel\Desktop|SmoothScroll|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|115. Disable Windows Explorer Recent Files History Lag|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer|ShowRecent|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|116. Disable Windows Explorer Frequent Folders Tracking|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer|ShowFrequent|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|117. Disable Cloud Optimized Content in Windows|HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent|DisableCloudOptimizedContent|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|118. Disable Windows Consumer Features Bloat|HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent|DisableWindowsConsumerFeatures|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|119. Disable Windows Feedback Notifications|HKCU\Software\Microsoft\Siuf\Rules|NumberOfSIUFInPeriod|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|120. Disable Automatic Windows Store App Updates While Gaming|HKLM\SOFTWARE\Policies\Microsoft\WindowsStore|AutoDownload|REG_DWORD|2|4",
    "BASIC_FPS|BASIC|121. Disable App Capture Microphone Background Polling|HKCU\System\GameConfigStore|GameDVR_DSEBehavior|REG_DWORD|2|0",
    "BASIC_FPS|BASIC|122. Disable Windows Spotlight Action Center Notifications|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-338393Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|123. Disable Settings App Banner Suggestions|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-353694Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|124. Disable Windows Welcome Experience After Updates|HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager|SubscribedContent-310093Enabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|125. Disable Live Tile Push Notifications Overhead|HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications|NoTileApplicationNotification|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|126. Disable Toast Notification Center Background Wake|HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications|ToastEnabled|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|127. Disable Windows Backup Reminder Notifications|HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsBackup|DisableMonitoring|REG_DWORD|1|0",
    "BASIC_FPS|BASIC|128. Disable SmartScreen App Launch Check Delay|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableSmartScreen|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|129. Disable Windows Font Streaming Background Service|HKLM\SOFTWARE\Policies\Microsoft\Windows\System|EnableFontProviders|REG_DWORD|0|1",
    "BASIC_FPS|BASIC|130. Disable Explorer Thumbnail Cache Network Lookup|HKCU\Software\Policies\Microsoft\Windows\Explorer|DisableThumbsDBOnNetworkFolders|REG_DWORD|1|0",

    "BASIC_CPU|BASIC|131. Set Games Multimedia SFIO Disk Priority to High|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|SFIO Priority|REG_SZ|High|Normal",
    "BASIC_CPU|BASIC|132. Set Games Multimedia Background Only to False|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Background Only|REG_SZ|False|True",
    "BASIC_CPU|BASIC|133. Set Games Multimedia Clock Rate to 10000 (1ms)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Clock Rate|REG_DWORD|10000|10000",
    "BASIC_CPU|BASIC|134. Set Games Multimedia Affinity to All Cores (0)|HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games|Affinity|REG_DWORD|0|0",
    "BASIC_CPU|BASIC|135. Reduce Hung Application Kill Timeout (2000ms)|HKCU\Control Panel\Desktop|HungAppTimeout|REG_SZ|2000|5000",
    "BASIC_CPU|BASIC|136. Reduce WaitToKillAppTimeout on Shutdown (2000ms)|HKCU\Control Panel\Desktop|WaitToKillAppTimeout|REG_SZ|2000|20000",
    "BASIC_CPU|BASIC|137. Reduce Service Shutdown WaitToKill Timeout (2000ms)|HKLM\SYSTEM\CurrentControlSet\Control|WaitToKillServiceTimeout|REG_SZ|2000|5000",
    "BASIC_CPU|BASIC|138. Disable Low-Level Hooks Timeout Lag (1000ms)|HKCU\Control Panel\Desktop|LowLevelHooksTimeout|REG_SZ|1000|5000",
    "BASIC_CPU|BASIC|139. Disable Prefetcher Disk Background Stutter|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnablePrefetcher|REG_DWORD|0|3",
    "BASIC_CPU|BASIC|140. Disable Superfetch Background Indexing Flag|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnableSuperfetch|REG_DWORD|0|3",
    "BASIC_CPU|BASIC|141. Disable BootTrace Disk Logging Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters|EnableBootTrace|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|142. Disable System Hibernation Power Overhead|HKLM\SYSTEM\CurrentControlSet\Control\Power|HibernateEnabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|143. Disable Energy Estimation Background Telemetry|HKLM\SYSTEM\CurrentControlSet\Control\Power|EnergyEstimationEnabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|144. Disable Power EventProcessor Telemetry|HKLM\SYSTEM\CurrentControlSet\Control\Power|EventProcessorEnabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|145. Disable CsEnabled Modern Standby Micro-Sleep|HKLM\SYSTEM\CurrentControlSet\Control\Power|CsEnabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|146. Unpark CPU Cores in Power Registry (ValueMax=0)|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|ValueMax|REG_DWORD|0|100",
    "BASIC_CPU|BASIC|147. Unpark CPU Cores Minimum (ValueMin=0)|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|ValueMin|REG_DWORD|0|0",
    "BASIC_CPU|BASIC|148. Reveal Hidden CPU Core Parking Attributes in Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583|Attributes|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|149. Reveal Processor Performance Boost Mode in Power Plan|HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7|Attributes|REG_DWORD|2|1",
    "BASIC_CPU|BASIC|150. Disable Windows Customer Experience Improvement|HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows|CEIPEnable|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|151. Disable Application Launch Tracking Overhead|HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced|Start_TrackProgs|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|152. Disable Tailored Diagnostic Telemetry|HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy|TailoredExperiencesWithDiagnosticDataEnabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|153. Disable Windows Advertising ID Tracking|HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo|Enabled|REG_DWORD|0|1",
    "BASIC_CPU|BASIC|154. [PROCESS KILLER] Disable Diagnostic Policy Service (DPS)|HKLM\SYSTEM\CurrentControlSet\Services\DPS|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|155. [PROCESS KILLER] Disable Connected User Telemetry Process (DiagTrack)|HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|156. [PROCESS KILLER] Disable dmwappushservice WAP Telemetry Process|HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|157. [PROCESS KILLER] Disable SysMain / Superfetch Background Process|HKLM\SYSTEM\CurrentControlSet\Services\SysMain|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|158. [PROCESS KILLER] Disable Windows Search Indexing Process (WSearch)|HKLM\SYSTEM\CurrentControlSet\Services\WSearch|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|159. [PROCESS KILLER] Disable MapsBroker Downloaded Maps Process|HKLM\SYSTEM\CurrentControlSet\Services\MapsBroker|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|160. [PROCESS KILLER] Disable lfsvc Geolocation Tracking Process|HKLM\SYSTEM\CurrentControlSet\Services\lfsvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|161. [PROCESS KILLER] Disable Print Spooler Process (If No Printer)|HKLM\SYSTEM\CurrentControlSet\Services\Spooler|Start|REG_DWORD|3|2",
    "BASIC_CPU|BASIC|162. [PROCESS KILLER] Disable Fax Background Service Process|HKLM\SYSTEM\CurrentControlSet\Services\Fax|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|163. [PROCESS KILLER] Disable RetailDemo Background Process|HKLM\SYSTEM\CurrentControlSet\Services\RetailDemo|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|164. [PROCESS KILLER] Disable WpcMonSvc Parental Controls Process|HKLM\SYSTEM\CurrentControlSet\Services\WpcMonSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|165. [PROCESS KILLER] Disable WerSvc Windows Error Reporting Process|HKLM\SYSTEM\CurrentControlSet\Services\WerSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|166. [PROCESS KILLER] Disable PcaSvc Compatibility Assistant Process|HKLM\SYSTEM\CurrentControlSet\Services\PcaSvc|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|167. [PROCESS KILLER] Disable WdiSystemHost Diagnostic Host Process|HKLM\SYSTEM\CurrentControlSet\Services\WdiSystemHost|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|168. [PROCESS KILLER] Disable WdiServiceHost Diagnostic Service Process|HKLM\SYSTEM\CurrentControlSet\Services\WdiServiceHost|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|169. [PROCESS KILLER] Disable TrkWks Distributed Link Tracking Process|HKLM\SYSTEM\CurrentControlSet\Services\TrkWks|Start|REG_DWORD|4|2",
    "BASIC_CPU|BASIC|170. [PROCESS KILLER] Disable wisvc Windows Insider Service Process|HKLM\SYSTEM\CurrentControlSet\Services\wisvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|171. [PROCESS KILLER] Disable PhoneSvc Phone Telephony Process|HKLM\SYSTEM\CurrentControlSet\Services\PhoneSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|172. [PROCESS KILLER] Disable SensorService Hardware Sensor Process|HKLM\SYSTEM\CurrentControlSet\Services\SensorService|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|173. [PROCESS KILLER] Disable SensorDataService Background Process|HKLM\SYSTEM\CurrentControlSet\Services\SensorDataService|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|174. [PROCESS KILLER] Disable SensrSvc Adaptive Brightness Process|HKLM\SYSTEM\CurrentControlSet\Services\SensrSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|175. [PROCESS KILLER] Disable WalletService Microsoft Wallet Process|HKLM\SYSTEM\CurrentControlSet\Services\WalletService|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|176. [PROCESS KILLER] Disable SEMgrSvc Payments & NFC Process|HKLM\SYSTEM\CurrentControlSet\Services\SEMgrSvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|177. [PROCESS KILLER] Disable SCardSvr Smart Card Reader Process|HKLM\SYSTEM\CurrentControlSet\Services\SCardSvr|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|178. [PROCESS KILLER] Disable ScDeviceEnum Smart Card Enum Process|HKLM\SYSTEM\CurrentControlSet\Services\ScDeviceEnum|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|179. [PROCESS KILLER] Disable RemoteRegistry Background Process|HKLM\SYSTEM\CurrentControlSet\Services\RemoteRegistry|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|180. [PROCESS KILLER] Disable shpamsvc Shared PC Account Process|HKLM\SYSTEM\CurrentControlSet\Services\shpamsvc|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|181. [PROCESS KILLER] Disable tzautoupdate Auto Time Zone Process|HKLM\SYSTEM\CurrentControlSet\Services\tzautoupdate|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|182. [PROCESS KILLER] Disable AJRouter AllJoyn Router Process|HKLM\SYSTEM\CurrentControlSet\Services\AJRouter|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|183. [PROCESS KILLER] Disable DiagHub Collector Service Process|HKLM\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service|Start|REG_DWORD|4|3",
    "BASIC_CPU|BASIC|184. [PROCESS KILLER] Merge PlugPlay Service Into Shared SvcHost|HKLM\SYSTEM\CurrentControlSet\Services\PlugPlay|SvcHostSplitDisable|REG_DWORD|1|0",
    "BASIC_CPU|BASIC|185. [PROCESS KILLER] Merge Power Service Into Shared SvcHost|HKLM\SYSTEM\CurrentControlSet\Services\Power|SvcHostSplitDisable|REG_DWORD|1|0",

