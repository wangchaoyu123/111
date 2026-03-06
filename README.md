# Simulink 拟合问题解决方案

本仓库提供 MATLAB/Simulink 曲线拟合与参数估计的示例脚本，用于解决常见的拟合问题。

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
