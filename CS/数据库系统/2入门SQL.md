# SQL

## DDL 数据定义语言

Data Definition Language，定义或修改数据库的**结构**（比如创建表、删除表、修改字段）

一共三类语句分别是 CREATE、DROP、ALTER，代表创建、删除、修改，能够对 DATABASE、TABLE、VIEW、INDEX 对象进行定义

SQL 中有如下数据类型

|关键字|数据类型|
|---|---|
|INYINT|1B 整数|
|SMALLINT|2B 整数|
|INT|4B 整数|
|BIGINT|8B 整数|
|FLOAT|浮点数|
|CHAR(n)|定n长字符串|
|VARCHAR(n)|最大n长字符串|
|DATETIME|日期|
|DECIMAL|十进制数据|

### CREATE

**CREATE DATABASE** 用于创建数据库，语法如下

```sql
CREATE DATABASE dbname;
```

**CREATE TABLE** 用于创建表，语法如下

```sql
CREATE TABLE TableName (
    列名1 数据类型 约束条件,
    列名2 数据类型 约束条件,
    列名3 数据类型 约束条件,
    ...
    PRIMARY KEY (主键列名)
);
```

例如，创建一个用户表

```sql
CREATE TABLE Users (
    user_id INT,                   -- 用户ID
    username VARCHAR(50) NOT NULL, -- 用户名，不能为空
    email VARCHAR(100) UNIQUE,     -- 邮箱，必须唯一
    birth_date DATE,               -- 生日
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
                                   -- 创建时间默认为当前
    PRIMARY KEY (user_id)          -- 设置 user_id 为主键
);
```

常见的约束条件有

- NOT NULL: 强制该列不能有空值
- UNIQUE: 确保该列的所有值都是唯一的
- PRIMARY KEY: 主键，唯一标识每一行（自带 UNIQUE 和 NOT NULL 属性）
- FOREIGN KEY: 外键，用来建立和其他表的关联
- DEFAULT: 当不输入数据时，使用的默认值
- CHECK: 值必须满足特定条件

> 在约束条件中写上 FOREIGN KEY 只能让该列作为主键，而使用 PRIMARY KEY () 可以定义联合主键，前者适合简单表后者适合复杂表
>
> PRIMARY KEY 是自带 NOT NULL 和 UNIQUE 约束条件的，不需要多写

### DROP

**DROP DATABASE** 用于删除数据库，语法如下

```sql
DROP DATABASE 数据库名;
DROP DATABASE IF EXISTS 数据库名;   // 如果存在再删除
```

**DROP TABLE** 用于删除表，语法如下

```sql
DROP TABLE 表名;
DROP TABLE IF EXISTS 表名;   // 如果存在再删除
```

删除数据库或索引不同的 DBMS 支持度不同，但删除表一般都支持删除多个，如：

```sql
DROP TABLE table1, table2;
```

### ALTER

**ALTER TABLE** 用于修改表结构，例如

```sql
-- 在表末尾增加一列
ALTER TABLE 表名 ADD 列名 数据类型;

-- 彻底删除该列及数据
ALTER TABLE 表名 DROP COLUMN 列名;

-- 改变列的类型
ALTER TABLE 表名 MODIFY 列名 数据类型;

-- 重命名列
ALTER TABLE 表名 RENAME COLUMN 旧列名 TO 新列名;

-- 重命名表
ALTER TABLE 表名 RENAME TO 新表名;
```

### INDEX

上面三种操作都没有提到索引，这里单独说明。索引创建于经常出现在 WHERE 子句、JOIN 关联条件、ORDER BY 排序中的列

比如要根据手机号查找用户，如果没有索引

```sql
SELECT username FROM users WHERE phone = '19101010101';
```

那么这行语句将会以 $O(n)$ 时间查找用户，但执行了

```sql
CREATE UNIQUE INDEX idx_phone_unique ON users(phone);
```

查找语句无需改变，自动调用索引，查询变为 B+ 树查找，速度大幅提升

**CREATE INDEX** 用于创建索引，语法如下

```sql
CREATE INDEX 索引名称 ON 表名 (列名 次序);
-- 创建普通索引

CREATE UNIQUE INDEX 索引名称 ON 表名 (列名 次序);
-- 创建唯一索引（确保列中没有重复值）

CREATE INDEX 索引名称 ON 表名 (列1, 列2);
-- 创建复合索引（多列组合）
```

