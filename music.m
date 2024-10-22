  % 创建主窗口
fig = figure('Name', 'Music Generator', 'NumberTitle', 'on', 'Position', [100, 100, 700, 400]);
%--------------------------------------------------------------------------组件-------------------------------------------------------------------------------------------------

%---------------创建钢琴块组件------------------
for i=1:35
    handles.(sprintf('white%d',i)) = uicontrol('Style', 'pushbutton','BackgroundColor','white', 'Position', [(i-1)*20,200,20,150], 'Callback', {@click, fig, i});
end
for i=1:35
    if ~ismember(i, [3,7,10,14,17,21,24,28,31,35,38])
        handles.(sprintf('black%d',i)) = uicontrol('Style', 'pushbutton', 'BackgroundColor','black','Position', [(i-1)*20+10,250,15,100], 'Callback', {@click_, fig, i});
    end
end

%-------------UI界面中的图片-------------------
% 读取指定图片
handles.image_data = imread('sign.jpg!con');
% 在GUI窗口中插入图像
axes('Units', 'pixels', 'Position', [440, 365, 20, 20]);
imshow(handles.image_data);
handles.image = imread('dllgb.jpg');
% 在GUI窗口中插入图像
axes('Units', 'pixels','Position', [650, 350, 50, 50]);
imshow(handles.image);
%文本"音乐工作室"
handles.title=uicontrol('Style', 'text', 'String', '音乐工作室', 'Position', [500, 360, 140,30],'FontSize',17);
set(handles.title,'FontName', '方正姚体','FontWeight', 'bold', 'FontAngle', 'italic');%设置字体为斜体、加粗等

%------------------播放、暂停、保存组件------------------
handles.play=uicontrol('Style', 'pushbutton', 'String', '播放','Position', [20,100,50,30],'Callback',{@play_,fig});
handles.pause=uicontrol('Style', 'pushbutton', 'String', '暂停','Position', [100,100,50,30],'Callback',{@pause_,fig});
handles.save=uicontrol('Style', 'pushbutton', 'String', '保存','Position', [180,100,50,30],'Callback',{@save_,fig});
set(handles.pause,'Enable','off');%初始状态，暂停按钮设置为不可用
% 创建延音功能组件
handles.checkbox = uicontrol('Style', 'checkbox', 'String', '延音', 'Value', 0, ...
    'Position', [395, 356, 40, 30], 'Callback', {@sustion,fig});
%--------------------------------------混响功能组件-----------------------------
handles.reverb_label = uicontrol('Style', 'checkbox', 'String', '混响', ...%混响功能开关组件
    'Position', [50, 50, 80, 30], 'Callback', {@reverb_,fig});
handles.predelay_label = uicontrol('Style', 'text', 'String', 'PreDelay', ...
    'Position', [110, 50, 50, 20]);
handles.predelay=uicontrol('Style','edit','Position', [165,55, 50,15],'Callback',{@reverb_edit,fig});%predelay值编辑文本框组件
set(handles.predelay,'Enable','off')%初始状态设置为不可用，当混响功能开时，predelay值可以设置。
set(handles.predelay,'String',0.3)%初始值设置为0.3
set(handles.reverb_label,'FontSize',12)%设置文本字体
handles.wetdrymix_label = uicontrol('Style', 'text', 'String', 'WetDryMix', ...
    'Position', [220, 50, 60, 20], 'Callback', {@reverb_,fig});
