# KMS 激活

开源激活工具：<https://massgrave.dev/，包含> 下载 windows 的地址。

> 确保安装的 Windows 和 Office 是 VL 版。

## Windows 激活

KMS 服务器参考：<https://www.kms.pub/>

批处理自动激活：

```sh
@echo off
%1 mshta vbscript:Createobject("Shell.Application").ShellExecute("%~s0","::","","runas",1)(window.close)&&exit

title Windows 10 激活工具
cscript //Nologo %windir%\system32\slmgr.vbs /xpr | find "已永久激活" > NUL && goto permanent
echo 正在查询操作系统信息...
ver | find "10.0." > NUL ||  goto ext
for /f "tokens=3 delims= " %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set edition=%%i
echo 当前操作系统是：Windows 10 %edition%

echo 尝试进行永久激活。
cscript //Nologo %windir%\system32\slmgr.vbs /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
cscript //Nologo %windir%\system32\slmgr.vbs /ato | find "成功"  > NUL &&  goto permanent
cscript //Nologo %windir%\system32\slmgr.vbs /ipk QJNXR-YD97Q-K7WH4-RYWQ8-6MT6Y
cscript //Nologo %windir%\system32\slmgr.vbs /ato | find "成功"  > NUL &&  goto permanent

set series=n
if %edition%==Professional (set series=W269N-WFGWX-YVC9B-4J6C9-T83GX)
if %edition%==Education (set series=WNW6C2-QMPVW-D7KKK-3GKT6-VCFB2)
if %edition%==Enterprise (set series=NPPR9-FWDCX-D2C8J-H872K-2YT43)
if %series%==n goto :ext

echo.
echo   **** ！！务必确保已联网！！****
echo.

echo 正在导入密钥：%series%
cscript //Nologo %windir%\system32\slmgr.vbs /ipk %series%

echo 正在设置Windows的KMS服务器地址...
cscript //Nologo %windir%\system32\slmgr.vbs /skms kms.03k.org
::其它KMS服务器
::kms.chinancce.com
::kms.library.hk
::kms.lotro.cc

echo 正在激活Windows...
cscript //Nologo %windir%\system32\slmgr.vbs /ato

echo 正在当前许可证的过期日期...
cscript //Nologo %windir%\system32\slmgr.vbs /xpr

pause & exit

:ext
echo.
echo 当前操作系统不支持KMS方式激活！
echo.
pause & exit

:permanent
echo.
echo 当前操作系统已永久激活！
echo.
pause & exit
```

激活说明：

> KMS 激活有 180 天期限，此期限称为激活有效间隔。若要保持激活状态，您的系统必须通过至少每 180 天连接一次 KMS 服务器来续订激活。默认情况下，系统每 7 天自动进行一次激活续订尝试。在续订客户端激活之后，激活有效间隔重新开始。
>
> 综上所述，只要您不超过 180 天以上无法连接互联网，就无需进行任何操作，系统会自行续期保持激活状态。

## Office VOL 版本激活

1.使用 命令提示符（CMD）管理员模式 执行命令：

```sh
::Office16 - 【Office2021/2024】
set office="C:\Program Files\Microsoft Office\Office16"
cd /d %office%

::执行命令设置Office的KMS服务器地址
cscript ospp.vbs /sethst:kms.chinancce.com

::执行命令激活Office
cscript ospp.vbs /act

::(可选)执行命令查询Office激活时间
cscript ospp.vbs /dstatus
::END
```

一键激活 office 脚本：

```sh
@echo off
:: 14.0 对应 office2010
:: 15.0 对应 office2013
:: 16.0 对应 office2016
%1 mshta vbscript:Createobject("Shell.Application").ShellExecute("%~s0","::","","runas",1)(window.close)&&exit

for %%i in (14.0 15.0 16.0) do (reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\%%i\Common\InstallRoot">nul 2>nul&&(set ver=%%i&goto office))

:quit
cls
echo.
echo 没有安装Office，或是Office版本过低。请安装 office2010 或以上版本。
echo.
pause & exit

:office
for /f "tokens=2,*" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\%ver%\Common\InstallRoot" /v "Path"') do (set office=%%j)
echo.
echo Office的安装位置是：%office%
echo.

cd /d %office%
echo 正在设置Office的KMS服务器地址...
cscript //nologo ospp.vbs /sethst:kms.03k.org
::其它KMS服务器
::kms.chinancce.com
::kms.library.hk
::kms.lotro.cc
echo 正在激活Office...
cscript //nologo ospp.vbs /act | find /i "successful" && (
    echo.&echo ***** 激活成功！ ***** & echo.) || (echo.&echo ***** 激活失败！ ***** & echo.)
)

pause & exit
```

