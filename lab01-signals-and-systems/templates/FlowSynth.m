%% FlowSynth -- student version
%  Applied Signal Processing, FH JOANNEUM
%  based on MatSynth by KalMa #MatFunZone (2018), maciej.kalarus@gmail.com
%  modified by Florian Mayer, florian.mayer@fh-joanneum.at
%
%  Use the keyboard or the mouse to play.
%  Use the mouse to change the amplitude profile and the shape of the waves.
%
%  Everything you have to do is marked with TODO in CreateSamples() at the
%  bottom of this file. The synthesizer starts and runs before you change
%  anything -- it is simply silent until you have filled in the shapes.

function FlowSynth

    close all
    clearvars -global Synth
    global Synth

    Name                    = 'TheFlowsSynth';
    Version                 = 2.0;

    %% Tones
    RefTone                 = 440;                                      % [Hz] - reference tone (A)
    ToneId                  = -9:27;                                    % with respect to reference tone (0-A)
    ToneName                = {'C' 'C#' 'D' 'D#' 'E' 'F' 'F#' 'G' 'G#' 'A' 'A#' 'B'};
    Synth.Tones.Fs          = 16384;                                    % [Hz] - sampling frequency
    Synth.Tones.Frequency   = RefTone * 2.^(ToneId/12);                 % table of frequencies [Hz]
    Synth.Keyboard          = {'z' 'x' 'd' 'c' 'f' 'v' 'b' 'h' 'n' 'j' 'm' 'k' 'comma' 'period' 'semicolon' 'slash'};
    KeyboardMarker          = {'z' 'x' 'd' 'c' 'f' 'v' 'b' 'h' 'n' 'j' 'm' 'k' ','     '.'      ';'         '/'};
    Synth.Tones.Sample      = cell(size(ToneId));
    Synth.T                 = 0.45;                                     % sound duration [s]

    %% Keys
    Key(1)                  = struct('X',[-0.5 0.5 0.5 -0.5], 'Y',[0 0 3 3], 'Color','white');
    Key(2)                  = struct('X',[-0.4 0.4 0.4 -0.4], 'Y',[1 1 3 3], 'Color','black');
    KeyName                 = ToneName(mod(ToneId+9,12)+1);
    KeyColorId              = cellfun(@(x) (length(x)==2)+1, KeyName);  % 1-white, 2-black
    Synth.KeyboardToneId    = (1-length(Synth.Keyboard):0) + find(strcmp(KeyName,'D'),1,'last');

    %% Board
    KeyScale        = 40;
    Size            = [sum(KeyColorId==1)+1, 3] * KeyScale + [0 60];
    Color           = [0 0.6 0.8];
    BackgroundColor = [1 1 1];

    %% Application window
    ScreenSize = get(0,'ScreenSize');
    figure( 'Units','pixels',...
            'Renderer','painters',...
            'Position',[(ScreenSize(3:4) - Size)*0.5, Size] + [0 0 10 27],...
            'MenuBar','none',...
            'NumberTitle','off',...
            'Resize','off',...
            'Color',BackgroundColor,...
            'Name',Name,...
            'KeyPressFcn',@(~,evt)KeyPress(evt.Key));

    axes( 'Units','pixels',...
          'Position',[5 5 Size],...
          'NextPlot','add',...
          'box','on',...
          'Color',Color,...
          'xlim',[0 Size(1)],...
          'ylim',[0 Size(2)],...
          'XTick',[],...
          'YTick',[]);

    title(sprintf('%s v%0.1f', Name, Version));

    %% Create keyboard
    nTone           = length(ToneId);
    KeyBoard(nTone) = matlab.graphics.primitive.Patch;
    X = KeyScale;
    for i = 1:nTone
        cid = KeyColorId(i);
        x = X + (Key(cid).X - (cid==2)*0.5)*KeyScale;
        y = 5 + Key(cid).Y*KeyScale;
        KeyBoard(i) = patch(x,y,Key(cid).Color,'ButtonDownFcn',@(~,~)MousePress(i));
        if (cid==1), uistack(KeyBoard(i),'bottom'); end
        text(mean(x(1:2)),y(1)+12,KeyName{i},'Color',Key(3-cid).Color,...
             'HorizontalAlignment','center','PickableParts','none');
        id = find(Synth.KeyboardToneId==i);
        if ~isempty(id)
            text(mean(x(1:2)),y(1)+30,KeyboardMarker{id},'Color',[0.5 0.5 0.5],...
                 'HorizontalAlignment','center','PickableParts','none');
        end
        X = X + (cid==1)*KeyScale;
    end

    text([120;120],Size(2)-[15;35],{'shape:','amplitude profile:'},...
         'HorizontalAlignment','right','FontWeight','bold');
    Synth.hShape     = text((130:90:400)',ones(4,1)*(Size(2)-15),...
                       {'sinus','square','3 sin','triangle'},...
                       'ButtonDownFcn',@(src,~)ChangeShape(src));
    Synth.hAmplitude = text((130:90:220)',ones(2,1)*(Size(2)-35),...
                       {'constant','descending'},...
                       'ButtonDownFcn',@(src,~)ChangeAmplitude(src));

    %% Initial settings
    Synth.ToneShapeId       = 1;
    Synth.ToneAmplitudeId   = 1;
    CreateSamples();
