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

export fn blockingHandler() void {
    while (true) {}
}

export fn nullHandler() void {}

// Not a function, but pretend it is to suppress type error
extern fn _stack() void;

// These are all functions that can be overriden
extern fn nmiHandler() void;
extern fn hardFaultHandler() void;
extern fn memoryManagementFaultHandler() void;
extern fn busFaultHandler() void;
extern fn usageFaultHandler() void;
extern fn svCallHandler() void;
extern fn debugMonitorHandler() void;
extern fn pendSVHandler() void;
extern fn sysTickHandler() void;

export const vector_table linksection(".vectors") = [_]?fn () callconv(.C) void{
    _stack,
    resetHandler, // Reset
    nmiHandler, // NMI
    hardFaultHandler, // Hard fault
    memoryManagementFaultHandler, // Memory management fault
    busFaultHandler, // Bus fault
    usageFaultHandler, // Usage fault
    null, // Reserved 1
    null, // Reserved 2
    null, // Reserved 3
    null, // Reserved 4
    svCallHandler, // SVCall
    debugMonitorHandler, // Debug monitor
    null, // Reserved 5
    pendSVHandler, // PendSV
    sysTickHandler, // SysTick
};
