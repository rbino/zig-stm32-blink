extern fn main() void;
extern var _data_loadaddr: u32;
extern var _data: u32;
extern var _data_size: u32;
extern var _bss: u32;
extern var _bss_size: u32;

export fn resetHandler() void {
    // copy data from flash to RAM
    var data_loadaddr = @ptrCast([*]u8, &_data_loadaddr);
    var data = @ptrCast([*]u8, &_data);
    var data_size = @ptrToInt(&_data_size);
    for (data_loadaddr[0..data_size]) |d, i| data[i] = d;

    // clear the bss
    const bss = @ptrCast([*]u8, &_bss);
    const bss_size = @ptrToInt(&_bss_size);
    for (bss[0..bss_size]) |*b| b.* = 0;

    // start
    main();

    unreachable;
}

fn blockingHandler() callconv(.C) void {
    while (true) {}
}

fn nullHandler() callconv(.C) void {}

// Not a function, but pretend it is to suppress type error
extern fn _stack() void;

export const vector_table linksection(".vectors") = [_]?fn () callconv(.C) void{
    _stack,
    resetHandler, // Reset
    nullHandler, // NMI
    blockingHandler, // Hard fault
    blockingHandler, // Memory management fault
    blockingHandler, // Bus fault
    blockingHandler, // Usage fault
    null, // Reserved 1
    null, // Reserved 2
    null, // Reserved 3
    null, // Reserved 4
    nullHandler, // SVCall
    null, // Reserved 5
    null, // Reserved 6
    nullHandler, // PendSV
    nullHandler, // SysTick
};
