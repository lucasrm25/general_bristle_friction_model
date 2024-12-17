%% Shows the simulation of the 2d general bristle model
clearvars; 

model = 'general_bristle_model_2d';
addpath('general_bristle_model_2d')

save_figs = true;
fig_prefix = fullfile('experiment_11_2d','experiment_11_2d');

%% Set Parameters
dot_rt = [ 
    % time, vx  vy
    0,      0,  0;
    1,      0,  0;
    1.1,    1,  1;
    3,      1,  -1;
    3.1,    0,  0;
];

% friction parameters
k_1 = 10;
d_1 = 0;
k_2 = 10;
d_2 = 0;
m_b = 0.01;
F_g = diag([1.2, 1]);
F_h = diag([1.5, 1.2]);
v_minslip = 1e-3;
lambda_flag = 1;

% solver settings
t_end = 4;
t_step = 0.001;


%% Simulate

out_sim = sim(model);


%% Plot

ell_F_h = ellipse2d(F_h)';
ell_F_g = ellipse2d(F_g)';
f_mu = out_sim.simlog.Dynamic_Friction.f.series.values;
stick = out_sim.simlog.Dynamic_Friction.stick.series.values;


figure(); hold on; grid on; axis equal;
% plot(f_mu(:,1), f_mu(:,2));
plot(ell_F_h(:,1), ell_F_h(:,2))
plot(ell_F_g(:,1), ell_F_g(:,2))
patch( ...
    [f_mu(:,1);NaN], [f_mu(:,2);NaN], [2-stick;NaN], ...
    EdgeColor='flat',Marker='.',LineWidth=1, MarkerSize=1 ...
);
colormap([0,0,0; 1,0,0]);

