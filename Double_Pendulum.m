%  DOUBLE PENDULUM SIMULATION

clear; clc; close all;

% Physical Parameters
m1 = 1.0;  m2 = 1.0;
L1 = 1.0;  L2 = 1.0;
g  = 9.81;

t_end    = 30;
dt_plot  = 0.02;
trailLen = 200;
SPEED    = 0.40;

BG   = [0.08 0.08 0.12];
DARK = [0.05 0.05 0.10];

LBL_CLR = [0.85 0.85 0.92];
BOX_BG  = [0.14 0.14 0.20];
BOX_FG  = [0.90 0.92 1.00];

% Figure
fig = figure('Name','Double Pendulum Simulation', ...
             'Color',BG,'Units','normalized', ...
             'OuterPosition',[0.04 0.04 0.92 0.92],'Resize','on');

% Title
annotation(fig,'rectangle',[0 0.91 1 0.09], ...
           'FaceColor',[0.10 0.10 0.16],'EdgeColor',[0.22 0.22 0.32]);
uicontrol(fig,'Style','text','String','Double Pendulum Simulator', ...
          'Units','normalized','Position',[0.15 0.922 0.70 0.056], ...
          'BackgroundColor',[0.10 0.10 0.16], ...
          'ForegroundColor',[0.55 0.78 1.00], ...
          'FontSize',20,'FontWeight','bold','HorizontalAlignment','center');

% Animation axes
axAnim = axes(fig,'Position',[0.03 0.36 0.35 0.52]);
set(axAnim,'Color',DARK,'XColor',[0.6 0.6 0.7],'YColor',[0.6 0.6 0.7], ...
           'GridColor',[0.22 0.22 0.28],'GridAlpha',0.6,'FontSize',9);
hold(axAnim,'on'); grid(axAnim,'on'); axis(axAnim,'equal');
lim = L1+L2+0.2;
xlim(axAnim,[-lim lim]); ylim(axAnim,[-lim-0.1 lim*0.55]);
title(axAnim,'Animation','Color',[0.92 0.92 0.95],'FontSize',11,'FontWeight','bold');
xlabel(axAnim,'x  [m]','Color',[0.7 0.7 0.8],'FontSize',9);
ylabel(axAnim,'y  [m]','Color',[0.7 0.7 0.8],'FontSize',9);

% Input Boxes
annotation(fig,'rectangle',[0.02 0.04 0.35 0.28], ...
           'FaceColor',[0.10 0.10 0.16],'EdgeColor',[0.22 0.22 0.32]);

% θ1
uicontrol(fig,'Style','text','String','θ₁  from vertical (°):', ...
          'Units','normalized','Position',[0.03 0.235 0.17 0.032], ...
          'BackgroundColor',[0.10 0.10 0.16],'ForegroundColor',LBL_CLR, ...
          'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');
hEdit1 = uicontrol(fig,'Style','edit','String','120', ...
          'Units','normalized','Position',[0.21 0.232 0.08 0.038], ...
          'BackgroundColor',BOX_BG,'ForegroundColor',BOX_FG, ...
          'FontSize',12,'FontWeight','bold');

% θ2
uicontrol(fig,'Style','text','String','θ₂  rel. to rod 1 (°):', ...
          'Units','normalized','Position',[0.03 0.175 0.17 0.032], ...
          'BackgroundColor',[0.10 0.10 0.16],'ForegroundColor',LBL_CLR, ...
          'FontSize',10,'FontWeight','bold','HorizontalAlignment','left');
hEdit2 = uicontrol(fig,'Style','edit','String','30', ...
          'Units','normalized','Position',[0.21 0.172 0.08 0.038], ...
          'BackgroundColor',BOX_BG,'ForegroundColor',BOX_FG, ...
          'FontSize',12,'FontWeight','bold');

% Start button
hBtn = uicontrol(fig,'Style','pushbutton','String','▶  START', ...
          'Units','normalized','Position',[0.03 0.100 0.12 0.055], ...
          'BackgroundColor',[0.18 0.52 0.22],'ForegroundColor',[0.92 1.00 0.92], ...
          'FontSize',12,'FontWeight','bold','UserData',0);
set(hBtn,'Callback',@(~,~) set(hBtn,'UserData',1));

% Plot
axPlot = axes(fig,'Position',[0.41 0.07 0.57 0.81]);
set(axPlot,'Color',DARK,'XColor',[0.6 0.6 0.7],'YColor',[0.6 0.6 0.7], ...
           'GridColor',[0.22 0.22 0.28],'GridAlpha',0.6,'FontSize',11);
