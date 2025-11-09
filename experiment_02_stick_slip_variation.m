%% Shows the impact of varying the mass
clearvars; clc; close all;

model = 'generalBristleFriction2d_velocity_input';

save_figs = false;
fig_prefix = fullfile('experiment_02_stick_slip_variation','experiment_02_stick_slip_variation');

color_1 = [0 0 0];
color_2 = [0 128 255]/255;
color_3 = [76 0 153]/255;
linewidth = 1;

%% Set Parameters

dot_rt = [ 
    % time, vx  vy
    0,      0,  0;
    1,      0,  0;
    1.01,    1,  0;
    3,      1,  0;
    3.01,    0,  0;
];

% friction parameters
k = 15 * eye(2);
d = 0 * eye(2);
k_m = 10 * eye(2);
d_m = 0 * eye(2);

m_b = 0.0;

F_g = 1 * eye(2);
v_minslip = 1e-3;

lambda_flag = 1;

% solver settings
t_end = 4;
t_step = 0.001;

%% Simulate

F_h = 2.0 * eye(2);
out_sim_Fh2p0 = sim(model);

F_h = 1.0 * eye(2);
out_sim_Fh1p0 = sim(model);


%% Plot Results

colors = [0.1216, 0.4667, 0.7059; ...
          1,      0.4980, 0.0549; ...
          0.1725, 0.6275, 0.1725; ...
          0.8392, 0.1529, 0.1569; ...
          0.5804, 0.4039, 0.7412; ...
          0.5490, 0.3373, 0.2941; ...
          0.8902, 0.4667, 0.7608; ...
          0.4980, 0.4980, 0.4980; ...
          0.7373, 0.7412, 0.1333; ...
          0.0902, 0.7451, 0.8118];
colors = get(0,'FactoryAxesColorOrder');

set(0,'Defaulttextinterpreter','latex');
set(0,'DefaultAxesTickLabelInterpreter','latex');
set(0,'DefaultAxesFontName', 'CMU Serif');
set(0,'DefaultAxesFontSize', 10);
set(0,'DefaultAxesColorOrder', colors);
set(0,'DefaultLegendInterpreter','latex');
set(0,'DefaultLegendFontName', 'CMU Serif');
set(0,'DefaultLegendFontSize', 10);
set(0,'DefaultTextFontname', 'CMU Serif');

time = out_sim_Fh2p0.tout;

f_mu_Fh2p0 = out_sim_Fh2p0.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_Fh1p0 = out_sim_Fh1p0.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;

stick_Fh2p0 = out_sim_Fh2p0.simlog.generalBristleFriction.Dynamic_Friction.stick.series.values;
stick_Fh1p0 = out_sim_Fh1p0.simlog.generalBristleFriction.Dynamic_Friction.stick.series.values;

% f_mue
f1 = figure('Color','white', 'Position',[395.4000  463.4000  304.8000  130.6000]); hold on; grid on;
p1=plot(time, f_mu_Fh1p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.0 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, f_mu_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex')
l = legend([p1,p2],'Location','northeast');
l.ItemTokenSize = [20, 10];

if save_figs
    savefig(sprintf('%s_f_mue.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_f_mue.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% stick-state
f2 = figure('Color','white', 'Position',[395.4000  463.4000  304.8000  110.6000]); hold on; grid on;
p1=plot(time, stick_Fh1p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.0 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, stick_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('Stick State [1]', 'Interpreter','latex')

if save_figs
    savefig(sprintf('%s_stick_state.fig',fig_prefix));
    exportgraphics(f2, sprintf('%s_stick_state.pdf',fig_prefix), 'ContentType', 'vector'); 
end