其中次序为升序 ASC 或降序 DESC，默认是升序的不需要写 ASC

### VIEW

上面三种操作都没有提到视图，这里单独说明。视图是一个**虚拟表**，基于 SQL 查询定义，不存储数据，查询时动态计算，常用于简化复杂查询、提供数据安全和抽象数据层

**CREATE VIEW** 用于创建视图，语法如下

```sql
CREATE VIEW 视图名称 (列名1, 列名2, ...) AS 
<一个查询块，即 SELECT 语句>
[WITH CHECK OPTION]
```

其中视图的列名可以省略，但以下情况下列名必须写出：

- 存在聚合函数，除非有别名
- 存在算术表达式或函数，除非有别名
- 存在 JOIN 导致的列名重复

WITH CHECK OPTION 选项用于确保通过视图进行的任何数据修改都必须满足视图定义的条件，否则会被拒绝。

例如

```sql
CREATE VIEW ScoreA AS
SELECT id, score
FROM Scores
WHERE score >= 90
WITH CHECK OPTION
```

如果在上面的视图定义中存在 WITH CHECK OPTION，任何试图通过 ScoreA 视图插入或更新数据的操作都必须满足 score >= 90 的条件，否则将会失败

如果视图有以下情况，不允许更新：

- 由两个基本表连接而成
- 字段是聚合函数、表达式或常数
- 包含 DISTINCT、GROUP BY、HAVING 或 UNION 等子句
- 包含子查询
- 由不可更新的视图定义而成

## DML 数据操作语言

Data Manipulation Language，对表里的**数据行**进行增、删、改

### INSERT

**INSERT INTO** 用于向表中插入行，语法如下

```sql
INSERT INTO 表名
VALUES (值1, 值2, 值3);
-- 所有列均有值，可省略列名

INSERT INTO 表名 (列名1, 列名2, 列名3) 
VALUES (值1, 值2, 值3);
-- 指定插入某些列
```

可以一次性，插入多行，如：

```sql
INSERT INTO students (name, age) 
VALUES 
    ('李四', 19),
    ('王五', 20),
    ('赵六', 18);
```

此外，还可以与 SELECT 搭配使用，实现表拷贝等操作。如下，将表现为 A 的实习生插入员工表中

```sql
INSERT INTO employees (name, department)
SELECT name, dept
FROM interns
WHERE performance = 'A';
```

Tips:

- 自主增键不要写在 INSERT 语句中
- VALUES 中的值可以为 NULL
- 尽量不要选择省略列名的写法，鲁棒性差

DBMS 会自动检测插入会不会违反目前表的完整性约束

### UPDATE

**UPDATE** 用于更新表中已经存在的记录，语法如下

```sql
UPDATE 表名
SET 列名1 = 新值1, 列名2 = 新值2
WHERE 过滤条件;
```

比如要修改学号为 101 的学生的成绩：

```sql
UPDATE Scores
SET score1 = 100, score2 = 99
WHERE id = 101;
```

### DELETE

**DELETE** 用于删除表中的某一行，语法如下

```sql
DELETE FROM 表名
WHERE 过滤条件;
```

WHERE 子句的过滤条件等同 SELECT 语句中的 WHERE 子句

**TRUNCATE** 用于清空整张表，实则是直接重建，速度会比 DELETE 快

```sql
TRUNCATE 表名;
```

## DQL 数据查询语言

Data Query Language，最常用的部分，用于从数据库中检索数据

### SELECT

用于在表中查询，最重要的语句，语法如下

```sql
SELECT [DISTINCT] 列名               -- 1. 想要什么
FROM 表名                            -- 2. 从哪儿拿
连接类型 JOIN 表名 ON 连接条件         -- 3. 关联别的表
WHERE 过滤条件                        -- 4. 第一次筛选（行级）
GROUP BY 分组列                      -- 5. 分类汇总
HAVING 分组后的过滤条件                -- 6. 第二次筛选（组级）
ORDER BY 排序列 ASC/DESC             -- 7. 排序
LIMIT 偏移量, 数量;                   -- 8. 截取部分结果
```

