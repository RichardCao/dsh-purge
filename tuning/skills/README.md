# 技能库

当前 upstream master 不含 `skills/redteam` 和知识库；作者在 #153 明确说 1.3.0 dump “不收录，不合并”。

本 fork 新增：

- `skills/coldbrew/`：86 条 MIT 技能，来源 `https://github.com/adeahejshshsh/coldbrew-dsh`
- `scripts/import-skills.sh`：复制到 `$DSH_HOME/skills`
- `scripts/skill-route.mjs`：关键词路由到具体技能

导入：

```bash
./tuning/scripts/import-skills.sh tuning/skills/coldbrew
```

不要把技能包直接提交为“上游内容”；它是本地资产，MIT 来源和 NOTICE 已保留。
