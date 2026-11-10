# Computer Laboratory 1 & 2 — Discrete-Time Signals and Systems

FH JOANNEUM — Applied Signal Processing

**→ [Before you start](../NOTE.md)**

> **For every exercise in which audio examples are played, start with a low
> volume.**

---

## Contents

- [0. Writing a MATLAB function](#0-writing-a-matlab-function)
  - [A function lives in its own file](#a-function-lives-in-its-own-file)
  - [Several inputs and several outputs](#several-inputs-and-several-outputs)
  - [Where MATLAB looks for it](#where-matlab-looks-for-it)
  - [Package folders: +](#package-folders-)
  - [Naming convention used in this course](#naming-convention-used-in-this-course)
  - [Test it immediately](#test-it-immediately)
- [Example 1: Special Signals](#example-1-special-signals)
- [Example 2: Representation of DT Signals](#example-2-representation-of-dt-signals)
- [Example 3: Convolution](#example-3-convolution)
- [Example 4: Sounds](#example-4-sounds)
- [Example 5: Pre-Processing filter](#example-5-pre-processing-filter)
- [Example 6: Discrete-Time Fourier Transform — Implementation](#example-6-discrete-time-fourier-transform--implementation)
- [Example 7: Discrete-Time Fourier Transform — A Tuner](#example-7-discrete-time-fourier-transform--a-tuner)

## 0. Writing a MATLAB function

Almost every task below asks you to *write a function*. If you have only ever
written scripts, start here.

### A function lives in its own file

The file name and the function name must be identical. A function
`convASP` goes into a file called `convASP.m`:

```matlab
function [vconOut] = convASP(vInput1, vInput2)
%CONVASP  Convolution of two finite-length sequences.
%
%   vconOut = convASP(vInput1, vInput2) returns the linear convolution
%   of the two input vectors.

    % ... your code here ...
    vconOut = ...;
end
```

- Everything after `function` up to `end` is the body.
- The names in brackets on the left are what the function *returns*, the
  names in parentheses are what it *receives*.
- The comment block directly under the `function` line is what `help convASP`
  will print. Write it — you will thank yourself in three weeks.

### Several inputs and several outputs

```matlab
function [vxe, vxo] = analyzeSignal(vn, vx)
```

Called like this:

```matlab
[vEven, vOdd] = analyzeSignal(vn, vx);   % both outputs
vEven         = analyzeSignal(vn, vx);   % only the first one
```

### Package folders: `+`
 
A folder whose name begins with `+` is a **package**, a namespace of its own.
Collect your own functions in one:
 
```
lab01-signals-and-systems/
├── firstLAB.md
└── +asp/
    ├── delta.m
    ├── step.m
    ├── convASP.m
    └── analyzeSignal.m
```
 
You then call them with the package name in front:
 
```matlab
vd = asp.delta(vn);
vy = asp.convASP(vx, vh);
```
 
Three things to know:
 
1. **Put the *parent* of `+asp` on the path, never `+asp` itself.** In the
   layout above that is the lab folder. Adding the `+asp` folder directly does
   not work and MATLAB warns about it.
2. Inside the package, your functions call each other **without** the prefix —
   `convASP.m` can simply write `delta(vn)`.
3. `help asp.convASP` and `doc asp.convASP` work exactly as for any other
   function.
The prefix is also the point: `asp.median` and the built-in `median` can
coexist peacefully. Nothing of yours can ever shadow anything of MATLAB's.

### Naming convention used in this course

The function signatures in this assignment use a prefix for the data type.
Please keep to it — it makes your code readable in the delivery interview:

| Prefix | Meaning | Example |
|---|---|---|
| `v` | vector | `vx`, `vn`, `vw` |
| `m` | matrix | `mX` |
| `d` | scalar, double | `dFs`, `dAlpha` |
| `i` | scalar, integer | `iN`, `iLength` |
| `b` | boolean | `bLinear` |
| `s` | string | `sNote` |
| `c` | cell array | `cSystems` |

### Test it immediately

Write the function, then check it against something you already trust —
a hand-calculated example, or a MATLAB built-in:

```matlab
vx = [1 5 -1 6 3];
vh = [1 2 1];
norm(convASP(vx,vh) - conv(vx,vh), 2)     % should be 0, or very close
```

If that number is not essentially zero, fix the function before moving on.

---

## Example 1: Special Signals

Investigate in the MATLAB functions `ones`, `zeros`, `find` using MATLAB help
— these functions could indeed be useful.

Special signals play a crucial role in DSP. They are used to determine the
impulse response and they support the representation of signals. In this very
first task, implement the delta function and the step function as standalone
functions:

$$\delta[n] = \begin{cases} 1, & \text{if } n = 0 \\ 0, & \text{if } n \neq 0 \end{cases}
\qquad\qquad
u[n] = \begin{cases} 1, & \text{if } n \geq 0 \\ 0, & \text{if } n < 0 \end{cases}$$

$\qquad\qquad\qquad\qquad\qquad\qquad\qquad\qquad$ for $-20 \leq n \leq 20$.

> **HINT:** Try to use a generated $n$ vector, which consists of the indices,
> as the input for the two functions.

After your implementation, test your functions and `stem` the following
signals, all for $-20 \leq n \leq 20$:

**(a)** $\delta[n+1]$, $\quad \delta[n-3]$, $\quad \delta[n+6]$

**(b)** $u[n+5]$, $\quad u[n]$, $\quad u[n-3]$

**(c)** $3\delta[n+1] + n^2\left(u[n+5]-u[n+4]\right) + 10(0.5)^n$

> **HINT:** Every one of these signals can be built from `delta` and `step`
> alone, without a single `if` and without a loop. Two steps subtracted from
> each other give you a window — that is the trick behind most of them.

---

## Example 2: Representation of DT Signals

Investigate in the MATLAB functions `imag`, `real`, `fliplr`, `circshift`
using MATLAB help.

Use the signal

$$x[n] = (-0.2 + j0.3)^n \sin\left(\tfrac{\pi}{4}n\right)\left(u[n+3]-u[n-5]\right)$$

for the following tasks.

**(a)** Write a function `[vxe,vxo] = analyzeSignal(vn,vx)` which calculates
the even part $x_e[n]$ and the odd part $x_o[n]$ of the signal $x[n]$.

**(b)** Plot the real part and the imaginary part of $x_e[n]$. Does the result
agree with your expectations?

**(c)** Plot the real part and the imaginary part of $x_o[n]$. Does the result
agree with your expectations?

**(d)** Apply the function `analyzeSignal(vn,vx)` to the signals
$x_r[n] = \Re(x[n])$ and $jx_i[n] = j\Im(x[n])$.

**(e)** Plot the signals $x_{r,e}[n]$ and $x_{r,o}[n]$. Do the results agree
with (b) and (c)? Why or why not?

**(f)** Plot the signals $x_{i,e}[n]$ and $x_{i,o}[n]$. Do the results agree
with (b) and (c)? Why or why not?

---

## Example 3: Convolution

Investigate in the MATLAB functions `audioread`, `sound` using MATLAB help.

For a given input signal $x[n] = [1,5,-1,6,3]$ and a system output signal
$y[n] = 3x[n]-4x[n-2]+6x[n-4]$, compute the convolution of two vectors.

**(a)** Determine the impulse response $h[n]$ of the given system,
analytically.

**(b)** Write a function `[vconOut] = convASP(vInput1, vInput2)` which
calculates the convolution of the input vectors. Compare your results with the
built-in MATLAB function `conv`.

**(c)** Generate the following impulse response

$$h_{ech}[n] = \sum_{k=0}^{\infty}\alpha^k\,\delta(n-kN)$$

for $\alpha = 0.7$ and $N = 4$, for $-20 \leq n \leq 20$.

**(d)** Investigate the audio file [`files/aclarinet.mp3`](files/aclarinet.mp3)
and load it into your workspace using `audioread`. What is the sampling rate of
the loaded signal? How many samples are needed to represent $1\,\text{s}$, or
$100\,\text{ms}$? Investigate and try the function `sound` — what happens if
you replay the same (already loaded) file with a different sampling rate?

**(e)** Load [`files/aclarinet.mp3`](files/aclarinet.mp3) into your workspace
using `audioread` and compute the convolution with the generated impulse
response $h_{ech}$. At the beginning, just use the first $2$ seconds of the
sound file. Set $N$ to a number of samples for $100\,\text{ms}$, or
$200\,\text{ms}$. Play the result using `sound`. What do you notice? After
that, set the values $\alpha$ and $N$ to your own desire. How could we speed
up the convolution itself? This effect just appears to be offline.

---

## Example 4: Sounds

Investigate in the MATLAB functions `linspace`, `sum`, `sin` using MATLAB help.

The creation of signals or sounds is sometimes a great approach to test
computed systems — or just to have fun. In order to generate *oscillating*
sounds we need to consider the following:

- The sampling frequency of the signal; let us consider $f_s = 16384\,\text{Hz}$.
- A proper duration vector $t$ in order to create the time instances for each
  sample. Its length is the duration of the tone multiplied by the number of
  samples per second.
- In order to create an oscillating signal we need an oscillator $\omega$ as well.

**(a)** Create the following sounds at $440\,\text{Hz}$ for a sampling
frequency $f_s = 16384\,\text{Hz}$ with a duration of $T = 0.5\,\text{s}$:

$$\text{Sine wave:}\quad y(t) = \sin(\omega t)$$

$$\text{Square wave:}\quad y(t) = \begin{cases} 0.6, & \text{if } \sin(\omega t) > 0 \\ 0, & \text{if } \sin(\omega t) < 0 \end{cases}$$

$$\text{3 sine waves:}\quad y(t) = 0.6\sin(\omega t) + 0.3\sin(2\omega t) + 0.1\sin(4\omega t)$$

`plot` each sound and listen to it, if you want to, using `sound`. How could a
triangular wave be implemented?

> **HINT:** Use the Fourier applet to see which cosines and sines, and which
> of their harmonics, are used to create the signal.

**(b)** Take [`templates/FlowSynth.m`](templates/FlowSynth.m) and spend some
time to see what happens in it. Place your generated sounds at the positions
marked with `TODO` so that they can be used in the synthesizer GUI. Is it
possible to add the triangular wave as well? What needs to be modified for
practical use?

**(c)** Play along, if you want to, and have fun.

---

## Example 5: Pre-Processing filter

Investigate in the MATLAB functions `filter`, `median`, `conv` using MATLAB
help.

Smoothing suppresses what is unimportant in a measurement (i.e. noise), so
that the trend becomes visible. The three classic smoothers are:

$$\text{Moving Average Filter:}\quad y[n] = \frac{1}{L}\sum_{k=0}^{L-1}x[n-k]$$

$$\text{Median Filter:}\quad y[n] = \begin{cases} \tilde{x}_{\frac{L+1}{2}} & \text{if } L \text{ is odd} \\[4pt] \frac{1}{2}\left(\tilde{x}_{\frac{L}{2}} + \tilde{x}_{\frac{L}{2}+1}\right) & \text{if } L \text{ is even} \end{cases}$$

where $\tilde{x}$ is the sorted window $\left(x[n-L+1],\ldots,x[n]\right)$.

$$\text{Weighted Moving Average Filter:}\quad y[n] = \sum_{k=-K}^{K}w_k\,x[n-k] \quad\text{with}\quad w_k = \tfrac{1}{8},\tfrac{1}{4},\tfrac{1}{4},\tfrac{1}{4},\tfrac{1}{8}$$

```matlab
% MATLAB built-in test data
load bostemp
days = (1:31*24)/24;
plot(days, tempC), axis tight
xlabel('Time elapsed from Jan 1, 2011 (days)'), ylabel('Temp (\circC)')
title('Logan Airport Dry Bulb Temperature (source: NOAA)')
```

**(a)** The moving average is the simplest low pass FIR filter: it averages
$L$ input samples into one output sample. Create a function
`myMovingAverage(signal, sampleLength)` to smooth the measurement results, and
compare it with the following:

```matlab
% Moving average filter
hoursPerDay = 24;
coeff24hMA  = ones(1, hoursPerDay)/hoursPerDay;
avg24hTempC = filter(coeff24hMA, 1, tempC);
plot(days,[tempC avg24hTempC])
```

**(b)** The median filter slides a window over the signal and takes the median
of its values. It is useful against random noise with large outliers, which a
moving average would smear out instead of removing. Create a function
`myMedianFilt(signal, sampleLength)` to smooth the measurement results.

**(c)** In a weighted moving average the samples enter and leave the window
gradually instead of at full weight, which yields a smoother trend. Create a
function `myWeightedMA(signal, sampleLength, weights)` to smooth the
measurement results. The weights have to sum to one and be symmetric,
$w_{-k} = w_k$ — choose your own. Compare with the following:

```matlab
% Weighted moving average filter
h = [1/2 1/2];
binomialCoeff = conv(h,h);
for n = 1:4
    binomialCoeff = conv(binomialCoeff,h);
end
figure
fDelay     = (length(binomialCoeff)-1)/2;
binomialMA = filter(binomialCoeff, 1, tempC);
plot(days,tempC,days-fDelay/24,binomialMA)
```

**(d)** A filter is linear if superposition holds,

$$\mathcal{H}\{\alpha x_1[n] + \beta x_2[n]\} = \alpha\,\mathcal{H}\{x_1[n]\} + \beta\,\mathcal{H}\{x_2[n]\}$$

Test your three functions with random signals $x_1[n]$, $x_2[n]$ and random
scalars $\alpha$, $\beta$, and report the largest deviation for each one. One
of the three is not linear — find a short pair of input signals that proves it
by hand. Does homogeneity,
$\mathcal{H}\{\alpha x[n]\} = \alpha\,\mathcal{H}\{x[n]\}$, still hold for
that filter?

**(e)** Compare your three filter results. Which filter could fit to which
application, and which of the three can be described by an impulse response
$h[n]$ at all?

---

## Example 6: Discrete-Time Fourier Transform — Implementation

**(a)** Implement the discrete-time Fourier transform
`[vX] = computeDTFT(vn,vx,vw)` without using a loop. Consider the general form
of the DTFT:

$$X(\omega) = \sum_{n=-\infty}^{\infty}x[n]\,e^{-j\omega n}$$

**(b)** Compute the DTFT for the given input signal $x[n] = [1,5,-1,6,3]$
using your function `computeDTFT`. Plot your result. Does the result agree
with your expectations? Why or why not?

**(c)** Compare your function with the MATLAB command `fft` for the signal
$x[n]$. Do the results agree? What are the restrictions on $n$ and
$\omega_k$? How can you modify the signals or the results so that both
calculations agree? You can use the command `norm(vX1-vX2,2)` to calculate the
Euclidean norm between the two results.

---

## Example 7: Discrete-Time Fourier Transform — A Tuner

Investigate in the MATLAB functions `audiowrite`, `audioread`, `sound`,
`linspace`, `max`, `audiorecorder` using MATLAB help.

Musical distance is measured in cents: one semitone is $100$ cents, one octave
$1200$. The deviation of a frequency $f$ from a reference $f_\mathrm{ref}$ is

$$\Delta = 1200\,\log_2\left(\frac{f}{f_\mathrm{ref}}\right)\ \text{cents}$$

A tuner has to be accurate to a few cents — at $A_4 = 440\,\text{Hz}$ that is
$0.25\,\text{Hz}$.

**(a)** Generate a sine of $440\,\text{Hz}$ with $f_s = 44.1\,\text{kHz}$,
$1\,\text{s}$ long and with an amplitude of $0.8$. Save it as `a440.wav` using
`audiowrite`, listen to it with `sound` and read it back in with `audioread`.
Why is the signal from the file not identical to the one in your workspace?

**(b)** Analyse the file with your function `computeDTFT`, using
`vw = linspace(0,pi,2000)`. Plot $\lvert X(\omega)\rvert$ over
$f = \omega f_s/(2\pi)$ and give the deviation of the maximum from
$440\,\text{Hz}$ in cents. Compare the spacing of your $\omega$ grid with the
resolution $f_s/N$ — which of the two limits your result?

**(c)** Evaluate the DTFT a second time, now only within $\pm 20\,\text{Hz}$
around that maximum, again with $2000$ points. What is the deviation in cents
now, and what do you get with $\pm 1\,\text{Hz}$? Why can `fft` not do this, no
matter how much you zero-pad? Put the procedure into a function
`[dF0,dCents] = aspTuner(vx,dFs,dFref)`.

**(d)** Extend `aspTuner` so that it also recognises *which* note was played —
you do not have to tell it. Instead of storing a table of all notes, use that
equal temperament is geometric: the nearest note lies

$$m = \mathrm{round}\left(12\log_2\left(\frac{f}{f_\mathrm{ref}}\right)\right)$$

semitones from the reference, its frequency is
$f_m = f_\mathrm{ref}\,2^{m/12}$, and the deviation from it is again measured
in cents. Note that $f_\mathrm{ref}$ is the concert pitch
($A_4 = 440\,\text{Hz}$), which anchors the whole grid — it is not the note
you are playing. Return `[dF0,dCents,sNote]` and check that `dCents` always
stays within $\pm 50$. Can your tuner decide by itself whether an orchestra
tunes to $440$ or to $443\,\text{Hz}$?

> **HINT:** The twelve note names repeat every octave, so the name follows
> from $m$ modulo $12$ and the octave number from the integer division.

**(e)** What does your tuner display for a tone that is $51$ cents sharp, and
is that answer wrong? What does it display if your frequency estimate is off by
exactly one octave — and why is that case far more dangerous than the first
one?

**(f)** Run your `aspTuner` on the instrument recordings in
[`files/recordings/`](files/recordings/). The spectrum now has several peaks
and the tone decays — which peak, and which part of the recording, do you use?
State for each recording how far the instrument is out of tune, in cents. One
of them fools a tuner that simply takes the largest peak. Which one, and by how
much?

**(g)** Before you go live, measure what your two options cost. Time your
`computeDTFT` against `fft` using `tic`/`toc` or `timeit`, once for a full scan
over $0\ldots\pi$ and once for the narrow zoom of task (c). Count the
operations as well: the direct DTFT needs $N\cdot K$ terms for $K$ frequency
points, the FFT about $N\log_2 N$. For which $K$ is which one faster, how much
memory does the matrix $e^{-j\omega n}$ occupy for $N = 44100$ and $K = 2000$,
and could you reach the resolution of task (c) with `fft` alone? Decide from
your own measurements which of the two you use in the next task.

**(h) Bonus — live.** Record blocks with `audiorecorder` and `recordblocking`
inside a loop, run `aspTuner` on every block and print note and cents
continuously. Play a tuning tone from your phone, or bring your instrument.
Find a suitable block length yourself: try several and justify your choice —
what fails if the block is too short, and what if it is too long? What does
your tuner report in the pauses when nobody plays, and how do you stop the
display from jumping around?

**(i)** *Hey Doc, I took the Fourier transform of my cat and now it won't come
back to the time domain.* Analyse an animal sound the same way — record your
own, or take one from [`files/recordings/`](files/recordings/). Does it have a
pitch at all? Compare two short windows from different points in time and
explain why a single DTFT over the whole file tells you so little.

![FourierCat](https://imgs.xkcd.com/comics/fourier.jpg)
