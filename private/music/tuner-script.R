library(tuneR) #load tuenR package
library(tidyverse)
#play “mywave.wav” file located in the current directory
play('mywave.wav', 'play') #play the file by the player, 'play'

#make a simple sine wave and play
t = seq(0, 3, 1/8000) #times in seconds if sample for 3 seconds at 8000Hz
u = (2^15-1)*sin(2*pi*440*t) #440 Hz sine wave that lasts t length seconds (here, 3 seconds)
w = Wave(u, samp.rate = 8000, bit=16) #make the wave variable
play(w) 
 # , "play"
?Wave

tbl_1 <- tibble(t = seq(0, 1, 1/8000)) %>%
  mutate(u = (2^15-1)*sin(2*pi*440*t))
tbl_2 <- tibble(t = seq(1, 2, 1/8000)) %>%
  mutate(u = (2^15-1)*sin(2*pi*300*t))
tbl_3 <- tibble(t = seq(2, 3, 1/8000)) %>%
  mutate(u = (2^15-1)*sin(2*pi*600*t))
tbl_4 <- tibble(t = seq(3, 4, 1/8000)) %>%
  mutate(u = (2^15-1)*sin(7*pi*300*t))
tbl <- tbl_1 %>%
  bind_rows(tbl_2) %>%
  bind_rows(tbl_3) %>% 
  bind_rows(tbl_4) 
tbl %>% ggplot() +
  aes(x = t, y = u) +
  geom_line()

w = Wave(tbl$u, samp.rate = 8000, bit=16) #make the wave variable
play(w) 

content <- readMidi(system.file("example_files", "Bass_sample.mid", package="tuneR"))
getMidiNotes(content)

content

# ----------------------------------------------------------------------------
library("tuneR") # in a regular session, we are loading tuneR

# constructing a mono Wave object (2 sec.) containing sinus 
# sound with 440Hz and folled by 220Hz:
Wobj <- bind(sine(440), sine(220))
show(Wobj)
plot(Wobj) # it does not make sense to plot the whole stuff
plot(extractWave(Wobj, from = 1, to = 500))
## Not run: 
play(Wobj) # listen to the sound

## End(Not run)

tmpfile <- file.path(tempdir(), "testfile.wav")
# write the Wave object into a Wave file (can be played with any player):
writeWave(Wobj, tmpfile)
# reading it in again:
Wobj2 <- readWave(tmpfile)

Wobjm <- mono(Wobj, "left") # extract the left channel
# and downsample to 11025 samples/sec.:
Wobjm11 <- downsample(Wobjm, 11025)
# extract a part of the signal interactively (click for left/right limits):
## Not run: 
Wobjm11s <- extractWave(Wobjm11)

## End(Not run)
# or extract some values reproducibly 
Wobjm11s <- extractWave(Wobjm11, from=1000, to=17000)

# calculating periodograms of sections each consisting of 1024 observations,
# overlapping by 512 observations:
WspecObject <- periodogram(Wobjm11s, normalize = TRUE, width = 1024, overlap = 512)
# Let's look at the first periodogram:
plot(WspecObject, xlim = c(0, 2000), which = 1)
# or a spectrogram
image(WspecObject, ylim = c(0, 1000))
# calculate the fundamental frequency:
ff <- FF(WspecObject)
print(ff)
# derive note from FF given diapason a'=440
notes <- noteFromFF(ff, 440)
# smooth the notes:
snotes <- smoother(notes)
# outcome should be 0 for diapason "a'" and -12 (12 halftones lower) for "a"
print(snotes) 
# plot melody and energy of the sound:
melodyplot(WspecObject, snotes)

# apply some quantization (into 8 parts): 
qnotes <- quantize(snotes, WspecObject@energy, parts = 8) 
# an plot it, 4 parts a bar (including expected values):
quantplot(qnotes, expected = rep(c(0, -12), each = 4), bars = 2)
# now prepare for LilyPond
qlily <- quantMerge(snotes, 4, 4, 2)
qlily


