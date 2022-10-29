# 美字精灵🧚‍♀️
<img src="logo.jpeg" alt="logo" width="50"/>

中文个人手写字体制作工具

\#手写体 \#字体 \#中文 \#书法 \#艺术 \#造字

## 目标用户
希望制作自己手写字体的爱好者，本工具使用开源fontforge，你拥有你字体的完全版权。

## 流程及工具
* 下载模版
* 打印模版 （需要打印机）
* 填充模板 （需要笔）
* 扫描模板 （最好是使用扫描仪，手机扫描其实也还行）
* 产生字体  （需要安装使用本工具）  

## 安装 [MAC版]
安装 [Homebrew](https://docs.brew.sh/Installation) , 然后
```
brew install fontforge
brew install potrace
brew install zbar
```
  Python packages 建议使用 [conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html) 安装
```
conda env create -f environment.yml
```
之后你可能会遇到错误 `ImportError: Unable to find zbar shared library`，你需要以下workaround
```
mkdir ~/lib
ln -s $(brew --prefix zbar)/lib/libzbar.dylib ~/lib/libzbar.dylib
```

## 使用说明
### 模板
如果你目标宏大，想得到完整字体，你需要写6763个汉字，模板可以直接在 `template` 下面下载。同时也提供常用一千字模板，二千字模板等等。

你也可以定制自己的模板，你的目标可以是先覆盖一本你最爱的的书，比如 `红楼梦.txt`
```
sed 's/\(.\)/\1\n/g' 红楼梦.txt | sort | uniq -c | sort -nr | awk '{print $2}' > 红楼梦字集.txt
```

就可以得到这本书里面所有的不同单字，按照出现频率排列。用这个文件就可以产生自己的模板。
```
cd src
python generate_template.py 红楼梦字集.txt
```
就可以得到一个pdf模板文件。
你也可以调整模板字格大小，字体，输出文件名。

`src/config` 里面可以找到常用字的单字文本，可以直接用来用。

```
(wefont) ➜  src git:(master) python generate_template.py -h
usage: generate_template.py [-h] [-cs CELL_SIZE] [-f FONT] [-fs FONT_SIZE] [-o OUTPUT] [-rs] [-v] filename

generate template based on gb2312

positional arguments:
  filename              input file containing the characters

options:
  -h, --help            show this help message and exit
  -cs CELL_SIZE, --cell_size CELL_SIZE
                        the size of cell, default is 20
  -f FONT, --font FONT  the Chinese font used, default is fireflysung
  -fs FONT_SIZE, --font_size FONT_SIZE
                        the font size, default is based on cell size
  -o OUTPUT, --output OUTPUT
                        output pdf file name
  -rs, --remove_subscript
                        remove the subscript number of cell
  -v, --verbose         print more info
```

### 书写，扫描
书写建议使用色彩比较重的笔，扫描后如果输出的是 `pdf`，需要转化为 `jpg`

```
convert -verbose -density 150 -quality 100 扫描文件.pdf input-%02d.jpg
```
可能需要安装 `ImageMagic`

### 产生字体
这一步可以一键完成
```
cd src
./forge_my_font.sh 字体名 扫描文件1.jpg 扫描文件2.jpg 扫描文件3.jpg ... 
```

## 先导尝试
在大规模开写之前，可以先试一试。template里面有`测试模板（郭襄小诗）.pdf`，写完得到字体之后可以用你的字体预览下下面这首小诗，看看效果

> 我走过山时   
> 山不说话  
> 我路过海时  
> 海不说话  
> 小毛驴滴滴答答  
> 倚天剑伴我走天涯  
> 大家都说我因为爱着杨过大侠  
> 才在峨嵋山上出了家  
> 其实我只是爱上了峨嵋山上的云和霞  
> 像极了十六岁那年的烟花  

## 写错了字怎么办
如果模板中有字写错了，可以先不用管它，正常先生成字体，然后打补丁。打补丁的方式是先把错字集中写到一个文件中，比如"错字集.txt", 然后使用
```
cd src
python generate_template.py 红楼梦字集.txt
```
生成模板，书写，扫描，得到jpg文件
```
cd src
./patch_my_font.sh 现在的字体.ttf 扫描文件1.jpg 扫描文件2.jpg 扫描文件3.jpg ... 
```
这样新的模板中的字符就会覆盖旧的字体中的字符，从而得到新的打补丁的字体。
而且模板中的字符也可以是完全新的字符，这样就不是覆盖，而是添加到旧的字体中。用这种方式，你可以循序渐进的书写新的字，添加到旧的字体中，从而不断得到更加完全的字体。


## 常见问题
**问：为什么我的图片无法被处理？**

**答：** 目前发现截图的图片无法被正确处理，QR code无法被识别，所以请目前不要使用截图。

## 卖家秀
![alt text](./show.jpg)
