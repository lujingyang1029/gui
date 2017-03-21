function varargout = IFT_Toolbox_Heterogeneous_Data_Fusion(varargin)
% IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION MATLAB code for IFT_Toolbox_Heterogeneous_Data_Fusion.fig
%      by Zijian Mo, Intelligent Fusion Technology, Inc.
%
%      IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION, by itself, creates a new IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION or raises the existing
%      singleton*.
%
%      H = IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION returns the handle to a new IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION or the handle to
%      the existing singleton*.
%
%      IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION.M with the given input arguments.
%
%      IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION('Property','Value',...) creates a new IFT_TOOLBOX_HETEROGENEOUS_DATA_FUSION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IFT_Toolbox_Heterogeneous_Data_Fusion_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IFT_Toolbox_Heterogeneous_Data_Fusion_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
% Last Modified by GUIDE v2.5 15-Mar-2017 11:56:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IFT_Toolbox_Heterogeneous_Data_Fusion_OpeningFcn, ...
                   'gui_OutputFcn',  @IFT_Toolbox_Heterogeneous_Data_Fusion_OutputFcn, ...
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


% --- Executes just before IFT_Toolbox_Heterogeneous_Data_Fusion is made visible.
function IFT_Toolbox_Heterogeneous_Data_Fusion_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IFT_Toolbox_Heterogeneous_Data_Fusion (see VARARGIN)

% IFT icon loading
axes(handles.IFTicon)
IFTImage = imread('IFTLogo_Trans.jpg');
image(IFTImage)
axis off
axis image

% AFRL icon loading
axes(handles.AFRL_icon)
AFRLImage = imread('AFRL_icon.jpg');
image(AFRLImage)
axis off
axis image

axes(handles.axes3);
axis off;
axes(handles.axes4);
axis off;

% Scenario Table
handles.tabcontent = {' ', ' ' , ' ', ' ', ''};
set(handles.Scenario_Table, 'Data', handles.tabcontent);
set(handles.Scenario_Table,'ColumnName',{'Sim. ID','Num. Veh.','Tx Waveform','Veh. Motion', 'Video Obscuration'});



% Initialize the MSE_VALUE and video Display panel
handles.MSE_VALUE = -1; % if less than 0, no MSE_VALUE yet.
handles.flag_axes4 = false; % true, approach select would not affect video display panel, otherwise, it does.
handles.index_scenario = 0 ; % 0 is zero, 1,2,3 stand for scenario 1,2,3
handles.video = load('videosetting.mat'); % video setting
handles.sigint = load('sigintsetting.mat'); % sigint setting

handles.image = 0; % store all frames data in the video
handles.vehicle = 0; % store the ground truth of target vehicles
handles.vehicle_est = 0; % store the estimation of target vehicles

% Choose default command line output for IFT_Toolbox_Heterogeneous_Data_Fusion
handles.output = hObject;

handles.model_compare_handle =[];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IFT_Toolbox_Heterogeneous_Data_Fusion wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IFT_Toolbox_Heterogeneous_Data_Fusion_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function IFTicon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IFTicon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate IFTicon


% --- Executes when entered data in editable cell(s) in Scenario_Table.
function Scenario_Table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to Scenario_Table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Scenario_Sel.
function Scenario_Sel_Callback(hObject, eventdata, handles)
% hObject    handle to Scenario_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the axes
set(handles.axes3, 'Visible', 'off'); cla (handles.axes3);% turn off the visible of axes for video display
set(handles.axes4, 'Visible', 'off'); cla (handles.axes4);% turn off the visible of axes for error
% legend('handles.axes4','hide')
% disable the run&view button and  reset button
set(handles.Run_Alg,'Enable', 'off');
% set(handles.MSE_button,'Enable', 'off');
set(handles.MSE_text,'String', '');

% temporarily diable the buttons
set(handles.Scenario_Preview,'Enable', 'off');
set(handles.Approach_Sel,'Enable', 'off');
set(handles.Rest_Button,'Enable', 'off');
set(handles.Scenario_Sel,'Enable', 'off');
set(handles.Approach_Sel,'Value', 1);

