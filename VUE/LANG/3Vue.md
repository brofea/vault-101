# Vue

## 快速开始

Vue 是一个 JS 框架，使用 Node.js 的包管理器 npm 来安装和管理依赖，可以按照如下步骤快速开始一个 Vue 项目

1. `npm init vue@latest` 创建项目文件夹，若是全栈项目，则可在根目录下执行 `npm init vue@latest frontend`
2. `npm install` 安装依赖
3. `npm run dev` 启动开发服务器，它会监听文件变化并自动刷新浏览器
4. `npm run build` 构建生产版本，生成优化后的静态文件

一个 Vue 文件从上至下通常包含三个部分

1. `<script>` 定义组件的 JavaScript 逻辑
2. `<template>` 定义组件的 HTML 模板
3. `<style>` 定义组件的 CSS 样式

一个 Vue 项目文件结构通常如下

- `src/` 包含源代码
  - `components/` 存放 Vue 组件
  - `views/` 存放页面组件
  - `assets/` 存放静态资源如图片、样式等
  - `App.vue` 根组件
  - `main.js` 入口文件
- `public/` 包含公共资源
- `package.json` 定义项目依赖和脚本
- `vite.config.js` Vite 配置文件
- `tsconfig.json` TypeScript 配置文件（如果使用 TypeScript）
- `index.html` 入口 HTML 文件

此外还有 git 忽略的，无需手动修改的文件

- `node_modules/` 存放安装的依赖包
- `dist/` 存放构建后的生产版本文件

