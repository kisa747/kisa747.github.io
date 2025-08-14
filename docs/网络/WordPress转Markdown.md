# WordPress转Markdown

参考：<https://github.com/dreikanter/wp2md>

<https://github.com/ytechie/wordpress-to-markdown>

配置好 Node.js，然后使用下面工具转换

Clone the repo and go into its directory to install dependencies:

```sh
git clone https://github.com/ytechie/wordpress-to-markdown.git
cd wordpress-to-markdown/
npm i xml2js to-markdown
```

Copy your Wordpress content export into the folder as `export.xml`. Then run the script

```sh
node convert.js
```
