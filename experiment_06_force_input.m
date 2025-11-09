%% Shows the impact of varying the mass
clearvars; clc; close all;

model = 'generalBristleFriction2d_force_input';

save_figs = true;
fig_prefix = fullfile('experiment_06_force_input','experiment_06_force_input');

color_1 = [0 0 0];
color_2 = [0 128 255]/255;
color_3 = [76 0 153]/255;
linewidth = 1;

%% Set Parameters

force_input = [ 
    % time, Fx  Fy
    0,      0,  0;
    1,      0,  0;
    2,      1.7,  0;
    3,      1.7,  0;
    3.01,   1.7,  0;
];

% friction parameters
k = 1500 * eye(2);
d = 100 * eye(2);
k_m = 10 * eye(2);
d_m = 0 * eye(2);

m_b = 0.0;

F_g = 1 * eye(2);
v_minslip = 1e-3;

lambda_flag = 1;

% solver settings
t_end = 6;
t_step = 0.001;

%% Simulate

F_h = 2.0 * eye(2);
out_sim_Fh2p0 = sim(model);

F_h = 1.5 * eye(2);
out_sim_Fh1p5 = sim(model);


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
f_mu_Fh1p5 = out_sim_Fh1p5.simlog.generalBristleFriction.Dynamic_Friction.f.series.values;

f_t_Fh2p0 = out_sim_Fh2p0.simlog.generalBristleFriction.Spring.f.series.values + ...
    out_sim_Fh2p0.simlog.generalBristleFriction.Damper.f.series.values;
f_t_Fh1p5 = out_sim_Fh1p5.simlog.generalBristleFriction.Spring.f.series.values + ...
    out_sim_Fh1p5.simlog.generalBristleFriction.Damper.f.series.values;

f_input_Fh2p0 = out_sim_Fh2p0.simlog.force_input.f.series.values;
f_input_Fh1p5 = out_sim_Fh1p5.simlog.force_input.f.series.values;

v_body_Fh2p0 = out_sim_Fh2p0.simlog.Body.v.series.values;
r_body_Fh2p0 = cumtrapz(v_body_Fh2p0)*t_step;
v_body_Fh1p5 = out_sim_Fh1p5.simlog.Body.v.series.values;
r_body_Fh1p5 = cumtrapz(v_body_Fh1p5)*t_step;

stick_Fh2p0 = out_sim_Fh2p0.simlog.generalBristleFriction.Dynamic_Friction.stick.series.values;
stick_Fh1p5 = out_sim_Fh1p5.simlog.generalBristleFriction.Dynamic_Friction.stick.series.values;

% f_mue
f1 = figure('Color','white', 'Position',[313.8000 309 356.8000 181.6000]); hold on; grid on;
p1=plot(time, f_mu_Fh1p5(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.5 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, f_mu_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);
p3=plot(time, -f_input_Fh1p5(:,1), 'DisplayName', '$f_{input,x}$', 'LineStyle','-', 'Color', color_3, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{\mu}$ [N]', 'Interpreter','latex')
l = legend([p1,p2,p3],'Location','southeast');
l.ItemTokenSize = [20, 10];

if save_figs
    savefig(sprintf('%s_f_mue.fig',fig_prefix));
    exportgraphics(f1, sprintf('%s_f_mue.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% f_t
f2 = figure('Color','white', 'Position',[680.2000 311.4000 374.4000 179.2000]); hold on; grid on;
p1=plot(time, f_t_Fh1p5(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.5 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, f_t_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);
p3=plot(time, -f_input_Fh1p5(:,1), 'DisplayName', '$f_{input,x}$', 'LineStyle','-', 'Color', color_3, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')
l = legend([p1,p2,p3],'Location','southeast');
l.ItemTokenSize = [20, 10];

if save_figs
    savefig(sprintf('%s_f_t.fig',fig_prefix));
    exportgraphics(f2, sprintf('%s_f_t.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% stick-state
f3 = figure('Color','white', 'Position',[704.2000 579.4000 304.8000 110.4000]); hold on; grid on;
p1=plot(time, stick_Fh1p5(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.5 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, stick_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);

xlabel('Time [s]', 'Interpreter','latex')
ylabel('Stick State [1]', 'Interpreter','latex')

if save_figs
    savefig(sprintf('%s_stick_state.fig',fig_prefix));
    exportgraphics(f3, sprintf('%s_stick_state.pdf',fig_prefix), 'ContentType', 'vector'); 
end

% r_mass
f4 = figure('Color','white', 'Position',[1.0618e+03 313.8000 374.4000 179.2000]); hold on; grid on;
p1=plot(time, r_body_Fh1p5(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=1.5 N$', 'Color', color_1, 'LineWidth', linewidth);
p2=plot(time, r_body_Fh2p0(:,1), 'DisplayName', '$f_{h,x}=f_{h,y}=2.0 N$', 'LineStyle','--', 'Color', color_2, 'LineWidth', linewidth);
ylim([0,1e-2])

xlabel('Time [s]', 'Interpreter','latex')
ylabel('$r_{body}$ [m]', 'Interpreter','latex')
l = legend([p1,p2],'Location','northeast');
l.ItemTokenSize = [20, 10];

if save_figs
    savefig(sprintf('%s_r_body.fig',fig_prefix));
    exportgraphics(f4, sprintf('%s_r_body.pdf',fig_prefix), 'ContentType', 'vector'); 
end
