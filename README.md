<h1>Vben Admin 5.0 精简模板</h1>
</div>

## 简介

本项目是基于 [Vue Vben Admin 5.0](https://github.com/vbenjs/vue-vben-admin) 的精简模板。鉴于官方从 5.0 版本开始不再提供精简版本，本项目作为一个开箱即用的模板，帮助开发者快速启动项目。

Vue Vben Admin 是一个免费开源的中后台模板，使用最新的 `vue3`、`vite`、`TypeScript` 等主流技术开发，开箱即用的中后台前端解决方案。

## 为什么使用本模板？

官方 Vben Admin 5.0 包含了多个 UI 框架版本、完整的文档和演示代码，但对于实际项目来说，很多内容是不需要的。本模板已经按照官方精简指南完成了以下精简操作：

### 已完成的精简操作

#### 1. 应用精简
- ✅ 保留 `apps/web-antd` - 基于 Ant Design Vue 的主应用
- ❌ 删除 `apps/web-ele` - Element Plus 版本
- ❌ 删除 `apps/web-naive` - Naive UI 版本
- ❌ 删除 `apps/web-tdesign` - TDesign 版本
- ✅ 保留 `apps/backend-mock` - Mock 服务

#### 2. 演示代码精简
- ❌ 删除 `playground` 文件夹 - 完整的演示应用（包含所有功能展示和 E2E 测试）

#### 3. 文档精简
- ❌ 删除 `docs` 文件夹 - 完整的文档站点（文档可在线查看：https://doc.vben.pro/）

#### 4. GitHub 配置精简
- ❌ 删除 `.github` 文件夹 - GitHub Actions 工作流、Issue 模板等

## 项目特点

- **单一 UI 框架**：仅保留 Ant Design Vue 版本，减少选择困难
- **精简依赖**：移除了其他 UI 框架的依赖，减少安装时间
- **保留核心功能**：保留了所有核心功能和常用组件
- **开箱即用**：可直接作为新项目的起点

## 快速开始

### 1. 获取项目代码

```bash
git clone https://github.com/your-username/vben-template.git
cd vben-template
```

### 2. 安装依赖

```bash
# 确保 Node.js 版本 >= 18
npm i -g corepack
pnpm install
```

### 3. 启动开发服务器

```bash
pnpm dev
```

### 4. 构建生产版本

```bash
pnpm build
```

## 可用命令

```bash
# 开发模式
pnpm dev

# 构建
pnpm build

# 预览构建产物
pnpm preview

# 类型检查
pnpm type-check

# 代码检查
pnpm lint

# 代码格式化
pnpm format
```

## 进一步精简

如需进一步精简项目，可以参考以下操作：

- 删除不需要的路由及页面（`apps/web-antd/src/router/routes`）
- 删除不需要的组件（`packages/effects/common-ui/src/ui`）
- 关闭 Mock 服务（删除 `apps/backend-mock`，设置 `VITE_NITRO_MOCK=false`）
- 删除 `.changeset`、`.vscode` 等可选文件夹

详细的精简指南请参考 [官方文档](https://doc.vben.pro/guide/introduction/thin.html)。


## 项目更新说明

### 本项目定位

本项目是 [Vue Vben Admin 5.0](https://github.com/vbenjs/vue-vben-admin) 的精简模板版本，会持续跟踪上游更新。

由于采用了 **Monorepo** 架构，核心代码抽离到 `packages/@core`、`packages/effects` 等独立包中，因此删除其他应用和文档后，仍可轻松同步上游的核心更新。

### 更新方式

**从本模板获取更新**
   ```bash
   git remote add template https://github.com/yxiZo/vben-template.git
   git fetch template main
   git merge template/main
   ```

详细的更新策略和冲突处理请参考 [官方文档](https://doc.vben.pro/guide/introduction/thin.html)。

## Vben Admin相关链接

- [官方文档](https://doc.vben.pro/)
- [更新日志](https://github.com/vbenjs/vue-vben-admin/releases)
- [GitHub Discussions](https://github.com/vbenjs/vue-vben-admin/discussions)


## 致谢

本项目基于 [Vue Vben Admin](https://github.com/vbenjs/vue-vben-admin) 开发，感谢原作者和所有贡献者的辛勤付出。