**SELECT** 后可以用 DISTINCT 消除重复结果，列名可以有多个也可以是聚合函数，如：

```sql
SELECT 
    COUNT(*) AS total_orders,       -- 统计行数
    MAX(price) AS max_price,        -- 最大值
    AVG(price) AS average_price     -- 平均值
FROM orders
WHERE product_category = '电子产品';
```

**AS** 可用于给表或列起别名，如

```sql
SELECT 列名 AS 别名
FROM 表明;
-- 给列起别名（常用）

SELECT 列名(s)
FROM 表名 AS 表别名;
-- 给表起别名
```

### FROM

**FROM** 后面可以跟一个表，也可以跟一个子查询块，甚至是多个表或子查询块

当 FROM 后面跟多个表时，本质上是进行 CROSS JOIN（笛卡尔积），需要在 WHERE 子句中指定连接条件，否则会得到大量无意义的结果。这是一种旧式标准，如果忘记写 WHERE 子句，会得到一个巨大的笛卡尔积结果，但性能上和 JOIN 没有区别

### WHERE

**WHERE** 用于筛选符合条件的行，支持多种运算符，但不能用聚合函数

运算符包括：= 等于、<> 不等于、> 大于、< 小于、>= 大于等于、<= 小于等于、NOT 非、AND 并、OR 或，以及如下几个比较复杂的：

- LIKE 用于模糊匹配，比如 `LIKE '张%'`，其中 `%` 代表任意长度的字符串，`_` 代表单个字符，`[138]` 代表匹配 1、3、8 中的任意一个字符，`[^a-c]` 代表匹配除 a、b、c 以外的任意一个字符，`ESCAPE` 用于指定转义符，比如 `LIKE '100\%' ESCAPE '\'` 匹配以 "100%" 开头
- IN 用于匹配列表中的值，比如 `IN (1, 2, 3)`，或后接一个子查询
- ANY 用于比较一个值与一个子查询返回的结果集中的任意一个值
- ALL 用于比较一个值与一个子查询返回的结果集中的所有值
- EXISTS 用于判断子查询是否返回至少一行数据，常用于相关子查询中
- BETWEEN 范围查询，比如 `BETWEEN 10 AND 100`，等价于 `>= 10 AND <= 100`
- IS NULL 用于判断是否为 NULL，比如 `IS NULL` 或 `IS NOT NULL`
- 括号用于分组或改变运算优先级，如 `(A AND B) OR C`，其中 A、B、C 是条件表达式

在 SQL 中， `""`用于标识列名或表名，`''` 用于标识字符串常量，`[]` 用于标识列名或表名（SQL Server 中），反引号 `` 用于标识列名或表名（MySQL 中）

