# HTML

## 语法

### 标签

**标签**是组成 HTML 的基本元素，大部分由开始标签和结束标签组成，元素的内容位于两者之间，也有的元素是自闭合的，没有内容

```html
<div> </div>
<span> </span>
<p> </p>
<br />
```

### 属性

**属性**提供了关于元素的更多信息，通常以键值对的形式存在于开始标签中

```html
<a href="https://www.example.com">Example</a>
<img src="image.jpg" alt="Description of image" />
```

上述例子中，`href` 和 `src` 是属性，分别指定了链接的目标和图片的来源，而 `alt` 属性提供了图片的替代文本

常用的通用属性有

| 属性名称 | 适用标签 | 作用说明 |
| ------- | ------- | ------- |
| id | 所有标签 | 元素的唯一身份证，全页面不能重复 |
| class | 所有标签 | 元素的分类/样式名，多个元素可以共用 |
| style | 所有标签 | 直接写 CSS 样式（不推荐大量使用） |
| title | 所有标签 | 鼠标悬停时显示的文字提示 |
| name | 表单元素 | 提交数据时给这个数据起的名字 |
| disabled | 表单元素 | 禁用该元素，用户无法操作 |

更多属性参考 [MDN HTML 属性](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Attributes)，对于不同标签特定的属性，后文中会有介绍

### 注释

**注释**用于在 HTML 代码中添加说明或备注，不会被浏览器显示

```html
<!-- 这是一个注释，不会被浏览器显示 -->
<p> 这是一个段落，会被浏览器显示 </p>
```

### 基本结构

HTML 的**基本结构**通常包括 `<!DOCTYPE html>` 声明、`<html>` 根元素、`<head>` 头部元素和 `<body>` 主体元素

```html
<!DOCTYPE html>
<html>
  <head>
    <title>显示在浏览器标签页上的标题</title>
  </head>
  <body>
    <h1>网页上的大标题</h1>
    <p>网页上的段落内容</p>
  </body>
</html>
```

其中，`<!DOCTYPE html>` 声明了文档类型，`<html>` 包含了整个 HTML 文档，`<head>` 包含了文档的元数据和标题，而 `<body>` 包含了网页的可见内容

## 头部

`<head>` 元素包含了文档的元数据和其他信息，其常见的子元素有

- `<title>`：定义网页的标题，显示在浏览器标签页上
- `<meta>`：提供关于文档的元信息，如字符编码、作者、描述等
- `<link>`：用于链接外部资源，如 CSS 样式表
- `<style>`：用于在文档中嵌入 CSS 样式
- `<script>`：用于在文档中嵌入 JavaScript 代码

## 区块元素和内联元素

区块元素占据整行，常见的有 `<p>`、`<h1>` 等，而内联元素只占据其内容所需的空间，写在一起常常不会换行，常见的有 `<a>`、`<img>` 等

有两种没有含义的标签

- `<div>` 一个区块元素，用于分组和布局
- `<span>` 一个内联元素，用于对文本进行样式化

```html
<div>
  <span>一个内联元素</span>
  <span>一个内联元素，和前面的元素在同一行</span>
</div>
<div>
  <span>一个内联元素，但和前面的元素不在同一行，因为被区块元素隔开了</span>
</div>
```

这两种标签没有特定的语义，主要用于结合 CSS 对内容进行结构化和样式化，`<div>` 常用于布局，而 `<span>` 常用于对文本进行局部样式调整

## 标题、段落和换行

h 意为 Header，标题一共六级，从大到小分别是 `<h1>` 到 `<h6>`，语法如下

```html
<h1>这是一级标题</h1>
<h2>这是二级标题</h2>
```

p 意为 Paragraph，段落使用 `<p>` 标签，换行使用 `<br />` 标签

```html
<p>这是一个段落。</p>
<p>这是另一个段落。</p>
<p>这是一个段落。<br />这是同一段落中的换行。</p>
```

## 链接

a 意为 Anchor，链接使用 `<a>` 标签，`href` 属性指定链接的目标地址

```html
<a href="https://www.example.com">访问示例网站</a>
```

`target` 属性可以指定链接的打开方式，常用值有 `_blank`（在新标签页中打开）和 `_self`（在当前标签页中打开，默认值）

`download` 属性提示浏览器下载链接指向的资源而不是导航到它

## 图片

图片使用 `<img>` 标签，`src` 属性指定图片的来源，`alt` 属性提供图片的替代文本，当图片无法加载时显示

```html
<img src="image.jpg" alt="这是图片的描述" />
```

## 列表

无序列表使用 `<ul>` 标签，列表项使用 `<li>` 标签，ul 意味 Unordered List，li 意味 List Item

```html
<ul>
  <li>第一项</li>
  <li>第二项</li>
  <li>第三项</li>
</ul>
```

有序列表使用 `<ol>` 标签，列表项同样使用 `<li>` 标签，ol 意味 Ordered List

```html
<ol>
  <li>第一项</li>
  <li>第二项</li>
  <li>第三项</li>
</ol>
```

自定义列表使用 `<dl>` 标签，定义列表项使用 `<dt>` 标签，定义描述使用 `<dd>` 标签，dl 意味 Definition List，dt 意味 Definition Term，dd 意味 Definition Description

## 表格

表格使用 `<table>` 标签，表头使用 `<th>` 标签，表格行使用 `<tr>` 标签，表格数据使用 `<td>` 标签，分别是 Table Header、Table Row 和 Table Data 的缩写