hold(axPlot,'on'); grid(axPlot,'on');
ylim(axPlot,'auto');
xlim(axPlot,[0 t_end]);
xlabel(axPlot,'Time  [s]','Color',[0.7 0.7 0.8],'FontSize',11);
ylabel(axPlot,'Angle  [deg]','Color',[0.7 0.7 0.8],'FontSize',11);

hLine1 = plot(axPlot,nan,nan,'-','Color',[0.20 0.60 1.00],'LineWidth',2.0);
hLine2 = plot(axPlot,nan,nan,'-','Color',[1.00 0.42 0.30],'LineWidth',2.0);
hLeg   = legend(axPlot,{'\theta_1  (abs, from vertical)', ...
                        '\theta_2  (rel, to rod 1)'}, ...
                        'TextColor',[0.85 0.85 0.90],'Color',[0.10 0.10 0.16], ...
                        'EdgeColor',[0.32 0.32 0.45],'Location','northwest','FontSize',12);

% Pendulum Animation
for xi = -lim:0.22:lim
    plot(axAnim,[xi xi+0.16],[0 0.16],'-','Color',[0.32 0.32 0.40],'LineWidth',0.8);
end
plot(axAnim,[-lim lim],[0 0],'-','Color',[0.50 0.50 0.58],'LineWidth',1.8);
plot(axAnim,0,0,'o','MarkerSize',9,'MarkerFaceColor',[0.85 0.85 0.90], ...
     'MarkerEdgeColor','w','LineWidth',1.5);
plot(axAnim,[0 0],[0 -lim],'--','Color',[0.40 0.40 0.50],'LineWidth',0.8);

% Trails
trailX1=nan(1,trailLen); trailY1=nan(1,trailLen);
trailX2=nan(1,trailLen); trailY2=nan(1,trailLen);
hTrail1=plot(axAnim,trailX1,trailY1,'-','Color',[0.20 0.60 1.00 0.38],'LineWidth',1.1);
hTrail2=plot(axAnim,trailX2,trailY2,'-','Color',[1.00 0.42 0.30 0.38],'LineWidth',1.1);

% Rods
hRod1=plot(axAnim,[0 0],[0 0],'-','Color',[0.78 0.80 0.90],'LineWidth',2.8);
hRod2=plot(axAnim,[0 0],[0 0],'-','Color',[0.78 0.80 0.90],'LineWidth',2.8);

% Bobs
hBob1=plot(axAnim,0,0,'o','MarkerSize',19, ...
           'MarkerFaceColor',[0.20 0.60 1.00],'MarkerEdgeColor',[0.70 0.88 1.00],'LineWidth',1.5);
hBob2=plot(axAnim,0,0,'o','MarkerSize',19, ...
           'MarkerFaceColor',[1.00 0.42 0.30],'MarkerEdgeColor',[1.00 0.75 0.65],'LineWidth',1.5);

hTime   = text(axAnim,-lim+0.07,lim*0.48,'t = 0.00 s', ...
               'Color',[0.85 0.85 0.92],'FontSize',10,'FontWeight','bold');