% Hints: contents = cellstr(get(hObject,'String')) returns Scenario_Sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Scenario_Sel
str = get(hObject, 'String');
val = get(hObject,'Value');
% Set current data to the selected data set.
if (strcmp(str{val},'Please Select...'))
    handles.tabcontent = {' ', ' ' , ' ', ' ', ''};
    set(handles.Scenario_Preview,'Enable', 'off');
    set(handles.Approach_Sel,'Enable', 'off');
  %  set(handles.Run_Alg,'Enable', 'off');
    handles.index_scenario = 0;
    % update the state box 
    set(handles.State_Text,'String', 'No loaded scenario, please select one ...');
else
    switch str{val};
        case 'Scenario 1'  
            % update the state box
            set(handles.State_Text,'String', 'Loading Scenario 1 (Sim 1) ...');
            pause(1); % pause 1s
            handles.image = load('case1/sim1video.mat');
            handles.vehicle = load('case1/vehicle_data.mat');
            pause(1); % pause 1s
            set(handles.State_Text,'String', 'Scenario 1 (Sim 1) is loaded.');
            handles.tabcontent = {'1', '1' , 'Tone', 'N-to-S', 'N/A'};
            % set index as 1, scenario 1 is selected
            handles.index_scenario = 1;
        case 'Scenario 2'  
            % update the state box
            set(handles.State_Text,'String', 'Loading Scenario 2 (Sim 5) ...');
            pause(1); % pause 1s
            handles.image = load('case2/sim2video.mat');
            handles.vehicle = load('case2/vehicle_data.mat');
            pause(1); % pause 1s
            set(handles.State_Text,'String', 'Scenario 2 (Sim 5) is loaded.');
            handles.tabcontent = {'5', '2' , 'Tone,Tone', 'N-to-S,NW-to-SE', 'N/A'};
            % set index as 2, scenario 2 is selected
            handles.index_scenario = 2;
        case 'Scenario 3'  
            % update the state box
            set(handles.State_Text,'String', 'Loading Scenario 3 (Sim 9) ...');
            pause(1); % pause 1s
            handles.image = load('case3/sim3video.mat');
            handles.vehicle = load('case3/vehicle_data.mat');
            pause(1); % pause 1s
            set(handles.State_Text,'String', 'Scenario 3 (Sim 9) is loaded.');
            handles.tabcontent = {'9', '2' , 'Tone,Tone', 'N-to-S,NW-to-SE', 'Trees over Road'};
            % set index as 3, scenario 3 is selected
            handles.index_scenario = 3;

    end
    set(handles.Scenario_Preview,'Enable', 'on');
    set(handles.Approach_Sel,'Enable', 'on');
end
% reset the scenario selectio pop-up menu and reset button
set(handles.Scenario_Sel,'Enable', 'on');
set(handles.Rest_Button,'Enable', 'on');
% no MSE result yet
% set(handles.MSE_button,'Enable', 'off');
% put the new content into the table
set(handles.Scenario_Table, 'Data', handles.tabcontent);

% for the case that reset button is pressed during the preview or run, need
% to clear the stopPlot flag.
if (isappdata(handles.axes3,'stopPlot'))
    rmappdata(handles.axes3,'stopPlot'); % delete the stop signal
end

% Save the handles structure.
 guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function Scenario_Sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Scenario_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Scenario_Preview.
function Scenario_Preview_Callback(hObject, eventdata, handles)
% hObject    handle to Scenario_Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preview the Scenario
% clear axes and MSE result
cla (handles.axes3); 
set(handles.axes4, 'Visible', 'off'); cla (handles.axes4); 

% turn on the visible of axes for video display
set(handles.axes3, 'Visible', 'on'); 

% pause a short interval
interval_disp = 0.01;
pause(2* interval_disp);
% disable all button which possibly interupt the code
set(handles.Approach_Sel,'Enable', 'off');
set(handles.Scenario_Sel,'Enable', 'off');
set(handles.Scenario_Preview,'Enable', 'off');
% set(handles.Rest_Button,'Enable', 'off');
% need to remember before disable
flag_run_alg = false; flag_MSE_button = false;
if (size(get(handles.Run_Alg, 'Enable'),2) == 2) % 2 is 'on', 3 is 'off'
    flag_run_alg = true;
end
% if (size(get(handles.MSE_button, 'Enable'),2) == 2) % 2 is 'on', 3 is 'off'
%     flag_MSE_button = true;  
% end
set(handles.Run_Alg,'Enable', 'off');
% set(handles.MSE_button,'Enable', 'off');

