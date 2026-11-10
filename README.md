# Applied Signal Processing — Computer Laboratory

FH JOANNEUM — University of Applied Sciences
Electronics and Computer Engineering
Florian Mayer · <florian.mayer@fh-joanneum.at>

---

## Read this first

**→ [Before you start](NOTE.md)**

Please read that page before the first exercise. It is short, and it explains
what these exercises are actually for.

---

## Laboratory blocks

| Block | Topic | Assignment |
|---|---|---|
| 1 & 2 | Discrete-Time Signals and Systems | [lab01-signals-and-systems](lab01-signals-and-systems/README.md) |

---

## What you need

### MATLAB

Any release from R2019b onwards will do. The exercises use only features that
have been stable for years.

### Toolboxes

You need **one** toolbox beyond base MATLAB:

| Toolbox | Needed for |
|---|---|
| **Signal Processing Toolbox** | `xcorr`, `chirp`, `findpeaks`, `hann`, and the `bostemp` data set used in Example 5 |

Everything else — `audioread`, `audiowrite`, `sound`, `audiorecorder`,
`conv`, `deconv`, `filter`, `median`, `toeplitz`, `fft` — is part of base
MATLAB. You do **not** need the Audio Toolbox or the DSP System Toolbox.

Check what you have installed:

```matlab
ver                                  % lists every installed toolbox
license('test','Signal_Toolbox')     % 1 = Signal Processing Toolbox available
```

If it is missing, install it from the MATLAB desktop:
**Home → Add-Ons → Get Add-Ons**, search for *Signal Processing Toolbox*.
It is covered by the university campus licence.

### Finding help

MATLAB's own documentation is better than anything you will find elsewhere,
and it is available offline:

```matlab
help findpeaks        % short description in the command window
doc findpeaks         % full page with examples in the Help browser
doc                   % opens the documentation home
docsearch('window')   % full-text search across the documentation
```

Every task in this laboratory begins with a line listing the functions you
will need. Start by reading their documentation — the examples at the bottom
of each page are usually the fastest way in.

Online equivalents:

- MATLAB: <https://mathworks.com/help/matlab/>
- Signal Processing Toolbox: <https://mathworks.com/help/signal/>

---

## Submitting

Submit a single **zip** file containing your documentation and all simulation
files (`*.m`). Make sure your approaches, procedures and results are clearly
presented.

There is a delivery interview at the end of the semester covering all
computer exercises.

> **For every exercise in which audio examples are played, start with a low
> volume.**
