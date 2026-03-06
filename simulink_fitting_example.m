%% Simulink 拟合示例脚本
% 本脚本演示在 MATLAB/Simulink 环境中常见的曲线拟合与参数估计方法，
% 并提供常见问题的排查与解决思路。
%
% 运行环境：MATLAB R2019b 及以上版本
% 依赖工具箱：Optimization Toolbox / Curve Fitting Toolbox (可选)

%% ========================================================
% 第一部分：基础多项式曲线拟合
% ========================================================
clc; clear; close all;

% 1. 生成示例数据（实际使用时替换为您的测量数据）
x_data = (0:0.1:10)';                      % 自变量
y_data = 2.5 * sin(x_data) + 0.5 * x_data ...
         + 0.3 * randn(size(x_data));       % 含噪声的因变量

% 2. 多项式拟合（polyfit / polyval）
degree = 5;                                 % 多项式阶数，可根据残差调整
p_coeff = polyfit(x_data, y_data, degree);  % 求拟合系数
y_fit   = polyval(p_coeff, x_data);         % 求拟合值

% 3. 计算拟合误差
residuals   = y_data - y_fit;
rmse_poly   = sqrt(mean(residuals.^2));
fprintf('[多项式拟合] RMSE = %.6f\n', rmse_poly);

% 4. 可视化
figure('Name', '多项式拟合');
plot(x_data, y_data, 'b.', 'MarkerSize', 8, 'DisplayName', '原始数据');
hold on;
plot(x_data, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', ...
     sprintf('多项式拟合 (阶数=%d)', degree));
legend('Location', 'best');
xlabel('x'); ylabel('y');
title('多项式曲线拟合');
grid on;

%% ========================================================
% 第二部分：基于自定义模型的非线性最小二乘拟合
% ========================================================

% 常见问题：拟合不收敛或结果偏差大时，请检查初值设定。
% 推荐做法：先绘图估计参数初值，再代入求解器。

% 自定义模型：y = a * sin(b*x + c) + d
model_func = @(params, x) params(1) .* sin(params(2) .* x + params(3)) + params(4);

% 初值（关键！需要尽量接近真实值）
p0 = [2.0, 1.0, 0.0, 0.5];

% 使用 lsqcurvefit（需要 Optimization Toolbox）
options = optimoptions('lsqcurvefit', ...
    'Algorithm',       'levenberg-marquardt', ...
    'MaxIterations',   1000, ...
    'FunctionTolerance', 1e-8, ...
    'Display',         'off');

try
    [p_opt, resnorm] = lsqcurvefit(model_func, p0, x_data, y_data, [], [], options);
    y_nlfit = model_func(p_opt, x_data);
    rmse_nl = sqrt(mean((y_data - y_nlfit).^2));
    fprintf('[非线性拟合] a=%.4f  b=%.4f  c=%.4f  d=%.4f\n', p_opt(1), p_opt(2), p_opt(3), p_opt(4));
    fprintf('[非线性拟合] RMSE = %.6f\n', rmse_nl);

    figure('Name', '非线性最小二乘拟合');
    plot(x_data, y_data,  'b.', 'MarkerSize', 8, 'DisplayName', '原始数据');
    hold on;
    plot(x_data, y_nlfit, 'r-', 'LineWidth', 2, 'DisplayName', '非线性拟合');
    legend('Location', 'best');
    xlabel('x'); ylabel('y');
    title('非线性最小二乘曲线拟合');
    grid on;
catch ME
    warning('lsqcurvefit 失败（可能未安装 Optimization Toolbox）：%s', ME.message);
end

%% ========================================================
% 第三部分：Simulink 参数估计（Parameter Estimation）
% ========================================================
% 若需要对 Simulink 模型的参数进行估计，推荐使用以下流程：
%
%   1. 准备实验数据（时间向量 + 输出向量）
%   2. 建立 Simulink 模型，将待估计参数声明为 MATLAB 工作区变量
%   3. 使用 sdo.optimize 或 Parameter Estimation App 进行优化
%
% 以下为 sdo.optimize 的简化示例（需要 Simulink Design Optimization Toolbox）：
%
%   model_name = 'your_model';          % 替换为您的模型名称
%   load_system(model_name);
%
%   % 声明待估计参数
%   p = sdo.getParameterFromModel(model_name, {'param1', 'param2'});
%   p(1).Minimum = 0;   p(1).Maximum = 10;
%   p(2).Minimum = -5;  p(2).Maximum = 5;
%
%   % 定义优化目标（残差）
%   sim_opt = sdo.SimulationOptions('StopTime', '10');
%   cost_fn = @(p_val) sdoExampleCostFunction(p_val, model_name, exp_data);
%
%   opt_options = sdo.OptimizeOptions('Method', 'lsqnonlin');
%   [p_opt, opt_info] = sdo.optimize(cost_fn, p, opt_options);

%% ========================================================
% 第四部分：常见问题与解决方案
% ========================================================
%
% 问题 1：拟合结果与数据偏差过大
%   原因：初值设置不合理，算法陷入局部最优
%   解决：① 多次随机初值重跑；② 使用 GlobalSearch 或 MultiStart
%
% 问题 2：lsqcurvefit 提示 "Solver stopped prematurely"
%   原因：迭代次数不足或容差过松
%   解决：增大 MaxIterations，减小 FunctionTolerance / StepTolerance
%
% 问题 3：Simulink 仿真在参数估计时不收敛
%   原因：步长过大或模型刚性方程
%   解决：① 使用变步长求解器（ode45/ode15s）；② 减小最大步长
%
% 问题 4：数据噪声过大导致过拟合
%   原因：模型阶数或参数过多
%   解决：① 降低多项式阶数；② 先对数据做低通滤波再拟合

fprintf('\n脚本运行完毕。请查看图形窗口中的拟合结果。\n');
