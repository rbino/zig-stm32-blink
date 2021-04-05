usingnamespace @import("main.zig");

// These symbols come from the linker script
extern var _data_loadaddr: u32;
extern var _data: u32;
extern var _data_size: u32;
extern var _bss: u32;
extern var _bss_size: u32;

export fn resetHandler() void {
    // Copy data from flash to RAM
    var data_loadaddr = @ptrCast([*]u8, &_data_loadaddr);
    var data = @ptrCast([*]u8, &_data);
    var data_size = @ptrToInt(&_data_size);
    for (data_loadaddr[0..data_size]) |d, i| data[i] = d;

    // Clear the bss
    const bss = @ptrCast([*]u8, &_bss);
    const bss_size = @ptrToInt(&_bss_size);
    for (bss[0..bss_size]) |*b| b.* = 0;

    // Call main imported from main.zig
    main();

    unreachable;
}