opts = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Re-run Function
while ishandle(fig)

    % Reset Button to Ready state
    set(hBtn,'String','▶  START','BackgroundColor',[0.18 0.52 0.22], ...
             'ForegroundColor',[0.92 1.00 0.92],'UserData',0,'Enable','on');
    set([hEdit1 hEdit2],'Enable','on');

    while ishandle(fig) && get(hBtn,'UserData') == 0
        drawnow; pause(0.05);
    end
    if ~ishandle(fig), break; end

    % Read Initial Conditions
    theta1_0_deg   = mod(str2double(get(hEdit1,'String')), 360);
    theta2_rel_deg = mod(str2double(get(hEdit2,'String')), 360);

    if isnan(theta1_0_deg) || isnan(theta2_rel_deg)
        errordlg('Please enter valid numeric angles.','Input Error');
        continue;
    end

    % θ2 absolute = θ1 + θ2_relative
    theta2_0_deg = mod(theta1_0_deg + theta2_rel_deg, 360);

    fprintf('\nInitial conditions:\n');
    fprintf('  θ₁         = %.1f°  (rod 1 from vertical)\n',  theta1_0_deg);
    fprintf('  θ₂ rel      = %.1f°  (rod 2 relative to rod 1)\n', theta2_rel_deg);
    fprintf('  θ₂ absolute = %.1f°  (rod 2 from vertical)\n',  theta2_0_deg);

    y0 = [deg2rad(theta1_0_deg); 0; deg2rad(theta2_0_deg); 0];

    % Update Legend
    set(hLeg,'String',{ ...
        sprintf('\\theta_1  (abs, start: %.0f°)', theta1_0_deg), ...
        sprintf('\\theta_2  (rel, start: %.0f°)', theta2_rel_deg)});

    % Disable controls and show running state
    set([hEdit1 hEdit2 hBtn],'Enable','off');
    set(hBtn,'String','● RUNNING','BackgroundColor',[0.45 0.18 0.18]);

    % Reset animation & plot for new run
    trailX1=nan(1,trailLen); trailY1=nan(1,trailLen);
    trailX2=nan(1,trailLen); trailY2=nan(1,trailLen);
    set(hTrail1,'XData',trailX1,'YData',trailY1);
    set(hTrail2,'XData',trailX2,'YData',trailY2);
    set(hRod1,'XData',[0 0],'YData',[0 0]);
    set(hRod2,'XData',[0 0],'YData',[0 0]);
    set(hBob1,'XData',0,'YData',0);
    set(hBob2,'XData',0,'YData',0);
    set(hLine1,'XData',nan,'YData',nan);
    set(hLine2,'XData',nan,'YData',nan);
    set(hTime,'String','t = 0.00 s');
    xlim(axPlot,[0 t_end]);
    ylim(axPlot,'auto');
    drawnow;

    % Simulation loop
    tData=[]; th1Data=[]; th2Data=[];
    t_now=0;  y_now=y0;

    while t_now < t_end && ishandle(fig)

        t_next = min(t_now + dt_plot, t_end);

        [tChunk, yChunk] = ode45(@(t,y) dpEOM(t,y,m1,m2,L1,L2,g), ...
                                  [t_now, t_next], y_now, opts);

        % θ1 absolute
        th1_disp = rad2deg(yChunk(2:end,1));
        % θ2 relative to θ1
        th2_disp = rad2deg(yChunk(2:end,3) - yChunk(2:end,1));

        tData   = [tData;   tChunk(2:end)];   %#ok<AGROW>
        th1Data = [th1Data; th1_disp];        %#ok<AGROW>
        th2Data = [th2Data; th2_disp];        %#ok<AGROW>

        th1=yChunk(end,1); th2=yChunk(end,3);
        x1= L1*sin(th1);   y1=-L1*cos(th1);
        x2= x1+L2*sin(th2);y2= y1-L2*cos(th2);

        trailX1=[trailX1(2:end),x1]; trailY1=[trailY1(2:end),y1];
        trailX2=[trailX2(2:end),x2]; trailY2=[trailY2(2:end),y2];

        set(hRod1,  'XData',[0,x1], 'YData',[0,y1]);
        set(hRod2,  'XData',[x1,x2],'YData',[y1,y2]);
        set(hBob1,  'XData',x1,     'YData',y1);
        set(hBob2,  'XData',x2,     'YData',y2);
        set(hTrail1,'XData',trailX1,'YData',trailY1);
        set(hTrail2,'XData',trailX2,'YData',trailY2);
        set(hTime,  'String',sprintf('t = %.2f s',t_next));

        set(hLine1,'XData',tData,'YData',th1Data);
        set(hLine2,'XData',tData,'YData',th2Data);
        ylim(axPlot,'auto');

        pause(dt_plot / SPEED - dt_plot);
        drawnow;

        t_now=t_next;
        y_now=yChunk(end,:)';
    end

    % Run Complete
    if ishandle(fig)
        set(hBtn,'String','▶  RUN AGAIN','BackgroundColor',[0.18 0.35 0.52], ...
                 'ForegroundColor',[0.85 0.92 1.00],'UserData',0,'Enable','on');
        set([hEdit1 hEdit2],'Enable','on');
        fprintf('Simulation complete.\n');
    end

end % Restart the Outer Loop

% EOM and solving the Lagrangian
function dydt = dpEOM(~,y,m1,m2,L1,L2,g)
    th1=y(1); w1=y(2); th2=y(3); w2=y(4);
    d=th1-th2; sd=sin(d); cd=cos(d);

    A11=(m1+m2)*L1^2; A12=m2*L1*L2*cd;
    A21=A12;           A22=m2*L2^2;

    b1=-m2*L1*L2*w2^2*sd-(m1+m2)*g*L1*sin(th1);
    b2= m2*L1*L2*w1^2*sd-m2*g*L2*sin(th2);

    detA=A11*A22-A12*A21;
    dydt=[w1;(A22*b1-A12*b2)/detA; w2;(A11*b2-A21*b1)/detA];
end