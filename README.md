## Tattanii-Scripts

Scripts and tools to generate EAGLE parts library for Energy Micro MCUs

There are two parts in this tool :

### EMFootprintGen

This perl script generates the foot-prints a.k.a packages part of Eagle Library XML

#### Usage

1. Change directory to /EMFootprintGen
2. Run EMFootprintGen.sh
    > This creates /Tattanii-Scripts/output/packages.pac

### EMLibGen

This Qt based application generates the complete Eagle Library for EFM32 devices.

#### Usage

1. Open /Tattanii-Scripts/EMLibGen/src/EMLibGen.pro in QtCreator
2. Make sure the Projects->Build directory is set to /Tattanii-Scripts/EMLibGen/build for both Debug and Release builds.
3. Compile and Run.
4. Open Footprint file packages.pac created using EMFootPrintGen
5. Click `Open CSV File and Generate` button. Select all .csv files.
    > This creates /Tattanii-Scripts/output/EnergyMicro.lbr
6. Use `Save Eagle Library` button to save the generated library to another location (say /eagle/lbr/ folder)

### What is in the name?

Tattanii (sa:टट्टनी) is [Sanskrit](http://en.wikipedia.org/wiki/Sanskrit) word for small house gecko.



