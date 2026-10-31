# 技能库恢复

当前 upstream master 不含 `skills/redteam` 和知识库；作者在 #153 明确说 1.3.0 dump “不收录，不合并”。

恢复方式：

1. 从 1.3.0 dump 或旧发行件取得 `skills/redteam`。
2. 复制到 `$DSH_HOME/skills/`。
3. 用 `/skills import <zip>` 或侧栏技能页导入。

示例目录：

```text
$DSH_HOME/skills/
  redteam/
    SKILL.md
  ...
```

不要把技能包直接提交进本仓库；它是本地资产，不是插件补丁。
