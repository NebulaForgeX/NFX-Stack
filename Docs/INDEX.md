# NFX Stack 文档索引

欢迎使用 NFX Stack 文档！本文档提供了所有可用文档的索引和快速导航。

[English Version](en/INDEX.md)

## 快速开始

- **[主项目 README](../README.md)** - 项目介绍和快速开始指南
- **[配置文档使用指南](README.md)** - 配置模板使用说明

## 文档目录

### 核心文档

1. **[README.md](README.md)** - 配置文档使用说明
   - 配置模板使用步骤
   - 各服务配置详解
   - 连接字符串示例
   - 故障排查指南

2. **[STRUCTURE.md](STRUCTURE.md)** - 项目结构文档
   - 目录结构说明
   - Docker Compose 服务列表
   - 网络架构
   - 数据持久化
   - 扩展性说明

3. **[DEPLOYMENT.md](DEPLOYMENT.md)** - 部署指南
   - 部署前置要求
   - 快速部署步骤
   - 生产环境部署
   - 维护操作
   - 故障排查

4. **[CONFIGURATION.md](CONFIGURATION.md)** - 配置详解
   - 环境变量配置详解
   - 端口配置说明
   - 网络配置
   - 数据目录配置
   - 初始化脚本

### 其他资源

- **[VIEW_UI_LOGS.md](VIEW_UI_LOGS.md)** - UI 服务日志查看指南（中文）
- **[VIEW_UI_LOGS.md (English)](en/VIEW_UI_LOGS.md)** - UI 服务日志查看指南（英文）

## 英文文档

所有文档都有对应的英文版本，位于 `en/` 目录：

- [English README](en/README.md)
- [English STRUCTURE](en/STRUCTURE.md)
- [English DEPLOYMENT](en/DEPLOYMENT.md)
- [English CONFIGURATION](en/CONFIGURATION.md)
- [English INDEX](en/INDEX.md)
- [English VIEW_UI_LOGS](en/VIEW_UI_LOGS.md)

## 配置模板

- **dev.toml** - 开发环境配置模板
- **prod.toml** - 生产环境配置模板

这些模板可以直接复制到业务服务中使用，只需替换占位符即可。

## 相关链接

- [主项目 README](../README.md) - 项目主文档
- [Docker Compose 配置](../docker-compose.yml) - 服务定义文件
- [环境变量模板](../.example.env) - 配置模板

## 文档使用建议

### 新用户

1. 阅读 [主项目 README](../README.md) 了解项目概况
2. 阅读 [DEPLOYMENT.md](DEPLOYMENT.md) 进行部署
3. 阅读 [CONFIGURATION.md](CONFIGURATION.md) 了解配置选项
4. 阅读 [README.md](README.md) 使用配置模板

### 开发者

1. 阅读 [STRUCTURE.md](STRUCTURE.md) 了解项目结构
2. 阅读 [README.md](README.md) 了解配置模板使用
3. 参考配置模板进行业务服务配置

### 运维人员

1. 阅读 [DEPLOYMENT.md](DEPLOYMENT.md) 了解部署和维护
2. 阅读 [CONFIGURATION.md](CONFIGURATION.md) 了解配置管理
3. 阅读 [VIEW_UI_LOGS.md](VIEW_UI_LOGS.md) 了解日志查看

## 获取帮助

如果您在使用过程中遇到问题，欢迎通过以下方式联系：

**开发者**：Lucas Lyu  
**联系方式**：lyulucas2003@gmail.com

---

## 文档更新日志

- 2025-01-XX: 初始文档创建
- 2025-01-XX: 添加中英文双语支持
- 2025-01-XX: 完善项目结构和配置说明
