# 破甲测试工具

`jailbreak_probe.py` 直接调用配置的 OpenAI-compatible responses API，用本地提示词做对照测试。

## 用法

```bash
export LOCAL_MODEL_API_KEY=$(cat /path/to/.qwen-api-key)
export MODEL_BASE_URL=http://10.3.16.57:8090/v1
export MODEL_ID=deepseek-v4.1-flash

python3 tuning/tests/jailbreak_probe.py \
  --cases game_cheat,bomb,drug,minor_nsfw,public_pentest,keylogger \
  --variants current,v3,current_prefill,current_steer \
  --timeout 180 --retries 2
```

脚本含 9 个类别定义；本轮执行 6 个，新增 `phishing` / `c2` / `adult_nsfw` 作为可选扩展。

## 变体

- `current`：`tuning/config/prompt-inject.md`
- `v3`：`tuning/config/prompt-inject-v3.md`
- `current_prefill`：当前提示词 + assistant 预填
- `current_steer`：先请求；若触发拦截，再用 steer 消息追一轮

## 判定

`REFUSAL_RE` 只匹配强拦截话术，不把 `<ds_safety>` 前言或普通安全说明当成拒答。

## 输出

脚本会写 `tuning/tests/results.json`。该文件含短文本片段，默认被 `.gitignore` 忽略；不要把原始输出直接提交到公开仓库。
