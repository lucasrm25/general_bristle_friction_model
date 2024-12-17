%% Shows the impact of varying the mass
clearvars; bdclose; 

model = 'general_bristle_model_1d';
addpath('general_bristle_model_1d')

save_figs = true;
fig_prefix = fullfile('experiment_01_mass_variation_noslip','experiment_01_mass_variation_noslip');

%% Set Parameters

dot_rt = [ 
    % time, velocity
    0,      0;
    1,      0;
    1.01,   1;
    3,      1;
    3.01,   0;
];

% friction parameters
k_1 = 10;
d_1 = 0;
k_2 = 10;
d_2 = 0;
m_b = 0.01;
F_g = 1;
F_h = 1.2 * 1e-10;
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

f1 = figure('Color','white', 'Position',1.0e+03 *[1.1674    1.6402    0.2816    0.1248]); hold on; grid on;
p1=plot(out_sim_m0p00.simlog.dot_rt.f.series.time, -out_sim_m0p00.simlog.dot_rt.f.series.values, 'DisplayName', '$f_t$ $(m_b=0.00)$');
p2=plot(out_sim_m0p05.simlog.dot_rt.f.series.time, -out_sim_m0p05.simlog.dot_rt.f.series.values, 'DisplayName', '$f_t$ $(m_b=0.05)$');
p3=plot(out_sim_m0p10.simlog.dot_rt.f.series.time, -out_sim_m0p10.simlog.dot_rt.f.series.values, 'DisplayName', '$f_t$ $(m_b=0.10)$');
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')
% l = legend([p1,p2,p3],'Location','southeast');
% set(l,'Position',[0.617251435589999 0.640302747187487 0.312543517043214 0.345558377232042]);
if save_figs
    savefig(sprintf('%s_f_t.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_f_t.pdf',fig_prefix), 'ContentType', 'vector'); 
end

f2 = figure('Color','white', 'Position',1.0e+03 *[1.1706    1.3962    0.2816    0.1248]); hold on; grid on;
plot(out_sim_m0p00.simlog.Dynamic_Friction.f.series.time, out_sim_m0p00.simlog.Dynamic_Friction.f.series.values, 'DisplayName', '$\dot r_\mu$ $(m_b=0.00)$')
plot(out_sim_m0p05.simlog.Dynamic_Friction.f.series.time, out_sim_m0p05.simlog.Dynamic_Friction.f.series.values, 'DisplayName', '$\dot r_\mu$ $(m_b=0.05)$')
plot(out_sim_m0p10.simlog.Dynamic_Friction.f.series.time, out_sim_m0p10.simlog.Dynamic_Friction.f.series.values, 'DisplayName', '$\dot r_\mu$ $(m_b=0.10)$')
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex')
ylim([0,1.5])
% legend('Location','southeast');
if save_figs
    savefig(sprintf('%s_f_mu.fig',fig_prefix));
    exportgraphics(f2, sprintf('%s_f_mu.pdf',fig_prefix), 'ContentType', 'vector'); 
end

f3 = figure('Color','white', 'Position',1.0e+03 *[1.1706    1.1466    0.2816    0.1248]); hold on; grid on;
p1 = plot(out_sim_m0p00.simlog.Bristle_Mass.v.series.time, out_sim_m0p00.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(m_b=0.00)$');
p2 = plot(out_sim_m0p05.simlog.Bristle_Mass.v.series.time, out_sim_m0p05.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(m_b=0.05)$');
p3 = plot(out_sim_m0p10.simlog.Bristle_Mass.v.series.time, out_sim_m0p10.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(m_b=0.10)$');
ylabel('$\dot r_b$ [m/s]', 'Interpreter','latex');
ylim([0,1.5]);
yyaxis right;
p4 = plot( ...
    out_sim_m0p10.simlog.dot_rt.v.series.time, ...
    out_sim_m0p10.simlog.dot_rt.v.series.values, ...
    'DisplayName', '$\dot r_t$', ...
    'Color', [0.4,0.4,0.4],'LineStyle','--' ...
);
ylabel('$\dot r_t$ [m/s]', 'Interpreter','latex', 'Color',[0.4,0.4,0.4]);
ylim([0,1.5]);
ax = gca;
ax.YColor = [0.4,0.4,0.4];
xlabel('Time [s]', 'Interpreter','latex')

% l = legend([p1,p2,p3,p4],'Location','southoutside','Orientation','horizontal');
% set(l,'Position',[0.575077193285721 0.635226605055508 0.365395938659644 0.345558377232043]);
% l.ItemTokenSize = [10, 10];
if save_figs
    savefig(sprintf('%s_r_b.fig',fig_prefix));
    exportgraphics(f3, sprintf('%s_r_b.pdf',fig_prefix), 'ContentType', 'vector'); 
end


f_legend = figure('Color','white', 'Position',1.0e+03 *[1.4154    1.6826    0.2816    0.0248]); hold on; grid on;
p1=plot([0,1], [NaN,NaN], 'DisplayName', '$m_b=0.00 kg$');
p2=plot([0,1], [NaN,NaN], 'DisplayName', '$m_b=0.05 kg$');
p3=plot([0,1], [NaN,NaN], 'DisplayName', '$m_b=0.10 kg$');
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


