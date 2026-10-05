# 中职说课比赛 Codex Skills

本仓库包含 5 个可独立发现、也可组合使用的 Codex Skill。每个 Skill 均位于 `skills/<skill-name>/`，入口文件为 `SKILL.md`，并附带 `agents/openai.yaml` 界面元数据。

## Skills

- `zhongzhi-teaching-contest-master`：总控工作流，统一教学设计、说课 PPT、逐字稿与模拟评审。
- `zhongzhi-competition-teaching-design`：中职比赛教学设计。
- `zhongzhi-teaching-competition-presentation`：面向评委的说课 PPT。
- `zhongzhi-teaching-speaking-script`：逐页对齐的说课逐字稿。
- `zhongzhi-teaching-mock-review`：模拟评委审查。

## 安装到 Codex

在 PowerShell 中从仓库根目录运行：

```powershell
.\scripts\install-codex-skills.ps1
```

脚本默认安装到 `$env:CODEX_HOME\skills`；未设置 `CODEX_HOME` 时安装到当前用户目录下的 `.codex\skills`。更新已安装版本时运行：

```powershell
.\scripts\install-codex-skills.ps1 -Force
```

也可以在 Codex 中调用 `$skill-installer`，从仓库 `liuran921-art/wmsh` 一次安装以下路径：

```text
skills/zhongzhi-teaching-contest-master
skills/zhongzhi-competition-teaching-design
skills/zhongzhi-teaching-competition-presentation
skills/zhongzhi-teaching-speaking-script
skills/zhongzhi-teaching-mock-review
```

安装完成后，在下一轮对话或新建对话中显式调用：

```text
$zhongzhi-teaching-contest-master

请基于当前项目中的已有材料，先诊断和校准教学设计，再生成比赛三件套并模拟评委审查。
```

## 验证

验证仓库内结构：

```powershell
.\scripts\test-codex-skills.ps1
```

验证默认用户级安装目录：

```powershell
$codexRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex' }
.\scripts\test-codex-skills.ps1 -Root (Join-Path $codexRoot 'skills')
```

验证成功后，应能看到 5 个 Skill 全部通过；其中总控 Skill 的显式调用名为 `$zhongzhi-teaching-contest-master`。
