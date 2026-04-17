# CSS

CSS (Cascading Style Sheets，层叠样式表)，一种用来为结构化文档（如 HTML 文档或 XML 应用）添加样式（字体、间距和颜色等）的计算机语言，文件扩展名为 .css

## 语法

CSS 代码由**选择器**和**声明块**组成，选择器用于指定要应用样式的元素，声明块设置元素的样式属性

```css
选择器 {
  属性: 值;
  属性: 值;
  ...
}
```

在 HTML 中常见的选择器有

|选择器类型|语法|示例|作用范围|
|---|---|---|---|
|标签选择器|标签名|`h1 { }`|页面上所有该标签|
|类选择器|.类名|`.red-text { }`|所有 class="red-text" 的元素|
|ID 选择器|#ID名|`#nav-bar { }`|专门针对 id="nav-bar" 的唯一元素|
|通配符选择器|*|`* { }`|页面上所有元素（常用于重置边距）|

常见的属性有

|属性|作用|示例|
|---|---|---|
|color|设置文本颜色|`color: red;`|
|background-color|设置背景颜色|`background-color: blue;`|
|font-size|设置字体大小|`font-size: 16px;`|
|margin|设置元素外边距|`margin: 10px;`|
|padding|设置元素内边距|`padding: 5px;`|

## 注释

CSS 中的注释使用 `/* 注释内容 */` 语法，注释内容不会被浏览器解析和显示

```css
/* 这是一个注释，不会被浏览器解析 */
p {
  color: red; /* 这是一个行内注释 */
}
```

## HTML 中的 CSS

有三种方式在 HTML 中使用 CSS

内联样式：直接在 HTML 元素的 `style` 属性中定义样式

```html
<p style="color: red; font-size: 16px;">这是一个红色的段落，字体大小为 16px</p>
```

内部样式表：在 HTML 文档的 `<head>` 部分使用 `<style>` 标签定义样式

```html
<head>
  <style>
    p {
      color: red;
      font-size: 16px;
    }
  </style>
</head>
<body>
  <p>这是一个红色的段落，字体大小为 16px</p>
</body>
```

外部样式表：将 CSS 代码保存在一个独立的 .css 文件中，并在 HTML 文档的 `<head>` 部分使用 `<link>` 标签链接该文件

```css
/* styles.css */
p {
  color: red;
  font-size: 16px;
}
```

```html
<head>
  <link rel="stylesheet" href="styles.css">
</head>
<body>
  <p>这是一个红色的段落，字体大小为 16px</p>
</body>
```

## 盒子模型

CSS 盒子模型是一个重要的概念，用于描述 HTML 元素在页面上的布局和空间占用。每个元素都被看作一个矩形盒子，包含以下四个部分：

- 内容区：元素的实际内容，如文本或图片
- 内边距（Padding）：内容区与边框之间的空间
- 边框（Border）：包围内边距和内容区的线条，可以设置宽度、样式和颜色
- 外边距（Margin）：元素与其他元素之间的空间

```html
<header>
  <style>
    .box {
      width: 200px; /* 内容区宽度 */
      height: 100px; /* 内容区高度 */
      padding: 20px; /* 内边距 */
      border: 2px solid black; /* 边框 */
      margin: 10px; /* 外边距 */
    }
  </style>
</header>
<body>
  <div class="box">这是一个盒子模型示例</div>
</body>
```