Unofficial devkitPro from source
================================

**Don't report bugs upstream, reproduce them with the official packages first**. (or report them here instead)

This is a collection of PKGBUILDs for devkitPro's core utilities, in lieu of the mysteriously bygone tool-packages repository, as used to be provided in the devkitPro organization.

The scripts in this repository allow you to build devkitPro from source, making it possible to use the toolchain on platforms and operating systems that the developers never envisioned, such as:
- systems without root access, or inmutable systems
- musl-based distributions
- distributions that don't have a copy of pacman
- upcoming architectures such as RISC-V
- unconventional environments such as Termux (probably with caveats, untested)
- probably more

This repository isn't a 1:1 clone of the official tools provided by devkitPro, because I didn't keep a copy of the original repository before it Vanish Oxi Action. Not all packages are contained within this repository. I've currently only packaged tools that are necessary to build all the libraries, and examples. It's unlikely I will bother packaging tools that aren't directly used by the toolchain, such as hactool and ctrtool.

Additionally, this repository allows building and installing the toolchain under any given prefix, not constrained to `/opt/devkitpro`. Do note, however, that the directory must be accessible by a non-root user building and installing the packages.

Modifications to the pacman-packages and wut-packages repositories are required to use in conjunction with this repository, both to allow installing under a custom prefix, and because not all packages in the upstream repositories can actually be built from source anymore.

The companion repositories can be found here:
- [pacman-packages](https://github.com/mid-kid/devkitpro-pacman-packages/)
- [wut-packages](https://github.com/mid-kid/devkitpro-wut-packages/) (Wii U packages)

Installing
----------

First install pacman:
```
export DEVKITPRO="$HOME/.devkitPro"  # Or any accessible directory of choice
./bootstrap
source $DEVKITPRO/devkit-env.sh
```

Add the environment script to your shell configuration for persistence:
```
echo "source $DEVKITPRO/devkit-env.sh" >> ~/.bashrc  # For bash
echo "source $DEVKITPRO/devkit-env.sh" >> ~/.zshrc  # For zsh
```

Now, to install any package, do as follows:
```
cd <pkg>
dkp-makepkg -ci
```

You'll probably first want to build a compiler toolchain. These take the longest of any package to build, so don't panic. Depending on your platform, you'll want to pick one of:
- `tool-packages/devkitARM` (gba gp32 gp2x nds 3ds)
- `tool-packages/devkitPPC` (gc wii wiiu)
- `tool-packages/devkitA64` (switch)

Clone the [pacman-packages](https://github.com/mid-kid/devkitpro-pacman-packages/) repository, and install the rules/crtls for your toolchain:
- `pacman-packages/devkitarm/devkitarm-rules`
- `pacman-packages/devkitarm/devkitarm-crtls`
- `pacman-packages/devkitppc/devkitppc-rules`
- `pacman-packages/devkita64/devkita64-rules`

Once that's done, the compiler will work as-is. However, most programs and portlibs (ported libraries in `pacman-packages`) will require some libraries to compile properly, depending on your platform. Here's some examples:
- `pacman-packages/libgba` (gba)
- `pacman-packages/libmirko` (gp32)
- `pacman-packages/gp2x/liborcus` (gp2x)
- `pacman-packages/libnds` (nds, required for portlibs), as well as `pacman-packages/default-arm7` for building any ROM.
- `pacman-packages/libctru` (3ds, required for portlibs)
- `pacman-packages/libogc` (gc/wii, required for portlibs)
- `wut-packages/wut` (wiiu, required for portlibs)
- `pacman-packages/libnx` (switch, required for portlibs)

If you're not familiar with the library ecosystem of the platform you're building for, you'll probably want to run `grep -rw <group>` in the `pacman-packages` repository to find out about the common libraries for your platform. `<group>` can be any of:
- `gba-dev`
- `gp32-dev`
- `nds-dev`
- `3ds-dev`
- `gamecube-dev`
- `wii-dev`
- `wiiu-dev`
- `switch-dev`

If a package dependency is missing, makepkg will (usually) tell you about it, and you'll have to look for the appropriate PKGBUILD in the repository.

Updates
-------

I don't have the time or energy to continually maintain this repository. As such, it'll generally only be updated when I need it. Feel free to contribute.

While I'm generally confident that the current state of this repository will remain working for a decent amount of time, at some point it the future it might break.

To check if updates are available for packages in the repository, use the following script:
```
./repo_check.sh
```
