%% Shows the simulation of the 2d general bristle model
clearvars; close all;

model = 'general_bristle_model_2d';
addpath('general_bristle_model_2d')

color_slip = [0 128 255]/255;
color_stick = [0 0 0]/255;

color_stick_x = [51 0 102]*2/255;
color_slip_x = [0 0 0]/255;

color_stick_y = [0 0 153]/255;
color_slip_y = [150 150 150]/255;

color_r_t_x = [0 0 0]/255;
color_r_t_y = [150 150 150]/255;

linewidth = 1;

save_figs = false;
fig_prefix = fullfile('experiment_05_2d_properties','experiment_05_2d_properties');

%% Set Parameters
dot_rt = [ 
    % time, vx  vy
    0,      0,  0;
    1,      0,  0;
    1.1,   1,  1;
    3,      1,  -1;
    3.1,   0,  0;
];

dot_rt = [ 
    % time, vx  vy
    0,      0,  0;
    (1:0.01:3)', 2*sigmf(1:0.01:3, [25,1.2])',  -1*sin(1/2*2*pi*(1:0.01:3))';
    4, 2, 0
    4.001, 0, 0
];
figure('Position',[1.2114e+03 1.3242e+03 560 420]);hold on; plot(dot_rt(:,1),dot_rt(:,2)); plot(dot_rt(:,1),dot_rt(:,3))

% friction parameters
k = 10 * eye(2);
d = 0 * eye(2);
k_m = 15 * eye(2);
d_m = 20 * eye(2);

m_b = 0.0;

F_g = diag([1.2, 1]);
F_h = diag([1.5, 1.2]);
v_minslip = 1e-3;

lambda_flag = 1;

% solver settings
t_end = 7;
t_step = 0.001;


%% Simulate
out_sim = sim(model);

%% Get Data
ell_F_h = ellipse2d(F_h)';
ell_F_g = ellipse2d(F_g)';
f_mu = out_sim.simlog.Dynamic_Friction.f.series.values;
stick = out_sim.simlog.Dynamic_Friction.stick.series.values;
lambda = out_sim.simlog.Dynamic_Friction.lambda.series.values;
r_b  = out_sim.simlog.Bristle_Mass.v.series.values;
r_t = out_sim.simlog.velocity_input.v.series.values;
time = out_sim.simlog.velocity_input.v.series.time;

%% Detection of Stick-Slip
switches = 0;
switchposition = [1];
time_stick = time(stick == 1);
time_slip  = time(stick == 0);

for i=1:length(time_stick)-1
    if time_stick(i+1)-time_stick(i)>1.5*t_step
        switches = switches+1;
        switchposition(end + 1) = [i];
    end
end

if time_stick(end)>time_slip(end)
    switches = switches+1;
    switchposition(end+1) = switchposition(end) + length(time_slip);
end

switchposition(end+1) = length(time);

%% Plot of forces
fig = figure('Position',[395.4000  463.4000  304.8000  130.6000],'Color','white'); hold on; grid on; %axis equal;
hold on
for i=1:switches+1
    if mod(i,2)==1
        plot(time(switchposition(i):switchposition(i+1)),f_mu(switchposition(i):switchposition(i+1),1),'Color',color_slip_x, 'LineWidth', linewidth, 'LineStyle', '--')
        plot(time(switchposition(i):switchposition(i+1)),f_mu(switchposition(i):switchposition(i+1),2),'Color',color_slip_y, 'LineWidth', linewidth, 'LineStyle', '--')
    else
        plot(time(switchposition(i):switchposition(i+1)),f_mu(switchposition(i):switchposition(i+1),1),'Color',color_slip_x, 'LineWidth', linewidth)
        plot(time(switchposition(i):switchposition(i+1)),f_mu(switchposition(i):switchposition(i+1),2),'Color',color_slip_y, 'LineWidth', linewidth)
    end
end

xlim([0 7])
ylim([-0.5 1.5])
xlabel('Time $[s]$', 'Interpreter','latex');
ylabel('$f_\mu$ $[N]$', 'Interpreter','latex');

if save_figs
    savefig(sprintf('%s_f_mue.fig',fig_prefix));
    exportgraphics(fig, sprintf('%s_f_mue.pdf',fig_prefix), 'ContentType', 'vector'); 
end

%% Plot Velocities
fig = figure('Position',[395.4000  463.4000  304.8000  80.6000],'Color','white'); hold on; grid on; %axis equal;
hold on

plot(time,r_t(:,1), 'LineStyle','-', 'Color',color_r_t_x, 'DisplayName', '$\dot r_{t,x}$', 'LineWidth', linewidth)
plot(time,r_t(:,2), 'LineStyle','-', 'Color',color_r_t_y, 'DisplayName', '$\dot r_{t,y}$', 'LineWidth', linewidth)

l=legend('Location',[0.742590614911195 0.583250844722535 0.144176889666196 0.34084156451839],'Orientation','horizontal', 'NumColumns',1, 'Interpreter','latex');
l.ItemTokenSize = [15, 10];

xlim([0 7])
ylim([-1 2])
xlabel('Time $[s]$', 'Interpreter','latex');
ylabel('$\dot r_{t}$ $[m/s]$', 'Interpreter','latex');

