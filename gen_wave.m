function y=gen_wave(tone,rythm,octave,enve,key,sustion,attack,decay,relase,predelay,wetdrymix,beat)
    Fs=8192;
    freqs_all=[16.352,18.354,20.602,21.0827,24.500,27.501,20.868];%各调式基频频率
    base=freqs_all(key);%获取选择调式的基频
    %得到当前调式各音阶的频率
    freqs=[base*2^(octave),base*2^(1/6)*2^(octave),base*2^(1/3)*2^(octave),base*2^(5/12)*2^(octave),base*2^(7/12)*2^(octave),base*2^(3/4)*2^(octave),base*2^(11/12)*2^(octave)];
    %disp(tone)
    %disp(freqs(tone));
    x=linspace(0,2*pi*rythm,floor(Fs*rythm));
    if tone==0        %如果音节为0，代表停顿，此时并不发出声音，
        switch enve
            case 1
                if predelay==0                
                    if beat==0
                        y=sin(0).*(exp((-x)/(rythm*2*pi)));
                    else
                        beator = square(2*pi*6*beat);
                        y=sin(0).*beator.*(exp((-x)/(rythm*2*pi)));
                    end
                else
                    if beat==0
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);%添加空间混响效果。
                        y=reverb(sin(0).*(exp((-x)/(rythm*2*pi)))')';
                    else
                        beator = square(2*pi*6*beat);
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);%添加空间混响效果。
                        y=reverb(sin(0).*beator.*(exp((-x)/(rythm*2*pi)))')';
                    end
                end
            case 2
                if predelay==0
                    y=sin(0).*(exp((-x)/(rythm*2*pi)));
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(0).*(exp((-x)/(rythm*2*pi)))')';
                end
            case 3
                if predelay==0
                    y=sin(0).*(1-x/(rythm*2*pi));
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(0).*(exp((-x)/(rythm*2*pi)))')';
                end
        end
    else %此时音阶不为0，根据设置的参数发出声音，返回音频序列
        switch enve
             %----------------------------------使用ADSR包络--------------
            case 1                                                                     
                if predelay==0      
                    if beat==0
                        %disp('这不是混响音效')
                        y=adsr(attack,decay,sustion,relase,sin(freqs(tone)*x),x);
                        %disp(size(y))
                    else
                        beator = square(x*beat);
                        y=adsr(attack,decay,sustion,relase,sin(freqs(tone)*x).*beator,x);
                    end
                    %----------------------开启混响模式-----------------
                else                
                    if beat==0
                        %disp('这是混响音效')
                        %定义混响器，生成混响的音频数据，此时为二通道音频
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                        y=reverb(adsr(attack,decay,sustion,relase,sin(freqs(tone)*x),x)')';
                        %disp(size(y))
                    else
                        %-----------开启节拍器模式---------
                        beator = square(x*beat);    %定义发出节拍器的声音信号
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                        %生成具有节拍器的音频序列
                        y=reverb(adsr(attack,decay,sustion,relase,sin(freqs(tone)*x).*beator,x)')';
                    end
                end
            %--------------------------------使用指数衰减包络--------------------
            case 2
                if predelay==0
                    if beat==0
                        y=sin(freqs(tone)*x).*(exp((-x)/(rythm*2*pi)));
                    else
                        beator = square(x*beat);
                        y=sin(freqs(tone)*x).*beator.*(exp((-x)/(rythm*2*pi)));
                    end
                else
                    if beat==0
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                        y=reverb(sin(freqs(tone)*x).*(exp((-x)/(rythm*2*pi)))')';
                    else
                        beator = square(x*beat);
                        y=sin(freqs(tone)*x).*beator.*(exp((-x)/(rythm*2*pi)));
                    end
                end
            case 3
                if predelay==0
                    if beat==0
                        y=sin(freqs(tone)*x).*(1-x/(rythm*2*pi));
                    else
                        beator = square(x*beat);
                        y=sin(freqs(tone)*x).*beator.*(1-x/(rythm*2*pi));
                    end
                else 
                    if beat==0
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                        y=reverb(sin(freqs(tone)*x).*(1-x/(rythm*2*pi))')';
                    else 
                        beator = square(x*beat);
                        reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                        y=reverb(sin(freqs(tone)*x).*beator.*(1-x/(rythm*2*pi))')';
                    end
                end
        end
    end
 