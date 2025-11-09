%% Shows the impact of varying the mass
clearvars; clc; close all;

model = 'generalBristleFriction2d_velocity_input';

save_figs = false;
fig_prefix = fullfile('experiment_04_rheo_variation','experiment_04_rheo_variation');

color_black = [0 0 0]/255;
color_red = [153,0,0]/255;
linewidth = 1;

width=200;
height_sma=170;
%% Set Parameters

dot_rt = [ 
    % time, vx  vy
    0,      0,  0;
    1,      0,  0;
    1.01,    1,  0;
    4,      1,  0;
    4.01,    0,  0;
];

% friction parameters
m_b = 0.0;

F_g = 1 * eye(2);
F_h = 2 * eye(2) * 1e-13;

v_minslip = 1e-3;
lambda_flag = 1;

% solver settings
t_end = 10;
t_step = 0.001;

%% Simulate

% Spring
k = 15 * eye(2);
d = 0 * eye(2);
k_m = 10 * eye(2);
d_m = 0 * eye(2);
out_sim_spring = sim(model);

% Damper
k = 0 * eye(2);
d = 15 * eye(2);
k_m = 10 * eye(2);
d_m = 0 * eye(2);
out_sim_damper = sim(model);

% Maxwell
k = 0 * eye(2);
d = 0 * eye(2);
k_m = 15 * eye(2);
d_m = 20 * eye(2);
out_sim_maxwell = sim(model);

% Kelvin-Voigt
k = 5 * eye(2);
d = 10 * eye(2);
k_m = 10 * eye(2);
d_m = 0 * eye(2);
out_sim_kelvin = sim(model);

% Zener
k = 1 * eye(2);
d = 0 * eye(2);
k_m = 15 * eye(2);
d_m = 20 * eye(2);
out_sim_zener = sim(model);

% Jeffreys
k = 0 * eye(2);
d = 20 * eye(2);
k_m = 15 * eye(2);
d_m = 20 * eye(2);
out_sim_jeffreys = sim(model);


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

time = out_sim_spring.simlog.velocity_input.v.series.time;
r_t_spring = out_sim_spring.simlog.velocity_input.v.series.values;

f_mu_spring = out_sim_spring.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_damper = out_sim_damper.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_maxwell = out_sim_maxwell.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_kelvin = out_sim_kelvin.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_zener = out_sim_zener.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;
f_mu_jeffreys = out_sim_jeffreys.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;

% Spring
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_spring(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_spring_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_spring_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% Damper
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_damper(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_damper_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_damper_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% Maxwell
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_maxwell(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_maxwell_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_maxwell_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% Kelvin-Voigt
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_kelvin(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_kelvin_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_kelvin_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% Zener
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_zener(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_zener_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_zener_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% Jeffreys
f1 = figure('Color','white', 'Position',[395.4000  463.4000  width  height_sma]); hold on; grid on;
p1=plot(time, r_t_spring(:,1), 'DisplayName', '$r_t$', 'Color', color_black, 'LineWidth', linewidth);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',color_black);
xlabel('Time [s]', 'Interpreter','latex')
ylim([0 1.01])
xlim([0 10])
xticks([0 5 10])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_black;

yyaxis right
p2=plot(time, f_mu_jeffreys(:,1), 'DisplayName', '$f_\mu$', 'Color', color_red, 'LineWidth', linewidth);
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex', 'Color',color_red)
ylim([0 1.01])
yticks([0 0.5 1])
ax = gca;
ax.YColor = color_red;

grid off
if save_figs
    savefig(sprintf('%s_jeffreys_variation.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_jeffreys_variation.pdf',fig_prefix), 'ContentType', 'vector'); 
end

