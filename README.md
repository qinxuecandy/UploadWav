# 使用说明
1. 手机和电脑连接在同一局域网下（比如都连接校网），查找电脑的ip地址;
2. 打开FlaskServer文件夹，执行FlaskServer.py，打开对应的端口，比如http://10.180.84.149:5000/upload ，查看服务器端是否正常运行，可以用在同一局域网下的其他设备访问网址，查看是否可以进行访问。注意关闭所有防火墙。
3. 打开patternlistener文件夹，运行patternlistener，在.\PatternListener\app\src\main\java\com\example\patternlistener\ImageUpload中将ip地址更改为服务器端的ip地址;
4. 在手机上运行app即可，文件储存在.\FlaskServer\static\images\test.wav

## 2.0.0

实现matlab部分的自启动

## 1.0.0

实现patternlistener和uploadwav的融合

## 0.1.1
实现同名文件的覆盖

## 0.1
实现音频文件的上传以及重命名

## 0.0
实现图片的上传