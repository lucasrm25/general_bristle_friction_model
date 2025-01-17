%% Shows the impact of varying the mass
clearvars; bdclose; 

model = 'general_bristle_model_2d';
addpath('general_bristle_model_2d');

save_figs = false;
fig_prefix = fullfile('experiment_01_mass_variation','experiment_01_mass_variation');

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

F_g = 1 * eye(2);
F_h = 1.2 * 1e-10 * eye(2);

v_minslip = 1e-3 * 0;

lambda_flag = 1;

% solver settings
t_end = 4;
t_step = 0.001;

%% Simulate

m_b = 0.00;
out_sim_m0p00 = sim(model);

m_b = 0.05;
out_sim_m0p05 = sim(model);

m_b = 0.10;
out_sim_m0p10 = sim(model);


%% Plot Results
close all;

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
set(0,'DefaultLegendFontSize', 8);
set(0,'DefaultTextFontname', 'CMU Serif');

f_mu_m0p00 = out_sim_m0p00.simlog.Dynamic_Friction.f.series.values;
f_t_m0p00  = out_sim_m0p00.simlog.velocity_input.f.series.values;
r_b_m0p00  = out_sim_m0p00.simlog.Bristle_Mass.v.series.values;

f_mu_m0p05 = out_sim_m0p05.simlog.Dynamic_Friction.f.series.values;
f_t_m0p05  = out_sim_m0p05.simlog.velocity_input.f.series.values;
r_b_m0p05  = out_sim_m0p05.simlog.Bristle_Mass.v.series.values;

f_mu_m0p10 = out_sim_m0p10.simlog.Dynamic_Friction.f.series.values;
f_t_m0p10  = out_sim_m0p10.simlog.velocity_input.f.series.values;
r_b_m0p10  = out_sim_m0p10.simlog.Bristle_Mass.v.series.values;

r_t = out_sim_m0p10.simlog.velocity_input.v.series.values;

% f_t
f1 = figure('Color','white', 'Position',[865.8000 546.6000 281.6000 124.8000]); hold on; grid on;
p1=plot(out_sim_m0p00.tout, -f_t_m0p00(:,1), 'DisplayName', '$f_t$ $(m_b=0.00)$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(out_sim_m0p05.tout, -f_t_m0p05(:,1), 'DisplayName', '$f_t$ $(m_b=0.05)$', 'Color', color_2, 'LineWidth', linewidth);
p3=plot(out_sim_m0p10.tout, -f_t_m0p10(:,1), 'DisplayName', '$f_t$ $(m_b=0.10)$', 'Color', color_3, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')

if save_figs
    savefig(sprintf('%s_f_t.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_f_t.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% f_mue
f2 = figure('Color','white', 'Position',[865.8000 546.6000 281.6000 124.8000]); hold on; grid on;
plot(out_sim_m0p00.tout, f_mu_m0p00(:,1), 'DisplayName', '$\dot r_\mu$ $(m_b=0.00)$', 'Color', color_1, 'LineWidth', linewidth);
plot(out_sim_m0p05.tout, f_mu_m0p05(:,1), 'DisplayName', '$\dot r_\mu$ $(m_b=0.05)$', 'Color', color_2, 'LineWidth', linewidth);
plot(out_sim_m0p10.tout, f_mu_m0p10(:,1), 'DisplayName', '$\dot r_\mu$ $(m_b=0.10)$', 'Color', color_3, 'LineWidth', linewidth);
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex')
ylim([0,1.5])

if save_figs
    savefig(sprintf('%s_f_mu.fig',fig_prefix));
    exportgraphics(f2, sprintf('%s_f_mu.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% dr_t and dr_b
f3 = figure('Color','white', 'Position',[865.8000 546.6000 281.6000 124.8000]); hold on; grid on;
p1 = plot(out_sim_m0p00.tout, r_b_m0p00(:,1), 'DisplayName', '$\dot r_b$ $(m_b=0.00)$', 'Color', color_1, 'LineWidth', linewidth);
p2 = plot(out_sim_m0p05.tout, r_b_m0p05(:,1), 'DisplayName', '$\dot r_b$ $(m_b=0.05)$', 'Color', color_2, 'LineWidth', linewidth);
p3 = plot(out_sim_m0p10.tout, r_b_m0p10(:,1), 'DisplayName', '$\dot r_b$ $(m_b=0.10)$', 'Color', color_3, 'LineWidth', linewidth);
ylabel('$\dot r_b$ [m/s]', 'Interpreter','latex');
ylim([0,1.5]);
yyaxis right;
p4 = plot( ...
    out_sim_m0p10.tout, ...
    r_t(:,1), ...
    'DisplayName', '$\dot r_t$', ...
    'Color', [0.4,0.4,0.4],'LineStyle','--', 'LineWidth', linewidth ...
);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',[0.4,0.4,0.4]);
ylim([0,1.5]);
ax = gca;
ax.YColor = [0.4,0.4,0.4];
xlabel('Time [s]', 'Interpreter','latex')

if save_figs
    savefig(sprintf('%s_r_b.fig',fig_prefix));
    exportgraphics(f3, sprintf('%s_r_b.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% legend
f_legend = figure('Color','white', 'Position',[865.8000 546.60006    1.0e+03 *0.2816    1.0e+03 *0.0248]); hold on; grid on;
p1=plot([0,1], [NaN,NaN], 'DisplayName', '$m_{b,no}=0.00 kg$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot([0,1], [NaN,NaN], 'DisplayName', '$m_{b,lo}=0.05 kg$', 'Color', color_2, 'LineWidth', linewidth);
p3=plot([0,1], [NaN,NaN], 'DisplayName', '$m_{b,hi}=0.10 kg$', 'Color', color_3, 'LineWidth', linewidth);
p4=plot([0,1], [NaN,NaN], 'DisplayName', '$\dot r_t$', 'Color', 'black','LineStyle','--');
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')
l = legend([p1,p2,p3],'Location','southeast','Orientation','horizontal');
l.ItemTokenSize = [10, 10];
set(l,'Position',[0.0871179212053049 0.191397881456602 0.811962444305473 0.625806419618666]);
axis off

if save_figs
    savefig(sprintf('%s_legend.fig',fig_prefix));
    exportgraphics(f_legend, sprintf('%s_legend.pdf',fig_prefix), 'ContentType', 'vector'); 
end


