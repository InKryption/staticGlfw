const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("gl_project", "src/main.zig");
    
    
    
    exe.linkLibC();
    exe.linkSystemLibrary("opengl32");
    exe.linkSystemLibrary("gdi32");
    
    exe.linkSystemLibrary("gdi32");
    exe.addIncludeDir("dependencies/glfw-3.3.4/include/");
    exe.defineCMacro("_GLFW_WIN32", null);
    exe.defineCMacro("_UNICODE", null);
    const glfw_src_dir = "dependencies/glfw-3.3.4/src/";
    exe.addCSourceFiles(
        &[_][]const u8{
            glfw_src_dir ++ "context.c",
            glfw_src_dir ++ "init.c",
            glfw_src_dir ++ "input.c",
            glfw_src_dir ++ "vulkan.c",
            glfw_src_dir ++ "window.c",
            
            glfw_src_dir ++ "win32_init.c",
            glfw_src_dir ++ "win32_joystick.c",
            glfw_src_dir ++ "win32_monitor.c",
            glfw_src_dir ++ "win32_time.c",
            glfw_src_dir ++ "win32_thread.c",
            glfw_src_dir ++ "win32_window.c",
            glfw_src_dir ++ "wgl_context.c",
            glfw_src_dir ++ "egl_context.c",
            glfw_src_dir ++ "osmesa_context.c",
            
            glfw_src_dir ++ "monitor.c",
        },
        &[_][]const u8{
            "-std=c99",
            "-I" ++ glfw_src_dir
        },
    );
    
    const glad_dir = "dependencies/glad/";
    exe.addCSourceFiles(
        &[_][]const u8{
            glad_dir ++ "src/glad.c",
        },
        &[_][]const u8{
            "-I" ++ glad_dir ++ "/include/",
        },
    );
    exe.addIncludeDir(glad_dir ++ "/include/");
    
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
