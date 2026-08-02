# Foobar2000 笔记

## 配置

视图 - 按评分：

参数 - 媒体库 - 专辑列表：按评分 `$if(%rating_stars%,%rating_stars%)`

自定义分栏

参数 - 显示 - 默认用户界面 - 播放列表视图

流派： `%genre%`

分级：`$ifequal(%ITUNESADVISORY%,1,E,)`

评分（这个已经不需要，新版的已经默认有此功能）：`$if(%rating_stars%,%rating_stars%)`
