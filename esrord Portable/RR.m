function varargout = RR(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RR_OpeningFcn, ...
                   'gui_OutputFcn',  @RR_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RR is made visible.
function RR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RR (see VARARGIN)

% Choose default command line output for RR
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = RR_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;



function numbertaskk_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function numbertaskk_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

msgbox('Now open the MATLAB command window. You will find input fields for the transactions. Fill them in to display the tasks interface.', ...
                'Méthode', 'help');
msgbox('Ouvrez maintenant la fenêtre de commandes de MATLAB. Vous y trouverez des champs de saisie pour les paramètres. Remplissez-les pour afficher linterface de Task.', ...
                'Méthode', 'help');
n =str2double(get(handles.numbertaskk,'String'));
% ===== Input number of tasks =====
while n <= 0 || mod(n,1) ~= 0
    n = input('Please enter a positive integer for number of tasks: ');
end

% ===== Input task data =====
tasks = zeros(n, 5); % [arrival_time, burst_time, deadline, period, task_id]
period_values = zeros(n, 1); % All tasks will have periods

fprintf('\n=== Input Task Details ===\n');
for i = 1:n
    fprintf('\nTask %d:\n', i);
    arrival_time = input('  Initial arrival time: ');
    burst_time = input('  Burst time: ');
    deadline = input('  Deadline: ');
    
    % ALL tasks will be periodic - ask for period for ALL tasks
    period = input('  Enter period (repetition interval): ');
    while period <= 0
        period = input('  Please enter positive period value: ');
    end
    
    % Store task with period (all tasks are periodic)
    period_values(i) = period;
    tasks(i, :) = [arrival_time, burst_time, deadline, period, i];
end

% ===== Input quantum time for RR =====
quantum = input('\nEnter quantum time for Round Robin: ');
while quantum <= 0
    quantum = input('Please enter positive value for quantum time: ');
end

% ===== Calculate hyperperiod H as LCM of all periods =====
% Calculate LCM of all periods
H = period_values(1);
for i = 2:length(period_values)
    H = lcm(H, period_values(i));
end

fprintf('\nHyperperiod H (LCM of all periods) = %d\n', H);

% Also ensure H is at least as large as the maximum deadline
max_deadline = max(tasks(:,3));
if H < max_deadline
    % Extend H to cover the maximum deadline
    H = max_deadline;
    fprintf('Adjusted hyperperiod to cover maximum deadline: %d\n', H);
end

% ===== Generate ALL periodic task instances =====
all_tasks = [];
for i = 1:n
    period = tasks(i,4);
    % Calculate number of repetitions within hyperperiod
    repetitions = floor(H / period);
    
    for rep = 0:repetitions
        arrival_time = tasks(i,1) + rep * period;
        if arrival_time <= H
            deadline = arrival_time + tasks(i,3); % Relative deadline
            
            % Create task instance
            task_copy = [arrival_time, tasks(i,2), deadline, period, i, rep+1];
            all_tasks = [all_tasks; task_copy];
        end
    end
end

% Sort tasks by arrival time
all_tasks = sortrows(all_tasks, 1);

% ===== Display generated periodic tasks =====
fprintf('\n=== Generated Periodic Task Instances (Hyperperiod = %d) ===\n', H);
fprintf('%-10s %-10s %-12s %-12s %-12s %-10s %-10s\n', ...
    'Task ID', 'Instance', 'Arrival', 'Burst', 'Deadline', 'Period', 'Period End');
fprintf('%-10s %-10s %-12s %-12s %-12s %-10s %-10s\n', ...
    '-------', '--------', '-------', '-----', '--------', '------', '----------');

for i = 1:size(all_tasks, 1)
    task_id = all_tasks(i,5);
    instance = all_tasks(i,6);
    arrival = all_tasks(i,1);
    burst = all_tasks(i,2);
    deadline = all_tasks(i,3);
    period = all_tasks(i,4);
    
    period_str = sprintf('%.1f', period);
    period_end = sprintf('%.1f', arrival + period);
    
    fprintf('%-10d %-10d %-12.1f %-12.1f %-12.1f %-10s %-10s\n', ...
        task_id, instance, arrival, burst, deadline, period_str, period_end);
end

% ===== RR Scheduling Simulation =====
fprintf('\n=== Starting RR Simulation ===\n');

% Initialize simulation variables
time = 0;
order = []; % To store [start_time, end_time, task_id, instance]
queue = [];
current_task = -1;
task_start_time = 0;
task_index = 1;
total_tasks = size(all_tasks, 1);

% Create copies of remaining time
remaining_time_all = all_tasks(:, 2);
completed_all = false(total_tasks, 1);
arrival_times_all = all_tasks(:, 1);

% Main simulation loop
simulation_active = true;
while simulation_active && time <= H*2  % Allow some extra time
    
    % Add tasks that have arrived to queue
    while task_index <= total_tasks && arrival_times_all(task_index) <= time
        if ~completed_all(task_index) && remaining_time_all(task_index) > 0
            queue(end + 1) = task_index;
        end
        task_index = task_index + 1;
    end
    
    % If queue is empty, advance time or end simulation
    if isempty(queue)
        if time >= H && all(completed_all)
            simulation_active = false;
            break;
        elseif time >= H
            % Force completion of remaining tasks
            for i = 1:total_tasks
                if ~completed_all(i) && remaining_time_all(i) > 0
                    queue(end + 1) = i;
                end
            end
            if isempty(queue)
                simulation_active = false;
                break;
            end
        else
            time = time + 1;
            continue;
        end
    end
    
    % Select next task from queue
    if current_task == -1 || remaining_time_all(current_task) == 0
        % Mark current task as completed if it exists
        if current_task ~= -1 && remaining_time_all(current_task) == 0
            completed_all(current_task) = true;
        end
        
        % Select new task (FIFO)
        current_task = queue(1);
        queue(1) = [];
        task_start_time = time;
    end
    
    % Calculate execution time
    exec_time = min([quantum, remaining_time_all(current_task)]);
    
    if exec_time > 0
        time = time + exec_time;
        remaining_time_all(current_task) = remaining_time_all(current_task) - exec_time;
        
        % Record execution period
        original_task_id = all_tasks(current_task, 5);
        instance_num = all_tasks(current_task, 6);
        order(end + 1, :) = [task_start_time, time, original_task_id, instance_num];
        
        % Check for new arrivals during execution
        while task_index <= total_tasks && arrival_times_all(task_index) <= time
            if ~completed_all(task_index) && remaining_time_all(task_index) > 0
                queue(end + 1) = task_index;
            end
            task_index = task_index + 1;
        end
    end
    
    % Check if task completed
    if remaining_time_all(current_task) == 0
        completed_all(current_task) = true;
        current_task = -1;
    else
        % Move to end of queue if not completed
        task_start_time = time;
        queue(end + 1) = current_task;
        current_task = -1;
    end
    
    % Check if simulation should end
    if time >= H && all(completed_all)
        simulation_active = false;
    end
    
    % Safety check: prevent infinite loop
    if time > H * 3
        fprintf('Warning: Simulation time exceeded 3*H. Forcing termination.\n');
        break;
    end
end

% Ensure order is not empty
if isempty(order)
    fprintf('\nNo tasks were scheduled during simulation time!\n');
    return;
end

% ===== Setup colors for tasks =====
colors = hsv(n);

% ===== Create Figure 1: Gantt Chart and Timeline =====
figure('Position', [100, 100, 1200, 900], 'Name', 'RR Scheduling Results', 'NumberTitle', 'off');

% ==== SUBPLOT 1: Gantt Chart ====
subplot(3,1,1);
hold on;
box on;

% Draw Gantt chart bars with instance numbers
for k = 1:size(order,1)
    t0 = order(k,1);
    t1 = order(k,2);
    task = order(k,3);
    instance = order(k,4);
    
    % Draw time bar
    plot([t0 t1], [task task], 'LineWidth', 20, 'Color', colors(task,:));
    
    % Add text with instance number
    mid_time = (t0 + t1) / 2;
    text(mid_time, task, sprintf('T%d', task), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle', ...
        'FontWeight', 'bold', ...
        'Color', 'white', ...
        'FontSize', 9);
    
    % Add small instance number
    text(mid_time, task+0.15, sprintf('(%d)', instance), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 7, ...
        'Color', 'yellow');
end

% Add period boundaries
for i = 1:size(all_tasks, 1)
    task_id = all_tasks(i,5);
    arrival = all_tasks(i,1);
    period = all_tasks(i,4);
    
    % Draw period boundaries
    period_end = arrival + period;
    if period_end <= H
        plot([period_end period_end], [task_id-0.4 task_id+0.4], ...
            '--b', 'LineWidth', 1);
    end
end

% Add deadline markers
deadline_missed = 0;
for i = 1:size(all_tasks, 1)
    task_id = all_tasks(i,5);
    instance = all_tasks(i,6);
    deadline = all_tasks(i,3);
    
    if deadline <= H
        % Find finish time for this instance
        instance_exec = order(order(:,3) == task_id & order(:,4) == instance, :);
        if ~isempty(instance_exec)
            finish_time = max(instance_exec(:,2));
            
            if finish_time > deadline
                % Deadline missed
                plot([deadline deadline], [task_id-0.3 task_id+0.3], ...
                    '--r', 'LineWidth', 2);
                deadline_missed = deadline_missed + 1;
            else
                % Deadline met
                plot([deadline deadline], [task_id-0.2 task_id+0.2], ...
                    '--g', 'LineWidth', 1);
            end
        end
    end
end

% Configure plot
xlabel('Time Units');
ylabel('Task ID');
title(sprintf('RR Scheduling - Gantt Chart (Quantum = %.1f, Hyperperiod = %d)', quantum, H));
grid on;
ylim([0.5 n+0.5]);
xlim([0 H]);

set(gca, 'YTick', 1:n);
set(gca, 'YDir', 'reverse');
set(gca, 'FontSize', 10);

% Create legend
legend_str = cell(1, n);
for i = 1:n
    legend_str{i} = sprintf('Task %d (P=%d, BT=%.1f, D=%.1f)', ...
        i, tasks(i,4), tasks(i,2), tasks(i,3));
end
legend([legend_str, {'Period End', 'Deadline Met', 'Deadline Missed'}], ...
    'Location', 'eastoutside');

% ==== SUBPLOT 2: Execution Order Timeline ====
subplot(3,1,3);
hold on;
box on;

exe_order = order(:,3)';
steps = 1:length(exe_order);

% Plot timeline
plot(steps, exe_order, '-o', 'LineWidth', 1.5, ...
    'MarkerSize', 6, 'MarkerFaceColor', 'b', 'Color', 'b');

% Configure plot
xlabel('Execution Step');
ylabel('Task ID');
title('Task Execution Timeline');
grid on;

if ~isempty(steps)
    xlim([1 max(steps)]);
else
    xlim([0 10]);
end

ylim([0.5 n+0.5]);
set(gca, 'YTick', 1:n);
set(gca, 'FontSize', 10);

% ===== Display Results Table =====
fprintf('\n=== Scheduling Results (Hyperperiod = %d) ===\n', H);
fprintf('%-10s %-10s %-12s %-12s %-15s %-12s\n', ...
    'Task ID', 'Instance', 'Arrival', 'Finish', 'Deadline', 'Met?');
fprintf('%-10s %-10s %-12s %-12s %-15s %-12s\n', ...
    '-------', '--------', '-------', '------', '--------', '-----');

deadline_stats = zeros(n, 1);
deadline_stats_total = zeros(n, 1);

% Collect statistics for each task
for i = 1:size(all_tasks, 1)
    task_id = all_tasks(i,5);
    instance = all_tasks(i,6);
    arrival_time = all_tasks(i,1);
    deadline = all_tasks(i,3);
    
    % Find finish time for this task instance
    task_executions = order(order(:,3) == task_id & order(:,4) == instance, :);
    if ~isempty(task_executions)
        finish_time = max(task_executions(:,2));
        deadline_met = finish_time <= deadline;
        
        % Update statistics
        deadline_stats_total(task_id) = deadline_stats_total(task_id) + 1;
        if deadline_met
            deadline_stats(task_id) = deadline_stats(task_id) + 1;
        end
        
        status = 'Yes';
        if ~deadline_met
            status = 'No';
        end
        
        fprintf('%-10d %-10d %-12.1f %-12.1f %-15.1f %-12s\n', ...
            task_id, instance, arrival_time, finish_time, deadline, status);
    end
end

% ===== Calculate and Display Statistics =====
fprintf('\n=== Final Statistics ===\n');
fprintf('Hyperperiod H (LCM of periods): %d\n', H);
fprintf('Number of task instances: %d\n', size(all_tasks, 1));
fprintf('Number of execution steps: %d\n', size(order,1));
if size(order,1) > 0
    segment_lengths = order(:,2) - order(:,1);
end

fprintf('Instances with missed deadlines: %d/%d (%.1f%%)\n', ...
    deadline_missed, size(all_tasks,1), (deadline_missed/size(all_tasks,1))*100);

fprintf('\n=== Deadline Compliance Rate ===\n');
for task_id = 1:n
    if deadline_stats_total(task_id) > 0
        met = deadline_stats(task_id);
        total = deadline_stats_total(task_id);
        percentage = (met / total) * 100;
        fprintf('Task %d: %d/%d instances (%.1f%%)\n', task_id, met, total, percentage);
    end
end


% Calculate total utilization
fprintf('\n=== Simulation Complete ===\n');
fprintf('All tasks are periodic with automatic repetition at period end.\n');
fprintf('Hyperperiod H = LCM of all periods = %d\n', H);
