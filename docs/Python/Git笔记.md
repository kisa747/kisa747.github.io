# Git 笔记

官方文档：<https://git-scm.com/book/zh>

更多命令参考：<https://gitee.com/all-about-git>

教程参考：

* [廖雪峰 | Git 教程](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000)     详细讲解了 git 的原理、流程。
* [易百教程 | Git 教程](https://www.yiibai.com/git/)  有常用命令的详解。
* [Git 初阶使用笔记](https://steinslab.io/archives/1520)  推荐看看，里面有很多常用的实例。

## 笔记

### Git 标准操作流程

```bash
# 开始工作前，先把远程分支fetch回来
git fetch

# 检查本地本地仓库状态，判断是否可以 ff，还是有 diverged，亦或是有未提交的修改
git status

# 如果可以 fast forward，就可以直接使用 git pull 与远程仓库合并。
git pull

# 使用 git merge 也可以。
git merge FETCH_HEAD
git add .
git commit -m "update"

# 强制恢复为远程状态
git reset --hard FETCH_HEAD
```

### 常用命令

```bash
# 另一台电脑有新的推送，本机也有修改，就需要合并操作
# 缓存当前工作区
git add .
# 保险起见，先将本地所有的修改暂存起来，防止合并后出错
git stash  # git stash list 查看所有的暂存列表，git stash apply stash@{0}恢复至指定的暂存
# 拉取远程仓库
git fetch
# 检查状态，是否可以快速合并、有冲突
git status
# 如果提示  can be fast-forwarded，就可以快速合并
git merge FETCH_HEAD  # 相当于 git pull
# 如果不想合并，使用远程的版本，放弃本地的修改
git merge --strategy-option theirs
# 如果不想合并，使用本地的版本
git merge --strategy-option ours
# 如果提示 You have unmerged paths，说明有冲突
# 查看冲突
git diff

# push [-u | --set-upstream]参数，Git不但会把本地的main分支内容推送的远程新的main分支，
# 还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。
# 实际上是配置了 .git 目录下的 config 文件
git push -u origin main
# 停止追踪指定文件/目录，但该文件/目录会保留在工作区
git rm --cached [file | folder]
# 停止追踪所有文件、目录，重新 git add . 即可重新应用.gitignore 忽略规则
git rm -r --cached .

# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
git commit --amend -m [message]

git add -A  # 提交所有变化
git add -u  # 提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)
git add .   # 提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件
```

## Quik Start

### 安装 git

1、进入 git 官方网站：<https://git-scm.com/download/win> ，下载 `PortableGit-**-64-bit.7z.exe` ，然后解压到指定文件夹。

git 官方网站下载速度超慢，可以使用国内镜像下载：

<https://npm.taobao.org/mirrors/git-for-windows/>

<https://mirrors.huaweicloud.com/git-for-windows/>

2、双击 `post-install.bat`，安装 git。

3、使用 git-bash

为 `PortableGit\git-bash.exe` 创建快捷方式（记得修改启始位置）。即可使用 `git-bash` 。

### 创建新仓库

至此，git 已经可以正常工作了。可以新建一个本地仓库，也可以 clone 一个远程仓库。

方法 1：（**强烈推荐**）首次使用建议的方法（先创建远程仓库，再克隆至本地）：

```bash
# 在 github 创建新仓库，还可以根据需要选择要添加的 README.md、.gitignore 文件
# 进入工作目录，克隆远程仓库
# 使用 clone 命令克隆了一个仓库，命令会自动将其添加为远程仓库并默认以 “origin” 为简写。
# 此方法最为简单，甚至不需要 git push -u origin main ，就已经自动关联起来了。
git clone git@github.com:kisa747/pycode.git

# 进入仓库目录
cd pycode
# 添加一些文件
# 添加当前目录所有修改过的文件至缓存区
git add .
# 提交改动
git commit -m "代码提交信息"

# 将这些改动提交到远端仓库
# 前面使用 git clone已经自动关联了 origin main，相当于执行：git push origin main
git push
```

方法 2：先创建本地仓库，再 push 至远程仓库

```bash
# 创建前一定要确保主线名为 main
git config --global init.defaultBranch main
# 在本地创建新的 git 仓库
git init
# 添加一个readme文件
echo "这是说明文档" > README.md
# 添加至暂存区
git add README.md
# 提交
git commit -m "first commit"
# 把本地仓库与远程仓库关联
git remote add origin git@github.com:kisa747/test.git
# 把本地仓库的内容推送到GitHub仓库，并建立关联（-u 参数）
git push -u origin main
# 以后就可以简化命令使用add、commit、push方法了。
```

### 配置 SSH 免密登录

1、生成 `SSH key` 。

在 `git-bash` 中输入命令：

```bash
# SSH默认使用 ed25519 加密算法，推荐使用，比RSA算法更高效、密钥更短
ssh-keygen -t ed25519 -C "LOVE_2025"

# 生成 SSH key，默认是2048位，足够安全了，也可以指定4096。
ssh-keygen -t rsa -b 4096 -C "**"
# 将在 %userprofile%\.ssh 目录下生2个文件 id_rsa、id_rsa.pub
# id_rsa        SSH密钥
# id_rsa.pub    SSH公钥
```

2、将公钥内容填至 GitHub

进入 `%userprofile%\.ssh` 目录，复制 `id_rsa.pub` 公钥的内容。

打开 `github` 页面 `Settings - SSH and PGP keys - New SSH key - Key` ，粘贴复制的内容。

### git 的全局配置

在 `git-bash` 中输入命令：

```sh
# 设置 git 全局的用户名、邮箱
git config --global user.name kevin
git config --global user.email m@kisa747.top
# 默认为 main 主线
git config --global init.defaultBranch main

git config --global core.autocrlf input  # [true | input | false]
git config --global core.quotepath false

# 提交包含混合换行符的文件策略：[拒绝 | 允许 | 警告] / [true|false|warn]
git config --global core.safecrlf true  # 建议设为 true

git config --global alias.f "fetch"
git config --global alias.m "merge"
git config --global alias.s "status"
git config --global alias.ss "status -s"
git config --global alias.a "add ."
git config --global alias.c "commit -m"
git config --global alias.ca "commit -a -m"
git config --global alias.ch "checkout"
git config --global alias.b "branch"
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

命令详细解释

```sh
# 提交时转换为 LF，检出时转换为 CRLF
git config --global core.autocrlf true
# 提交时转换为 LF，检出时不转换（推荐设置）
# 某些文件（比如批处理*.cmd）需要 CRLF 格式才能正常运行，
# 可以配合 .gitattributes 文件实现 *.cmd 文件从仓库检出也是 CRLF 格式
git config --global core.autocrlf input
# 提交检出均不转换
git config --global core.autocrlf false

# 建议设为 true
#提交包含混合换行符的文件策略：[拒绝 | 允许 | 警告][true|false|warn]
git config --global core.safecrlf true

# Windows 命令提示符下使用 git status 命令，中文文件名会有乱码：
modified:   "\350\256\241\345\210\222\344\273\273\345\212\241/0-sync.cmd"
# 将 core.quotepath 设为 false，git 就不会对 0x80 以上的字符进行 quote。中文显示正常。
git config --global core.quotepath false
# Windows 命令提示符下还有使用 git log 乱码等情况，就不要解决了，直接用 git-bash 是最好的解决方案。
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

对应的配置文件

```ini
# %USERPOFILE%\.gitconfig [Windows]
# ~/.gitconfig [Linux]
[user]
 name = kevin
 email = xx@qq.com
[core]
 autocrlf = input
 quotepath = false
[alias]
    f = fetch
    m = merge
    s = status
    ss = status -s
    a = add *
 c = commit -m
 ca = commit -a -m
 ch = checkout
 b = branch
 lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

## 笔记

### 分支管理

```bash
# 列出所有分支，当前分支前面会标一个*号
git branch
# 创建 dev 分支
git branch dev
# 删除分支（需先切换至别的分支）
git switch main
git branch -d dev


# 切换分支
git switch
# 切换至 dev 分支
git switch dev
# 创建并切换到新分支 dev
git switch -c dev


# 时光穿梭机、检出文件
git restore
# 从指定分支中检出文件
git restore --source=origin/dev function1.js  # 会覆盖本地文件
# 在版本的历史之间穿梭
git reset --hard commit_id


# 然后所有的操作都是在 dev 分支上了。
git add readme.txt
git commit -m "branch test"

# 推送至远程仓库，建立追踪关系，在现有分支与指定的远程分支之间，简写参数为 -u
git push --set-upstream origin dev

git checkout master
# 合并dev到主分支
git merge dev
# 可能会提示错误
# Automatic merge failed; fix conflicts and then commit the result.
# 需要手动解决冲突
git diff
# 然后手动合并冲突的部分
git c "update"

# 顺便打个标签
git tag "V1.0"
# 然后 master 分支也可以推送至远程仓库了
git push

# 就可以愉快地删除 dev 分支了
git branch -d dev

# 一般情况下，正常情况下都在dev分支上工作，正式版合并到 main 上，打上tag，然后继续回到dev上工作。

# 检出文件
git checkout
# 从指定分支中检出文件
git checkout develop function1.js  # 会覆盖本地文件
```

### 同时推送至两个仓库

命令

```sh
git remote set-url --add origin git@gitee.com:kisa747/pycode.git
```

其实就是修改了仓库目录下的 `.git/config` 文件：

```ini
# .git/config
[core]
 repositoryformatversion = 0
 filemode = false
 bare = false
 logallrefupdates = true
 symlinks = false
 ignorecase = true
[remote "origin"]
 url = git@github.com:kisa747/pycode.git
 url = git@gitee.com:kisa747/pycode.git  # 添加了本行内容
 fetch = +refs/heads/*:refs/remotes/origin/*
[branch "main"]
 remote = origin
 merge = refs/heads/main
```

### 忽略文件.gitignore 文件配置

不必从头写.gitignore 文件，GitHub 上提供了很多的模板供使用。<https://github.com/github/gitignore>

更多设置参考：<https://www.cnblogs.com/kevingrace/p/5690241.html>

```sh
# 定义 Git 全局的 .gitignore 文件
git config --global core.excludesfile ~/.gitignore_global

#               表示此为注释，将被 Git 忽略
*.a             表示忽略所有 .a 结尾的文件
!lib.a          表示但lib.a除外
/TODO           表示仅仅忽略项目根目录下的 TODO 文件，不包括 subdir/TODO
build/          表示忽略 build/目录下的所有文件，过滤整个build文件夹；
doc/*.txt       表示会忽略doc/notes.txt但不包括 doc/server/arch.txt
```

### 修改 .gitignore 文件后规则不生效

```sh
# 解决 .gitignore 文件规则不生效。
# .gitignore 文件只能忽略那些原来没有被 track 的文件
# 如果某些文件已经被纳入了版本管理中，则修改.gitignore 是无效的。
# 解决方法就是先把本地缓存删除（改变成未 track 状态），然后再提交
git rm -r --cached .
git add .
```

### 属性 .gitattributes 文件配置

```bash
# .gitattributes

# windows特有文件，必须 crlf 格式
*.cmd  text eol=crlf
*.vbs  text eol=crlf

# 文本文件
*.txt  text eol=lf
*.sh  text eol=lf
*.py  text eol=lf

# 非文本文件
*.jpg  -text
*.pdf       -text
```

### 清除所有的 commit 痕迹

方法一

```sh
# 如何清除之前所有的 commit 痕迹。

# 1、删除.git 隐藏目录

#初始化本地目录为一个 git 仓库
git init
# 添加本地代码到仓库
git add -A
# 提交一个 commit
git commit -m "First commit"
# 关联远程仓库
git remote add origin git@github.com:kisa747/note.git
# 强制提交到远程仓库
# 把本地仓库的内容推送到 GitHub 仓库，并建立关联（-u 参数）
git push -u origin main -f

# 检查是否成功
git r
```

方法二（未尝试过）

参考：<https://www.cnblogs.com/ag-chen/p/18658107>

**创建一个新的空分支或引用：**创建一个临时分支来保存当前的 HEAD 提交。

```bash
git checkout --orphan temp_branch
```

> --orphan 选项会创建一个新的分支，这个分支没有父提交，因此它成为一个新的根提交。

**添加所有文件到新的临时分支：**因为我们现在在一个空的历史记录上，所以需要将所有文件重新添加到这个新分支。

```bash
git add -A
git commit --allow-empty -m "Initial commit"
```

> -A 选项会添加所有文件（包括新的、删除的、修改的）。
> --allow-empty 选项允许在没有任何变化的情况下进行提交（在首次提交时可能需要）。

**删除旧分支：**假设原来的主分支是 main 或 master，可以删除这些分支。不过要小心，这些分支的历史将被删除。

```bash
git branch -D main
```

> -D 选项会在分支已经合并到当前分支时删除它。如果分支没有合并，你可能需要使用 -r（强制删除）选项：

```bash
git branch -rD origin/main  # 删除远程分支
git branch -D main          # 删除本地分支
```

**重命名临时分支：**将临时分支重命名为你的主分支名称。

```bash
git checkout temp_branch
git branch -m main
```

**更新远程仓库（如果适用）：**如果你在一个团队协作的环境中，还需要更新远程仓库。

```bash
git push origin main --force
```

> --force 选项是必需的，因为你已经更改了历史记录。

### 版本回退操作

```bash
# 工作区和暂存区不改变，但是引用向前回退n次。
git reset --soft HEAD^  # 回退1次。
git reset --soft HEAD~2  # 回退2次。
git reset --soft HEAD~3  # 回退3次。
git reset --soft 15a3bc625a  # 回退至指定的commit
# 重新提交
git rm -r --cached . -f
git add .
git commit -m "first"
# 强制推送至远程仓库。
git push -f

# git 命令简写
git config --global alias.f fetch
git config --global alias.s status

#  回退操作详解
# git reset 命令是回退操作，有很多的参数

# git reset --hard永久删除最后几个提交，真正的版本回退。操作之前先将当前HEAD保存到topic/wip分支。
git branch topic/wip     #(1)
git reset --hard HEAD~3  #(2)
git checkout topic/wip   #(3)

# 回滚最近一次提交
git commit -a -m "这是提交的备注信息"
git reset --soft HEAD^      #(1)
$ edit code                 #(2) 编辑代码操作
git commit -a -c ORIG_HEAD  #(3) 会进入vi编辑界面，重新编辑上次提交的信息。
git push

git commit -a -m  # 无法提交新增加的文件。因此如果有新增的文件，必须先使用 git add 命令

git branch
```

### 版本回退原理

若提交后发现有若干改动没有添加，可以使用`--amend`选项尝试重新提交

```bash
git commit --amend
```

最终这次提交会代替上次提交结果

版本回退：

```bash
git reset --hard HEAD^
```

其中，`git reset`用于回退版本。虽然在调用时加上 `--hard` 选项可以令 `git reset` 成为一个危险的命令（可能导致工作目录中所有当前进度丢失！）

`HEAD`可以理解为一个版本的指针。进行回退时，指针直接指向回退的版本。`^`表示上一个版本。

可以用`git reflog`查看回退版本指针情况。

对于后悔药，为`git reset --hard commit_id`

这里摘抄一段穆雪峰老师的评论：

假设一开始你的本地和远程都是：

> a -> b -> c

你想把 HEAD 回退到 b，那么在本地就变成了：

> a -> b

这个时候，如果没有远程库，你就接着怎么操作都行，比如：

> a -> b -> d

但是在有远程库的情况下，你 push 会失败，因为远程库是 a->b->c，你的是 a->b->d

两种方案：

* push 的时候用–force，强制把远程库变成 a -> b -> d，大部分公司严禁这么干，会被别人揍一顿。
* 做一个反向操作，把自己本地变成 a -> b -> c -> d，注意 b 和 d 文件快照内容一莫一样，但是 commit id 肯定不同，再 push 上去远程也会变成 a -> b -> c -> d

简单地说就是你无法容易地抹去远程库的提交信息，所以本地提交怎么都行，push 前想好了

使用 git revert <commit_id>操作实现以退为进，git revert 不同于 git reset  它不会擦除”回退”之后的 commit_id ,而是正常的当做一次”commit”，产生一次新的操作记录，所以可以 push，不会让你再 pull

若要撤销更改，可以使用

```bash
git checkout -- [file]
```

使工作区的该文件撤回到最近一次 `git commit`或者`git add`的状态。

若要删除文件，可先 rm 掉文件，再使用`git remove`。若要恢复误删文件，可使用`git checkout -- [file]`

### 修改仓库 https、git 地址

使用 ssh 更为方便，如果 clone 时使用了 https，使用下面命令可以修改为 ssh

```sh
# https 更换为 git
git remote set-url origin git@github.com:kisa747/note.git
```

尽管使用 ssh 更为方便，但如果要使用 https，当第一次 push 时，会出现一个 `credential helperSelector`的提示。

参考：<https://help.github.com/en/articles/caching-your-github-password-in-git>

<https://www.jianshu.com/p/0ad3d88c51f4>

Git 共有三个级别的 config 文件，分别是**system、global 和 local**。在当前环境中，分别对应`%GitPath%\mingw64\etc\gitconfig`文件、`$home\.gitconfig`文件和`%RepoPath%\.git\config`文件。其中`%GitPath%`为 Git 的安装路径，`%RepoPath%`为某仓库的本地路径。所以 system 配置整个系统只有一个，global 配置每个账户只有一个，而 local 配置和 git 仓库的数目相同，并且只有在仓库目录才能看到该配置。

>manager  若安装 Git 时安装了 GitGUI，自动会在 system 级别中设置 credential.helper 为 manager。并且不配置所处级别（system、global 或者 local）如何，一旦设置了 manager，都优先使用该方式。若本地没有存储凭证，第一次 push 的时候，会弹出窗口，要求输入用户名密码（图 1）。输入并验证成功后并将其存储至 Windows 的凭据管理器中（图 2）。
>
>wincred  **推荐使用**。与 manager 很像，也存储在 Windows 的凭据管理器中，。如果本地没有账户信息，当 push 时会提示输入。如果输入正确也会记录在 Windows 的凭据管理器中。除此之外，该工具还可以使用命令行管理本地存储。**但是，经个人测试，如果同一个 host 使用 wincred 存储多份凭证，只会有一个账户生效。**

```sh
git config --global credential.helper wincred
# 查看本地记录账号
git credential-wincred get
# 删除本地账号
$ git credential-wincred erase
protocol=https
host=github.com
username=NinputerWonder
password=123456
# 添加账号
$ git credential-wincred store
protocol=https
host=github.com
username=NinputerWonder
password=123456
```

综上，因为 store 使用明文保存账户信息，存在安全隐患。使用 manager 和 wincred 方式比较安全，但不能满足多账户（GitHub 账户）切换（除非删除重录）。
**使用 store 方式时，配置每个 repository 的 local 级别 credential.helper，并且通过--file 配置不同的文件，这样每个 repository 可以读取独立的账户信息，可满足需求。**

### 现有仓库修改名称为 main

```sh
# 设置 git 默认设置主线为 main，不影响已有的项目
git config --global init.defaultBranch main

# 把当前 master 分支改名为 main, 其中-M 的意思是移动或者重命名当前分支
# 所以本地 master 分支已经没有了
git branch -M main

# 将新命名的 main 分支推送到 GitHub
git push -u origin main

# 打开 GitHub，修改默认分支为 main，Settings - Repositories - Repository default branch

# 删除远程 master 分支
git push origin :master
```

### git LFS

参考：<https://git-lfs.github.com/>

<https://blog.csdn.net/peterxiaoq/article/details/77851921>

```sh
# windows 下安装
scoop install git-lfs
# Debian 下安装
sudo apt install git-lfs
# initialize the Git LFS project，此仓库启用 Git LFS
git lfs install

# 进入到仓库目录后操作。
git lfs track "*.xz"
# 这个仓库就会自动使用 lfs 追踪 xz 后缀的文件。
# 其实就是保存在了 .gitattributes 文件中。
$ cat .gitattributes
*.xz filter=lfs diff=lfs merge=lfs -text
# 然后就可以正常使用 git，跟以前没有什么区别。
git add .
git commit -m "u"
git push origin master

# 查看当前正在追踪的实际文件的列表
git lfs ls-files
```

#### LFS 原理

由于 git 会保存文件的所有更改，如果是文本文件，这没什么问题，git 只需以 diff 形式保存更改就行了，对于二进制文件，只要文件发生了变化，git 无法知道它到底哪里发生了更改，只能原封不动地记录所有更改，也就是每当提交一个 100MB 的 Photoshop 文件中的细微改变，仓库的大小当然也会增长 100MB。如果二进制文件较多、较大，而且更改又比较频繁，就会导致本地仓库急剧增大。

LFS 并没有改变 git 本身的原理，被提交到仓库中的文件还会保留在仓库和本地。

当然，LFS 并不能像"变魔术一样"处理所有的大型数据：它需要记录并保存每一个变化。然而，这就把负担转移给了远程服务器 - 允许本地仓库保持相对的精简。

为了实现这个可能，LFS 耍了一个小把戏：它在本地仓库中并不保留所有的文件版本，而是仅根据需要提供检出版本中必需的文件。

但这引发了一个有意思的问题：如果这些庞大的文件本身没有出现在你的本地仓库中....改用什么来代替呢？[LFS 保存轻量级指针](https://www.git-tower.com/learn/git/ebook/en/desktop-gui/advanced-topics/git-lfs?utm_source=gitlab-blog&utm_campaign=GitLabLFS&utm_medium=guest-post)中有真实的文件数据。当你用一个这样的指针去迁出一个修订版时，LFS 会很轻易地找到源文件（不在他上面可能就在服务器上，特殊缓存）然后你下载就行了。

因此，你最终只会得到你真正想要的文件 - 而不是一些你可能永远都不需要冗余数据。

> 这意味着应该在文件没有提交到仓库前就让 LFS 进行追踪。不然，它就成了项目历史的一部分，令项目增大数 MB 或数 GB 的大小...

### Keep your fork synced

参考：<https://help.github.com/en/articles/fork-a-repo>
