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

本项目旨在将知名 LaTeX 编辑器 [TeXstudio](https://github.com/texstudio-org/texstudio) 以及其核心依赖项 [Poppler](https://gitlab.freedesktop.org/poppler/poppler) 和 [TeX Live](https://tug.org/texlive/) 统一移植到OpenHarmony平台。 

## 仓库结构

本项目主要由以下几个核心部分组成：

```text
texstudio-harmony/
├── additional-packages/     # 额外的预编译包或扩展依赖
├── scripts/                 # 核心构建、打包与部署脚本
│   ├── common/              # 通用脚本（依赖拷贝、部署配置生成、HNP打包、签名推送等）
├── ├── ├── texstudio-harmony-deployment-settings.json # Qt6 自动生成鸿蒙应用部署配置
│   ├── poppler/             # Poppler 库的下载与交叉编译脚本
│   ├── qt/                  # Qt6 框架的下载与交叉编译脚本
│   ├── texlive/             # TeX Live 依赖包编译脚本
│   └── texstudio/           # TeXstudio 核心源码的交叉编译脚本
├── third_party/             # 第三方依赖及核心源码库
│   ├── lycium/              # 用于 OpenHarmony 交叉编译构建的依赖管理工具
│   └── texstudio/           # TeXstudio 官方原始仓库源码（作为子模块接入）
├── build/                   # 自动生成的构建输出目录（不入库，执行编译后产生）
│   ├── build-poppler-ohos/  # Poppler 鸿蒙平台编译产物
│   ├── build-qt-ohos/       # Qt6 鸿蒙平台编译产物
│   └── build-texstudio-ohos/# TeXstudio 鸿蒙平台编译产物
└── README.md                # 项目说明文档
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

**Qt6 & Poppler**: 
* Qt6 版本为 gerrit/dev 最新分支 6.13.0 
* Poppler 版本为 24.12.0 

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
# 第一步：下载 Qt6 所需的 additional-packages 到当前目录下
https://drive.google.com/file/d/1muyUjBPS8B0CLEoLAhtGgxNY6C6W7TTl/view?usp=share_link

# 第二步：下载并编译 Qt for HarmonyOS
cd ./scripts/qt
./download_qt.sh
./build_qt_host.sh
./build_qt.sh

# 第三步：编译 Poppler
cd ./scripts/poppler
./download_poppler.sh
./build_poppler.sh

# 第四步：编译 Tex Live 相关依赖
cd ./third_party/lycium
./build_all_packages.sh

# 第五步：编译并打包 TeX Live
cd ./scripts/texlive
./download_texlive.sh
./build_texlive_host.sh
./build_texlive_ohos.sh
./build_pack_texmf.sh

# 第六步：编译 TeXstudio
cd ./scripts/texstudio
./build_texstudio.sh

# 第七步：打包 Tex Live HNP
cd ./scripts/common
./build_texlive_hnp.sh  # 打包成 OpenHarmony Native Package (HNP)

# 第八步：构建HAP，使用 Qt6 提供的harmonydeployqt，构建位置为./scripts/common/libtexstudio-harmonyos
cd ./scripts/common
# 如果构建报错的话 pkill -f hvigor 
./generate_deployment_settings.sh
./generate_hvigor_hap.sh
./add_hnp_support.sh
```

### 3. 生成签名并推送

* 在 DevEco Studio 中打开 libtexstudio-harmonyos 工程，并生成签名
* 将 C:\Users\User\.ohos文件夹复制到scripts/common/sign下
* 修改 libtexstudio-harmonyos/build-profile.json5 中 certpath、profile、storeFile 路径
* 构建、签名并推送
  
  ```bash
  # 连接设备
  hdc tconn 192.168.0.102:34377 

  # 构建、签名并推送
  cd scripts/common/sign
  ./sign_push.sh

  # 签名失败多半是 build-profile.json5 中有多余的逗号
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