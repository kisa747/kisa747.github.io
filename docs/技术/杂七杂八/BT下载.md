# BT 下载

## 磁力链接格式

参考：<https://www.ruanyifeng.com/blog/2009/11/future_of_bittorrent.html>

举例来说，今天的热门下载文件是 `Inglourious.Basterds.DVDRip.XviD-iMBT.avi`，按照以前的方式，我们需要下载它的 torrent 文件，然后才能下载这部电影本身。但是，在新的模式下面，我们不需要下载 torrent 文件，我们只需要知道它的 magnet URI，就可以了。只要把这个地址告诉下载软件，软件就会开始自动下载。这和 emule 下载非常相似，只需要一个资源定位信息，其他都不需要。

Inglourious.Basterds.DVDRip.XviD-iMBT.avi 的 magnet URI 如下：

> magnet:?xt=urn:btih:60c423137f453492ca34c2d69f6f573408dca35a
> &dn=Inglourious.Basterds.DVDRip.XviD-iMBT.avi
> &tr=http%3A%2F%2Ftracker.publicbt.com%2Fannounce

分解一下这个网址：

> **magnet**：协议名。
>
> **xt**：exact topic 的缩写，表示资源定位点。BTIH（BitTorrent Info Hash）表示哈希方法名，这里还可以使用 SHA1 和 MD5。这个值是文件的标识符，是不可缺少的。
>
> **dn**：display name 的缩写，表示向用户显示的文件名。这一项是选填的。
>
> **tr**：tracker 的缩写，表示 tracker 服务器的地址。这一项也是选填的。

简单说，只要知道 `magnet:?xt=urn:btih:60c423137f453492ca34c2d69f6f573408dca35a` 这个地址，不用下载 torrent 文件，也不用再了解其他信息，就能开始 BT 下载这个文件了。

引用阮一峰说的一句话。

>当互联网上每一台机器都在自动交换信息的时候，谎言和封锁又能持续多久呢？

## Tracker 列表

有了 DHT 以后，Tracker 服务器作用已经不是特别大了。

<https://trackerslist.com> ，对应 GitHub 地址： <https://github.com/XIU2/TrackersListCollection>

<https://ngosang.github.io/trackerslist/>

下载工具：[Photon](https://github.com/zmzhang8/Photon)、[Qdown](https://lightzhan.xyz/index.php/qdown/)、[Motrix](https://motrix.app/)
