<h1 align="center">
TeXstudio for HarmonyOS
</h1>

<div align="center">
<picture>
    <img src="assets/splash_large_harmonyos.png" width="500px">
</picture>
</div>

## 目录

- [目录](#目录)
- [项目简介](#项目简介)
- [仓库结构](#仓库结构)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
  - [1. 克隆代码库](#1-克隆代码库)
  - [2. 交叉编译构建流程](#2-交叉编译构建流程)
  - [3. 生成签名并推送](#3-生成签名并推送)
- [致谢](#致谢)
- [License](#license)

## 项目简介

本项目旨在将知名 LaTeX 编辑器 [TeXstudio](https://github.com/texstudio-org/texstudio) 以及其核心依赖项 [Poppler](https://github.com/innodatalabs/poppler) 和 [TeX Live](https://tug.org/texlive/) 统一移植到OpenHarmony平台。 

## 仓库结构

```text
.
├── scripts/                    # 自动化构建脚本目录
│   ├── common/                 # 共有工具脚本 (HNP 打包、.so 库拷贝、签名等)
│   ├── poppler/                # Poppler 及 freetype 构建脚本
│   ├── qt/                     # Qt 源码下载、Patch 修复及构建脚本
│   ├── texlive/                # TeX Live 源码下载、宿主机/目标机交叉编译及资源打包脚本
│   └── texstudio/              # TeXstudio 主程序交叉编译脚本
├── texstudio_harmony/          # DevEco Studio 应用工程目录
│   ├── AppScope/               # 全局应用配置
│   ├── entry/                  # 主模块 (Main Entry) 目录，存放代码与生成的动态库
│   └── qEmbeddedUiExtensionHost/ # UI 扩展 Host 模块
├── third_party/                # 第三方依赖及子模块
│   ├── lycium/                 # 用于 OpenHarmony 的第三方库交叉编译框架
│   ├── poppler/                # Poppler 源码 (Git Submodule，包含适配 HarmonyOS 的修改)
│   └── texstudio/              # TeXstudio 源码 (Git Submodule，包含适配 HarmonyOS 的修改)
├── LICENSE                     # MIT 开源许可证
└── .gitmodules                 # 子模块配置
```

## 环境要求

在编译本工程前，请确保开发环境满足以下要求：

* **操作系统**: Linux/WSL2 环境 (推荐 Ubuntu 20.04/22.04)
* **OpenHarmony SDK**: 已下载并解压 OpenHarmony SDK
* **基础工具链**: 
  
  ```bash
  sudo apt update
  sudo apt install -y \
       build-essential autoconf automake libtool pkg-config \
       bison flex perl python3 curl wget tar xz-utils fonts-noto-cjk
  ```

* **IDE**: [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/) (生成签名)、VSCode

**环境变量配置**:
必须在您的 `.bashrc` 或构建终端中配置 `TOOL_HOME` 环境变量以指向 SDK 根目录。脚本会默认根据 `$TOOL_HOME/sdk/default/openharmony/native` 寻找 NATIVE SDK。

```bash
export TOOL_HOME="~/software/command-line-tools"
```

## 快速开始

### 1. 克隆代码库

本项目使用了 Git Submodules 管理源码依赖：

```bash
git clone --recursive https://github.com/baitianyu-kun/texstudio-harmony.git
cd texstudio-harmony
```

### 2. 交叉编译构建流程

在确保环境变量 `TOOL_HOME` 配置无误后，请**依次**执行以下脚本：

```bash
# 第一步：下载并编译 Qt for HarmonyOS
cd ./scripts/qt
./download_qt.sh
./patch_qt.sh
./build_qt.sh

# 第二步：编译 Poppler (依赖 Qt 与 Freetype)
cd ./scripts/poppler
./build_freetype.sh
./build_poppler.sh

# 第三步：编译 Tex Live 相关依赖
cd ./third_party/lycium
./build_all_packages.sh

# 第四步：编译并打包 TeX Live
cd ./scripts/texlive
./download_texlive.sh
./build_texlive_host.sh
./build_texlive_ohos.sh
./build_pack_texmf.sh
./build_texlive_hnp.sh  # 打包成 OpenHarmony Native Package (HNP)

# 第五步：编译 TeXstudio
cd ./scripts/texstudio
./build_texstudio.sh

# 第六步：将编译产物拷贝到工程中
cd ./scripts/common
./copy_libs_entry.sh
```

### 3. 生成签名并推送

* 在 DevEco Studio 中打开texstudio_harmony工程，并生成签名
* 将 C:\Users\User\.ohos文件夹复制到scripts/common/sign下
* 修改 texstudio_harmony/build-profile.json5 中 certpath、profile、storeFile 路径
* 构建、签名并推送
  
  ```bash
  # 连接设备
  hdc tconn 192.168.0.102:34377 

  # 构建、签名并推送
  cd scripts/common/sign
  ./sign_push.sh
  ```

## 致谢

- [TexHarmony](https://github.com/panedioic/TexHarmony) 提供 Tex Live 编译脚本
- [Termony](https://github.com/TermonyHQ/Termony)
- [lycium](https://gitee.com/openharmony-sig/tpc_c_cplusplus)
- [TexStudio](https://github.com/texstudio-org/texstudio)
- [Poppler](https://github.com/innodatalabs/poppler)
- claude、gemini、deepseek-v4

## License

本项目使用 **MIT License**。详情请参阅 [LICENSE](./LICENSE) 文件。