```html
<table border="1" cellpadding="5" cellspacing="0">
  <tr>
    <th>姓名</th>
    <th>年龄</th>
  </tr>
  <tr>
    <td>张三</td>
    <td>25</td>
  </tr>
  <tr>
    <td>李四</td>
    <td>30</td>
  </tr>
</table>
```

表格有属性，如 `border`（设置边框宽度）、`cellpadding`（设置单元格内边距）和 `cellspacing`（设置单元格间距），值均为像素单位

## 表单元素

表单元素用于收集用户输入的数据，常见的表单元素有 `<input>`（输入框）、`<textarea>`（多行文本输入框）、`<select>`（下拉选择框）和 `<button>`（按钮）

属性有 `type`（指定输入类型，如 text、password、checkbox 等）、`name`（提交数据时的字段名）、`value`（输入的值）、 `placeholder`（输入框的占位提示文本）、`required`（必填项）等

```html
<form action="/" method="post">
    <!-- 文本输入框 -->
    <label for="name">用户名:</label>
    <input type="text" id="name" name="name" required>

    <br>

    <!-- 密码输入框 -->
    <label for="password">密码:</label>
    <input type="password" id="password" name="password" required>

    <br>

    <!-- 单选按钮 -->
    <label>性别:</label>
    <input type="radio" id="male" name="gender" value="male" checked>
    <label for="male">男</label>
    <input type="radio" id="female" name="gender" value="female">
    <label for="female">女</label>

    <br>

    <!-- 复选框 -->
    <input type="checkbox" id="subscribe" name="subscribe" checked>
    <label for="subscribe">订阅推送信息</label>

    <br>

    <!-- 下拉列表 -->
    <label for="country">国家:</label>
    <select id="country" name="country">
        <option value="cn">CN</option>
        <option value="usa">USA</option>
        <option value="uk">UK</option>
    </select>

    <br>

    <!-- 提交按钮 -->
    <input type="submit" value="提交">
</form>
```

## 框架

框架元素用于在页面中嵌入其他 HTML 文档，常见的框架元素有 `<iframe>`（内联框架）和 `<frameset>`（框架集，已过时）

```html
<!-- 内联框架 -->
<iframe src="https://www.example.com" width="600" height="400"></iframe>
<iframe src="sub_page.html" width="600" height="400"></iframe>
```

## JS脚本

元素 `<script>` 用于在 HTML 文档中嵌入或引用 JavaScript 代码，这里给一个简单的例子

```html
<p id="demo">
    JavaScript 可以触发事件，就像按钮点击。</p>

<script>
    function myFunction() {
        document.getElementById("demo").innerHTML = "Hello JavaScript!";
    }
</script>

<button type="button" onclick="myFunction()">点我</button>
```

点击按钮后，页面上的文本会被修改为 "Hello JavaScript!"，这是通过 `onclick` 事件触发的函数实现的

## 语义化标签

语义化标签没有具体功能，但具有明确的语义，使用这些标签可以让浏览器和开发者更好地理解页面的结构和内容，从而提高可访问性和 SEO 性能

常见的语义化标签有

- `<header>`：定义页面或区块的头部
- `<nav>`：定义导航链接的区域
- `<main>`：定义文档的主要内容
- `<article>`：定义独立的内容块，如博客文章或新闻报道
- `<section>`：定义文档中的一个区域，通常包含一个标题
- `<aside>`：定义与主内容相关的侧边栏内容
- `<footer>`：定义页面或区块的底部

比如

```html
<-- 本质上没有任何区别 -->
<header>
    <h1>网页标题</h1>
</header>
<h1>网页标题</h1>
```

## 实体字符

由于 HTML 保留了一些特殊字符，需要用别的方式表示

| 字符 | 描述 | 命名实体 | 数字实体 |
|-----|------|--------|---------|
| | 空格 | `&nbsp;` | `&#160;` |
| < | 小于号 | `&lt;` | `&#60;` |
| > | 大于号 | `&gt;` | `&#62;` |
| & | 和号 | `&amp;` | `&#38;` |
| " | 引号 | `&quot;` | `&#34;` |
| ' | 撇号 | `&apos;` | `&#39;` |
| ￠ | 分 | `&cent;` | `&#162;` |
| £ | 镑 | `&pound;` | `&#163;` |
| ¥ | 人民币/日元 | `&yen;` | `&#165;` |
| € | 欧元 | `&euro;` | `&#8364;` |
| § | 小节 | `&sect;` | `&#167;` |
| © | 版权 | `&copy;` | `&#169;` |
| ® | 注册商标 | `&reg;` | `&#174;` |
| ™ | 商标 | `&trade;` | `&#8482;` |
| × | 乘号 | `&times;` | `&#215;` |
| ÷ | 除号 | `&divide;` | `&#247;` |

## 文本格式化

```html
<b>粗体文本</b>
<code>计算机代码</code>
<em>强调文本</em>
<i>斜体文本</i>
<kbd>键盘输入</kbd> 
<pre>预格式化文本</pre>
<small>更小的文本</small>
<strong>重要的文本</strong>
 
<abbr> （缩写）
<address> （联系信息）
<bdo> （文字方向）
<blockquote> （从另一个源引用的部分）
<cite> （工作的名称）
<del> （删除的文本）
<ins> （插入的文本）
<sub> （下标文本）
<sup> （上标文本）
```