end

% =========================================================================
function ChangeShape(src)
    global Synth
    Synth.ToneShapeId = find(Synth.hShape==src);
    CreateSamples();
end

function ChangeAmplitude(src)
    global Synth
    Synth.ToneAmplitudeId = find(Synth.hAmplitude==src);
    CreateSamples();
end

% =========================================================================
%  THIS IS THE ONLY FUNCTION YOU HAVE TO TOUCH
% =========================================================================
function CreateSamples()
    global Synth
    set([Synth.hShape; Synth.hAmplitude],'Color','black');
    set([Synth.hShape(Synth.ToneShapeId); Synth.hAmplitude(Synth.ToneAmplitudeId)],'Color','yellow');

    dFs = Synth.Tones.Fs;                 % sampling frequency [Hz]
    iN  = round(dFs * Synth.T);           % number of samples of one tone

    %% amplitude profile
    switch Synth.ToneAmplitudeId
        case 1                                      % constant
            vAmp = ones(1, iN);
        case 2                                      % descending
            vAmp = linspace(1, 0, iN);
    end

    %% ---------------------------------------------------------------- TODO 1
    %  Build the time vector for one tone: iN samples taken at the sampling
    %  rate dFs.
    %  HINT: sample number n belongs to the time instant n/dFs, n = 0...iN-1.
    %        Do not use linspace(0,Synth.T,iN) -- compare the sample spacing
    %        of both versions and you will see why.
    vt = zeros(1, iN);                              % <-- replace this

    for i = 1:length(Synth.Tones.Sample)

        dF = Synth.Tones.Frequency(i);              % frequency of this key [Hz]

        %% ------------------------------------------------------------ TODO 2
        %  The argument of the oscillator for this tone, i.e. omega*t.
        va = zeros(1, iN);                          % <-- replace this

        switch Synth.ToneShapeId

            case 1                                  % ------------- TODO 3: sine
                vs = zeros(1, iN);                  % <-- replace this

            case 2                                  % ----------- TODO 4: square
                vs = zeros(1, iN);                  % <-- replace this

            case 3                                  % ------ TODO 5: three sines
                vs = zeros(1, iN);                  % <-- replace this

            case 4                                  % --------- TODO 6: triangle
                %  How do you build a triangle from sine waves? Which
                %  harmonics do you need, and with which amplitudes?
                %  Careful with the highest keys: harmonics above dFs/2
                %  do not disappear, they fold back.
                vs = zeros(1, iN);                  % <-- replace this

        end

        %% normalise, so that all shapes are equally loud
        if max(abs(vs)) > 0
            vs = vs / max(abs(vs)) * 0.8;
        end

        Synth.Tones.Sample{i} = vs .* vAmp;
    end
end

% =========================================================================
function MousePress(ToneId)
    global Synth
    PlayTone(ToneId);
end

function KeyPress(key)
    global Synth
    id = find(ismember(Synth.Keyboard,key));
    if ~isempty(id)
        ToneId = Synth.KeyboardToneId(id);
        if (ToneId>0)
            PlayTone(ToneId);
        end
    end
end

function PlayTone(ToneId)
    global Synth
    vs = Synth.Tones.Sample{ToneId};
    if isempty(vs) || max(abs(vs)) == 0
        return                                      % nothing implemented yet
    end
    sound(vs, Synth.Tones.Fs);
end
