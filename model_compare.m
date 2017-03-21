function varargout = model_compare(varargin)
% MODEL_COMPARE MATLAB code for model_compare.fig
%      MODEL_COMPARE, by itself, creates a new MODEL_COMPARE or raises the existing
%      singleton*.
%
%      H = MODEL_COMPARE returns the handle to a new MODEL_COMPARE or the handle to
%      the existing singleton*.
%
%      MODEL_COMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODEL_COMPARE.M with the given input arguments.
%
%      MODEL_COMPARE('Property','Value',...) creates a new MODEL_COMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before model_compare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to model_compare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help model_compare

% Last Modified by GUIDE v2.5 16-Mar-2017 21:19:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @model_compare_OpeningFcn, ...
                   'gui_OutputFcn',  @model_compare_OutputFcn, ...
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

% --- Executes just before model_compare is made visible.
function model_compare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to model_compare (see VARARGIN)

axes(handles.iftcon)
IFTImage = imread('IFTLogo_Trans.jpg');
image(IFTImage)
axis off
axis image

axes(handles.afrlcon)
AFRLImage = imread('AFRL_icon.jpg');
image(AFRLImage)
axis off
axis image

axes(handles.axes1);
cla(handles.axes1,'reset')
cla;
axis off;
legend off;

axes(handles.axes5);
cla;
cla(handles.axes5,'reset');
axis off;
legend off;





% Choose default command line output for model_compare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using model_compare.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes model_compare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = model_compare_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes1);
cla;
legend off;
axis on;


popup_sel_index = get(handles.popupmenu1, 'Value');
switch popup_sel_index
    case 1
        axes(handles.axes5);
        cla;
        legend off;
        set(handles.axes5,'visible','off')
        axes(handles.axes1);
        handles.MSE1_jse = load('case1/MSE_1.mat');
        handles.MSE1_jml = load('case1/MSE_2.mat');
        handles.MSE1_mod = load ('case1/MSE_3.mat');

        f1h=plot(handles.axes1,handles.MSE1_jse.Frame_index(100:500),handles.MSE1_jse.Inst_Error(100:500),'-r.')
        hold on;
        f2h = plot(handles.axes1,handles.MSE1_jml.Frame_index(100:500),handles.MSE1_jml.Inst_Error(100:500),'-k.');

        f3h = plot(handles.axes1,handles.MSE1_mod.Frame_index(100:500),handles.MSE1_mod.Inst_Error(100:500),'-b.');

        legend(handles.axes1,'Joint Sparsity Support Recovery','Joint Manifold Learning','Model Based Estiamtion');
        f1h.LineWidth = 1;
        f2h.LineWidth =1;
        f3h.LineWidth =1;
     
        ah = gca;
        ah.LineWidth = 1.5;
        ah.FontSize = 12;
        xlabel('Frame Index (n)');
        ylabel('Estimation Error');
        grid;

    case 2
        axes(handles.axes1);
        handles.MSE2_jse = load('case2/MSE_1.mat');
        handles.MSE2_jml = load('case2/MSE_2.mat');
        handles.MSE2_mod = load('case2/MSE_3.mat');
        axes(handles.axes1);
        cla;
        axis on;

        title('Target_1');
        plot( handles.MSE2_jse.Frame_index(100:500), handles.MSE2_jse.Inst_Error_1(100:500),'-r','LineWidth',1);
        
        hold on;
        plot( handles.MSE2_jml.Frame_index(100:500), handles.MSE2_jml.Inst_Error_1(100:500),'-k','LineWidth',1);
        plot( handles.MSE2_mod.Frame_index(100:500), handles.MSE2_mod.Inst_Error_1(100:500),'-b','LineWidth',1);
        grid;
        ah = gca;
        ah.LineWidth = 1.5;
        ah.FontSize = 12;
        xlabel('Frame Index (n)');
        ylabel('Estimation Error');
        
        legend(handles.axes1,'Joint Sparsity Support Recovery','Joint Manifold Learning','Model Based Estiamtion');
        axes(handles.axes5);
        cla;
        axis on;
        
        plot(handles.MSE2_jse.Frame_index(100:500), handles.MSE2_jse.Inst_Error_2(100:500),'-r','LineWidth',1);
        hold on;
        plot(handles.MSE2_jml.Frame_index(100:500), handles.MSE2_jml.Inst_Error_2(100:500),'-k','LineWidth',1);
        
        plot(handles.MSE2_mod.Frame_index(100:500), handles.MSE2_mod.Inst_Error_2(100:500),'-b','LineWidth',1);
        ah = gca;
        ah.LineWidth = 1.5;
        ah.FontSize = 12;
        title('Target_2')
        xlabel('Frame Index (n)');
        ylabel('Estimation Error');
        grid;
        legend(handles.axes5,'Joint Sparsity Support Recovery','Joint Manifold Learning','Model Based Estiamtion');

end
    
        guidata(hObject, handles);
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Sim1', 'sim5'});


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Main_handle = IFT_Toolbox_Heterogeneous_Data_Fusion;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