handles.wetdrymix=uicontrol('Style', 'edit', 'Position', [285, 55, 50, 15],'Callback',{@reverb_edit,fig});%wetdrymix值文本编辑框组件
set(handles.wetdrymix,'Enable','off')%同上
set(handles.wetdrymix,'String',0.5)%初始值设置为0.2
%----------------------------------节拍器功能组件--------------------------------
option_beat={'无','四拍','三拍','六拍'};%节拍器功能选项
handles.beat_label=uicontrol('Style', 'text', 'String', '节拍器','Position', [300, 357, 40, 20]);
handles.beat = uicontrol('Style', 'popupmenu', 'String', option_beat,'Position', [340, 350, 50, 30], 'Callback', {@beat_,fig});%节拍器下拉选项栏组件
%--------------------------------乐器音色选择组件--------------------------
options_timbre={'钢琴','管乐','木琴','拨弦音'};%乐器选项组件
handles.timbre = uicontrol('Style', 'popupmenu', 'String', options_timbre,'Position',[200, 350, 100, 30], 'Callback', {@change_timbre ,fig});%乐器音色下拉选项栏组件
%-------------------------------音乐调式选择组件---------------
options_tone={'C大调','D大调','E大调','F大调','A大调','B大调'};
handles.tones = uicontrol('Style', 'popupmenu', 'String', options_tone,'Position',[100, 350, 100, 30], 'Callback', {@change_tone ,fig});%音乐调式下拉选项栏组件
%------------------------------歌曲选择组件------------------
songs={'卖报歌','小星星','粉刷匠(钢琴版)','天空之城'};
handles.songs = uicontrol('Style', 'popupmenu', 'String', songs,'Position',[250, 140, 100, 30], 'Callback', {@change_song ,fig});%歌曲选择下拉选项栏组件
%-------------当前播放音乐的歌曲名称文本----------------------
handles.textLabel = uicontrol('Style', 'text', 'String', '卖报歌', 'Position', [50, 150, 150,30 ],'FontSize',13);
set(handles.textLabel,'FontName', '宋体','FontWeight', 'bold','FontSize',13);%设置字体
%------------------时域分析按钮-------------
handles.fft=uicontrol('Style', 'pushbutton', 'String', '时域分析','Position', [250,100,100,30],'Callback',{@time_,fig});
%-----------------显示 钢琴按下的键块音阶--------------
handles.texttone=uicontrol('Style', 'text', 'String', '','Position', [460, 350, 40,30 ],'FontSize',9);
set(handles.texttone,'FontName', 'Arial','FontWeight', 'bold', 'FontAngle', 'italic');%设置字体
% ----------------------包络信号类型选择----------------------
handles.enve=1;
options_envelop={'ADSR包络','指数衰减包络','直线包络'};%包络信号类型选项
handles.envelop = uicontrol('Style', 'popupmenu', 'String', options_envelop,'Position',[9, 350, 90, 30], 'Callback', {@change_enve ,fig});
%----------------------------------------音调分析板块-------------------------------
handles.fft_label=uicontrol('Style', 'text', 'String', '音调分析', 'Position', [450, 160, 80, 20]);
set(handles.fft_label,'FontName', '宋体','FontWeight', 'bold','FontSize',13);
handles.syllable_label=uicontrol('Style', 'text', 'String', '音节序号', 'Position', [400, 100, 80, 20]);
handles.syllable= uicontrol('Style', 'edit', 'Position', [480, 100, 60, 20]);                                   %音节序号编辑栏
set(handles.syllable,'String',1);
handles.sy_btn=uicontrol('Style', 'pushbutton', 'String', '傅里叶分析','Position', [580,140,80,30],'Callback',{@fft_,fig});%进行FFT分析的按钮
handles.result_label=uicontrol('Style', 'text', 'String', '基频', 'Position', [400, 60, 80, 20]);
handles.result= uicontrol('Style', 'edit', 'Position', [480, 60, 60, 20]);                                      %通过FFT分析，得到当前音节的频率
set(handles.result,'Enable','off')
handles.truth_label=uicontrol('Style', 'text', 'String', '音阶', 'Position', [540, 60, 40, 20]);
handles.truth=uicontrol('Style', 'edit', 'Position', [580, 60, 40, 20]);                                        %通过乐曲和音节序号确定该音节的音阶
set(handles.truth,'Enable','off')
handles.key_label=uicontrol('Style', 'text', 'String', '调式', 'Position', [540, 100, 40, 20]);                  %通过该音阶的频率和音阶得到该乐曲的调式
handles.key=uicontrol('Style', 'edit', 'Position', [580, 100, 40, 20]);
set(handles.key,'Enable','off')
handles.second_result_label=uicontrol('Style', 'text', 'String', '频率2', 'Position', [400, 20, 80, 20]);         %乐曲可能存在的第二个频率（在粉刷匠歌中，我们无法具体分析一个音节，只能分析1s内存在的音节频率）
handles.second_result= uicontrol('Style', 'edit', 'Position', [480, 20, 60, 20]);
set(handles.second_result,'Enable','off');
handles.second_result.Visible='off';
handles.second_result_label.Visible='off';
handles.second_label=uicontrol('Style', 'text', 'String', '音阶', 'Position', [540, 20, 40, 20]);             %已知粉刷匠乐曲是C大调，通过频率可以确定乐曲的音阶
handles.second=uicontrol('Style', 'edit', 'Position', [580, 20, 40, 20]);
set(handles.second,'Enable','off')
handles.second.Visible='off';
handles.second_label.Visible='off';
%---------------------------------------------------全局变量--------------------------------------------
handles.player=0;%播放器
handles.ispause=0;%是否处于暂停状态
handles.isPlaying=0;%是否处于播放状态
handles.sust_value=0.0001;%ADSR包络下，延时参数
handles.attack=0.05;%冲激时间所占比例参数
handles.decay=0.9;%衰减时间所占比例参数
handles.relase=0.05;%释放时间所占比例
handles.reverb_value=0;%是否开启混响模式
handles.predelay_value=0.0;%混响模式下predelay值
handles.wetdrymix_value=0.0;%混响模式下wetdrymix值
handles.beat_value=0;%是否开启节拍器
handles.tone_value=1;%
%-------------------------------加载初始歌曲卖报歌----------------------
handles.song=[[5,0.5,4],[5,0.5,4],[5,1,4],[5,0.5,4],[5,0.5,4],[5,1,4],[3,0.5,4],[5,0.5,4],[6,0.5,4],[5,0.25,4],[3,0.25,4],[2,0.5,4],[3,0.5,4],[5,1,4],[5,0.5,4],[3,0.5,4],[5,0.5,4],[3,0.25,4],[2,0.25,4],[1,0.5,4],[3,0.5,4],[2,1,4],[3,0.5,4],[3,0.5,4],[2,1,4],[6,0.5,3],[1,0.5,4],[2,1,4],[6,1,4],[6,0.5,4],[5,0.5,4],[3,0.5,4],[6,0.5,4],[5,1,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[5,2,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[6,0.5,3],[1,0.5,4],[2,0.5,4],[3,0.5,4],[1,1,4],[0,0.5,0]];
y = [];
Fs=8192;%采样频率
n = length(handles.song);
for i = 1:3:n
    ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve,handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
    y = [y, ys];
end
audiowrite('output.wav',y,Fs)%写入存储当前歌曲的wav文件，
%------------------------------------------------------------回调函数---------------------------------------------------------------------------------------
guidata(fig,handles)
%---------------------点击白色琴块的回调函数----------------
function click(~, ~, fig, i)
    handles = guidata(fig);
    set(handles. (sprintf("white%d", i)), 'BackgroundColor', '#35D4CD');%在点击琴块时，琴块变色0.1s
    pause(0.1)
    if mod(i,7)~=0              %通过点击琴块的序号判断音阶，并根据当前的调式、音色、包络信号选择、延音、混响等发出正确的声音，音时默认为半拍
        y = gen_wave(mod(i,7), 0.5, floor(i/7)+2, handles.enve,handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        switch mod(i,7) %在UI页面中显示按下琴块的音阶
            case 1          %判断音阶
                set(handles.texttone,'String','do')
            case 2
                set(handles.texttone,'String','re')
            case 3
                set(handles.texttone,'String','mi')
            case 4
                set(handles.texttone,'String','fa')
            case 5
                set(handles.texttone,'String','so')
            case 6
                set(handles.texttone,'String','la')
        end
        switch floor(i/7)+2
            case 2         %判断八度
                set(handles.texttone,'String',(sprintf('--%s',get(handles.texttone,'String'))))
            case 3
                set(handles.texttone,'String',(sprintf('-%s',get(handles.texttone,'String'))))
            case 4
                set(handles.texttone,'String',(sprintf('%s',get(handles.texttone,'String'))))
            case 5
                set(handles.texttone,'String',(sprintf('%s+',get(handles.texttone,'String'))))
            case 6
                set(handles.texttone,'String',(sprintf('%s++',get(handles.texttone,'String'))))
        end
    else
        y = gen_wave(7, 0.5, floor(i/7)+1,handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        set(handles.texttone,'String','si')
    end
        sound(y)    %sound函数发出声音，与播放乐曲的play函数不同，实现多线程播放声音
    set(handles.(sprintf("white%d", i)), 'BackgroundColor', 'white');
    guidata(fig,handles)        %更新全局变量
end
%----------------点击黑色琴块的回调函数-----------------
function click_(~, ~, fig, i)
    handles = guidata(fig);
    set(handles.(sprintf("black%d", i)), 'BackgroundColor', '#35D4CD');
    pause(0.1)
    if mod(i,7)~=0              %同上白色琴块
        y = gen_wave_(mod(i,7), 0.5, floor(i/7)+2,handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        switch mod(i,7)
            case 1
                set(handles.texttone,'String','do#')
            case 2
                set(handles.texttone,'String','re#')
            case 4
                set(handles.texttone,'String','fa#')
            case 5
                set(handles.texttone,'String','so#')
            case 6
                set(handles.texttone,'String','la#')
        end
        switch floor(i/7)+2
            case 2
                set(handles.texttone,'String',(sprintf('--%s',get(handles.texttone,'String'))))
            case 3
                set(handles.texttone,'String',(sprintf('-%s',get(handles.texttone,'String'))))
            case 4
                set(handles.texttone,'String',(sprintf('%s',get(handles.texttone,'String'))))
            case 5
                set(handles.texttone,'String',(sprintf('%s+',get(handles.texttone,'String'))))
            case 6
                set(handles.texttone,'String',(sprintf('%s++',get(handles.texttone,'String'))))
        end
    else
        y = gen_wave_(7, 0.5, floor(i/7)+1,handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        set(handles.texttone,'String','si')
    end
        sound(y)
    set(handles.(sprintf("black%d", i)), 'BackgroundColor', 'black');
    guidata(fig,handles)%更新全局变量
end
%----------------------------延时功能------------------------
function sustion(src,~,fig)
    handles=guidata(fig);
    if get(src,'Value')>0.001
        handles.sust_value=0.09;%将延时参数调整至0.09
    else
        handles.sust_value=0.0001;
    end
    %disp(handles.sust_value)
    Fs=8192;
    y = []; 
    n = length(handles.song);
    % 生成双通道音频数据，由于混响模式的音频是双通道音频，所以此处可以把音频都当作双通道音频进行处理
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve, handles.tone_value, handles.sust_value, handles.attack, handles.decay, handles.relase, handles.predelay_value, handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到音频后方
        end
    end
    % 将双通道音频数据写入文件
    audiowrite('output.wav', y', Fs); %由于处理得到双音频数据维度发生调换，此处需要进行将矩阵转置
    if handles.isPlaying        %由于乐曲播放设置得到了修改，如果此时正在播放音乐，会请求将当前音乐停下来
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');%弹出消息框
        set(h, 'Position', [300, 300, 120, 50]);
        uiwait(h);% 等待用户点击确定按钮
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end 
    guidata(fig,handles)%更新全局变量
end
%--------------------修改乐器音色函数-------------------
function change_timbre(src,~,fig)
    handles=guidata(fig);
    handles.tone_value=get(src,'Value');%通过下拉框选择的乐器音色，设置Adsr包络对应的参数
    switch handles.tone_value
        case 1
            handles.sust_value=0.0001;
            handles.attack=0.05;
            handles.decay=0.9;
            handles.relase=0.05;
        case 2
            handles.sust_value=0.0001;
            handles.attack=0.9;
            handles.decay=0.05;
            handles.relase=0.05;
        case 3
            handles.sust_value=0.15;
            handles.attack=0.05;
            handles.decay=0.25;
            handles.relase=0.15;
        case 4
            handles.sust_value=0.05;
            handles.attack=0.05;
            handles.decay=0.05;
            handles.relase=0.05;
    end
    %------更新参数之后，应重新加载歌曲----------------
    y = [];
    Fs=8192;
    n = length(handles.song);
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到矩阵的右侧
        end
    end
    audiowrite('output.wav',y',Fs)
    if handles.isPlaying                                   %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles);
end
%--------------------修改乐曲调式----------------------
function change_tone(src,~,fig)
    handles=guidata(fig);
    handles.tone_value=get(src,'Value');%通过下拉选择栏得到当前选择的乐器调式
    %---------------修改乐曲调式后，重新加载乐曲---------------
    y = [];
    Fs=8192;
    n = length(handles.song);
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到矩阵的右侧
        end
    end
    audiowrite('output.wav',y',Fs)
    if handles.isPlaying          %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles)%更新全局变量
end
%------------------更改乐曲曲目---------------------
function change_song(src,~,fig)
    handles=guidata(fig);
    Fs=8192;
    switch get(src,'Value')%通过下拉选项栏的选择，得到当前选择的音乐曲目
        case 1      %当选择第一首歌，即卖报歌，加载歌曲
            handles.song=[[5,0.5,4],[5,0.5,4],[5,1,4],[5,0.5,4],[5,0.5,4],[5,1,4],[3,0.5,4],[5,0.5,4],[6,0.5,4],[5,0.25,4],[3,0.25,4],[2,0.5,4],[3,0.5,4],[5,1,4],[5,0.5,4],[3,0.5,4],[5,0.5,4],[3,0.25,4],[2,0.25,4],[1,0.5,4],[3,0.5,4],[2,1,4],[3,0.5,4],[3,0.5,4],[2,1,4],[6,0.5,3],[1,0.5,4],[2,1,4],[6,1,4],[6,0.5,4],[5,0.5,4],[3,0.5,4],[6,0.5,4],[5,1,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[5,2,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[5,0.5,4],[3,0.5,4],[2,0.5,4],[3,0.5,4],[6,0.5,3],[1,0.5,4],[2,0.5,4],[3,0.5,4],[1,1,4],[0,0.5,0]];
            y = [];
            n = length(handles.song);
            for i = 1:3:n
                ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
                % 将生成的音频数据填充到双通道音频矩阵中
                if isempty(y)
                    y = ys; % 第一次循环直接赋值
                else
                    y = [y, ys]; % 后续循环追加到矩阵的右侧
                end
            end
            audiowrite('output.wav',y',Fs);
            set(handles.textLabel,'String','卖报歌')
             %--------------------------打开一些可能被关闭功能的组件---------------------
            set(handles.checkbox,'Enable','on')
            set(handles.tones,'Enable','on')
            %disp(handles.enve)
            if handles.enve==1
                set(handles.timbre,'Enable','on')%当选择ADSR包络时，才能选择乐器音色和延时功能
            end
            set(handles.envelop,'Enable','on')
            set(handles.syllable_label,'String','音节序号');
            handles.second_result.Visible='off';
            handles.second_result_label.Visible='off';
            set(handles.key,'String','')
            handles.second.Visible='off';
            handles.second_label.Visible='off';
            set(handles.result,'String','')
            set(handles.truth,'String','')
            set(handles.second,'String','')
            set(handles.result_label,'String','基频')
            set(handles.second_result,'String','')
            set(handles.beat,'Enable','on')
        case 2
            %同上，此时选择的歌曲是小星星
            handles.song=[[1,1,4],[1,1,4],[5,1,4],[5,1,4],[6,1,4],[6,1,4],[5,1,4],[0,1,4],[4,1,4],[4,1,4],[3,1,4],[3,1,4],[2,1,4],[2,1,4],[1,1,4],[0,1,4],[5,1,4],[5,1,4],[4,1,4],[4,1,4],[3,1,4],[3,1,4],[2,1,4],[0,1,4],[5,1,4],[5,1,4],[4,1,4],[4,1,4],[3,1,4],[3,1,4],[2,1,4],[0,1,4],[1,1,4],[1,1,4],[5,1,4],[5,1,4],[6,1,4],[6,1,4],[5,1,4],[0,1,4],[4,1,4],[4,1,4],[3,1,4],[3,1,4],[2,1,4],[2,1,4],[1,1,4],[0,1,4]];
            set(handles.textLabel,'String','小星星')
            set(handles.reverb_label,'Enable','on')
            set(handles.wetdrymix,'enable','on')
            set(handles.predelay,'enable','on')
            y = [];
            n = length(handles.song);
            for i = 1:3:n
                ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
                % 将生成的音频数据填充到双通道音频矩阵中
                if isempty(y)
                    y = ys; % 第一次循环直接赋值
                else
                    y = [y, ys]; % 后续循环追加到矩阵的右侧
                end
            end
            audiowrite('output.wav',y',Fs)
            %--------------------同上，打开被关闭功能的组件--------
            set(handles.checkbox,'Enable','on')
            set(handles.tones,'Enable','on')
            if handles.enve==1
                set(handles.timbre,'Enable','on')
            end
            set(handles.envelop,'Enable','on')
            set(handles.syllable_label,'String','音节序号');
            handles.second_result.Visible='off';
            handles.second_result_label.Visible='off';
            set(handles.result_label,'String','基频')
            set(handles.key,'String','')
            set(handles.result,'String','')
            set(handles.truth,'String','')
            set(handles.second,'String','')
            set(handles.second_result,'String','')
            handles.second.Visible='off';
            handles.second_label.Visible='off';
            set(handles.beat,'Enable','on')
        case 3
            %当选择的歌曲是粉刷匠时，由于这首歌并不是电子合成的，而是导入的音频文件
            %所以我们无法使用一些歌曲合成的设置的组件，所以我们需要关闭这些组件的功能
            %在音调分析时，我们也无法对每一个音节序号进行分析，所以我们采用对1s内的音频序列进行，所以需要修改一些组件的设置
            [y,Fs] = audioread('2201班粉刷匠.m4a');
            set(handles.textLabel,'String','粉刷匠(钢琴版)')
            audiowrite('output.wav',y,Fs);
            set(handles.checkbox,'Enable','off');
            set(handles.tones,'Enable','off');
            set(handles.timbre,'Enable','off');
            set(handles.syllable,'String','');
            set(handles.envelop,'Enable','off');
            set(handles.syllable_label,'String','时刻/s');
            handles.second_result.Visible='on';
            handles.second_result_label.Visible='on';
            set(handles.key,'String','C大调')
            handles.second.Visible='on';
            handles.second_label.Visible='on';
            set(handles.result,'String','')
            set(handles.truth,'String','')
            set(handles.second,'String','')
            set(handles.second_result,'String','')
            set(handles.result_label,'String','频率1')
            set(handles.reverb_label,'Enable','off')
            set(handles.wetdrymix,'enable','off')
            set(handles.predelay,'enable','off')
            set(handles.reverb_label,'Value',0)
            set(handles.beat,'Enable','off')
            set(handles.beat,'value',1)
        case 4
             %同上，此时选择的歌曲是天空之城
            handles.song=[[0,1,4],[0,1,4],[0,1,4],[6,0.5,4],[7,0.5,4],[1,1.5,5],[7,0.5,4],[1,1,5],[3,1,5],[7,1,4],[0,1,4],[0,1,4],[3,0.5,4],[3,0.5,4],[6,2,4],[5,0.5,4],[6,1,4],[1,1,5],[5,1,4],[0,1,4],[0,1,4],[3,1,4],[4,1.5,4],[3,0.5,4],[4,1,4],[1,1,5],[3,1,4],[0,1,4],[0,0.5,4],[1,0.5,5],[1,0.5,5],[1,0.5,5],[7,1,4],[4,0.5,4],[4,1,4],[7,1,4],[7,1,4],[0,1,4],[0,1,4],[6,0.5,4],[7,0.5,4],[1,1.5,5],[7,0.5,4],[1,1,5],[3,1,5],[7,1,4],[0,1,4],[0,1,4],[3,0.5,4],[3,0.5,4],[6,1.5,4],[5,0.5,4],[6,1,4],[1,1,5],[5,1,4],[0,1,4],[0,1,4],[2,0.5,4],[3,0.5,4],[4,1,4],[1,0.5,5],[7,0.5,4],[7,0.5,4],[1,0.5,5],[1,1,5],[2,0.5,5],[2,0.5,5],[3,0.5,5],[1,0.5,5],[1,1,5],[0,1,4],[1,0.5,5],[7,0.5,4],[6,0.5,4],[6,0.5,4],[7,1,4],[5,1,4],[6,1,4],[0,1,4],[0,1,4],[1,0.5,5],[2,0.5,5],[3,1.5,5],[2,0.5,5],[3,1,5],[5,1,5],[2,1,5],[0,1,4],[0,1,4],[5,0.5,4],[5,0.5,4],[1,1.5,5],[7,0.5,4],[1,1,5],[3,1,5],[3,1,5],[0,1,4],[0,1,4],[0,1,4],[6,0.5,4],[6,0.5,4],[1,1,5],[7,1,4],[2,0.5,4],[2,0.5,4],[1,1.5,5],[5,0.5,4],[5,1,4],[0,1,4],[4,1,5],[3,1,5],[2,1,5],[1,1,5],[3,1,5],[0,1,5],[0,1,5],[3,1,5],[6,1,5],[0,1,4],[5,1,5],[5,1,5],[3,0.5,5],[2,0.5,4],[1,1,5],[0,1,4],[0,0.5,4],[1,0.5,5],[2,1,5],[1,0.5,5],[2,0.5,5],[2,1,5],[5,1,5],[3,1,5],[0,1,4],[0,1,4],[3,1,5],[6,1,5],[0,1,5],[5,1,5],[0,1,4],[3,0.5,5],[2,0.5,5],[1,1,5],[0,1,4],[0,0.5,4],[1,0.5,5],[2,1,5],[1,0.5,5],[2,0.5,5],[2,1,5],[7,1,4],[6,1,4],[0,1,4],[0,1,4],[6,0.5,4],[6,0.5,4]];
            set(handles.textLabel,'String','天空之城')
            set(handles.reverb_label,'Enable','on')
            set(handles.wetdrymix,'enable','on')
            set(handles.predelay,'enable','on')
            y = [];
            n = length(handles.song);
            for i = 1:3:n
                ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
                % 将生成的音频数据填充到双通道音频矩阵中
                if isempty(y)
                    y = ys; % 第一次循环直接赋值
                else
                    y = [y, ys]; % 后续循环追加到矩阵的右侧
                end
            end
            audiowrite('output.wav',y',Fs)
            %--------------------同上，打开被关闭功能的组件--------
            set(handles.checkbox,'Enable','on')
            set(handles.tones,'Enable','on')
            if handles.enve==1
                set(handles.timbre,'Enable','on')
            end
            set(handles.envelop,'Enable','on')
            set(handles.syllable_label,'String','音节序号');
            handles.second_result.Visible='off';
            handles.second_result_label.Visible='off';
            set(handles.result_label,'String','基频')
            set(handles.key,'String','')
            set(handles.result,'String','')
            set(handles.truth,'String','')
            set(handles.second,'String','')
            set(handles.second_result,'String','')
            handles.second.Visible='off';
            handles.second_label.Visible='off';
            set(handles.beat,'Enable','on')


    end
    if handles.isPlaying        %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles)%更新全局变量
end
%--------------------暂停/继续功能--------------------
function pause_(~,~,fig)
    handles=guidata(fig);
    if handles.ispause%当处于暂停状态，此时点击，继续播放歌曲
        resume(handles.player);%继续播放歌曲
        set(handles.pause,'String','暂停');%修改按钮上的文本
        set(handles.play,'String','停止');
        handles.isPlaying=1;%将是否播放状态变量置1
        handles.ispause=0;%暂停状态变量置0
    else               %当不处于暂停状态，此时点击，暂停播放乐曲
        pause(handles.player);%暂停播放歌曲
        set(handles.pause,'String','继续');%修改按钮上的文本
        handles.ispause=1;%将是否暂停状态变量置1
        handles.isPlaying=0;%播放状态变量置0
    end
    guidata(fig,handles)%更新全局变量
end
%---------------------播放/停止歌曲功能函数-----------------
function play_(~,~,fig)
    handles=guidata(fig);
    if handles.isPlaying==0%当不处于播放状态时，此时点击，开始播放歌曲
        [y, Fs] = audioread('output.wav');%读取当前要播放的歌曲文件
        handles.player=audioplayer(y,Fs);%audioplayer加载播放器
        play(handles.player)%开始播放歌曲
        set(handles.play,'String','停止');%修改按钮上的文本
        set(handles.pause,'String','暂停');
        handles.ispause=0;%暂停状态变量置0
        handles.isPlaying=1;%播放状态变量置1
        set(handles.pause,'Enable','on')%此时打开暂停按钮，允许暂停/继续播放歌曲
    else                  %当处于播放状态时，此时点击，停止播放歌曲
        stop(handles.player) %停止播放歌曲
        set(handles.play,'String','播放');%修改按钮上的文本
        set(handles.pause,'String','暂停');
        handles.ispause=1;%暂停状态变量置1
        handles.isPlaying=0;%播放状态变量置0
        set(handles.pause,'Enable','off')%此时关闭暂停功能，防止出错
    end
    guidata(fig,handles)%更新全局变量
end
%-------------------保存当前播放歌曲至指定目录下------------------
function save_(~,~,fig)
    handles=guidata(fig);
    % 读取音频文件（示例中使用wav文件）
    [audio, fs] = audioread('output.wav');
    % 弹出保存对话框，选择保存目录和文件名
    [filename, pathname] = uiputfile('*.wav', 'Save Audio File');
    % 如果用户取消保存操作，则返回
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    % 构建完整的保存路径
    fullpath = fullfile(pathname, filename);
    % 将音频文件保存至选定目录和文件名
    audiowrite(fullpath, audio, fs);
    h = msgbox('保存成功', '提示', 'modal');%弹出消息框，代表保存成功
    set(h, 'Position', [300, 300, 120, 50]);
    guidata(fig,handles)%更新全局变量
end
%------------绘制当前歌曲的音频序列图，帮助分析音频特点----------------
function time_(~,~,fig)
    handles=guidata(fig);
    [Y,Fs] = audioread('output.wav'); 
    Y=Y(:,1); 
    figure,plot(Y);%绘图
    guidata(fig,handles);%更新全局变量
end
%---------------对FFT变换后的音频序列进行音调分析-------------
function fft_(~,~,fig)
    handles=guidata(fig);
    if get(handles.songs,'Value')==3%当此时歌曲为粉刷匠时，我们此时分析的是指定秒内的音频信息
        [Y,Fs] = audioread('output.wav'); 
        i=str2double(get(handles.syllable,'String'));%从edit框中读取选择的时间
        Y1=Y((i-1)*94500+1:94500*(i));%得到该时间下的音频序列
        figure,subplot(2,1,1) 
        plot(Y1); %绘图
        subplot(2,1,2) 
        f=-Fs/2:Fs/2-1; 
        plot(f,fftshift(abs(fft(Y1,Fs))));%并作fft变换后，作fft变换后的频谱图
        Y1_fft=fftshift(abs(fft(Y1,Fs)));
        [maxVal, maxIdx] = max(Y1_fft); %寻找当前时间处于峰值的频率，为音节1对应的频率
        Y1_fft(maxIdx)=0; % 将基频置零，以便找到第二高峰，即找到此时刻可能出现音节2对应的频率
        [secondMaxVal, secondMaxIdx] = max(Y1_fft);
        fundamentalFreq = abs(f(maxIdx));
        fundamentalFreq_second = abs(f(secondMaxIdx));
        while abs(fundamentalFreq_second-fundamentalFreq)<16%由于同一音节可能进行fft变换后，出现频率相近的多组频率，我们直接找到并不是音节2对应的频率，此时我们需要设置两个音节频率差的阈值，找到正确的音节2频率
            Y1_fft(secondMaxIdx)=0;
            [secondMaxVal, secondMaxIdx] = max(Y1_fft);
            fundamentalFreq_second = abs(f(secondMaxIdx));
        end
        set(handles.result,'String',(sprintf('%dHZ',abs(fundamentalFreq))));%更新频率文本框
        set(handles.second_result,'String',(sprintf('%dHZ',abs(fundamentalFreq_second))))
        tones=[130,146,164,174,196,220,246,262,293,329,349,392,440,493,523,587,659,698,784,880,987];
        % 在已知乐曲调式的情况下，我们通过频率就可以得出该音节的音阶是什么
        [minDiff, idx] = min(abs(tones -abs(fundamentalFreq)));
        switch mod(idx,7)%------通过计算，得到音阶，并在UI页面中显示
            case 1
                set(handles.truth,'String','do')
            case 2
                set(handles.truth,'String','re')
            case 3
                set(handles.truth,'String','mi')
            case 4
                set(handles.truth,'String','fa')
            case 5
                set(handles.truth,'String','so')
            case 6
                set(handles.truth,'String','la')
        end
        switch floor(idx/7)+1
            case 1
                set(handles.truth,'String',(sprintf('-%s',get(handles.truth,'String'))))
            case 2
                set(handles.truth,'String',(sprintf('%s',get(handles.truth,'String'))))
            case 3
                set(handles.truth,'String',(sprintf('%s+',get(handles.truth,'String'))))
        end
        %---------------第二个音节寻找音阶的方法同理-----------
        [minDiff, idx] = min(abs(tones -abs(fundamentalFreq_second)));
        switch mod(idx,7)
            case 1
                set(handles.second,'String','do')
            case 2
                set(handles.second,'String','re')
            case 3
                set(handles.second,'String','mi')
            case 4
                set(handles.second,'String','fa')
            case 5
                set(handles.second,'String','so')
            case 6
                set(handles.second,'String','la')
        end
        switch floor(idx/7)+1
            case 1
                set(handles.truth,'String',(sprintf('-%s',get(handles.truth,'String'))))
            case 2
                set(handles.truth,'String',(sprintf('%s',get(handles.truth,'String'))))
            case 3
        end
    %当此时播放的歌曲是电子合成时，我们需要对指定音节序号的音调进行分析，
    else
        [Y,Fs] = audioread('output.wav'); 
        Y=Y(:,1);
        i=str2double(get(handles.syllable,'String'));
        disp(handles.song(i*3-2))
        disp(handles.song(i*3))
        switch handles.song(i*3-2)
            case 1
                set(handles.truth,'String','do')
            case 2
                set(handles.truth,'String','re')
            case 3
                set(handles.truth,'String','mi')
            case 4
                set(handles.truth,'String','fa')
            case 5
                set(handles.truth,'String','so')
            case 6
                set(handles.truth,'String','la')
        end
        switch handles.song(i*3)
            case 2
                set(handles.truth,'String',(sprintf('--%s',get(handles.truth,'String'))))
            case 3
                set(handles.truth,'String',(sprintf('-%s',get(handles.truth,'String'))))
            case 4
                set(handles.truth,'String',(sprintf('%s',get(handles.truth,'String'))))
            case 5
                set(handles.truth,'String',(sprintf('%s+',get(handles.truth,'String'))))
            case 6
                set(handles.truth,'String',(sprintf('%s++',get(handles.truth,'String'))))
        end
        k=sum(handles.song(2:3:((i-1)*3)));%通过音节序号，我们需要结合所有音节的音时确定对应的音频序列
        Y1=Y(8192*(k)+1:8192*(k)+8192*(handles.song(i*3-1)));%获取选择音节序号的音频序列
        figure,subplot(2,1,1) 
        plot(Y1); %绘制该音频序列图
        subplot(2,1,2) 
        f=-Fs/2:Fs/2-1; 
        plot(f,fftshift(abs(fft(Y1,Fs))));%对音频序列进行fft变换，并绘制频谱图
        %同理，确定频谱图的峰值对应的是该音节的频率
        [maxVal, maxIdx] = max(fftshift(abs(fft(Y1,Fs)))); 
        fundamentalFreq = f(maxIdx);
        %disp(['Fundamental frequency: ' num2str(abs(fundamentalFreq)) ' Hz']);
        set(handles.result,'String',(sprintf('%dHZ',abs(fundamentalFreq))));
        switch get(handles.tones,'Value')
            case 1
                set(handles.key,'String','C大调');
            case 2
                set(handles.key,'String','D大调');
            case 3
                set(handles.key,'String','E大调');
            case 4
                set(handles.key,'String','F大调');
            case 5
                set(handles.key,'String','A大调');
            case 6
                set(handles.key,'String','B大调');
        end
    end
    guidata(fig,handles);%更新全局变量
end
%---------------修改包络信号类型-----------
function change_enve(~,~,fig)
    handles=guidata(fig);
    handles.enve=get(handles.envelop,'Value');%获取当前选择的包络信号类型
    if handles.enve~=1        %当选择直线包络、指数衰减包络无法实现修改乐器音色，所以关闭组件功能
        % 禁用下拉框
        set(handles.timbre,'Enable','off');
    else
        set(handles.timbre,'Enable','on');
    end
    %修改设置后，重新加载当前乐曲
    y = [];
    Fs=8192;
    n = length(handles.song);
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2),handles.enve, handles.tone_value, handles.sust_value,handles.attack,handles.decay,handles.relase,handles.predelay_value,handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到矩阵的右侧
        end
    end
    audiowrite('output.wav',y',Fs)
    if handles.isPlaying      %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles)%更新全局变量
end
%--------------------开启混响模式-------------------
function reverb_(src,~,fig)
    handles=guidata(fig);
    handles.reverb_value=get(src,'Value');
    if handles.reverb_value==1%开始混响模式
        set(handles.predelay,'Enable','on')%允许设置predelay与wetdrymix值
        set(handles.wetdrymix,'Enable','on')
        handles.predelay_value=str2double(get(handles.predelay,'string'));
        handles.wetdrymix_value=str2double(get(handles.wetdrymix,'string'));
        %修改设置后，需要重新加载当前歌曲
        Fs=8192;
        y = []; % 初始化一个空矩阵
        n = length(handles.song);
        % 生成双通道音频数据
        for i = 1:3:n
            ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve, handles.tone_value, handles.sust_value, handles.attack, handles.decay, handles.relase, handles.predelay_value, handles.wetdrymix_value,handles.beat_value);
            % 将生成的音频数据填充到双通道音频矩阵中
            if isempty(y)
                y = ys; % 第一次循环直接赋值
            else
                y = [y, ys]; % 后续循环追加到矩阵的右侧
            end
        end
        % 将双通道音频数据写入文件
        audiowrite('output.wav', y', Fs); % 注意这里需要将矩阵转置，使得每一列代表一个通道
    else              %关闭混响模式
        set(handles.predelay,'Enable','off')%不允许修改predelay与wetdrymix
        set(handles.wetdrymix,'Enable','off')
        handles.predelay_value=0;%这些参数置0
        handles.wetdrymix_value=0;
        Fs=8192;        %重新加载乐曲
        y = []; % 初始化一个空矩阵
        n = length(handles.song);
        % 生成双通道音频数据
        for i = 1:3:n
            ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve, handles.tone_value, handles.sust_value, handles.attack, handles.decay, handles.relase, handles.predelay_value, handles.wetdrymix_value,handles.beat_value);
            y = [y, ys];
        end
        % 将双通道音频数据写入文件
        audiowrite('output.wav', y', Fs); % 注意这里需要将矩阵转置，使得每一列代表一个通道
    end
    if handles.isPlaying        %同上
            h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
            set(h, 'Position', [300, 300, 120, 50]);
            % 等待用户点击确定按钮
            uiwait(h);
            handles.isPlaying=0;
            play_(handles.play,[],fig)
    end
    guidata(fig,handles);%更新全局变量
end
%-------------修改predelay与wetdrymix参数----------------
function reverb_edit(~,~,fig)
    handles=guidata(fig);
    handles.predelay_value=str2double(get(handles.predelay,'string'));
    handles.wetdrymix_value=str2double(get(handles.wetdrymix,'string'));
    %修改设置，重新加载歌曲
    Fs = 8192;
    y = []; % 初始化一个空矩阵
    n = length(handles.song);
    % 生成双通道音频数据
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve, handles.tone_value, handles.sust_value, handles.attack, handles.decay, handles.relase, handles.predelay_value, handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到矩阵的右侧
        end
    end
    % 将双通道音频数据写入文件
    audiowrite('output.wav', y', Fs); % 注意这里需要将矩阵转置，使得每一列代表一个通道
    if handles.isPlaying        %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles);
end
%------------------开启节拍器模式-------------
function beat_(src,~,fig)
    handles=guidata(fig);
    %通过下拉框选择使用节拍器的拍数
    switch get(src,'Value')
        case 1
            handles.beat_value=0;
        case 2
            handles.beat_value=4;
        case 3
            handles.beat_value=3;
        case 4
            handles.beat_value=6;
    end
    %修改设置，重新加载歌曲
    Fs = 8192;
    y = []; % 初始化一个空矩阵
    n = length(handles.song);
    % 生成双通道音频数据
    for i = 1:3:n
        ys = gen_wave(handles.song(i), handles.song(i+1), handles.song(i+2), handles.enve, handles.tone_value, handles.sust_value, handles.attack, handles.decay, handles.relase, handles.predelay_value, handles.wetdrymix_value,handles.beat_value);
        % 将生成的音频数据填充到双通道音频矩阵中
        if isempty(y)
            y = ys; % 第一次循环直接赋值
        else
            y = [y, ys]; % 后续循环追加到矩阵的右侧
        end
    end
    % 将双通道音频数据写入文件
    audiowrite('output.wav', y', Fs); % 注意这里需要将矩阵转置，使得每一列代表一个通道
    if handles.isPlaying           %同上
        h = msgbox('已修改设置，请重新播放音乐', '提示', 'modal');
        set(h, 'Position', [300, 300, 120, 50]);
        % 等待用户点击确定按钮
        uiwait(h);
        handles.isPlaying=0;
        play_(handles.play,[],fig)
    end
    guidata(fig,handles);
end
