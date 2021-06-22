const std = @import("std");
const c = @cImport({
    @cInclude("GL/gl.h");
    @cInclude("GLFW/glfw3.h");
});

pub fn main() anyerror!void {
    if (c.glfwInit() == 0) return error.cant_init_glfw;
    defer c.glfwTerminate();
    
    const window = c.glfwCreateWindow(640, 480, "Hello World", null, null) orelse return error.cant_create_window;
    c.glfwSetWindowPos(window, -1, 100);
    
    c.glfwMakeContextCurrent(window);
    
    while (c.glfwWindowShouldClose(window) == 0) {
        c.glClear(c.GL_COLOR_BUFFER_BIT);

        c.glfwSwapBuffers(window);

        c.glfwPollEvents();
    }
    
}
