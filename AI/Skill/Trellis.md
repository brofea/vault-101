# Trellis 使用指南（Codex 版）

本项目地址: [GitHub - mindfold-ai/Trellis](https://github.com/mindfold-ai/Trellis)

## 1. Trellis 是什么

Trellis 是一个面向 AI 编程的工程工作流层。它不是单纯的提示词集合，而是在你的代码仓库中维护一套可持久化的项目上下文：

- `.trellis/spec/`：项目规范、架构约定、测试规则、团队经验。
- `.trellis/tasks/`：每个任务的 PRD、研究记录、实现上下文、检查上下文和状态。
- `.trellis/workspace/<developer>/`：每个开发者自己的 session journal 和跨会话记忆。
- 平台目录，如 `.codex/`、`.claude/`、`.cursor/`、`.opencode/`：把 Trellis 工作流接入不同 AI 编程工具。

它解决的核心问题是：AI 编程会话经常从零开始，而 Trellis 把需求、约定、任务状态和经验沉淀在仓库里，让下一次会话可以继续读这些文件，而不是依赖聊天记录。

## 2. 安装与初始化

### 2.1 前置要求

- Node.js >= 18
- Python >= 3.9
- 一个 Git 仓库

### 2.2 安装 CLI

```bash
npm install -g @mindfoldhq/trellis@latest
trellis --version
```

### 2.3 在项目中初始化 Codex 支持

进入你的实际代码仓库根目录：

```bash
cd /path/to/your/project
trellis init --codex -u brofea
```

如果你同时使用多个 AI 编程平台，可以一次初始化多个平台：

```bash
trellis init --cursor --opencode --codex -u brofea
```

`-u brofea` 会设置你的开发者身份，并创建类似 `.trellis/workspace/brofea/` 的个人工作区。

### 2.4 常见初始化场景

| 场景 | 命令 | 结果 |
| --- | --- | --- |
| 第一次在项目中启用 Trellis | `trellis init --codex -u brofea` | 创建 `.trellis/`、Codex 配置、默认 spec 模板和 bootstrap 任务 |
| 已有 Trellis 项目，新增 Codex 支持 | `trellis init --codex` | 在现有 `.trellis/` 基础上添加 `.codex/` 相关文件 |
| 新成员加入已有 Trellis 项目 | `trellis init -u your-name` | 写入本机 `.trellis/.developer`，创建个人 workspace |
| 同一台机器重复初始化 | `trellis init -u brofea` | 通常是 no-op 或交互式提示 |

不要随便选 full re-initialize，除非你确定要重建整个 Trellis 配置。

## 3. Trellis 的日常工作流

Trellis 的主线是：

```text
Plan -> Execute -> Finish
```

更具体地说：

```text
create task -> brainstorm / prd.md -> curate jsonl -> start task -> implement -> check -> update spec -> commit -> finish-work
```

你平时不需要手动记住所有内部脚本，主要通过自然语言和少数命令推进。

## 4. Codex 中怎么用

### 4.1 开始一个会话

在支持 hook 的平台中，Trellis 会尽量自动注入上下文。Codex 下需要确保项目里已经初始化了 `.codex/`，并且你的 Codex 已经重启加载新 skills。

如果你想明确让 Codex 读取 Trellis 上下文，可以直接说：

```text
使用 trellis-start 开始当前项目开发会话。
```

它会读取：

- `.trellis/.developer`
- 当前 Git 状态
- 当前 active task
- `.trellis/workflow.md`
- `.trellis/spec/**/index.md`
- `.trellis/workspace/<developer>/` 中的近期记录

### 4.2 提新需求

直接描述任务即可：

```text
帮我给这个项目增加用户登录功能。
```

如果需求不清楚，Trellis 会触发 `trellis-brainstorm`，把需求整理成任务和 `prd.md`。它一般会一轮一轮问问题，而不是一次性乱写代码。

你也可以显式指定：

```text
用 trellis-brainstorm 帮我梳理这个需求：增加用户登录功能。
```

### 4.3 继续当前任务

当 PRD 已经写好、上下文已经准备好，或者 AI 卡在“不知道下一步”时，说：

```text
用 trellis-continue 继续当前 Trellis 任务。
```

或在支持 slash command 的平台中：

```text
/trellis:continue
```

`continue` 会根据当前 task 的 `task.json.status` 和工作流阶段决定下一步：补 PRD、补 JSONL、开始实现、检查、更新 spec 或进入收尾。

### 4.4 写代码前

Trellis 会通过 `trellis-before-dev` 确保 AI 在改代码前读相关 spec。你也可以显式提醒：

```text
开始写代码前，先用 trellis-before-dev 读取相关规范。
```

### 4.5 实现与检查

实现阶段通常由 `trellis-implement` 负责，检查阶段由 `trellis-check` 负责。

检查会关注：

- 实现是否符合 `prd.md`
- 是否违反 `.trellis/spec/` 中的项目规范
- 是否有无关文件混入 diff
- lint / typecheck / test 是否通过
- 是否需要自修复并重新跑检查

你可以显式要求：

```text
用 trellis-check 检查当前任务，并修复能自动修复的问题。
```

### 4.6 收尾

完成代码、检查通过并提交工作代码后，运行：

```text
用 trellis-finish-work 收尾当前任务。
```

或在支持 slash command 的平台中：

```text
/trellis:finish-work
```

注意：`finish-work` 不是提交业务代码的命令。业务代码应该在 Trellis 工作流 Phase 3.4 里先提交；`finish-work` 主要做归档和 journal：

- 检查工作区是否还有未提交任务代码。
- 归档当前 task 到 `.trellis/tasks/archive/YYYY-MM/`。
- 写入 `.trellis/workspace/<developer>/journal-*.md`。
- 生成 Trellis 自己的 archive / journal commit。

## 5. 关键目录与文件

### 5.1 `.trellis/spec/`

存放长期有效的项目规则。适合写入：

- API 设计约定
- 前端组件规范
- 错误处理规则
- 日志规范
- 测试策略
- 跨层设计原则
- 反复踩坑后的防复发规则

不适合写入：

- 单个任务的一次性细节
- 临时探索记录
- 只对某个 PRD 有意义的信息

### 5.2 `.trellis/tasks/`

每个任务会有自己的目录，例如：

```text
.trellis/tasks/06-12-user-login/
├── task.json
├── prd.md
├── implement.jsonl
├── check.jsonl
└── research/
```

其中：

- `task.json`：任务状态、优先级、assignee、branch、父子任务等元信息。
- `prd.md`：目标、需求、验收标准、Definition of Done、Out of Scope、技术备注。
- `implement.jsonl`：实现阶段要读的 spec / research 文件。
- `check.jsonl`：检查阶段要读的 spec / research 文件。
- `research/`：调研结果，避免重要结论只留在聊天记录里。

### 5.3 `.trellis/workspace/<developer>/`

个人工作区，保存你的 journal 和跨会话记录。团队协作时，每个人有自己的 workspace。

### 5.4 `.codex/`

Codex 平台接入目录。`trellis init --codex` 会生成 Codex 需要的 agents、skills、hooks 和根部 `AGENTS.md` 等配置。

## 6. JSONL 上下文怎么理解

Trellis 通过 `implement.jsonl` 和 `check.jsonl` 控制 AI 在实现和检查前读哪些规则。

典型格式：

```jsonl
{"file": ".trellis/spec/guides/index.md", "reason": "共享思考指南"}
{"file": ".trellis/spec/backend/index.md", "reason": "后端开发规范"}
{"file": ".trellis/tasks/06-12-user-login/research/auth-library.md", "reason": "认证库选择依据"}
```

通常应该放：

- `.trellis/spec/**/*.md`
- 当前任务下的 `research/*.md`

通常不应该放：

- `src/**` 这类要被修改的源代码文件
- 即将编辑的文件

原因是：代码文件应由实现阶段按需读取；JSONL 主要是“规则和背景资料索引”。

## 7. 常用命令速查

### 7.1 CLI 初始化

```bash
trellis init --codex -u brofea
trellis init --cursor --opencode --codex -u brofea
trellis init --help
```

### 7.2 任务脚本

这些脚本在项目初始化后位于 `.trellis/scripts/`：

```bash
# 查看当前上下文
python3 ./.trellis/scripts/get_context.py

# 查看 workflow phase
python3 ./.trellis/scripts/get_context.py --mode phase

# 查看包和 spec 索引
python3 ./.trellis/scripts/get_context.py --mode packages

# 创建任务
python3 ./.trellis/scripts/task.py create "Add user login" --slug user-login

# 启动任务
python3 ./.trellis/scripts/task.py start 06-12-user-login

# 查看任务
python3 ./.trellis/scripts/task.py list

# 校验 JSONL 上下文
python3 ./.trellis/scripts/task.py validate 06-12-user-login

# 查看 JSONL 上下文
python3 ./.trellis/scripts/task.py list-context 06-12-user-login

# 归档任务
python3 ./.trellis/scripts/task.py archive 06-12-user-login
```

日常使用时，大多数脚本会由 AI 根据 Trellis workflow 自动运行；你主要记住 `continue` 和 `finish-work` 就够了。

## 8. 典型使用模板

### 8.1 新项目从零开始

```text
我正在从零开始做一个 B2B dashboard。请用 Trellis 帮我完成第一周的工程启动：
先问清楚缺失的产品和技术栈决策，然后创建一个小的首个任务，并补充最小必要的 frontend structure、API shape、error handling、test strategy specs。
```

建议流程：

1. 在仓库根目录运行 `trellis init --codex -u brofea`。
2. 使用 bootstrap task 梳理技术栈和项目规范。
3. 先填最重要的 spec，不要试图一次性设计整个项目。
4. 创建一个最小可闭环任务。
5. 用 `trellis-continue` 推进实现、检查和收尾。

### 8.2 接入已有项目

```text
这个项目已经存在了。请用 Trellis 帮我从现有代码中提取关键工程规范：
目录结构、API 风格、错误处理、测试方式、前端组件约定。先只生成高信号 spec，不要改业务代码。
```

重点是先让 Trellis 读真实代码，把隐含约定沉淀为 `.trellis/spec/`。

### 8.3 做一个产品功能

```text
用 Trellis 帮我实现“用户登录功能”。先梳理 PRD 和验收标准，再规划实现上下文，最后实现并检查。
```

适合涉及多层改动的功能：UI、API、数据模型、权限、测试等。

### 8.4 重构遗留模块

```text
用 Trellis 帮我重构 billing 模块。目标是降低复杂度，但保持现有行为不变。先总结不变量和测试策略，再拆任务。
```

重构任务要特别强调：

- 行为不变
- public API 不变或明确说明变更
- 先补测试或回归检查
- 把重构约束写入 PRD 和 check context

### 8.5 修复反复出现的 bug

```text
这个 bug 已经反复出现。请用 Trellis 修复它，并在修复后用 trellis-break-loop 分析根因，最后把防复发规则写入 spec。
```

这类任务的价值不只是修掉当前 bug，而是把“以后别再犯”的规则写进 `.trellis/spec/`。

## 9. Codex 使用建议

1. 初始化项目后重启 Codex，让新生成的 skills / agents / hooks 被加载。
2. 新任务尽量从自然语言开始，不要一上来让 AI 直接改代码。
3. 模糊需求交给 `trellis-brainstorm`，清晰小修可以直接做。
4. 中途不知道下一步时，用 `trellis-continue`。
5. 写完代码后一定跑 `trellis-check`。
6. 从 bug、review feedback、平台坑里学到的稳定规则，用 `trellis-update-spec` 固化。
7. `finish-work` 之前先完成业务代码提交；`finish-work` 是归档和 journal，不是功能提交。
8. 不要把 `.trellis/.developer` 当团队共享文件提交，它是每台机器的本地身份。

## 10. 一句话心智模型

Trellis 把 AI 编程从“一段聊天”变成“仓库内可追踪的工程流程”：

- 需求落到 `prd.md`
- 规则落到 `.trellis/spec/`
- 调研落到 `research/`
- 实现和检查上下文落到 JSONL
- 经验落到 workspace journal
- 最终结果落到 Git commits

## 11. 参考资料

- GitHub 仓库：https://github.com/mindfold-ai/Trellis
- Install & First Task：https://docs.trytrellis.app/start/install-and-first-task
- How It Works：https://docs.trytrellis.app/start/how-it-works
- Commands, Tasks & Specs：https://docs.trytrellis.app/start/everyday-use
- Multi-Platform and Team Configuration：https://docs.trytrellis.app/advanced/multi-platform
- Real-World Scenarios：https://docs.trytrellis.app/start/real-world-scenarios