例如 [LeetCode 1683. 无效的推文](https://leetcode.cn/problems/invalid-tweets/) 选择 content 长度大于 15 的推文 id

```sql
SELECT tweet_id FROM Tweets WHERE LEN(content) > 15
```

例如 [LeetCode 1148. 文章浏览 I](https://leetcode.cn/problems/article-views-i) 选择所有作者 id 等于读者 id 的阅读记录，输出 id，重命名并排序

```sql
SELECT DISTINCT author_id AS id 
FROM Views
WHERE author_id = viewer_id
ORDER BY id;
```

例如 [LeetCode 595. 大的国家](https://leetcode.cn/problems/big-countries) 选择面积至少 300 万或人口至少 2500 万的国家，输出名字、人口和面积

```sql
SELECT name, population, area FROM World
WHERE area >= 3000000 OR population >= 25000000;
```

### JOIN

|类型|作用|
|---|---|
|INNER JOIN|返回两个表中满足连接条件的记录（交集）|
|LEFT JOIN|返回左表中的所有记录，即使右表无匹配（保留左表）|
|RIGHT JOIN|返回右表中的所有记录，即使左表无匹配（保留右表）|
|FULL OUTER JOIN|返回两个表的并集，包含匹配和不匹配的记录|
|CROSS JOIN|左表记录与每条右表记录进行组合（笛卡尔积）|
|SELF JOIN|将一个表与自身连接|
|NATURAL JOIN|基于同名字段自动匹配连接的表（自然连接）|

除了自然连接和笛卡尔积，JOIN 后必须跟 ON 关键字，说明连接的凭证。INNER JOIN 可简写为 JOIN

例如 [LeetCode 1378. 使用唯一标识码替换员工ID](https://leetcode.cn/problems/replace-employee-id-with-the-unique-identifier) 对相同 id 进行连接

```sql
SELECT unique_id, name
FROM Employees
LEFT JOIN EmployeeUNI
ON Employees.id = EmployeeUNI.id;
```

### GROUP BY

**GROUP BY** 对某一列分组，一般搭配 SELECT 中的聚合函数使用

```sql
SELECT 
    分类列名, 
    聚合函数(计算列名)
FROM 表名
GROUP BY 分类列名;
```

例如 [LeetCode 1581. 进店却未进行过交易的顾客](https://leetcode.cn/problems/customer-who-visited-but-did-not-make-any-transactions) 给定交易表和访问表找出访问过但没有交易过的顾客并统计数量

- 先链接两个表
- 选择交易 id 为 NULL 的元组
- 用 COUNT(*) 和 GROUP BY 分组并统计数量

```sql
SELECT 
    Visits.customer_id,
    COUNT(*) AS count_no_trans
FROM Visits
LEFT JOIN Transactions 
ON Visits.visit_id = Transactions.visit_id
WHERE Transactions.transaction_id IS NULL
GROUP BY Visits.customer_id;
```

**HAVING** 配合 GROUP BY 使用，用于分组完后再次进行筛选，筛选的是组而不是行

例如按部门分组后，找出平均工资大于一万的部门

```sql
SELECT department, AVG(salary) AS avg_pay
FROM employees
GROUP BY department
HAVING AVG(salary) > 10000; -- 这里只能用聚合函数或分组列
```

### ORDER BY

**ORDER BY** 用于排序，可以放入多个列名。比如

```sql
ORDER BY salary DESC, hire_date ASC;
-- 按工资从高到低排序，如果工资一样，按入职时间先后排
```

null 在排序中被认为是最大值，升序时排在最后，降序时排在最前

### LIMIT

**LIMIT** 用于截取部分结果，语法如下

```sql
LIMIT n           -- 只取前 n 条。
LIMIT offset, n   -- 跳过前 offset 条，取接下来的 n 条。
```

### 嵌套查询

一个 SELECT FROM WHERE 被称为一个查询块，查询块可以嵌套在另一个查询块中，形成嵌套查询（Nested Query）或子查询（Subquery）

子查询可出现在 SELECT、FROM、WHERE、JOIN、HAVING 子句中

子查询分为相关子查询和非相关子查询，前者依赖于外部查询块中的列，需要外层传递参数，例如查询每个部门中工资最高的员工

```sql
SELECT name, dept_id, salary
FROM Employees AS e1
WHERE salary = (
    SELECT MAX(salary) 
    FROM Employees AS e2 
    WHERE e2.dept_id = e1.dept_id
        -- 这里引用了外层的 e1.dept_id
);
```

上述代码的工作原理类似双重循环

- 遍历 Employees 表中的每一行，记为 e1
- 对于每一行 e1，执行子查询
  - 子查询在 Employees 表中查找与 e1.dept_id 相同的行，记为 e2
  - 在这些行中找到最大的 salary 值
- 如果 e1 的 salary 等于子查询返回的最大 salary，则将 e1 的 name、dept_id 和 salary 包含在最终结果中

再举例一个，找出没有参与任何工作的员工，即找出不存在于至少参与了一个工作的员工表中的员工

```sql
SELECT name
FROM Employees AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM WorksOn AS w
    WHERE w.emp_id = e.emp_id
);
```

可以看到，子查询对于外层表每一行都会遍历一次内层表，效率很低，所以尽量避免使用相关子查询，改用 JOIN 或窗口函数等更高效的方式

### UNION

**UNION** 用于求两个查询结果的并集，要求两个表列数相同，列类型兼容，默认去重

```sql
SELECT 列名1, 列名2 FROM 表1
UNION
SELECT 列名1, 列名2 FROM 表2;
```

## DCL & TCL 控制与事务语言

用于管理权限、确保数据安全和事务处理

- DCL (数据控制):
  - GRANT: 赋予用户权限
  - REVOKE: 收回权限
- TCL (事务控制):
  - COMMIT: 确认提交（持久化到磁盘）
  - ROLLBACK: 回滚（撤销刚才的操作，像按下 Ctrl+Z）
  - SAVEPOINT: 设置保存点

### GRANT & REVOKE

GRANT 用于赋予用户权限，语法如下

```sql
GRANT 权限类型 ON 对象 TO 用户
[WITH GRANT OPTION]
```

权限类型包括 SELECT、INSERT、UPDATE、DELETE、ALL 等，WITH GRANT OPTION 允许被授权用户继续授权给其他用户

REVOKE 用于收回权限，语法如下

```sql
REVOKE 权限类型 ON 对象 FROM 用户
```

## 控制流语句

### CASE END

类似于 Golang 中的 `switch case`，可以对某个值进行多重判断，也可以在 `CASE` 后写表达式

```sql

```

## SQL 函数

按输入内容分为聚合函数和标量函数，聚合函数输入列，标量函数输入一个值

### 聚合函数

SQL Aggregate Function，参数为一列，返回一个单一的值

- AVG() 返回平均值
- COUNT() 返回行数
- FIRST() 返回第一个记录的值
- LAST() 返回最后一个记录的值
- MAX() 返回最大值
- MIN() 返回最小值
- SUM() 返回总和

### 标量函数

SQL Scalar Function，参数为一个值，返回一个单一的值

- UCASE() 将某个字段转换为大写
- LCASE() 将某个字段转换为小写
- MID() 从某个文本字段提取字符，MySql 中使用
- SubString(字段，1，end) 从某个文本字段提取字符
- LEN() 返回某个文本字段的长度
- ROUND() 对某个数值字段进行指定小数位数的四舍五入
- NOW() 返回当前的系统日期和时间
- FORMAT() 格式化某个字段的显示方式

### 窗口函数

Window Functions，一个比较特殊的函数，它参照周边的关系返回一个值

### 表值函数

SQL Table-Valued Functions, TVF，输入参数为一个值，返回一个表格

## 综合例子

### [LeetCode 570. 至少有5名直接下属的经理](https://leetcode.cn/problems/managers-with-at-least-5-direct-reports)

一个 Employee 表，包含员工 ID、名字和自己的经理 ID，找出至少有 5 名直接下属的经理 ID 和名字

首先找出经理 ID 列中出现过至少 5 次的经理 ID

```sql
SELECT e.managerId, COUNT(e.managerId) AS cnt 
FROM Employee AS e
WHERE e.managerId IS NOT NULL
GROUP BY e.managerId
HAVING COUNT(e.managerId) >= 5
```

然后将其与 Employee 表连接，找出经理的名字

```sql
SELECT ee.name
FROM (
    SELECT e.managerId, COUNT(e.managerId) AS cnt 
    FROM Employee AS e
    WHERE e.managerId IS NOT NULL
    GROUP BY e.managerId
    HAVING COUNT(e.managerId) >= 5
) AS c 
JOIN Employee AS ee
ON ee.id = c.managerId
```

### [LeetCode 1251. 平均售价](https://leetcode.cn/problems/average-selling-price)

一个 Prices 表，包含产品 ID、开始日期、结束日期和售价。一个 UnitsSold 表，包含产品 ID、日期和售出数量。找出每个产品的平均售价

由于要找出每个产品，将 UnitsSold LEFT JOIN 至 Prices 表

```sql
SELECT *
FROM Prices AS P
LEFT JOIN UnitsSold AS U
ON P.product_id = U.product_id
AND U.purchase_date BETWEEN P.start_date AND P.end_date 
```

然后用 `SUM(A*B)/SUM(B)`  计算加权平均数，对于没有售出的产品，用 CASE WHEN 替换为 0，保留两位小数，最后按照 product_id 分组

```sql
SELECT P.product_id,
    CASE 
        WHEN SUM(U.units) = 0 OR SUM(U.units) IS NULL THEN 0.00
        ELSE ROUND(SUM(P.price * U.units) * 1.0 / SUM(U.units), 2)
    END AS average_price
FROM Prices AS P
LEFT JOIN UnitsSold AS U
ON P.product_id = U.product_id
AND U.purchase_date BETWEEN P.start_date AND P.end_date 
GROUP BY P.product_id
```