% find the name of the scenario
str = get(handles.Scenario_Sel, 'String');
val = get(handles.Scenario_Sel,'Value');

% preprocess the image data
% 3 std dev scaling
cax = mean(handles.image.I_new(:)) + std(handles.image.I_new(:)).*[-3 3];
% vehColors = 'bgr';

% grid 
x_grid = (handles.video.video.settings.coordLowerRight(1)- handles.video.video.settings.coordLowerLeft(1) )/size(handles.image.I_new(:,:,1),2);
y_grid = (handles.video.video.settings.coordUpperLeft(2)-handles.video.video.settings.coordLowerLeft(2))/size(handles.image.I_new(:,:,1),1);
add_grid_x = ceil(60/x_grid ); % 60 is the No. grids in x axis we want to increase
add_grid_y_top = ceil(180/y_grid);
add_grid_y_bottom =  ceil(60/y_grid);

Image_process = zeros(add_grid_y_bottom +size(handles.image.I_new(:,:,1),1) + add_grid_y_top,add_grid_x + size(handles.image.I_new(:,:,1),2));
Iter_Num = size(handles.image.I_new,3);

axes(handles.axes3);
axis off; grid off;
hold on;
Iter_Num = 500;
for i_iter = 100: Iter_Num
    % put original image into the large frame
    Image_process(add_grid_y_top+1:1:size(handles.image.I_new(:,:,1),1)+add_grid_y_top,add_grid_x+1:end) = handles.image.I_new(:,:,i_iter); 
    % check the flag, true, keep going, false, stop
    if (isappdata(handles.axes3,'stopPlot')) 
        break;
    end
    
    h_pre = imagesc([handles.video.video.settings.coordLowerLeft(1)-x_grid*add_grid_x  handles.video.video.settings.coordLowerRight(1)],...
        [handles.video.video.settings.coordUpperLeft(2)+y_grid*add_grid_y_top  handles.video.video.settings.coordLowerLeft(2)-y_grid*add_grid_y_bottom],...
        Image_process,cax);
    colormap(gray); axis xy; axis off; axis tight; 
    
    %%%%%%%%%% add Sensors
    hold on;
    h_sigint = plot(handles.sigint.sigint.location.north(1), handles.sigint.sigint.location.north(2), 'r+',...
        handles.sigint.sigint.location.west(1), handles.sigint.sigint.location.west(2), 'r+',...
        handles.sigint.sigint.location.nadir(1), handles.sigint.sigint.location.nadir(2), 'r+');
    hold on;
    h_camera = plot(handles.sigint.sigint.location.nadir(1), handles.sigint.sigint.location.nadir(2), 'yx');
    
    pause(interval_disp);
    if (i_iter ~= Iter_Num && ~isappdata(handles.axes3,'stopPlot'))
        delete(h_pre), delete(h_sigint), delete(h_camera) ;
    end
    
    % display the frame index
    if (~isappdata(handles.axes3,'stopPlot'))
        String_1 = ['Previewing ' str{val} ' ...'];
        String_2 = 'The Scenario includes 3 SIGINT sensors (red ''+''), 1 video sensor (yellow ''x'') ... ';
        String_3 = strcat('Frame_', num2str(i_iter));
        Output_String = char({String_1, String_2, String_3});
        set(handles.State_Text,'String', Output_String);
    end
end

if (~isappdata(handles.axes3,'stopPlot')) % no stop signal, run as usual, otherwise skip the enable in this button
    % display the frame index
    set(handles.State_Text,'String', char({[str{val} ' preview'], 'Done!!',['Num. Frame is ' num2str(i_iter) '.']}));
    
    % change the flag
    handles.flag_axes4 = true;  % approach select would not affect the display
    
    % enable all buttons which possibly interupt the code
    set(handles.Approach_Sel,'Enable', 'on');
    set(handles.Scenario_Sel,'Enable', 'on');
    set(handles.Scenario_Preview,'Enable', 'on');
    set(handles.Rest_Button,'Enable', 'on');
    
    % restore the buttons of run&alg and MSE
    if (flag_run_alg)
        set(handles.Run_Alg, 'Enable', 'on');
%         set(handles.MSE_button, 'Enable', 'off');
    end
