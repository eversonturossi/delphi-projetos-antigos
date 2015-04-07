******************************************************************
    How To Detect Multimedia Devices and Set their Volume

       by Alex Simonetti Abreu - simonet@bhnet.com.br
*******************************************************************

  The purpose of the Hot-To Project is to teach Delphi developers
  how it is possible to detect the number and names of auxiliary
  multimedia devices and, optionally, set their volume using a
  track bar (or any other similar) component.

  The point why there are two applications for this project is
  because you cannot set a device's (for example, the CD) volume
  if you don't know it's device ID (for most systems, the CD
  player has the device ID of 2, but that can change).

  The method for setting the volume (basically its math) was written
  by me a long time ago (when I was still getting started in VB), and
  still has its flaws. I left it here the way it was orinally (but not
  in Basic, of course!) and haven't given it too much thought since
  then. If you find a better way for setting the correct values for the
  low and high words that make up the value to be passed to
  AuxSetVolume, please let me know.

  This application was tested on a Pentium with a Creative Labs Sound
  Blaster AWE 64 and a total of 7 devices were detected: Wave, Midi,
  CD, Line In, Mic, Master (for the master volume) and PC speaker.

  To check if it works for real (besides "hearing" the volume changes),
  open Windows' volume taskbar control and this application at the same time.
  By changing the volume in the application, you'll see how Windows reacts
  to those changes. 


     Best regards.

        Alex Simonetti Abreu
        Belo Horizonte, MG, Brazil

        August, 1998


