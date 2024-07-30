function y=gen_wave_(tone,rythm,octave,enve,key,sustion,attack,decay,relase,predelay,wetdrymix,beat)
    Fs=8192;
    freqs_all=[16.352,18.354,20.602,21.0827,24.500,27.501,20.868];
    base=freqs_all(key);
    freqs=[base*2^(1/12)*2^(octave),base*2^(1/4)*2^(octave),0,base*2^(2/3)*2^(octave),base*2^(3/4)*2^(octave),base*2^(5/6)*2^(octave),0];
    %disp(freqs(tone));
    x=linspace(0,2*pi*rythm,floor(Fs*rythm));
    if tone==0
        switch enve
            case 1
                if predelay==0
                    y=sin(0);
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);%添加空间混响效果。
                    y=reverb(sin(0)')';
                end
            case 2
                if predelay==0
                    y=sin(0);
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(0)')';
                end
            case 3
                if predelay==0
                    y=sin(0);
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(0)')';
                end
        end
    else
        switch enve
            case 1
                if predelay==0
                    %disp('这不是混响音效')
                    y=adsr(attack,decay,sustion,relase,sin(freqs(tone)*x),x);
                else 
                    %disp('这是混响音效')
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(adsr(attack,decay,sustion,relase,sin(freqs(tone)*x),x)')';
                end
            case 2
                if predelay==0
                    y=sin(freqs(tone)*x).*(exp((-x)/(rythm*2*pi)));
                else
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(freqs(tone)*x).*(exp((-x)/(rythm*2*pi)))')';
                end
            case 3
                if predelay==0
                    y=sin(freqs(tone)*x).*(1-x/(rythm*2*pi));
                else 
                    reverb = reverberator('PreDelay', predelay, 'WetDryMix', wetdrymix);
                    y=reverb(sin(freqs(tone)*x).*(1-x/(rythm*2*pi))')';
                end
        end
    end
 