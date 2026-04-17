# JavaScript

## 数据类型

JS 是一个动态类型语言，变量可以随时改变类型。数据类型可分为基本类型和对象类型两大类

基本类型有 

- Number：数字类型，包含整数和浮点数
- String：字符串类型，表示文本数据
- Boolean：布尔类型，表示真（true）和假（false）
- Null：空类型，表示没有值
- Undefined：未定义类型，表示变量未赋值
- Symbol：符号类型，表示唯一的标识符

对象类型有

- Object：对象类型，表示一组键值对
- Array：数组类型，表示有序的元素集合
- Function：函数类型，表示可调用的代码块
- Date：日期类型，表示日期和时间
- RegExp：正则表达式类型，表示模式匹配的文本
...

## 字面量、变量、常量

JS 字面量有如下几种

```javascript
// 数字字面量
100
1e5
3.14

// 字符串字面量，用单引号双引号均可
"hello"
'world'

// 数组字面量
[1, 2, 3]

// 对象字面量
{ name: "alice", age: 30 }

// 布尔、Null 和 Undefined 字面量
true
false
null
undefined
```

在 JS 中，量可以使用三种关键字声明

- `var`：函数作用域，声明变量
- `let`：块作用域，声明变量
- `const`：块作用域，声明常量

且可以同时声明多个，例如

```javascript
var x = 10;
let a, b, c = 20.0;           // 只有 c 被初始化
const PI = 3.14, E = 2.7;     // 同时初始化多个
var name = "alice",
    age = 30,
    isStudent = false;        // 多行声明
```

块级作用域只能在其所在 `{}` 内访问，类似 C 语言的局部变量，函数作用域可以在整个函数内访问

```javascript
function example() {
    if (true) {
        var x = 10;
        let y = 20;
    }
    // 这里可以访问 x，但不能访问 y
}
```

声明量优先使用 `const`，如果需要修改则使用 `let`，尽量避免使用 `var` 以减少作用域混乱和变量提升问题

## 运算符

JS 的运算符和 C 语言几乎一样，包含算术运算符、比较运算符、逻辑运算符、位运算符、赋值运算符等，以下是不一样的地方

`+` 运算符在 JS 中既可以用于数字相加，也可以用于字符串连接，还能自动将数字转换为字符串进行连接，例如

```javascript
let x = "ab" + "cd";     // x 的值为 "abcd"
let y = "abc" + 12;      // y 的值为 "abc12"
```

赋值数组和对象时，可以直接用 `=` 后接字面量

```javascript
let arr = [1, 2, 3];    // 声明一个数组
let obj = {             // 声明一个对象
    name: "alice",
    age: 30
};
arr = [4, 5, 6];        // 重新赋值
```

`==` 在 JS 中是宽松相等运算符，会进行类型转换后比较，而 `===` 是严格相等运算符，不进行类型转换，只有类型和值都相等才返回 true，此外还有 `!=` 和 `!==` 分别对应宽松不相等和严格不相等

```javascript
0 == false;          // true
0 === false;         // false
"1" == 1;            // true
"1" === 1;           // false
null == undefined;   // true
null === undefined;  // false
"0" != false;        // false
"0" !== false;       // true
```


## 注释

和 C 语言一样，JS 支持单行注释和多行注释

```javascript
//  这是单行注释
/*
    这是多行注释
    可以跨越多行
*/
```

## 字符串

字符串 `s` 有内置的属性和方法：

- `s.length`：表示字符串的长度
- `s[0]`：表示字符串的第一个字符，索引从 0 开始
- `s.toUpperCase()`：返回字符串的大写形式
- `s.toLowerCase()`：返回字符串的小写形式
- `s.indexOf(sub)`：返回子字符串 `sub` 在字符串中首次出现的位置索引，如果不存在则返回 -1
- `s.slice(start, end)`：返回字符串从索引 `start` 到 `end`（不包括 `end`）的子字符串
- `s.split(sep)`：将字符串按照分隔符 `sep` 分割成数组
- `s.trim()`：去除字符串两端的空白字符

字符串可以用单引号或双引号括起来，也可以使用反引号（`` ` ``）创建模板字符串，例如

```javascript
let name = "alice";
let greeting = `Hello, ${name}!`;  // 使用模板字符串，值为 "Hello, alice!"
let multiLine = `This is
a multi-line string.`;       // 多行字符串
```

为了在字符串中包含特殊符号，可以用转义字符 `\` 或 raw 字符串，例如

```javascript
let str1 = "He said, \"Hello!\"";  // 使用转义字符
let str2 = String.raw`C:\Users\Alice\Documents`;  // raw 字符串，不处理转义字符
```

## 条件语句

和 C 几乎一样，支持 `if`、`else if` 和 `else` 语句，也有 三元运算符 `condition ? expr1 : expr2` 和 `switch` 语句，同样需要 `break` 来避免穿透

```javascript
if (condition) {
    // 条件为真时执行的代码
} else if (anotherCondition) {
    // 另一个条件为真时执行的代码
} else {
    // 所有条件都不满足时执行的代码
}

let result = condition ? expr1 : expr2;  // 三元运算符

switch (expression) {
    case value1:
        // expression 等于 value1 时执行的代码
        break;
    case value2:
        // expression 等于 value2 时执行的代码
        break;
    default:
        // expression 不等于任何 case 时执行的代码
}
```

## 循环语句

和 C 几乎一样，支持 `for` 和 `while` 循环

```javascript
for (let i = 0; i < 5; i++) {
    // 循环体
}
let j = 5;
while (j--) {
    // 循环体
}
```

但 JS 还支持 `for...of` 和 `for...in` 循环，用于遍历数组和对象的元素或属性

```javascript
let arr = [10, 20, 30];
for (let value of arr) {
    // value 依次为 arr 中的元素
} 
let obj = { name: "alice", age: 30 };
for (let key in obj) {
    // key 依次为 obj 中的键
    let value = obj[key];  // 获取值
}
```

## 函数

由于 JS 是动态类型语言，函数的参数和返回值没有类型声明，可以接受任意类型的值，甚至可以接受不同数量的参数，例如

```javascript
function add(a, b) {
    return a + b;
}
add(1, 2);              // 返回 3
add("hello", "world");  // 返回 "helloworld"
```