if save_figs
    savefig(sprintf('%s_dr.fig',fig_prefix));
    exportgraphics(fig, sprintf('%s_dr.pdf',fig_prefix), 'ContentType', 'vector'); 
end

%% Plot of lambda
fig = figure('Position',[395.4000  463.4000  304.8000  80.6000],'Color','white'); hold on; grid on; %axis equal;
hold on
for i=1:switches+1
    if mod(i,2)==1
        p1=plot(time(switchposition(i):switchposition(i+1)),lambda(switchposition(i):switchposition(i+1),1),'Color',color_stick, 'LineWidth', linewidth, 'DisplayName', 'Stick');
    else
        p2=plot(time(switchposition(i):switchposition(i+1)),lambda(switchposition(i):switchposition(i+1),1),'Color',color_slip, 'LineWidth', linewidth, 'DisplayName', 'Slip');
    end
end

xlim([0 7])
ylim([0 1.2])
xlabel('Time $[s]$', 'Interpreter','latex');
ylabel('$\lambda$ $[1]$', 'Interpreter','latex');

l=legend([p1,p2],'Location',[0.742590614911195 0.583250844722535 0.144176889666196 0.34084156451839],'Orientation','horizontal', 'NumColumns',1);
l.ItemTokenSize = [15, 10];

if save_figs
    savefig(sprintf('%s_lambda.fig',fig_prefix));
    exportgraphics(fig, sprintf('%s_lambda.pdf',fig_prefix), 'ContentType', 'vector'); 
end

%% Plot Ellipse
fig = figure('Position',[865.8000 546.6000 281.6000 150.8000],'Color','white'); ax=gca; hold on; grid on; %axis equal;

plot(ell_F_h(:,1), ell_F_h(:,2), 'LineStyle','--', 'Color', color_stick)
plot(ell_F_g(:,1), ell_F_g(:,2), 'LineStyle','--', 'Color', color_slip)

for i=1:switches+1
    if mod(i,2)==1
        p1 = plot(f_mu(switchposition(i):switchposition(i+1),1),f_mu(switchposition(i):switchposition(i+1),2),'Color',color_stick, 'LineWidth', linewidth, 'DisplayName', 'Stick');
    else
        p2 = plot(f_mu(switchposition(i):switchposition(i+1),1),f_mu(switchposition(i):switchposition(i+1),2),'Color',color_slip, 'LineWidth', linewidth, 'DisplayName', 'Slip');
    end
end

l=legend([p1,p2],'Location',[0.146924047009296 0.238732293664616 0.18830322571798 0.191666667499239],'Orientation','horizontal', 'NumColumns',1);
l.ItemTokenSize = [15, 10];

xlim([-1.7 1.7])
ylim([-1.5 1.5])
colormap([color_stick; color_slip]);
xlabel('$f_{\mu,x}$ $[N]$', 'Interpreter','latex');
ylabel('$f_{\mu,y}$ $[N]$', 'Interpreter','latex');
text(ax,-1.40197216117216, 0.297811111111111,'$F_g$','interpreter','latex', 'Color',color_slip,'FontSize',10)
text(ax,-1.56566373626374, 0.709611111111111,'$F_h$','interpreter','latex', 'Color',color_stick,'FontSize',10)

if save_figs
    savefig(sprintf('%s_f_mue_ellipse.fig',fig_prefix));
    exportgraphics(fig, sprintf('%s_f_mue_ellipse.pdf',fig_prefix), 'ContentType', 'vector'); 
end

%% Legend Force
fig = figure('Color','white', 'Position',[865.8000 546.60006    1.0e+03 *0.2816    1.0e+03 *0.0348]); hold on; grid on;

p1=plot([0,1], [NaN,NaN], 'DisplayName', '$f_{\mu,x}$:', 'Color', [255 255 255]/255, 'LineWidth', linewidth);
p2=plot([0,1], [NaN,NaN], 'DisplayName', '$f_{\mu,y}$:', 'Color', [255 255 255]/255, 'LineWidth', linewidth);
p3=plot([0,1], [NaN,NaN], 'DisplayName', 'Stick', 'Color', color_slip_x, 'LineWidth', linewidth, 'LineStyle','--');
p4=plot([0,1], [NaN,NaN], 'DisplayName', 'Stick', 'Color', color_slip_y, 'LineWidth', linewidth, 'LineStyle','--');
p5=plot([0,1], [NaN,NaN], 'DisplayName', 'Slip', 'Color', color_slip_x, 'LineWidth', linewidth);
p6=plot([0,1], [NaN,NaN], 'DisplayName', 'Slip', 'Color', color_slip_y, 'LineWidth', linewidth);
xlabel('Time [s]', 'Interpreter','latex')
ylabel('$f_{t}$ [N]', 'Interpreter','latex')
l = legend([p1,p3,p5,p2,p4,p6],'Location','southeast','Orientation','horizontal', 'NumColumns',3, 'Interpreter','latex');
l.ItemTokenSize = [30, 10];
set(l,'Position',[0.0340909090909091 0.0459752873563236 0.926858072099788 0.894878659788552]);
axis off
if save_figs
    savefig(sprintf('%s_legend_f_mue.fig',fig_prefix));
    exportgraphics(fig, sprintf('%s_legend_f_mue.pdf',fig_prefix), 'ContentType', 'vector'); 
end