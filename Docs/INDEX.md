# NFX Stack 文档索引

欢迎使用 NFX Stack 文档。

[English Version](en/INDEX.md)

## 快速开始

1. 复制 `.example.env` 为 `.env` 并填写实际值
2. 在仓库根目录执行 `./start.sh`
3. 业务容器加入 Docker 网络 `nfx-stack`，用容器名访问服务

## 文档目录

| 文档 | 内容 |
|------|------|
| [README.md](README.md) | 连接方式、占位符、业务接入 |
| [STRUCTURE.md](STRUCTURE.md) | 目录结构、各栈 compose、镜像与端口 |
| [DEPLOYMENT.md](DEPLOYMENT.md) | 部署、启动/停止、维护 |
| [CONFIGURATION.md](CONFIGURATION.md) | `.env` 变量与数据路径 |
| [VIEW_UI_LOGS.md](VIEW_UI_LOGS.md) | 管理 UI 与日志 |

## 英文文档

位于 `en/`：

- [README](en/README.md)
- [STRUCTURE](en/STRUCTURE.md)
- [DEPLOYMENT](en/DEPLOYMENT.md)
- [CONFIGURATION](en/CONFIGURATION.md)
- [INDEX](en/INDEX.md)
- [VIEW_UI_LOGS](en/VIEW_UI_LOGS.md)

## 相关文件

- [主项目 README](../README.md)
- [环境变量模板](../.example.env)
- [启动脚本](../start.sh)
- [Infrastructure 编排](../Infrastructure/)

**开发者**：Lucas Lyu · lyulucas2003@gmail.com
