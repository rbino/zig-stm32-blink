# Zig STM32 Blink

Make LEDs blink on an STM32F4 Discovery board using only Zig (and a linker script).

See [my blogpost](https://rbino.com/posts/zig-stm32-blink/) for a more thorough explanation of
what's going on.

## Build

The code was tested with Zig `0.7.1` and with Zig `0.8.0-dev.1509+b54514d9d`.

To build the ELF file just run:

```
zig build
```

## Flashing

The easiest way to flash the board is to install [`stlink`
tools](https://github.com/stlink-org/stlink). Most Linux distributions should have them in their
repos, the build system will try to use the `st-flash` program.

The command to flash the board is:

```
zig build flash
```

After flashing the board you should see the 4 LEDs blinking in an alternating pattern.

## Debugging

It's possible to use [`openocd`](http://openocd.org/) and `gdb-multiarch` to debug the firmware
directly on the board.

In a terminal run:
```
openocd -f board/stm32f4discovery.cfg
```

Then from another terminal navigate to the directory containing the ELF output (i.e.
`zig-cache/bin`) and run:

```
gdb-multiarch zig-stm32-blink.elf -ex "target remote :3333"
```

You can also manually flash the firmware inside `gdb` with:

```
load
```

## Emulation using `qemu`

If you don't have an STM32F4 Discovery board or you just want to test the code locally, you can use
[xPack QEMU Arm](https://xpack.github.io/qemu-arm/install/#manual-install). 

*Note*: you have to comment out [this
line](https://github.com/rbino/zig-stm32-blink/blob/master/src/main.zig#L44) to make the code work
in QEMU since it doesn't support the FPU coprocessor yet.

After that, you can emulate the board with:

```
qemu-system-gnuarmeclipse -machine STM32F4-Discovery -mcu STM32F407VG \
  -kernel zig-cache/bin/zig-stm32-blink.elf -gdb tcp::3333
```

You should see the blinking LEDs on the board image, and you can connect a `gdb` instance to it (see
the previous section).
