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

    const vector_obj = b.addObject("vector", "src/vector.zig");
    vector_obj.setTarget(target);
    vector_obj.setBuildMode(mode);

    exe.addObject(vector_obj);
    exe.setLinkerScriptPath("src/linker.ld");

    b.default_step.dependOn(&exe.step);
    b.installArtifact(exe);
}