如何清除 KMS 激活信息，参考：<https://kms.library.hk/archives/31.html>

## Windows GVLK 密钥对照表（KMS 激活专用）

以下 key 来源于微软官网：<https://learn.microsoft.com/zh-cn/windows-server/get-started/kms-client-activation-keys>

| 操作系统版本                                                 | KMS 客户端产品密钥            |
| ------------------------------------------------------------ | ----------------------------- |
| Windows 11 企业版 LTSC 2024<br/>Windows 10 企业版 LTSC 2021<br/>Windows 10 企业版 LTSC 2019 | M7XTQ-FN8P6-TTKYV-9D4CC-J462D |
| Windows IoT 企业版 LTSC 2024<br/>Windows IoT 企业版 LTSC 2021 | KBN8V-HFGQ4-MGXVD-347P6-PDQGT |

附上更高级的批处理代码，来自：<https://kms.library.hk/archives/kms.html>

```bash
@echo off
setlocal EnableDelayedExpansion & cd /d "%~dp0"
title KMS通用激活工具
%1 %2
ver|find "5.">nul&&goto :xptooff
mshta vbscript:createobject("shell.application").shellexecute("%~s0","goto :start","","runas",1)(window.close)&goto :eof

:start
cls
echo Windows 和 Office 激活
echo 正在检查与激活服务器的连接情况……
echo.
ping kms.library.hk  | find "超时"  > NUL &&  goto fail
ping kms.library.hk  | find "目标主机"  > NUL &&  goto fail
echo 成功连接上服务器,检查系统的激活情况，将自动跳过永久激活的系统。
cscript //Nologo %windir%\system32\slmgr.vbs /xpr | find "已永久激活">NUL&&goto wintooff
ver | find "6.0." > NUL &&  goto winvista
ver | find "6.1." > NUL &&  goto win7
ver | find "6.2." > NUL &&  goto win8
ver | find "6.3." > NUL &&  goto win81
ver | find "10.0." > NUL &&  goto win10
echo 未找到合适的NT6系统，可能是WinXP或Win2003。
goto office

:winvista
echo 当前为Windows Vista/2008。
set Business=YFKBB-PQJJV-G996G-VWGXY-2V3X8
set BusinessN=HMBQG-8H2RH-C77VX-27R82-VMQBT
set Enterprise=VKK3X-68KWM-X2YGT-QR4M6-4BWMV
set EnterpriseN=VTC42-BM838-43QHV-84HX6-XJXKV
set ServerWeb=WYR28-R7TFJ-3X2YQ-YCY4H-M249D
set ServerStandard=TM24T-X9RMF-VWXK6-X8JC9-BFGM2
set ServerStandardV=W7VD6-7JFBR-RX26B-YKQ3Y-6FFFJ
set ServerEnterprise=YQGMW-MPWTJ-34KDK-48M3W-X4Q6V
set ServerEnterpriseV=39BXF-X8Q23-P2WWT-38T2F-G3FPG
set ServerWeb=RCTX3-KWVHP-BR6TB-RB6DM-6X7HP
set ServerDatacenter=7M67G-PC374-GR742-YH8V4-TCBY3
set ServerDatacenterV=22XQ2-VRXRG-P8D42-K34TD-G3QQC
set ServerEnterpriseIA64=4DWFP-JF3DJ-B7DTH-78FJB-PDRHK
goto windowsstart

:win7
echo 当前为Windows 7/2008 R2。
set Professional=FJ82H-XT6CR-J8D7P-XQJJ2-GPDD4
set ProfessionalN=MRPKT-YTG23-K7D7T-X2JMM-QY7MG
set ProfessionalE=W82YF-2Q76Y-63HXB-FGJG9-GF7QX
set Enterprise=33PXH-7Y6KF-2VJC9-XBBR8-HVTHH
set EnterpriseN=YDRBP-3D83W-TY26F-D46B2-XCKRJ
set EnterpriseE=C29WB-22CC8-VJ326-GHFJW-H9DH4
set ServerWeb=6TPJF-RBVHG-WBW2R-86QPH-6RTM4
set ServerHPC=TT8MH-CG224-D3D7Q-498W2-9QCTX
set ServerStandard=YC6KT-GKW9T-YTKYR-T4X34-R7VHC
set ServerEnterprise=489J6-VHDMP-X63PK-3K798-CPX3Y
set ServerDatacenter=74YFP-3QFB3-KQT8W-PMXWJ-7M648
set ServerEnterpriseIA64=GT63C-RJFQ3-4GMB6-BRFB9-CB83V
goto windowsstart
:win8
echo 当前为Windows 8/2012。
set Professional=NG4HW-VH26C-733KW-K6F98-J8CK4
set ProfessionalN=XCVCF-2NXM9-723PB-MHCB7-2RYQQ
set Core=BN3D2-R7TKB-3YPBD-8DRP2-27GG4
set Enterprise=32JNW-9KQ84-P47T8-D8GGY-CWCK7
set EnterpriseN=JMNMF-RHW7P-DMY6X-RF3DR-X2BQT
set CoreN=8N2M2-HWPGY-7PGT9-HGDD8-GVGGY
set CoreSingleLanguage=2WN2H-YGCQR-KFX6K-CD6TF-84YXQ
set CoreCountrySpecific=4K36P-JN4VD-GDC6V-KDT89-DYFKP
set ServerMultiPointPremium=XNH6W-2V9GX-RGJ4K-Y8X6F-QGJ2G
set ServerMultiPointStandard=HM7DN-YVMH3-46JC3-XYTG7-CYQJJ
set ServerStandard=XC9B7-NBPP2-83J2H-RHMBY-92BT4
set ServerDatacenter=48HP8-DN98B-MYWDG-T2DCC-8W83P
set ProfessionalWMC=GNBB8-YVD74-QJHX6-27H4K-8QHDG
set CoreARM=DXHJF-N9KQX-MFPVR-GHGQK-Y7RKV
goto windowsstart
:win81
echo 当前为Windows 8.1。
set Core=M9Q9P-WNJJT-6PXPY-DWX8H-6XWKK
set CoreARM=XYTND-K6QKT-K2MRH-66RTM-43JKP
set CoreCountrySpecific=NCTT7-2RGK8-WMHRF-RY7YQ-JTXG3
set CoreN=7B9N3-D94CG-YTVHR-QBPX3-RJP64
set CoreSingleLanguage=BB6NG-PQ82V-VRDPW-8XVD2-V8P66
set EmbeddedIndustry=NMMPB-38DD4-R2823-62W8D-VXKJB
set EmbeddedIndustryA=VHXM3-NR6FT-RY6RT-CK882-KW2CJ
set EmbeddedIndustryE=FNFKF-PWTVT-9RC8H-32HB2-JB34X
set Enterprise=MHF9N-XY6XB-WVXMC-BTDCT-MKKG7
set EnterpriseN=TT4HM-HN7YT-62K67-RGRQJ-JFFXW
set Professional=GCRJD-8NW9H-F2CDX-CCM8D-9D6T9
set ProfessionalN=HMCNV-VVBFX-7HMBH-CTY9B-B4FXY
set ProfessionalWMC=789NJ-TQK6T-6XTH8-J39CJ-J8D3P
set ServerCloudStorageCore=3NPTF-33KPT-GGBPR-YX76B-39KDD
set ServerCloudStorage=3NPTF-33KPT-GGBPR-YX76B-39KDD
set ServerDatacenter=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set ServerDatacenterCore=W3GGN-FT8W3-Y4M27-J84CP-Q3VJ9
set ServerStandard=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set ServerStandardCore=D2N9P-3P6X9-2R39C-7RTCD-MDVJX
set ServerSolution=KNC87-3J2TX-XB4WP-VCPJV-M4FWM
set ServerSolutionCore=KNC87-3J2TX-XB4WP-VCPJV-M4FWM
goto windowsstart
:win10
echo 当前为Windows 10。
echo 尝试进行永久激活。
cscript //Nologo %windir%\system32\slmgr.vbs /ipk VK7JG-NPHTM-C97JM-9MPGT-3V66T
cscript //Nologo %windir%\system32\slmgr.vbs /ato | find "成功"  > NUL &&  goto win10tooff
cscript //Nologo %windir%\system32\slmgr.vbs /ipk QJNXR-YD97Q-K7WH4-RYWQ8-6MT6Y
cscript //Nologo %windir%\system32\slmgr.vbs /ato | find "成功"  > NUL &&  goto win10tooff
set Core=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
set CoreCountrySpecific=PVMJN-6DFY6-9CCP6-7BKTT-D3WVR
set CoreN=3KHY7-WNT83-DGQKR-F7HPR-844BM
set CoreSingleLanguage=7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH
set Professional=W269N-WFGWX-YVC9B-4J6C9-T83GX
set ProfessionalN=MH37W-N47XK-V7XM9-C7227-GCQG9
set Enterprise=NPPR9-FWDCX-D2C8J-H872K-2YT43
set EnterpriseN=DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4
set Education=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2
set EducationN=2WH4N-8QGBV-H22JP-CT43Q-MDWWJ
set EnterpriseS=WNMTR-4C88C-JK8YV-HQ7T2-76DF9
set EnterpriseSN=2F77B-TNFGY-69QQF-B8YKP-D69TJ
goto windowsstart
:windowsstart
for /f "tokens=3 delims= " %%i in ('reg QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "EditionID"') do set EditionID=%%i
if defined %EditionID% (
 cscript //Nologo %windir%\system32\slmgr.vbs /ipk !%EditionID%!
 cscript //Nologo %windir%\system32\slmgr.vbs /skms kms.library.hk
 cscript //Nologo %windir%\system32\slmgr.vbs /ato
) else (
 echo 找不到系列号，可能是旗舰版之类的系统……
)
goto office
:wintooff
echo 系统已经永久激活！转入office激活。
goto office
:win10tooff
echo 成功的对系统进行永久激活！转入office激活。
:office
echo 检查安装的office……
call :GetOfficePath 14 Office2010
call :ActOffice 14 Office2010
call :GetOfficePath 15 Office2013
call :ActOffice 15 Office2013
if exist "%ProgramFiles%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles%\Microsoft Office\Office16
if exist "%ProgramFiles(x86)%\Microsoft Office\Office16\ospp.vbs" set _Office16Path=%ProgramFiles(x86)%\Microsoft Office\Office16
if DEFINED _Office16Path (echo.&echo 已发现 Office2016
    call :ActOffice 16 Office2016
  ) else (echo.&echo 未发现 Office2016)
echo 操作成功完成！
echo.&pause
exit

:ActOffice
if DEFINED _Office%1Path (
    cd /d "!_Office%1Path!"
 echo 检查 %2 的激活状态。
 cscript //nologo ospp.vbs /act | find /i "successful" > NUL && (
        echo.&echo  %2 已经激活，自动跳过  & echo.) || (
  echo.&echo  %2 未激活，正尝试进行激活。
  if %1 EQU 16 call :Licens16
  cscript //nologo ospp.vbs /sethst:kms.library.hk  >nul
  cscript //nologo ospp.vbs /act | find /i "successful" && (
        echo.&echo ***** %2 激活成功 ***** & echo.) || (echo.&echo ***** %2 激活失败 ***** & echo.)
  )
)
cd /d "%~dp0"
goto :EOF

:GetOfficePath
echo.&echo 正在检测 %2 系列产品的安装路径...
set _Office%1Path=
set _Reg32=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Office\%1.0\Common\InstallRoot
set _Reg64=HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Office\%1.0\Common\InstallRoot
reg query "%_Reg32%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg32%" /v "Path"') do SET "_OfficePath1=%%b"
reg query "%_Reg64%" /v "Path" > nul 2>&1 && FOR /F "tokens=2*" %%a IN ('reg query "%_Reg64%" /v "Path"') do SET "_OfficePath2=%%b"
if DEFINED _OfficePath1 (if exist "%_OfficePath1%ospp.vbs" set _Office%1Path=!_OfficePath1!)
if DEFINED _OfficePath2 (if exist "%_OfficePath2%ospp.vbs" set _Office%1Path=!_OfficePath2!)
set _OfficePath1=
set _OfficePath2=
if DEFINED _Office%1Path (echo.&echo 已发现 %2) else (echo.&echo 未发现 %2)
goto :EOF

:Licens16
for /f %%x in ('dir /b ..\root\Licenses16\project???vl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\standardvl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\visio???vl_kms*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\project???vl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\proplusvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\standardvl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
for /f %%x in ('dir /b ..\root\Licenses16\visio???vl_mak*.xrm-ms') do cscript ospp.vbs /inslic:"..\root\Licenses16\%%x" >nul
cscript ospp.vbs /inpkey:NYH39-6GMXT-T39D4-WVXY2-D69YY >nul
cscript ospp.vbs /inpkey:7WHWN-4T7MP-G96JF-G33KR-W8GF4 >nul
cscript ospp.vbs /inpkey:RBWW7-NTJD4-FFK2C-TDJ7V-4C2QP >nul
cscript ospp.vbs /inpkey:XQNVK-8JYDB-WJ9W3-YJ8YR-WFG99 >nul
cscript ospp.vbs /inpkey:YG9NW-3K39V-2T3HJ-93F3Q-G83KT >nul
cscript ospp.vbs /inpkey:PD3PC-RHNGV-FXJ29-8JK7D-RJRJK >nul
goto :EOF

exit
:xptooff
echo 当前为WinXP或Win2003。
call :GetOfficePath 14 Office2010
call :ActOffice 14 Office2010


:fail
cls
echo 无法连接到服务器……
pause
exit
```
