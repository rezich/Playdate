this is a [Playdate](https://play.date) [C API](https://sdk.play.date/1.12.3/Inside%20Playdate%20with%20C.html) wrapper for Jai.

it is currently unfinished and unusable as Jai presently lacks features to compile for ARM.

fellow Jai beta user TheGag96 [has been working on getting Jai to compile for the 3DS](https://github.com/TheGag96/3ds-hello-jai), and I am watching his progress closely.

---

the basic idea is to have Playdate.jai be a more or less 1:1 wrapper of the Playdate C API (aside from constants/enums, which are renamed to be less verbose), and then, once that's confirmed as working and everything, I'll work on wrapping it to be more Jai-friendly and easy-to-use by utilizing Jai-specific features.

---

once that's all working, then the first proof-of-concept test is to set things up such that a basic example can be compiled into a .o object file, which can then be linked with the Playdate API's Visual Studio project. longer-term, it would be very cool if that step could be omitted entirely, and everything could be done from within Jai. however this'll require me to dive deep into the Playdate C API makefiles and replicate their tangled functionality into nice clean easy-to-understand Jai. quite the undertaking, but I'm here for it!
