# 爱范儿排版工具 (Lark2Pad)

爱范儿排版工具 (Lark2Pad) 是一款专为编辑团队打造的 macOS 原生高效排版与文档转换工具。它可以一键将飞书（Lark）云文档富文本解析为规范的 Markdown，自动处理私有图床上传，并支持直接复制适配微信公众号的排版样式或同步至公司内部 Etherpad / CMS 草稿箱。

---

## ✨ 核心特性

- 📋 **剪贴板一键转换**：在飞书云文档中全选复制后，点击或快捷键 `⌘V` 即可自动提取并清洗富文本，生成干净的标准 Markdown。
- 💚 **微信公众号一键排版导出**：
  - 自动将文章图片转为高清 Base64 内嵌格式，避免公众号草稿提示外部图片载入失败。
  - 支持对图片应用 iOS 贝塞尔曲线连续圆角（超椭圆）。
  - 支持自动插入爱范儿专属页头 Banner (DISCOVER THE NEXT) 及结尾关注底卡与二维码。
- ⚡️ **高并发私有图床上传**：内置图片上传引擎，支持多图高并发处理、失败自动重试、内存秒传缓存及超时保护。
- ☁️ **Etherpad & CMS 一键同步**：
  - 登录公司 Etherpad 账号后，支持将转换后的 HTML 直接同步生成专属 Pad。
  - 集成 `send2cms` 插件，支持一键转存至 ifanr、APPSO、董车会及知晓云等渠道的公众号草稿箱。
- 📁 **本地 Markdown 文件拖拽解析**：支持直接拖拽 `.md` / `.markdown` 文件，自动提取本地图片引用并上传转换。
- 🖼️ **WordPress 媒体库集成**：支持直连 WordPress 站点管理媒体资源与图库传输。
- 💎 **Liquid Glass 美学设计**：采用 SwiftUI + macOS Native 视觉设计，带有流畅的状态过渡动画与 Toast 提示。
- 🔄 **Sparkle 独立自动更新**：内置 Sparkle 更新引擎，支持自动检测并静默升级应用。

---

## 🛠️ 环境要求

- **操作系统**：macOS 15.0+ (Sequoia)
- **开发工具**：Xcode 16.0+
- **构建依赖**：Homebrew (`create-dmg` 用于生成 DMG 安装包)

---

## 💻 本地编译

编译调试版本：

```bash
xcodebuild -project "Lark2Pad.xcodeproj" -scheme "Lark2Pad" -configuration Debug build
```

---

## 🚀 打包与发版

### 1. 构建 Release 双架构 DMG

```bash
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer ./scripts/build.sh release
```

### 2. 生成 Sparkle 签名并发布 GitHub Release

```bash
./scripts/release.sh <版本号>
```
例如：
```bash
./scripts/release.sh 3.4.0
```
