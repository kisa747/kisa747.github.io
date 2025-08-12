# CD 抓轨

参考：<https://blog.abyss.moe/posts/Digitizing-CD-Archives/>

Windows 下 CD 抓轨推荐使用 EAC 软件，需要设置 CD 的偏移量。

一份完整的 EAC log 文件应该是有 checksum 校验值的。

EAC log 文件实例：

```sh
Exact Audio Copy V1.6 from 23. October 2020

EAC extraction logfile from 7. March 2021, 19:48

凋叶棕 / 宴

Used drive  : hp      BD CMB UJ160   Adapter: 1  ID: 0

Read mode               : Secure
Utilize accurate stream : Yes
Defeat audio cache      : Yes
Make use of C2 pointers : No

Read offset correction                      : 103
Overread into Lead-In and Lead-Out          : No
Fill up missing offset samples with silence : Yes
Delete leading and trailing silent blocks   : No
Null samples used in CRC calculations       : Yes
Used interface                              : Native Win32 interface for Win NT & 2000

Used output format : Internal WAV Routines
Sample format      : 44.100 Hz; 16 Bit; Stereo


TOC of the extracted CD

     Track |   Start  |  Length  | Start sector | End sector
    ---------------------------------------------------------
        1  |  0:00.00 |  5:42.03 |         0    |    25652
        2  |  5:42.03 |  6:14.03 |     25653    |    53705
        3  | 11:56.06 |  5:16.03 |     53706    |    77408
        4  | 17:12.09 |  5:43.05 |     77409    |   103138
        5  | 22:55.14 |  4:31.45 |    103139    |   123508
        6  | 27:26.59 |  4:12.03 |    123509    |   142411
        7  | 31:38.62 |  4:30.59 |    142412    |   162720
        8  | 36:09.46 |  5:50.03 |    162721    |   188973
        9  | 41:59.49 |  4:48.03 |    188974    |   210576
       10  | 46:47.52 |  5:24.03 |    210577    |   234879
       11  | 52:11.55 |  3:13.48 |    234880    |   249402


Range status and errors

Selected range

     Filename F:\CDRip\凋叶棕\宴\RDWL-0001.wav

     Peak level 100.0 %
     Extraction speed 4.2 X
     Range quality 100.0 %
     Copy CRC 8AD7EDF2
     Copy OK

No errors occurred


AccurateRip summary

Track  1  accurately ripped (confidence 2)  [DD636071]  (AR v2)
Track  2  accurately ripped (confidence 2)  [0C6FA8B9]  (AR v2)
Track  3  accurately ripped (confidence 2)  [ECFE2AF4]  (AR v2)
Track  4  accurately ripped (confidence 2)  [E6F0835D]  (AR v2)
Track  5  accurately ripped (confidence 2)  [A063BF27]  (AR v2)
Track  6  accurately ripped (confidence 2)  [C0EF54E0]  (AR v2)
Track  7  accurately ripped (confidence 2)  [E88F4926]  (AR v2)
Track  8  accurately ripped (confidence 2)  [7AB8EDB3]  (AR v2)
Track  9  accurately ripped (confidence 2)  [898E5AD5]  (AR v2)
Track 10  accurately ripped (confidence 2)  [2B7BF79A]  (AR v2)
Track 11  accurately ripped (confidence 2)  [5A4B14B7]  (AR v2)

All tracks accurately ripped

End of status report

---- CUETools DB Plugin V2.1.6

[CTDB TOCID: HBFiB3CptZA6LyLN9Kn1aRh7H.Y-] found
Submit result: HBFiB3CptZA6LyLN9Kn1aRh7H.Y- has been confirmed
Track | CTDB Status
  1   | (65/65) Accurately ripped
  2   | (65/65) Accurately ripped
  3   | (64/65) Accurately ripped
  4   | (64/65) Accurately ripped
  5   | (65/65) Accurately ripped
  6   | (65/65) Accurately ripped
  7   | (65/65) Accurately ripped
  8   | (64/65) Accurately ripped
  9   | (64/65) Accurately ripped
 10   | (64/65) Accurately ripped
 11   | (61/65) Accurately ripped


==== Log checksum C9294F4F0FBEB55D2A34159AC6C2EC5832937D1CB717F83CAC1B25BAF1F0D5A1 ====
```