%     if (flag_MSE_button)
%         set(handles.MSE_button, 'Enable', 'on');
%     end
else
    rmappdata(handles.axes3,'stopPlot'); % delete the stop signal
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Rest_Button.
function Rest_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Rest_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.axes3,'stopPlot',1);
% Update handles structure
guidata(hObject, handles);

Lag_Time = 0.3; % time for lagging disable

% reset all items
%%%% State Text Box 
set(handles.State_Text,'String', 'Toolbox is Starting Over ...'); pause(Lag_Time);
%%%% Two Video Windows
set(handles.axes3, 'Visible', 'off'); cla (handles.axes3); pause(Lag_Time);% turn off the visible of axes for video display
set(handles.axes4, 'Visible', 'off'); cla (handles.axes4); pause(Lag_Time);% turn off the visible of axes for error

%%%%% buttons state
set(handles.Approach_Sel,'Value', 1);
set(handles.Approach_Sel,'Enable', 'off');
set(handles.Run_Alg,'Enable', 'off');
% set(handles.MSE_button,'Enable', 'off');
set(handles.MSE_text,'String', '');
handles.MSE_VALUE = -1; % reset MSE result
pause(Lag_Time);

%%%%% Scenario Input Panel
set(handles.Scenario_Preview,'Enable', 'off');
d = {' ', ' ' , ' ', ' ', ''};
set(handles.Scenario_Table, 'Data', d);
set(handles.Scenario_Sel,'Value', 1);
set(handles.Scenario_Sel,'Enable', 'on');
handles.image = 0 ;
handles.vehicle = 0; 
handles.vehicle_est = 0; 

pause(2*Lag_Time);
set(handles.State_Text,'String', ' ');

% reset the flag 
handles.flag_axes4 = false; 
handles.index_scenario = 0; 

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in Approach_Sel.
function Approach_Sel_Callback(hObject, eventdata, handles)
% hObject    handle to Approach_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Approach_Sel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Approach_Sel

% select the approaches
str = get(hObject, 'String');
val = get(hObject,'Value');

if (strcmp(str{val},'Please Select ...')) % no approach is selected
    set(handles.Run_Alg,'Enable', 'off');
    %  set(handles.MSE_button,'Enable', 'off');
    % update the state box
    set(handles.State_Text,'String', 'No selected approach, please select one ...');
else
    switch str{val};
        case 'Approach 1 - Joint Sparsity Support Recovery Approach'
            % run the algorithm 1 and load the result
            % update the state box
            set(handles.State_Text,'String', 'Approach 1 - Joint Sparsity Support Recovery Approach, is selected.');
            
            % load the MSE result
            if (handles.index_scenario)
            String_path = ['case' num2str(handles.index_scenario) '/MSE_1'];
            handles.MSE_data = load(String_path);
            String_path_2 = ['case' num2str(handles.index_scenario) '/vehicle_est_1'];
            handles.vehicle_est = load(String_path_2);
            end
                    
        case 'Approach 2 - Joint Manifold Learning Approach' %
            % run the algorithm 2 and load the result
            % update the state box
            set(handles.State_Text,'String', 'Approach 2 - Joint Manifold Learning Approach, is selected.');
            
            % load the MSE result
            if (handles.index_scenario)
                String_path = ['case' num2str(handles.index_scenario) '/MSE_2'];
                handles.MSE_data = load(String_path);
                String_path_2 = ['case' num2str(handles.index_scenario) '/vehicle_est_2'];
                handles.vehicle_est = load(String_path_2);
            end
        case 'Approach 3 - Model Based Estimation Approach'
            set(handles.State_Text,'String', 'Approach 2 - Joint Manifold Learning Approach, is selected.');
            
            % load the MSE result
            if (handles.index_scenario)
                String_path = ['case' num2str(handles.index_scenario) '/MSE_3'];
                handles.MSE_data = load(String_path);
                String_path_2 = ['case' num2str(handles.index_scenario) '/vehicle_est_3'];
                handles.vehicle_est = load(String_path_2);
            end
      
    end
    set(handles.Run_Alg,'Enable', 'on');
end
% no MSE result yet
set(handles.MSE_text,'String', '');
% set(handles.MSE_button,'Enable', 'off'); 
if (~handles.flag_axes4) % check the flag, then determine what to deal with axes4
    set(handles.axes3, 'Visible', 'off'); cla (handles.axes3);% turn off the visible of axes for video display
