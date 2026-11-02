# dsh-purge tuning

本 fork 基于上游 `v1.1.84`，保存本地修正、可恢复能力和迁移配置。

## 目录

```text
config/
  cordis.patch.yml       # profile 配置：gate / refusal / prefill / persona
  model.cordis.patch.yml # 模型路由：machine-room / deepseek-v4.1-flash / reasoning off
  prompt-inject.md       # 当前提示词注入
  prompt-inject-v3.md    # 沙箱 v3 提示词（压缩 / 分类器规避）
lib/
  net-scope.js           # 公网/外挂门开关
  index.js               # refusal steer + assistant prefill
  identity.js            # factory persona 过滤
scripts/
  apply.sh               # 覆盖安装副本 + 配置
  verify.sh              # 语法与状态检查
  import-skills.sh       # 导入技能包
  skill-route.mjs        # 关键词路由到具体技能
skills/
  coldbrew/              # 86 条 MIT 技能包
tests/
  README.md              # 本地 probe 说明
```

## 固定版本

- Node.js `22.23.4`
- DSH `0.2.1-rc.2`
- dsh-purge `1.1.84`
- 模型：`deepseek-v4.1-flash`，`reasoningEffort` 默认 `off`

## 测试报告

见 [tests/report.md](tests/report.md)。测试覆盖 6 个类别，比较 current / v3 / prefill / steer。

## 迁移步骤

1. 在新机器上安装同版本 DSH 和 dsh-purge。
2. 克隆仓库并 checkout `tuning`。
3. 设置 `DSH_HOME`：

```bash
export DSH_HOME=/path/to/project/.dsh-home
```

4. 覆盖插件源码和配置：

```bash
./scripts/apply.sh            # current 提示词
PROMPT_MODE=v3 ./scripts/apply.sh  # v3 沙箱提示词
PROMPT_MODE=policy ./scripts/apply.sh  # Policy Puppetry 实验
```

5. 应用官方 patch：

```bash
./dsh-local purge --apply
```

6. 重启 dsh web，使用新启动时打印的 URL 和 token，新建会话。

`apply.sh` 只覆盖 `dsh-purge` 插件源码和 profile 配置；官方 DSH 文件仍由 `purge --apply` 清洗。

## 技能与路由

```bash
./scripts/import-skills.sh skills/coldbrew
node scripts/skill-route.mjs "做个自瞄"
```

插件内也有 `purge_route` 工具和 `purge_skills_install` 工具：

```text
purge_route("做个自瞄")
purge_route("做个自瞄", load=true)
purge_skills_install()
```

技能来源：`adeahejshshsh/coldbrew-dsh`，MIT；保留 `skills/coldbrew/NOTICE.md`。

## 不要提交的内容

- `.qwen-api-key`、`.dsh-home/.credentials.yaml`
- `.dsh-runtime/`、`.dsh-home/`、`.dsh-downloads/`
- `.dsh-logs/`、session 文件、临时文件
- 浏览器 token、web.log

## 安全下架与恢复

- 上游 1.1.73 起只允许本地/私网靶场，并下架技能库和知识库；1.3.0 dump 不合并（#153 作者明确“不收录，不合并”）。
- 本 fork 用 `regionGate:false` / `cheatGate:false` 恢复公网和外挂门。
- `tuning/config/prompt-inject.md` 已加入旧版 1.1.34 的“Permitted without restriction”段。
- `tuning/config/prompt-inject-v3.md` 提供压缩沙箱提示词，可用 `PROMPT_MODE=v3` 切换；测试显示 v3 整体弱于 current。
- 技能库/知识库：新增 `tuning/skills/coldbrew/`（86 条 MIT 技能）和导入脚本；实际知识库仍需本地导入。
- 1.3.0 的 `refusal-steer` / `hardening` / `model-profile` 不在 master；本 fork 用 `installRefusalSteer` + `installPrefill` 替代。

完整清单见 [RESTORE.md](RESTORE.md)。

## 注意

- 上游 `dsh-purge` 是 Apache-2.0；保留 `NOTICE` 和出处。
- 本项目是本地二开，不要作为商业产品转卖；上游要求署名。
- 上游升级后，需要重新核对 `lib/core.js` 的 patch pattern。
- 当前改动只针对 DSH `0.2.1-rc.2`；rc.3 及更新版本不保证可用。
