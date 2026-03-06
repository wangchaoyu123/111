# Simulink 拟合问题解决方案

本仓库提供 MATLAB/Simulink 曲线拟合与参数估计的示例脚本，用于解决常见的拟合问题。

---

## 🚀 如何上传您的代码和问题描述

### 方法一：通过 GitHub 网页上传文件（推荐新手）

1. 打开本仓库页面（`github.com/wangchaoyu123/111`）
2. 点击页面右上角的 **"Add file"** 按钮 → 选择 **"Upload files"**
3. 将您的文件拖拽到上传区域，支持以下格式：
   - `.m` — MATLAB 脚本
   - `.slx` / `.mdl` — Simulink 模型文件
   - `.mat` — MATLAB 数据文件
   - `.txt` / `.csv` — 原始数据或日志
4. 在 **"Commit changes"** 区域填写简短说明（例如：`上传拟合模型`），然后点击 **"Commit changes"** 完成上传

### 方法二：提交 Issue 描述问题

1. 点击仓库顶部菜单中的 **"Issues"** 选项卡
2. 点击右上角 **"New issue"**
3. 按照以下模板填写（直接复制粘贴）：

```
## 问题描述
（在此简述您遇到的问题，例如：拟合曲线与实测数据偏差过大）

## MATLAB / Simulink 版本
（例如：MATLAB R2022b，Simulink 10.6）

## 复现步骤
1. 打开模型 xxx.slx
2. 运行仿真
3. 观察到 ...

## 错误信息
（将 MATLAB 命令窗口中的红色报错文字粘贴到此处）

## 期望结果
（描述您希望得到的正确结果）
```

4. 如需附加截图，可直接将图片粘贴到 Issue 文本框中
5. 点击 **"Submit new issue"** 提交

### 方法三：通过 Git 命令上传（适合熟悉命令行的用户）

```bash
# 克隆仓库到本地
git clone https://github.com/wangchaoyu123/111.git
cd 111

# 复制您的文件到仓库目录，然后提交
git add your_model.slx your_script.m
git commit -m "上传待诊断的 Simulink 模型"
git push
```

---

> **💡 提示**：上传代码后，GitHub Copilot Agent 会自动读取您的文件，直接修改并修复问题，结果以 Pull Request 的形式呈现，您只需点击 "Merge" 即可应用修复。

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `simulink_fitting_example.m` | MATLAB 拟合示例脚本，包含多项式拟合、非线性最小二乘拟合和 Simulink 参数估计的完整示例 |

## 快速开始

1. 打开 MATLAB（建议 R2019b 及以上版本）
2. 将工作目录切换到本仓库根目录
3. 运行示例脚本：
   ```matlab
   run('simulink_fitting_example.m')
   ```

## 常见拟合问题及解决方案

### 问题 1：拟合结果与数据偏差过大
- **原因**：初值设置不合理，算法陷入局部最优
- **解决**：多次随机初值重跑，或使用 `GlobalSearch` / `MultiStart`

### 问题 2：`lsqcurvefit` 提示 "Solver stopped prematurely"
- **原因**：迭代次数不足或容差过松
- **解决**：在 `optimoptions` 中增大 `MaxIterations`，减小 `FunctionTolerance` / `StepTolerance`

### 问题 3：Simulink 仿真在参数估计时不收敛
- **原因**：求解器步长过大或模型存在刚性方程
- **解决**：使用变步长求解器（`ode45` / `ode15s`），并减小最大步长

### 问题 4：数据噪声过大导致过拟合
- **原因**：模型阶数或参数过多
- **解决**：降低多项式阶数；先对数据做低通滤波（`lowpass` / `filtfilt`）再拟合

## 依赖工具箱

- **Optimization Toolbox**：`lsqcurvefit`、`GlobalSearch`
- **Simulink Design Optimization Toolbox**：`sdo.optimize`（Simulink 参数估计）
- **Curve Fitting Toolbox**（可选）：`fit` 函数提供更丰富的拟合类型