end

set(handles.axes4, 'Visible', 'off'); cla (handles.axes4);% turn off the visible of axes for error
% for the case that reset button is pressed during the preview or run, need
% to clear the stopPlot flag.
if (isappdata(handles.axes3,'stopPlot'))
    rmappdata(handles.axes3,'stopPlot'); % delete the stop signal
end


% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Approach_Sel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Approach_Sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Run_Alg.
function Run_Alg_Callback(hObject, eventdata, handles)
% hObject    handle to Run_Alg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear axes and MSE result
cla (handles.axes3); cla (handles.axes4);
handles.MSE_VALUE = -1;

% pause a short interval
interval_disp = 0.01;
pause(2* interval_disp);
% disable all button which possibly interupt the code
% set(handles.MSE_button,'Enable', 'off');
set(handles.Approach_Sel,'Enable', 'off');
set(handles.Scenario_Sel,'Enable', 'off');
set(handles.Scenario_Preview,'Enable', 'off');
% set(handles.Rest_Button,'Enable', 'off');
set(handles.Run_Alg,'Enable', 'off');

% show the instantaneous result
set(handles.axes3, 'Visible', 'on'); % turn on the visible of axes for video display
set(handles.axes4, 'Visible', 'on');% turn on the visible of axes for error


% find the name of the approaches
str = get(handles.Approach_Sel, 'String');
val = get(handles.Approach_Sel,'Value');

% preprocess the image data
% 3 std dev scaling
cax = mean(handles.image.I_new(:)) + std(handles.image.I_new(:)).*[-3 3];

% grid 
x_grid = (handles.video.video.settings.coordLowerRight(1)- handles.video.video.settings.coordLowerLeft(1) )/size(handles.image.I_new(:,:,1),2);
y_grid = (handles.video.video.settings.coordUpperLeft(2)-handles.video.video.settings.coordLowerLeft(2))/size(handles.image.I_new(:,:,1),1);

if (handles.index_scenario==1)
    add_grid_x = ceil(0/x_grid ); % case 1, no need to show extra on the right of the view of the camera
else
    add_grid_x = ceil(80/x_grid); % case 2 & 3, the 2nd car start from the right hand side of the view of camera
end
add_grid_y_top = ceil(60/y_grid);
add_grid_y_bottom =  ceil(60/y_grid);

Image_process = zeros(add_grid_y_bottom +size(handles.image.I_new(:,:,1),1) + add_grid_y_top,add_grid_x + size(handles.image.I_new(:,:,1),2));
Iter_Num = size(handles.image.I_new,3);

% vehicle num
vehiclesInSim = size(handles.vehicle_est.vehicles_est,1);
start = 1, Inter_Num = 599;
    if (handles.index_scenario==1) 
        start = 100, Iter_Num = 500;
    end

start = 100, Iter_Num = 500;
% animation figure

axes(handles.axes4);
xlim([start,Iter_Num]); ylabel('Error, meter'); xlabel('Frame'); grid on;
hold on;

axes(handles.axes3);
grid off; axis off;
hold on;

for i_iter = start: Iter_Num
    % put original image into the large frame
    Image_process(add_grid_y_top+1:1:size(handles.image.I_new(:,:,1),1)+add_grid_y_top,add_grid_x+1:end) = handles.image.I_new(:,:,i_iter);
    
    if (isappdata(handles.axes3,'stopPlot')) % check the flag, true, keep going, false, stop
        break;
    end
    
    h_pre = imagesc([handles.video.video.settings.coordLowerLeft(1)-x_grid*add_grid_x  handles.video.video.settings.coordLowerRight(1)],...
        [handles.video.video.settings.coordUpperLeft(2)+y_grid*add_grid_y_top  handles.video.video.settings.coordLowerLeft(2)-y_grid*add_grid_y_bottom],...
        Image_process,cax);
    colormap(gray); axis xy; axis off; axis tight;
    
    % mark the estimated result
    hold on;
    for vv = 1:vehiclesInSim
        h_veh = plot(handles.vehicle_est.vehicles_est(vv,i_iter).location.meters(1),...
            handles.vehicle_est.vehicles_est(vv,i_iter).location.meters(2),...
            'gs');
    end
    if (handles.index_scenario==1)
        h= plot(handles.axes4, handles.MSE_data.Frame_index(start:i_iter),handles.MSE_data.Inst_Error(start:i_iter),'-r.');
    else
        h= plot(handles.axes4, handles.MSE_data.Frame_index(1:i_iter),handles.MSE_data.Inst_Error_1(1:i_iter),'-r.', ...
            handles.MSE_data.Frame_index(1:i_iter),handles.MSE_data.Inst_Error_2(1:i_iter),'-k.');
