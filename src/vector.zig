// These two are the default empty implementations for exception handlers
export fn blockingHandler() void {
    while (true) {}
}

export fn nullHandler() void {}

// Not a function, but pretend it is to suppress type error
extern fn _stack() void;

// These are the exception handlers, which are weakly linked to the default handlers
// in the linker script
extern fn resetHandler() void;
extern fn nmiHandler() void;
extern fn hardFaultHandler() void;
extern fn memoryManagementFaultHandler() void;
extern fn busFaultHandler() void;
extern fn usageFaultHandler() void;
extern fn svCallHandler() void;
extern fn debugMonitorHandler() void;
extern fn pendSVHandler() void;
extern fn sysTickHandler() void;

// The vector table
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
