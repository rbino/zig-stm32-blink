const Builder = @import("std").build.Builder;
const std = @import("std");

pub fn build(b: *Builder) void {
    // Target STM32F407VG
    const target = .{
        .cpu_arch = std.Target.Cpu.Arch.arm,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        .os_tag = std.Target.Os.Tag.freestanding,
        .abi = std.builtin.Abi.eabihf,
    };

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zig-stm32-blink.elf", "src/startup.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);

    const main_obj = b.addObject("main", "src/main.zig");
    main_obj.setTarget(target);
    main_obj.setBuildMode(mode);

    exe.addObject(main_obj);
    exe.setLinkerScriptPath("src/linker.ld");

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
