# WH Infinite Canvas

WH Infinite Canvas 是一个本地运行的 AI 图片创作工作台，提供无限画布、AI 图片生成、参考图编辑、对话助手、提示词、素材库、工作流、ComfyUI、RunningHub、ModelScope 以及浏览器/Photoshop 素材导入工具。

## 本地运行

首次使用可运行 `安装依赖.bat` 安装依赖。本机的自带 Python 已配置好依赖。Windows 下可直接运行 `run.bat`，也可以使用当前 Python 环境执行：

```powershell
python main.py
```

启动后打开 `http://127.0.0.1:3001`。如端口被占用，可设置 `WH_CANVAS_PORT` 使用其他端口。API Key 和画布素材默认保存在本机。

## 项目结构

- `main.py`：本地服务与 API
- `static/`：网页界面
- `workflows/`：内置工作流
- `tools/`：浏览器素材导入与 Photoshop 连接工具
- `CLI/`：可选的 CLI 集成脚本

本项目保留原始仓库的许可证文本和第三方依赖声明；使用和再发布请遵守 `LICENSE` 中的条款，来源见 `NOTICE.md`。

更换端口示例（PowerShell）：

```powershell
$env:WH_CANVAS_PORT = "3002"
.\run.bat
```

插件的连接地址也需同步修改。当前版本未配置应用内在线更新源。

## 服务器部署

腾讯云轻量应用服务器的部署配置和步骤见 [deploy/README.md](deploy/README.md)。当前线上实例公开访问，服务仍仅监听服务器回环地址；如配置付费 API 或私有素材，建议在 Caddy 增加认证。
