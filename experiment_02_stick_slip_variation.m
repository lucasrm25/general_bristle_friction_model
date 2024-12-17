%% Shows the impact of varying the mass
clearvars; bdclose; 

model = 'general_bristle_model_1d';
addpath('general_bristle_model_1d')

save_figs = false;
fig_prefix = fullfile('experiment_02_stick_slip_variation','experiment_02_stick_slip_variation');

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
m_b = 0.0;
F_g = 1;
F_h = 1.2;
v_minslip = 1e-3;
lambda_flag = 1;

% solver settings
t_end = 4;
t_step = 0.001;

%% Simulate

F_h = 2.0;
out_sim_Fh2p0 = sim(model);

F_h = 1.2;
out_sim_Fh1p2 = sim(model);

F_h = 1.0;
out_sim_Fh1p0 = sim(model);


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
set(0,'DefaultLegendFontSize', 10);
set(0,'DefaultTextFontname', 'CMU Serif');

f1 = figure('Color','white', 'Position',[395.4000  463.4000  304.8000  157.6000]); hold on; grid on;
p1=plot(out_sim_Fh2p0.simlog.dot_rt.f.series.time, -out_sim_Fh2p0.simlog.dot_rt.f.series.values, 'DisplayName', '$f_t$ $(F_h=2.0)$');
p2=plot(out_sim_Fh1p2.simlog.dot_rt.f.series.time, -out_sim_Fh1p2.simlog.dot_rt.f.series.values, 'DisplayName', '$f_t$ $(F_h=1.2)$');
p4=plot( ...
    out_sim_Fh2p0.simlog.Dynamic_Friction.stick.series.time, ...
    1-out_sim_Fh2p0.simlog.Dynamic_Friction.stick.series.values, ...
    'DisplayName', 'slip $(F_h=2.0)$', ...
    'Color', colors(1,:), 'LineStyle','--' ...
);
p5=plot( ...
    out_sim_Fh1p2.simlog.Dynamic_Friction.stick.series.time, ...
    1-out_sim_Fh1p2.simlog.Dynamic_Friction.stick.series.values, ...
    'DisplayName', 'slip $(F_h=1.2)$', ...
    'Color', colors(2,:),'LineStyle','-.' ...
);
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')
l = legend([p1,p2,p4,p5],'Location','northeast');
set(l,'Position',[0.617251435589999 0.640302747187487 0.312543517043214 0.345558377232042]);
if save_figs
    savefig(sprintf('%s_f_t.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_f_t.pdf',fig_prefix), 'ContentType', 'vector'); 
end

f2 = figure('Color','white', 'Position',[761.8000 420.2000 304.8000  157.6000]); hold on; grid on;
plot(out_sim_Fh2p0.simlog.Dynamic_Friction.f.series.time, out_sim_Fh2p0.simlog.Dynamic_Friction.f.series.values, 'DisplayName', '$f_\mu$ $(F_h=2.0)$')
plot(out_sim_Fh1p2.simlog.Dynamic_Friction.f.series.time, out_sim_Fh1p2.simlog.Dynamic_Friction.f.series.values, 'DisplayName', '$f_\mu$ $(F_h=1.2)$')
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex')
ylim([0,2.5])
legend('Location','northeast');
if save_figs
    savefig(sprintf('%s_f_mu.fig',fig_prefix));
    exportgraphics(f2, sprintf('%s_f_mu.pdf',fig_prefix), 'ContentType', 'vector'); 
end

f3 = figure('Color','white', 'Position',[356.2000  113.8000  304.8000  157.6000]); hold on; grid on;
p1 = plot(out_sim_Fh2p0.simlog.Bristle_Mass.v.series.time, out_sim_Fh2p0.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(F_h=2.0)$');
p2 = plot(out_sim_Fh1p2.simlog.Bristle_Mass.v.series.time, out_sim_Fh1p2.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(F_h=1.2)$');
p4 = plot( ...
    out_sim_Fh2p0.simlog.dot_rt.v.series.time, ...
    out_sim_Fh1p2.simlog.dot_rt.v.series.values, ...
    'DisplayName', '$\dot r_t$', ...
    'Color', 'black','LineStyle','--' ...
);
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$\dot r$ [m/s]', 'Interpreter','latex')
ylim([0,1.8])
l = legend([p1,p2,p4],'Location','northeast');
set(l,'Position',[0.575077193285721 0.635226605055508 0.365395938659644 0.345558377232043]);
if save_figs
    savefig(sprintf('%s_r_b.fig',fig_prefix));
    exportgraphics(f3, sprintf('%s_r_b.pdf',fig_prefix), 'ContentType', 'vector'); 
end


f4 = figure('Color','white', 'Position',[356.2000  113.8000  304.8000  157.6000]); hold on; grid on;
p1 = plot(out_sim_Fh2p0.simlog.Bristle_Mass.v.series.time, out_sim_Fh2p0.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(F_h=2.0)$');
p2 = plot(out_sim_Fh1p2.simlog.Bristle_Mass.v.series.time, out_sim_Fh1p2.simlog.Bristle_Mass.v.series.values, 'DisplayName', '$\dot r_b$ $(F_h=1.2)$');
p4 = plot( ...
    out_sim_Fh2p0.simlog.dot_rt.v.series.time, ...
    out_sim_Fh1p2.simlog.dot_rt.v.series.values, ...
    'DisplayName', '$\dot r_t$', ...
    'Color', 'black','LineStyle','--' ...
);
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$\dot r$ [m/s]', 'Interpreter','latex')
ylim([0,1.8])
l = legend([p1,p2,p4],'Location','northeast');
set(l,'Position',[0.575077193285721 0.635226605055508 0.365395938659644 0.345558377232043]);
if save_figs
    savefig(sprintf('%s_r_b.fig',fig_prefix));
    exportgraphics(f4, sprintf('%s_r_b.pdf',fig_prefix), 'ContentType', 'vector'); 
end