%         legend(handles.axes4,'Target_1','Target_2','Location','Best');
        
    end

    drawnow;
%     pause(interval_disp);
    if (i_iter~= Iter_Num && ~isappdata(handles.axes3,'stopPlot')) 
        delete (h), delete( h_veh) ; delete (h_pre) ;
    end;
    % display the frame index
    if (~isappdata(handles.axes3,'stopPlot'))
        String_1 = strcat(str{val}, ' is running ...');
        String_2 = 'The estimated Target position is marked in the green box. ';
        String_3 = strcat('Frame_', num2str(i_iter));
        Output_String = char({String_1, String_2, String_3});
        set(handles.State_Text,'String', Output_String);
    end
end

if (~isappdata(handles.axes3,'stopPlot')) % no stop signal, run as usual, otherwise skip the enable in this button
    
    % display the frame index
    set(handles.State_Text,'String', char({str{val}, 'Done!!',['Num. Frame is ' num2str(i_iter)]}));
    
    % pause a short interval
    pause(2* interval_disp);
    % enable the MSE button
%     set(handles.MSE_button,'Enable', 'on');
    % re-enable the buttons
    set(handles.Approach_Sel,'Enable', 'on');
    set(handles.Scenario_Sel,'Enable', 'on');
    set(handles.Scenario_Preview,'Enable', 'on');
    set(handles.Rest_Button,'Enable', 'on');
    set(handles.Run_Alg,'Enable', 'on');
    
    % Calculate MSE value
    if (handles.index_scenario==1)
        handles.MSE_VALUE = mean(abs(handles.MSE_data.Inst_Error(100:500)).^2);
    else
        handles.MSE_VALUE(1) = mean(abs(handles.MSE_data.Inst_Error_1(100:500)).^2);
        handles.MSE_VALUE(2) = mean(abs(handles.MSE_data.Inst_Error_2(100:500)).^2);
    end
    
    
    if (handles.MSE_VALUE(1) >=0)
        if (handles.index_scenario==1)
            set(handles.MSE_text,'String', num2str(handles.MSE_VALUE));
        else
            result_MSE = char({num2str(handles.MSE_VALUE(1)), num2str(handles.MSE_VALUE(2))});
            set(handles.MSE_text,'String', result_MSE);
        end
    end

    
    
    
    
    
    % change the flag
    handles.flag_axes4 = false;  % when change appraoch, axes4 will be cleared
    handles.flag_loop = true; % restore the flag for loop
    
else
    rmappdata(handles.axes3,'stopPlot'); % delete the stop signal
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in MSE_button.
% % % function MSE_button_Callback(hObject, eventdata, handles)
% % % % hObject    handle to MSE_button (see GCBO)
% % % % eventdata  reserved - to be defined in a future version of MATLAB
% % % % handles    structure with handles and user data (see GUIDATA)
% % % if (handles.MSE_VALUE(1) >=0)
% % %     if (handles.index_scenario==1)
% % %         set(handles.MSE_text,'String', num2str(handles.MSE_VALUE));
% % %     else
% % %         result_MSE = char({num2str(handles.MSE_VALUE(1)), num2str(handles.MSE_VALUE(2))});
% % %         set(handles.MSE_text,'String', result_MSE);
% % %     end
% % % end



function State_Text_Callback(hObject, eventdata, handles)
% hObject    handle to State_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of State_Text as text
%        str2double(get(hObject,'String')) returns contents of State_Text as a double


% --- Executes during object creation, after setting all properties.
function State_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to State_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(handles.model_compare_handle)
   
    handles.model_compare_handle = model_compare; 
%    warndlg('Please click Close Application button on GUI-3','!! Warning !!')
%     a =  (get(hObject, 'parent')); 
    guidata(hObject, handles); 
    delete(handles.output);
end


% --- Executes when user attempts to close figure1.


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
