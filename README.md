MySQL User-defined function (UDF) for HTTP GET/POST
==========

MySQL User-defined function (UDF) for HTTP REST

**Note:** It is a fork repository. Original Website is below.  
http://code.google.com/p/mysql-udf-http

## Overview

| HTTP Method | CRUD Action |      Description       |
|-------------|-------------|------------------------|
| POST        |  CREATE     |  Create a new resource |
| GET         |  READ       |  Read a resource       |
| PUT         |  UPDATE     |  Update a resource     |
| DELETE      |  DELETE     |  Delete a resource     |

Support MySQL version 5.1.x and 5.5.x on Linux systems.

## User Guide

### 0. Prepare

make sure these depandencies are installed.

* mysql server
* mysql_config command
* development tools

For Debian, like this.

```
apt-get install mysql-server
apt-get install make
apt-get install gcc
apt-get install libmysqlclient-dev
apt-get install pkg-config
```

### 1. Install on Linux

This sample is written for "/usr/local/webserver/mysql/" is your MySQL install path.

```
ulimit -SHn 65535
wget http://curl.haxx.se/download/curl-7.21.1.tar.gz
tar zxvf curl-7.21.1.tar.gz
cd curl-7.21.1/
./configure --prefix=/usr
make && make install
cd ../

echo "/usr/local/webserver/mysql/lib/mysql/" > /etc/ld.so.conf.d/mysql.conf
/sbin/ldconfig
wget http://mysql-udf-http.googlecode.com/files/mysql-udf-http-1.0.tar.gz
tar zxvf mysql-udf-http-1.0.tar.gz
cd mysql-udf-http-1.0/
./configure --prefix=/usr/local/webserver/mysql --with-mysql=/usr/local/webserver/mysql/bin/mysql_config
make && make install
cd ../
```

### 2. Enter to the MySQL console

```
/usr/local/webserver/mysql/bin/mysql -S /tmp/mysql.sock
```

### 3. Create the UDF function in the MySQL console

```
mysql>

create function http_get returns string soname 'mysql-udf-http.so';
create function http_post returns string soname 'mysql-udf-http.so';
create function http_put returns string soname 'mysql-udf-http.so';
create function http_delete returns string soname 'mysql-udf-http.so';
```

### 4. Usage

#### Description:

```
mysql>
SELECT http_get('<url>');
SELECT http_post('<url>', '<data>');
SELECT http_put('<url>', '<data>');
SELECT http_delete('<url>');
```

#### Example (A):

```
mysql>

/* Baidu Mobile Search */
SELECT http_get('http://m.baidu.com/s?word=xoyo&pn=0');
SELECT http_post('http://m.baidu.com/s','word=xoyo&pn=0');

/* Sina Weibo Open Platform */
SELECT http_get('http://api.t.sina.com.cn/statuses/user_timeline/103500.json?count=1&source=1561596835') AS data;
SELECT http_post('http://your_sina_uid:your_password@api.t.sina.com.cn/statuses/update.xml?source=1561596835', 'status=Thins is sina weibo test information');

/* Tokyo Tyrant */
SELECT http_put('http://192.168.8.34:1978/key', 'This is value');
SELECT http_get('http://192.168.8.34:1978/key');
SELECT http_delete('http://192.168.8.34:1978/key');
```

#### Example (B):

Use mysql-udf-http and lib_mysqludf_json synchronizes the update to Tokyo Tyrant with MySQL Trigger.

(1). Download and install lib_mysqludf_json:

On 32-Bit Linux:

```
wget http://mysql-udf-http.googlecode.com/files/lib_mysqludf_json-i386.tar.gz
tar zxvf lib_mysqludf_json-i386.tar.gz
cd lib_mysqludf_json-i386/
# if your MySQL install path is not '/usr/local/webserver/mysql/', please modify the path.
cp -f lib_mysqludf_json.so /usr/local/webserver/mysql/lib/mysql/plugin/lib_mysqludf_json.so
cd ../
```

On 64-Bit Linux:

```
wget http://mysql-udf-http.googlecode.com/files/lib_mysqludf_json-x86_64.tar.gz
tar zxvf lib_mysqludf_json-x86_64.tar.gz
cd lib_mysqludf_json-x86_64/
# if your MySQL install path is not '/usr/local/webserver/mysql/', please modify the path.
cp -f lib_mysqludf_json.so /usr/local/webserver/mysql/lib/mysql/plugin/lib_mysqludf_json.so
cd ../
```

Enter to the MySQL console:

```
/usr/local/webserver/mysql/bin/mysql -S /tmp/mysql.sock
```

```
mysql>

create function lib_mysqludf_json_info returns string soname 'lib_mysqludf_json.so';
create function json_array returns string soname 'lib_mysqludf_json.so';
create function json_members returns string soname 'lib_mysqludf_json.so';
create function json_object returns string soname 'lib_mysqludf_json.so';
create function json_values returns string soname 'lib_mysqludf_json.so';
```

How to use lib_mysqludf_json, please visit: http://www.mysqludf.org/lib_mysqludf_json/

(2). Create table:

```
mysql>

SET NAMES UTF8;
USE test;
CREATE TABLE IF NOT EXISTS `mytable` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `addtime` int(10) NOT NULL,
  `title` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;
(3). Create trigger for table:

mysql>

/* TRIGGER for INSERT */
DELIMITER |
DROP TRIGGER IF EXISTS mytable_insert;
CREATE TRIGGER mytable_insert
AFTER INSERT ON mytable
FOR EACH ROW BEGIN
    SET @tt_json = (SELECT json_object(id,addtime,title) FROM mytable WHERE id = NEW.id LIMIT 1);
    SET @tt_resu = (SELECT http_put(CONCAT('http://192.168.8.34:1978/', NEW.id), @tt_json));
END |
DELIMITER ;

/* TRIGGER for UPDATE */
DELIMITER |
DROP TRIGGER IF EXISTS mytable_update;
CREATE TRIGGER mytable_update
AFTER UPDATE ON mytable
FOR EACH ROW BEGIN
    SET @tt_json = (SELECT json_object(id,addtime,title) FROM mytable WHERE id = OLD.id LIMIT 1);
    SET @tt_resu = (SELECT http_put(CONCAT('http://192.168.8.34:1978/', OLD.id), @tt_json));
END |
DELIMITER ;

/* TRIGGER for DELETE */
DELIMITER |
DROP TRIGGER IF EXISTS mytable_delete;
CREATE TRIGGER mytable_delete
AFTER DELETE ON mytable
FOR EACH ROW BEGIN
    SET @tt_resu = (SELECT http_delete(CONCAT('http://192.168.8.34:1978/', OLD.id)));
END |
DELIMITER ;
```

(4). Select data from MySQL table and Tokyo Tyrant:

```
mysql>

SELECT id,addtime,title,http_get(CONCAT('http://192.168.8.34:1978/',id)) AS tt FROM mytable ORDER BY id DESC LIMIT 0,5;
```


### 5. How to drop the UDF function

```
mysql>

drop function http_get;
drop function http_post;
drop function http_put;
drop function http_delete;
```

## Author

Please check the ``Members`` at the left side of menu.
https://code.google.com/p/mysql-udf-http/

## License

This is free software, and you are welcome to modify and redistribute it under the New BSD License.
