## 安装步骤

1. 下载最新的 QAAC：<https://github.com/nu774/qaac>
2. 下载最新的 iTunes 运行库：<https://www.apple.com.cn/itunes/>
3. 下载最新的 libFlac.dll 文件：<https://xiph.org/flac/download.html> （这个网站也可以<https://www.rarewares.org/lossless.php）>
4. 如果没有系统没有安装 Visual C++ 2010，还需要 VC2010 的链接库。

对 Foobar 用户，直接下载 [encoderpack](https://www.foobar2000.org/encoderpack) + iTunes 运行库 + libFlac.dll 文件 即可。

## 命令行

```sh
"D:\App\Shell\QAAC\qaac64.exe" -v288 --copy-artwork -o aac-qaac.m4a input.flac
```

## 需要的完整文件

```sh
# 将以上文件及目录复制至 foobar2000\encoders 目录下。

qaac64.exe                       # qaac 主程序
refalac64.exe                    # alac 编码器主程序
libsoxconvolver64.dll            # qaac 动态库
libsoxr64.dll                    # qaac 动态库
QTfiles64\libFLAC.dll            # libFLAC 动态库
QTfiles64\msvcp100.dll           # VC2010 依赖库
QTfiles64\msvcr100.dll           # VC2010 依赖库

QTfiles64\ASL.dll                # 从 iTunes 解压得到的 QT 支持文件
QTfiles64\CoreAudioToolbox.dll
QTfiles64\CoreFoundation.dll
QTfiles64\icudt*.dll
QTfiles64\libdispatch.dll
QTfiles64\libicuin.dll
QTfiles64\libicuuc.dll
QTfiles64\objc.dll
```

## QAAC 命令行工具

QAAC 下载地址：<https://github.com/nu774/qaac>

下载后得到四个文件：

```sh
qaac64.exe
refalac64.exe
libsoxconvolver64.dll
libsoxr64.dll
```

## 获得 Apple Application Support

参考：<https://github.com/nu774/qaac/issues/69>

<https://github.com/jc3213/batchscript/blob/main/iTunes/Extractor.cmd>

下载最新版的 iTunes：<https://www.apple.com.cn/itunes/>

右键使用 7-zip 解压，得到 `iTunes64.msi`。

解压 msi 文件：

```sh
msiexec /a iTunes64.msi /q TARGETDIR={Directory}
```

得到以下文件：

```sh
QTfiles64\ASL.dll
QTfiles64\CoreAudioToolbox.dll
QTfiles64\CoreFoundation.dll
QTfiles64\icudt*.dll
QTfiles64\libdispatch.dll
QTfiles64\libicuin.dll
QTfiles64\libicuuc.dll
QTfiles64\objc.dll
```
