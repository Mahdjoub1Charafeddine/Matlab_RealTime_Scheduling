function varargout = untitled1(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function numbertash_Callback(hObject, eventdata, handles)
% hObject    handle to numbertash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numbertash as text
%        str2double(get(hObject,'String')) returns contents of numbertash as a double


% --- Executes during object creation, after setting all properties.
function numbertash_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numbertash (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
msgbox('Ouvrez maintenant la fenêtre de commandes de MATLAB. Vous y trouverez des champs de saisie pour les paramètres. Remplissez-les pour afficher linterface de Task.', ...
                'Méthode', 'help');
msgbox('Now open the MATLAB command window. You will find input fields for the transactions. Fill them in to display the tasks interface.', ...
                'Méthode', 'help');
% number task
n =str2double(get(handles.numbertash,'String'));
while n <= 0 || mod(n,1) ~= 0
    n = input('Please enter a positive integer for number of tasks: ');
end
%% ====================================================
%% Rate Monotonic (RM) Scheduling for Periodic Tasks
%% ====================================================
%% 1. Task Data Input
disp('========================================');
disp('     Rate Monotonic (RM) Scheduling System     ');
disp('========================================');

r0 = zeros(1, n);    % date de réveil de la tâche
C = zeros(1, n);     % Cmax: durée d’exécution maximale définie avec les restrictions exposées précédemment
D = zeros(1, n);     % deadline
T = zeros(1, n);     %  période d’exécution, c’est-à-dire la fréquence de renouvellement de la demande d’exécution de la tâche.

% Input parameters for each task
for i = 1:n
    fprintf('\n--- Task %d ---\n', i);
    r0(i) = input(sprintf('  r0 (First release time for Task %d): ', i));
    C(i) = input(sprintf('  C (Maximum execution time for Task %d): ', i));
    D(i) = input(sprintf('  D (Critical deadline for Task %d): ', i));
    T(i) = input(sprintf('  T (Period for Task %d): ', i));
end

%% Ordonnançabilité Analysis - Condition Suffisante
disp('========================================');
disp('ANALYSE D''ORDONNANÇABILITÉ - Condition Suffisante');
disp('========================================');

% Calculate total utilization
U = sum(C ./ T);%   ? Ci/Ti
fprintf('U = (Ci/Ti) = %.4f\n', U);

% Calculate RM bound
RM_bound = n * (2^(1/n) - 1);
fprintf('RM bound = n * (2^(1/n) - 1) = %d * (2^(1/%d) - 1) = %.4f\n', n, n, RM_bound);

% Condition suffisante
if U <= RM_bound
    fprintf('\n? Condition suffisante SATISFAITE:\n');
    fprintf('   U = %.4f <= RM bound = %.4f\n', U, RM_bound);
    fprintf('   =>>> Le système est ORDONNANÇABLE par Rate Monotonic\n <<=');
    ordonnancable = true;
    
    % Continue with visualization options
    disp('========================================');
    disp('Visualization Options:');
    disp('1. Show step-by-step animation (recommended for learning)');
    disp('2. Show only final results (faster)');
    visual_option = input('Choose visualization option (1-2): ');
    
    % Set flags based on user choice
    show_animation = (visual_option == 1);
    show_final_only = (visual_option == 2);
    
else
    fprintf('\n  Condition suffisante NON SATISFAITE:\n');
    fprintf('   U = %.4f > RM bound = %.4f\n', U, RM_bound);
    fprintf('   On ne peut pas garantir l''ordonnançabilité par RM\n');
    
    % Check condition nécessaire
    disp('========================================');
    disp('ANALYSE D''ORDONNANÇABILITÉ - Condition Nécessaire');
    disp('========================================');
    
    if U > 1
        fprintf('\n? Condition nécessaire NON SATISFAITE:\n');
        fprintf('   U = %.4f > 1\n', U);
        fprintf('    Le système est NON ORDONNANÇABLE par aucun algorithme!\n');
        ordonnancable = false;
    else
        fprintf('\n  Condition nécessaire SATISFAITE:\n');
        fprintf('   U = %.4f <= 1\n', U);
        fprintf('    Le système peut être ordonnançable\n');
        
        % Ask if user wants to continue anyway
        disp('========================================');
        continuer = input('Voulez-vous continuer la simulation malgré tout? (1=Oui, 0=Non): ');
        
        if continuer == 1
            ordonnancable = true;
            disp('========================================');
            disp('Visualization Options:');
            disp('1. Show step-by-step animation (recommended for learning)');
            disp('2. Show only final results (faster)');
          
            visual_option = input('Choose visualization option (1-2): ');
            
            % Set flags based on user choice
            show_animation = (visual_option == 1);
            show_final_only = (visual_option == 2);
            show_mini_updates = (visual_option == 3);
        else
            ordonnancable = false;
        end
    end
end

% Stop if not ordonnancable
if ~ordonnancable
    disp('========================================');
    disp('SIMULATION ARRÊTÉE: Système non ordonnançable');
    disp('========================================');
    return;
end

%% ANIMATION SPEED CONTROL 
animation_delay = 0.5; % Default value
if show_animation
    disp('========================================');
    disp('Animation Speed Control:');
    disp('1. Very Slow (2.0 seconds per step)');
    disp('2. Slow (1.0 second per step)');
    disp('3. Normal (0.5 seconds per step)');
    disp('4. Fast (0.2 seconds per step)');
    disp('5. Very Fast (0.1 seconds per step)');
    disp('6. Custom speed (enter your own value)');
    speed_option = input('Choose animation speed (1-6): ');
    
    switch speed_option
        case 1
            animation_delay = 2.0;
        case 2
            animation_delay = 1.0;
        case 3
            animation_delay = 0.5;
        case 4
            animation_delay = 0.2;
        case 5
            animation_delay = 0.1;
        case 6
            animation_delay = input('Enter custom delay in seconds: ');
            if animation_delay < 0.01
                animation_delay = 0.01;
                disp('Warning: Speed too fast, setting to minimum 0.01 seconds');
            elseif animation_delay > 5
                animation_delay = 5;
                disp('Warning: Speed too slow, setting to maximum 5 seconds');
            end
        otherwise
            animation_delay = 0.5;
            disp('Invalid option, using default speed (0.5 seconds)');
    end
    
    fprintf('Animation speed set to %.2f seconds per step\n', animation_delay);
end

%% Display Task Information and Calculate Priorities
disp('========================================');
disp('Task Information and Priorities:');
disp('========================================');

% Calculate priority according to Rate Monotonic (shorter period = higher priority)
[~, priority_order] = sort(T);  %T1<T2<T3... 
%Creating a table to sort the inputs
fprintf('%-6s %-8s %-8s %-8s %-8s %-10s %-12s\n', ...
        'Task', 'r0', 'C', 'D', 'T', 'U(C/T)', 'Priority');
fprintf('%s\n', repmat('-', 70, 1));

for i = 1:n
    utilization = C(i) / T(i);
    priority_rank = find(priority_order == i);  % Priority order (1 = highest)
    fprintf('%-6d %-8d %-8d %-8d %-8d %-10.3f %-12d\n', ...
            i, r0(i), C(i), D(i), T(i), utilization, priority_rank);
end

fprintf('\nPriority Order (1 = highest):\n');
for i = 1:n
    task_id = priority_order(i);
    fprintf('%d. Task %d (T=%d)\n', i, task_id, T(task_id));
end

%%  Calculate LCM=PPCM(Ti) of Periods
lcm_value = T(1);
for i = 2:n
    lcm_value = lcm(lcm_value, T(i));
end
fprintf('\nSimulation period PPCM(Ti)=: %d\n', lcm_value);

%% Create All Task Instances for the Hyperperiod (PPCM)
disp('========================================');
disp('Creating task instances for hyperperiod...');

% Calculate number of instances for each task
num_instances_per_task = zeros(1, n);
for i = 1:n
    num_instances_per_task(i) = ceil(lcm_value / T(i));%Cette ligne calcule le « nombre de fois » que la tâche i est répétée au cours d'un cycle temporel complet de la valeur lcm_value
    fprintf('Task %d: %d instances\n', i, num_instances_per_task(i));
end

% Create data structure for instances
all_instances = [];  % [task_id, instance_num, release_time, deadline, remaining_time, priority]

for i = 1:n
    priority_rank = find(priority_order == i);
    for k = 1:num_instances_per_task(i)
        release_time = r0(i) + (k-1) * T(i);
        deadline = release_time + D(i);
        
        all_instances = [all_instances; i, k, release_time, deadline, C(i), priority_rank];
    end
end

% Sort instances by release time, then by priority (highest first)
if ~isempty(all_instances)
    all_instances = sortrows(all_instances, [3, 6]);  % Sort by release_time, then priority
end

%% Display Instance Information
disp('========================================');
disp('Task Instances Information:');
disp('========================================');
fprintf('%-15s %-12s %-12s %-12s %-12s\n', ...
        'Task-Inst', 'Release', 'Deadline', 'Exec Time', 'Priority');
fprintf('%s\n', repmat('-', 70, 1));

for i = 1:size(all_instances, 1)
    fprintf('T%d-I%-12d %-12d %-12d %-12d %-12d\n', ...
            all_instances(i,1), all_instances(i,2), ...
            all_instances(i,3), all_instances(i,4), all_instances(i,5), all_instances(i,6));
end

%%  Initialize Real-time Gantt Figure
if show_animation
    fig1 = figure('Name', 'Real-time Gantt Chart - Rate Monotonic', ...
                  'Position', [50, 50, 1400, 600]);
    ax1 = axes('Parent', fig1);
    hold(ax1, 'on');
    
    % Colors for tasks
    colors = hsv(n);
    
    % Initialize text handles for status
    status_text = uicontrol('Style', 'text', 'Position', [10, 10, 1380, 50], ...
                           'String', 'Initializing...', 'FontSize', 10, ...
                           'HorizontalAlignment', 'left', 'BackgroundColor', 'white');
    
    % Add animation control buttons with simple callbacks
    % Pause button
    pause_btn = uicontrol('Style', 'pushbutton', 'Position', [10, 70, 80, 30], ...
                         'String', 'Pause', 'Callback', 'global anim_paused; anim_paused = true;');
    
    % Continue button (initially hidden)
    continue_btn = uicontrol('Style', 'pushbutton', 'Position', [100, 70, 80, 30], ...
                           'String', 'Continue', 'Visible', 'off', ...
                           'Callback', 'global anim_paused; anim_paused = false;');
    
    % Speed control buttons
    uicontrol('Style', 'text', 'Position', [200, 75, 100, 20], ...
              'String', 'Speed Control:', 'BackgroundColor', 'white');
    
    % Faster button
    faster_btn = uicontrol('Style', 'pushbutton', 'Position', [300, 70, 60, 30], ...
                          'String', 'Faster', ...
                          'Callback', 'global anim_delay; anim_delay = max(0.01, anim_delay * 0.7);');
    
    % Slower button
    slower_btn = uicontrol('Style', 'pushbutton', 'Position', [370, 70, 60, 30], ...
                          'String', 'Slower', ...
                          'Callback', 'global anim_delay; anim_delay = min(5.0, anim_delay * 1.3);');
    
    % Current speed display
    speed_display = uicontrol('Style', 'text', 'Position', [440, 70, 150, 30], ...
                             'String', sprintf('Speed: %.2f sec/step', animation_delay), ...
                             'BackgroundColor', 'white', 'FontSize', 10);
    
    % Initialize global variables for animation control
    global anim_paused anim_delay;
    anim_paused = false;
    anim_delay = animation_delay;
end

%% 8. Rate Monotonic Scheduling Simulation
disp('========================================');
disp('Starting Rate Monotonic Simulation...');
disp('========================================');

% Simulation variables
current_time = 0;
max_simulation_time = lcm_value * 2;  % Maximum simulation time

% Data structures
ready_queue = [];  % Ready instances
execution_history = [];  % Execution record
completion_status = zeros(size(all_instances, 1), 1);  % 0 = not completed, 1 = completed, 2 = cancelled (missed deadline)
remaining_times = all_instances(:,5); 
release_status = zeros(size(all_instances, 1), 1);  % 0 = not released, 1 = released

% NEW: Track cancelled tasks (tasks that have missed deadline and should be removed)
task_cancelled = false(1, n);  % Track if a task is cancelled

% Statistics
missed_deadlines = 0;
total_execution_time = 0;
preemptions = 0;  % Number of preemptions
currently_executing = 0;  % Currently executing instance index

% Data for plotting
execution_blocks = {};  % For execution periods
idle_blocks = {};       % For idle periods (time libre)
last_plot_time = 0;
last_idle_start = -1;   % Track idle start time

% Main simulation loop
simulation_active = true;
while simulation_active && current_time < max_simulation_time
    %% Step 1: Check for new instances released at current_time
    for i = 1:size(all_instances, 1)
        if all_instances(i,3) == current_time && release_status(i) == 0
            % Check if task is cancelled
            task_id = all_instances(i, 1);
            if task_cancelled(task_id)
                % Skip this instance - task is cancelled
                release_status(i) = 2;  % Mark as cancelled
                continue;
            end
            
            release_status(i) = 1;
            
            % Add to ready queue
            instance_info = [i, all_instances(i,1), all_instances(i,2), ...
                           all_instances(i,3), all_instances(i,4), ...
                           remaining_times(i), all_instances(i,6)];
            
            ready_queue = [ready_queue; instance_info];
            
            if show_animation || show_mini_updates
                fprintf('Time %d: Task %d Instance %d RELEASED (Deadline: %d, Priority: %d)\n', ...
                        current_time, all_instances(i,1), all_instances(i,2), ...
                        all_instances(i,4), all_instances(i,6));
            end
        end
    end
    
    %% Step 2: Sort ready queue by priority (Rate Monotonic)
    if ~isempty(ready_queue)
        ready_queue = sortrows(ready_queue, [7, 3]);  % Sort by priority, then release time
        
        %% Step 3: Check if we need to preempt current task
        if currently_executing > 0
            % Find the highest priority task in ready queue
            current_task_idx = find(ready_queue(:,1) == currently_executing, 1);
            if ~isempty(current_task_idx)
                current_task_priority = ready_queue(current_task_idx, 7);
                highest_priority = ready_queue(1, 7);
                
                % Preempt if a higher priority task has arrived
                if highest_priority < current_task_priority
                    % End current execution block
                    if currently_executing > 0
                        current_task = ready_queue(current_task_idx, 2);
                        current_instance = ready_queue(current_task_idx, 3);
                        execution_blocks{end+1} = [last_plot_time, current_time, current_task, current_instance];
                    end
                    
                    fprintf('Time %d: PREEMPTION! Task %d Instance %d (Priority %d) preempted by higher priority task\n', ...
                            current_time, ready_queue(current_task_idx, 2), ready_queue(current_task_idx, 3), current_task_priority);
                    
                    preemptions = preemptions + 1;
                    currently_executing = 0;
                    last_plot_time = current_time;
                end
            end
        end
        
        %% Step 4: Select task for execution
        if currently_executing == 0
            % End idle period if there was one
            if last_idle_start >= 0
                idle_blocks{end+1} = [last_idle_start, current_time];
                if show_animation || show_mini_updates
                    fprintf('Time %d: End of IDLE period (duration: %d)\n', current_time, current_time - last_idle_start);
                end
                last_idle_start = -1;
            end
            
            % Select the highest priority task
            current_instance_idx = ready_queue(1, 1);  % index in all_instances
            task_id = ready_queue(1, 2);
            instance_num = ready_queue(1, 3);
            deadline = ready_queue(1, 5);
            remaining_time = ready_queue(1, 6);
            priority = ready_queue(1, 7);
            
            currently_executing = current_instance_idx;
            last_plot_time = current_time;  % Start new execution block
            
            if show_animation || show_mini_updates
                fprintf('Time %d: EXECUTING Task %d Instance %d (Remaining: %d, Deadline: %d, Priority: %d)\n', ...
                        current_time, task_id, instance_num, remaining_time, deadline, priority);
            end
        else
            % Continue executing current task
            current_task_idx = find(ready_queue(:,1) == currently_executing, 1);
            if isempty(current_task_idx)
                currently_executing = 0;
                continue;
            end
            
            task_id = ready_queue(current_task_idx, 2);
            instance_num = ready_queue(current_task_idx, 3);
            deadline = ready_queue(current_task_idx, 5);
            remaining_time = ready_queue(current_task_idx, 6);
            priority = ready_queue(current_task_idx, 7);
        end
        
        %% Step 5: Execute the task
        exec_time = 1;  % Execute for one time unit
        
        % Record execution
        execution_history = [execution_history; current_time, task_id, instance_num];
        total_execution_time = total_execution_time + exec_time;
        
        %% Step 6: Update remaining time
        remaining_time = remaining_time - exec_time;
        remaining_times(currently_executing) = remaining_time;
        
        % Update in ready_queue
        current_task_idx = find(ready_queue(:,1) == currently_executing, 1);
        if ~isempty(current_task_idx)
            ready_queue(current_task_idx, 6) = remaining_time;
        end
        
        %% Step 7: Check if instance completed
        if remaining_time <= 0
            % Instance completed
            completion_status(currently_executing) = 1;
            
            % End execution block
            if currently_executing > 0
                execution_blocks{end+1} = [last_plot_time, current_time + 1, task_id, instance_num];
            end
            
            % Remove from ready_queue
            ready_queue(current_task_idx, :) = [];
            
            % Check deadline
            completion_time = current_time + 1;
            if completion_time > deadline
                fprintf('  ? Task %d Instance %d MISSED deadline! (Completed: %d, Deadline: %d)\n', ...
                        task_id, instance_num, completion_time, deadline);
                missed_deadlines = missed_deadlines + 1;
                
                % MARK TASK AS CANCELLED
                task_cancelled(task_id) = true;
                fprintf('  ??  Task %d CANCELLED - All future instances will be ignored\n', task_id);
                
                % Remove all future instances of this task from ready queue
                indices_to_remove = [];
                for j = 1:size(ready_queue, 1)
                    if ready_queue(j, 2) == task_id
                        indices_to_remove = [indices_to_remove, j];
                    end
                end
                ready_queue(indices_to_remove, :) = [];
            else
                if show_animation || show_mini_updates
                    fprintf('  ? Task %d Instance %d completed (Deadline: %d)\n', ...
                            task_id, instance_num, deadline);
                end
            end
            
            currently_executing = 0;
        end
    else
        %% Step 8: No tasks ready for execution - SCHEDULER IS IDLE
        if currently_executing == 0
            % Start idle period if not already idle
            if last_idle_start == -1
                last_idle_start = current_time;
                if show_animation || show_mini_updates
                    fprintf('Time %d: SCHEDULER IS IDLE (No tasks to execute)\n', current_time);
                end
            end
        else
            if show_animation || show_mini_updates
                fprintf('Time %d: No tasks ready for execution\n', current_time);
            end
        end
        
        % Store execution block if there was an executing task before
        if currently_executing > 0
            execution_blocks{end+1} = [last_plot_time, current_time, currently_executing, 0];
            currently_executing = 0;
        end
    end
    
    %% Step 9: Update Real-time Gantt Chart
    if show_animation
        % Update status text
        if currently_executing > 0
            current_status = sprintf('Time: %d units | Executing: Task %d Instance %d | Ready Queue: %d tasks | Completed: %d/%d', ...
                                     current_time, task_id, instance_num, size(ready_queue, 1), sum(completion_status == 1), size(all_instances, 1));
        else
            if last_idle_start >= 0
                current_status = sprintf('Time: %d units | SCHEDULER IDLE (for %d units) | Ready Queue: %d tasks | Completed: %d/%d', ...
                                         current_time, current_time - last_idle_start, size(ready_queue, 1), sum(completion_status == 1), size(all_instances, 1));
            else
                current_status = sprintf('Time: %d units | No task executing | Ready Queue: %d tasks | Completed: %d/%d', ...
                                         current_time, size(ready_queue, 1), sum(completion_status == 1), size(all_instances, 1));
            end
        end
        set(status_text, 'String', current_status);
        
        % Clear axes and redraw
        cla(ax1);
        
        % Plot idle blocks in BLACK
        for i = 1:length(idle_blocks)
            idle_block = idle_blocks{i};
            start_time = idle_block(1);
            end_time = idle_block(2);
            
            % Plot idle block at position n+1
            y_pos_idle = n + 1;
            rectangle('Parent', ax1, 'Position', [start_time, y_pos_idle-0.4, end_time-start_time, 0.8], ...
                     'FaceColor', 'black', 'EdgeColor', 'black', 'LineWidth', 1);
            
            % Add IDLE text in white
            if (end_time - start_time) >= 3
                text(start_time + (end_time-start_time)/2, y_pos_idle, 'IDLE', ...
                     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                     'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
            end
        end
        
        % Plot current idle period if any
        if last_idle_start >= 0
            y_pos_idle = n + 1;
            rectangle('Parent', ax1, 'Position', [last_idle_start, y_pos_idle-0.4, current_time-last_idle_start+1, 0.8], ...
                     'FaceColor', 'black', 'EdgeColor', 'black', 'LineWidth', 2);
            
            text(last_idle_start + (current_time-last_idle_start+1)/2, y_pos_idle, 'IDLE', ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                 'FontSize', 9, 'Color', 'white', 'FontWeight', 'bold');
        end
        
        % Plot execution blocks
        for block_idx = 1:length(execution_blocks)
            block = execution_blocks{block_idx};
            start_time = block(1);
            end_time = block(2);
            block_task = block(3);
            block_instance = block(4);
            
            if block_task > 0  % Actual task execution
                y_pos = n - block_task + 1;
                rectangle('Parent', ax1, 'Position', [start_time, y_pos-0.4, end_time-start_time, 0.8], ...
                         'FaceColor', colors(block_task, :), 'EdgeColor', 'k', 'LineWidth', 1);
                
                % Add label
                if (end_time - start_time) >= 1
                    text(start_time + (end_time-start_time)/2, y_pos, ...
                         sprintf('T%d-I%d', block_task, block_instance), ...
                         'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                         'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
                end
            end
        end
        
        % Draw current execution if any
        if currently_executing > 0 && ~isempty(find(ready_queue(:,1) == currently_executing, 1))
            current_task_idx = find(ready_queue(:,1) == currently_executing, 1);
            task_id = ready_queue(current_task_idx, 2);
            instance_num = ready_queue(current_task_idx, 3);
            y_pos = n - task_id + 1;
            
            rectangle('Parent', ax1, 'Position', [last_plot_time, y_pos-0.4, current_time-last_plot_time+1, 0.8], ...
                     'FaceColor', colors(task_id, :), 'EdgeColor', 'k', 'LineWidth', 2);
            
            text(last_plot_time + (current_time-last_plot_time+1)/2, y_pos, ...
                 sprintf('T%d-I%d', task_id, instance_num), ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                 'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
        end
        
        % Customize axes
        xlabel(ax1, 'Time (units)', 'FontSize', 12, 'FontWeight', 'bold');
        ylabel(ax1, 'Tasks', 'FontSize', 12, 'FontWeight', 'bold');
        title(ax1, sprintf('Real-time Gantt Chart - Time: %d units (IDLE in BLACK)', current_time), ...
              'FontSize', 14, 'FontWeight', 'bold');
        
        ytick_positions = 1:(n+1);
        ytick_labels = arrayfun(@(x) sprintf('Task %d', x), n:-1:1, 'UniformOutput', false);
        ytick_labels{end+1} = 'IDLE (Black)';
        
        set(ax1, 'YTick', ytick_positions);
        set(ax1, 'YTickLabel', ytick_labels);
        
        max_display_time = max(current_time+1, 10);
        xlim(ax1, [0, max_display_time]);
        
        % Set appropriate x-ticks for better visibility
        if max_display_time <= 20
            set(ax1, 'XTick', 0:max_display_time);
            set(ax1, 'XTickLabel', 0:max_display_time);
        elseif max_display_time <= 50
            set(ax1, 'XTick', 0:5:max_display_time);
            set(ax1, 'XTickLabel', 0:5:max_display_time);
        else
            set(ax1, 'XTick', 0:10:max_display_time);
            set(ax1, 'XTickLabel', 0:10:max_display_time);
        end
        
        set(ax1, 'FontSize', 10);
        
        ylim(ax1, [0, n+2]);
        grid(ax1, 'on');
        
        drawnow;
        
        % Handle animation pause and speed control
        global anim_paused anim_delay;
        
        % Update speed display
        set(speed_display, 'String', sprintf('Speed: %.2f sec/step', anim_delay));
        
        % Handle pause state
        if anim_paused
            set(pause_btn, 'Visible', 'off');
            set(continue_btn, 'Visible', 'on');
            while anim_paused
                pause(0.1);
                drawnow;
            end
            set(pause_btn, 'Visible', 'on');
            set(continue_btn, 'Visible', 'off');
        else
            % Use current animation delay
            pause(anim_delay);
        end
        
    elseif show_mini_updates && mod(current_time, 5) == 0
        % Show mini-update every 5 time units
        fprintf('\n--- Mini Update at Time %d ---\n', current_time);
        if currently_executing > 0
            fprintf('Currently executing: Task %d Instance %d\n', task_id, instance_num);
        elseif last_idle_start >= 0
            fprintf('Currently: SCHEDULER IDLE (for %d units)\n', current_time - last_idle_start);
        else
            fprintf('Currently: No task executing\n');
        end
        fprintf('Ready queue: %d tasks\n', size(ready_queue, 1));
        fprintf('Completed instances: %d/%d\n', sum(completion_status == 1), size(all_instances, 1));
        
        % Quick text-based gantt for last 10 time units
        fprintf('Recent execution (last 10 time units):\n');
        for t = max(0, current_time-10):current_time
            exec_at_t = execution_history(execution_history(:,1) == t, :);
            if ~isempty(exec_at_t)
                fprintf('  Time %d: Task %d-I%d\n', t, exec_at_t(1,2), exec_at_t(1,3));
            else
                fprintf('  Time %d: IDLE\n', t);
            end
        end
        fprintf('\n');
    end
    
    %% Step 10: Advance time
    current_time = current_time + 1;
    
    %% Step 11: Check if all instances completed or cancelled
    completed_or_cancelled = (completion_status == 1) | (release_status == 2);
    if all(completed_or_cancelled) || (sum(task_cancelled) == n)
        simulation_active = false;
        fprintf('\nTime %d: All task instances completed or cancelled!\n', current_time);
        
        % Store last execution block
        if currently_executing > 0
            execution_blocks{end+1} = [last_plot_time, current_time, task_id, instance_num];
        end
        
        % End any ongoing idle period
        if last_idle_start >= 0
            idle_blocks{end+1} = [last_idle_start, current_time];
            last_idle_start = -1;
        end
    end
    
    %% Step 12: Check for missed deadlines (early detection)
    for i = 1:size(all_instances, 1)
        if completion_status(i) == 0 && release_status(i) == 1 && ~task_cancelled(all_instances(i,1))
            deadline = all_instances(i, 4);
            if current_time > deadline
                % This instance missed its deadline
                task_id = all_instances(i,1);
                instance_num = all_instances(i,2);
                
                fprintf('  ??  Task %d Instance %d MISSED deadline! (Current time: %d, Deadline: %d)\n', ...
                        task_id, instance_num, current_time, deadline);
                
                % Mark task as cancelled
                task_cancelled(task_id) = true;
                fprintf('  ??  Task %d CANCELLED - All future instances will be ignored\n', task_id);
                
                % Mark this instance as cancelled
                completion_status(i) = 2;
                missed_deadlines = missed_deadlines + 1;
                
                % Remove all instances of this task from ready_queue
                indices_to_remove = [];
                for j = 1:size(ready_queue, 1)
                    if ready_queue(j, 2) == task_id
                        indices_to_remove = [indices_to_remove, j];
                    end
                end
                ready_queue(indices_to_remove, :) = [];
                
                % If this was the currently executing task, stop it
                if currently_executing == i
                    currently_executing = 0;
                end
            end
        end
    end
end

%%  Calculate Idle Time Statistics
% Calculate total idle time
total_idle_time = 0;
for i = 1:length(idle_blocks)
    idle_block = idle_blocks{i};
    total_idle_time = total_idle_time + (idle_block(2) - idle_block(1));
end

% Calculate idle percentage
if current_time > 0
    idle_percentage = (total_idle_time / current_time) * 100;
    cpu_utilization = (total_execution_time / current_time) * 100;
else
    idle_percentage = 0;
    cpu_utilization = 0;
end

%% 10. Display Results and Statistics
disp('========================================');
disp('Rate Monotonic Simulation Results:');
disp('========================================');

fprintf('Total simulation time: %d units\n', current_time);
fprintf('Hyperperiod (LCM): %d\n', lcm_value);
fprintf('Number of tasks: %d\n', n);
fprintf('Total instances: %d\n', size(all_instances, 1));
fprintf('Successfully completed: %d\n', sum(completion_status == 1));
fprintf('Cancelled (missed deadline): %d\n', sum(task_cancelled));
fprintf('Number of preemptions: %d\n', preemptions);

fprintf('\n--- SCHEDULER IDLE TIME ANALYSIS ---\n');
fprintf('Total idle time: %d units\n', total_idle_time);
fprintf('Idle time percentage: %.2f%%\n', idle_percentage);
fprintf('CPU Utilization: %.2f%%\n', cpu_utilization);
fprintf('Number of idle periods: %d\n', length(idle_blocks));
fprintf('Missed deadlines: %d\n', missed_deadlines);

% Final ordonnancabilité verdict
fprintf('\n--- ORDONNANÇABILITÉ FINALE ---\n');
if missed_deadlines == 0
    fprintf('? Toutes les tâches ont respecté leurs deadlines!\n');
    fprintf('   ? Le système est ORDONNANÇABLE par Rate Monotonic\n');
else
    fprintf('? %d tâches ont dépassé leurs deadlines\n', sum(task_cancelled));
    fprintf('   ? Le système n''est PAS ORDONNANÇABLE par Rate Monotonic\n');
    
    % List cancelled tasks
    fprintf('\nTâches annulées:\n');
    for i = 1:n
        if task_cancelled(i)
            fprintf('  - Task %d (C=%d, D=%d, T=%d)\n', i, C(i), D(i), T(i));
        end
    end
end

%% 11. Create Final Gantt Chart with Black Idle Time
disp('========================================');
disp('Creating Final Gantt Chart with Black Idle Time...');
disp('========================================');

if ~isempty(execution_history) || ~isempty(idle_blocks)
    % Create comprehensive figure
    figure('Name', 'Final Rate Monotonic Scheduling Analysis', ...
           'Position', [100, 100, 1400, 800]);
    
    %% Subplot 1: Complete Gantt Chart with Idle Time in BLACK
    subplot(2, 1, 1);
    hold on;
    
    % Colors for tasks
    colors = hsv(n);
    
    % FIRST: Plot IDLE blocks in BLACK (as background)
    for i = 1:length(idle_blocks)
        idle_block = idle_blocks{i};
        start_time = idle_block(1);
        end_time = idle_block(2);
        
        % Plot idle block at position n+1 (above all tasks)
        y_pos_idle = n + 1;
        rectangle('Position', [start_time, y_pos_idle-0.4, end_time-start_time, 0.8], ...
                 'FaceColor', 'black', 'EdgeColor', 'black', 'LineWidth', 1);
        
        % Add IDLE text in white for better visibility
        if (end_time - start_time) >= 3
            text(start_time + (end_time-start_time)/2, y_pos_idle, 'IDLE', ...
                 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                 'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
        end
    end
    
    % SECOND: Plot execution blocks
    for block_idx = 1:length(execution_blocks)
        block = execution_blocks{block_idx};
        start_time = block(1);
        end_time = block(2);
        block_task = block(3);
        block_instance = block(4);
        
        if block_task > 0
            y_pos = n - block_task + 1;
            rectangle('Position', [start_time, y_pos-0.4, end_time-start_time, 0.8], ...
                     'FaceColor', colors(block_task, :), 'EdgeColor', 'k', 'LineWidth', 1);
            
            % Add instance number
            if (end_time - start_time) >= 2
                text(start_time + (end_time-start_time)/2, y_pos, ...
                     sprintf('I%d', block_instance), ...
                     'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
                     'FontSize', 8, 'Color', 'white', 'FontWeight', 'bold');
            end
        end
    end
    
    % Add release time markers (green triangles UP)
    for i = 1:n
        y_pos = n - i + 1;
        task_indices = find(all_instances(:,1) == i);
        
        for idx = 1:length(task_indices)
            instance_idx = task_indices(idx);
            release_time = all_instances(instance_idx, 3);
            
            if release_time <= current_time
                % Draw upward triangle for release time
                triangle_size = 0.2;
                x = release_time;
                y_top = y_pos + 0.6;
                
                % Triangle pointing up
                patch([x-triangle_size, x, x+triangle_size], ...
                      [y_top, y_top+triangle_size, y_top], ...
                      'g', 'EdgeColor', 'g', 'LineWidth', 1);
                
                % Add small 'R' label
                if mod(release_time, 5) == 0 || idx == 1
                    text(x, y_top + triangle_size + 0.1, 'R', ...
                         'Color', 'g', 'FontSize', 7, 'FontWeight', 'bold', ...
                         'HorizontalAlignment', 'center');
                end
            end
        end
    end
    
    % Add deadline markers (red triangles DOWN)
    for i = 1:n
        y_pos = n - i + 1;
        task_indices = find(all_instances(:,1) == i);
        
        for idx = 1:length(task_indices)
            instance_idx = task_indices(idx);
            deadline = all_instances(instance_idx, 4);
            
            if deadline <= current_time
                % Draw downward triangle for deadline
                triangle_size = 0.2;
                x = deadline;
                y_bottom = y_pos - 0.6;
                
                % Triangle pointing down
                patch([x-triangle_size, x, x+triangle_size], ...
                      [y_bottom, y_bottom-triangle_size, y_bottom], ...
                      'r', 'EdgeColor', 'r', 'LineWidth', 1);
                
                % Add small 'D' label
                if mod(deadline, 5) == 0 || idx == 1
                    text(x, y_bottom - triangle_size - 0.1, 'D', ...
                         'Color', 'r', 'FontSize', 7, 'FontWeight', 'bold', ...
                         'HorizontalAlignment', 'center');
                end
            end
        end
    end
    
    % Customize plot
    xlabel('Time (units)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Tasks', 'FontSize', 12, 'FontWeight', 'bold');
    title('Final Gantt Chart - Rate Monotonic Scheduling (Idle Time in BLACK)', ...
          'FontSize', 14, 'FontWeight', 'bold');
    
    ytick_positions = [1:n, n+1];
    ytick_labels = cell(1, n+1);
    
    % Task labels
    for i = 1:n
        task_id = n - i + 1;
        priority_rank = find(priority_order == task_id);
        if task_cancelled(task_id)
            ytick_labels{i} = sprintf('Task %d (P%d) ?', task_id, priority_rank);
        else
            ytick_labels{i} = sprintf('Task %d (P%d) ?', task_id, priority_rank);
        end
    end
    
    % Idle label
    ytick_labels{n+1} = 'IDLE (Black)';
    
    set(gca, 'YTick', ytick_positions);
    set(gca, 'YTickLabel', ytick_labels);
   
    % Set font size for x-ticks
    set(gca, 'FontSize', 10);
    
    ylim([0, n+2]);
    grid on;
    
    % Add a time scale reference at the bottom
    text(current_time/2, -0.5, 'Time Scale (units)', ...
         'HorizontalAlignment', 'center', 'FontSize', 11, 'FontWeight', 'bold');
    
    % Add legend
    legend_elements = [];
    legend_labels = {};
    
    % Task colors
    for i = 1:n
        h = fill([0, 0, 1, 1], [0, 1, 1, 0], colors(i, :));
        set(h, 'EdgeColor', 'k', 'Visible', 'off');
        legend_elements = [legend_elements, h];
        legend_labels = [legend_labels, sprintf('Task %d', i)];
    end
    
    % Idle time (BLACK)
    h_idle = fill([0, 0, 1, 1], [0, 1, 1, 0], 'black');
    set(h_idle, 'EdgeColor', 'k', 'Visible', 'off');
    legend_elements = [legend_elements, h_idle];
    legend_labels = [legend_labels, 'Scheduler Idle'];
    
    % Release time (green up triangle)
    h_release = plot(0.5, 0.5, 'g^', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
    set(h_release, 'Visible', 'off');
    legend_elements = [legend_elements, h_release];
    legend_labels = [legend_labels, 'Release (R)'];
    
    % Deadline (red down triangle)
    h_deadline = plot(0.5, 0.5, 'rv', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    set(h_deadline, 'Visible', 'off');
    legend_elements = [legend_elements, h_deadline];
    legend_labels = [legend_labels, 'Deadline (D)'];
    
    legend(legend_elements, legend_labels, 'Location', 'eastoutside', 'FontSize', 9);
end
%% 12. Display Detailed Idle Period Information
disp('========================================');
disp('Detailed Idle Periods (Time Libre):');
disp('========================================');

if ~isempty(idle_blocks)
    fprintf('%-10s %-12s %-12s %-15s\n', 'Period', 'Start Time', 'End Time', 'Duration');
    fprintf('%s\n', repmat('-', 50, 1));
    
    for i = 1:length(idle_blocks)
        idle_block = idle_blocks{i};
        duration = idle_block(2) - idle_block(1);
        fprintf('%-10d %-12d %-12d %-12d (%.1f%%)\n', ...
                i, idle_block(1), idle_block(2), duration, ...
                (duration/current_time)*100);
    end
    
    fprintf('\nTotal idle time: %d / %d (%.1f%%)\n', ...
            total_idle_time, current_time, idle_percentage);
else
    fprintf('No idle periods - scheduler was always busy!\n');
end

%% 13. Final Summary
disp('========================================');
disp('SIMULATION COMPLETE');
disp('========================================');

fprintf('Task set analysis:\n');
fprintf('- Number of tasks: %d\n', n);
fprintf('- Hyperperiod (LCM): %d\n', lcm_value);
fprintf('- Total utilization: U = %.4f\n', U);
fprintf('- RM bound: %.4f\n', RM_bound);

fprintf('\nScheduler performance:\n');
fprintf('- CPU utilization: %.1f%%\n', cpu_utilization);
fprintf('- Scheduler idle time: %.1f%% (shown in BLACK)\n', idle_percentage);
fprintf('- Preemptions: %d\n', preemptions);
fprintf('- Canrcelled tasks: %d/%d\n', sum(task_cancelled), n);

if missed_deadlines == 0
    fprintf('- Result:  ALL TASKS SCHEDULED SUCCESSFULLY\n');
    fprintf('   Le système est ORDONNANÇABLE par Rate Monotonic\n');
else
    fprintf('- Result:  %d TASKS CANCELLED (missed deadlines)\n', sum(task_cancelled));
    fprintf('   Le système n''est PAS ORDONNANÇABLE par Rate Monotonic\n');
end

fprintf('\n +++++++Visualization completed successfully+++++++\n');
