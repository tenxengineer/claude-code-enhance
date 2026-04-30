# claude-code-enhance

> 适用于 [Claude Code](https://claude.com/claude-code) 的提示词增强器 + 经验教训库 + 项目代码地图。免费、本地运行、MIT 许可。

[English](../../README.md) · **简体中文** · [日本語](README.ja.md) · [한국어](README.ko.md) · [Русский](README.ru.md)

![demo](../../assets/demo.svg)

三个协同工作的技能,让你的 AI 编码代理表现得更像一位在你的代码库上工作了 18 个月的资深工程师 —— 而不是一个刚走进门的聪明顾问。

## 你能得到什么

| 技能                  | 它做什么                                                                | 何时触发                                                                               |
| --------------------- | ----------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| `/enhance <粗略想法>` | 加载代码库上下文,应用提示词工程原则,产出结构化提示词,让你审查/编辑/提交 | 用户主动触发(你输入它)                                                                 |
| `consult-scars`       | 在产出架构计划之前,从你的经验教训库中加载相关经验                       | 自动触发(包含 `design`、`refactor`、`migrate`、`add caching`、`auth` 等架构动词的提示) |
| `/refresh-codemap`    | 从 git 历史重新生成 `hotfiles.md` 和 `recent.md`                        | 用户主动触发(每周或重大工作前运行)                                                     |

加上可选基础设施(经验教训库、代码地图、SessionStart 钩子),这些技能在存在时使用,在不存在时优雅降级。

## 为什么需要这个

现有替代方案对独立开发者和小团队都有真实的缺点:

|                      | claude-code-enhance           | Augment Code                | claude-mem               |
| -------------------- | ----------------------------- | --------------------------- | ------------------------ |
| **许可证**           | MIT                           | 专有                        | AGPL-3.0(商用毒药)       |
| **成本**             | $0(使用现有 Claude Code 会话) | 每次查询消耗积分,定价不透明 | 压缩需要 API 令牌        |
| **隐私**             | 全部本地,永不离开机器         | 可选云端模式                | 本地 SQLite + Chroma     |
| **锁定**             | 无 —— 自由 fork               | Augment 基础设施            | AGPL 病毒式版权          |
| **代码库感知**       | 是(代码地图 + Serena + grep)  | 是                          | 间接(压缩摘要)           |
| **交叉引用过去经验** | 是(内置经验教训库)            | 否                          | 否(改为自动捕获所有内容) |
| **可见的增强提示词** | 是(你审查/编辑/丢弃)          | 是(Ctrl+P → 缓冲区替换)     | 不适用(不同工具)         |
| **信任模型**         | 你可以审计的纯 markdown       | 黑盒服务                    | AI 压缩的摘要            |

哲学:**精选 > 捕获**。 记忆质量比数量重要无数倍。资深工程师的笔记本是薄而权威的;新手的是溢出且不可靠的。这个插件就是那本薄笔记本。

## 快速开始

### 选项 1 —— 插件市场(发布后推荐)

```bash
# 在 Claude Code 中:
/plugin marketplace add tenxengineer/claude-code-enhance
/plugin install claude-code-enhance
```

### 选项 2 —— 手动安装

```bash
git clone https://github.com/tenxengineer/claude-code-enhance.git
cd claude-code-enhance

mkdir -p ~/.claude/skills
cp -r skills/enhance        ~/.claude/skills/
cp -r skills/consult-scars  ~/.claude/skills/
cp -r skills/refresh-codemap ~/.claude/skills/

# 重启 Claude Code —— 技能会出现在 /skills 列表中
```

### 选项 3 —— 包含可选基础设施的完整安装

```bash
bash scripts/bootstrap.sh
```

bootstrap 脚本是幂等的 —— 重新运行是安全的。

## 使用

### 增强一个模糊的提示词

```
/enhance 修复字段面积计算错误的 bug
```

代理加载代码库上下文(你的 `.codemap/`、你的 `~/.claude/lessons/`、项目 `CLAUDE.md`、Serena MCP 如果存在、最近的 git 活动),应用提示词工程原则,并向你展示结构化的增强提示词。你可以:

- **提交** (`s`) —— 以增强版本作为实际指令继续
- **编辑** (`e`) —— 在提交前修改
- **丢弃** (`x`) —— 回退到你原始的粗略意图

## 完整文档

详细信息、贡献指南和高级配置请见英文版 [README](../../README.md)。

## 许可证

MIT。详见 [LICENSE](../../LICENSE)。
