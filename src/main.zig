const std = @import("std");
const c = @cImport({
    @cInclude("glad/glad.h");
    @cInclude("GLFW/glfw3.h");
});

pub fn main() anyerror!void {
    
    if (c.glfwInit() == 0) return error.cant_init_glfw;
    defer c.glfwTerminate();
    
    const window = c.glfwCreateWindow(600, 600, "Hello World", null, null) orelse return error.cant_create_window;
    defer c.glfwDestroyWindow(window);
    c.glfwSetWindowPos(window, -1, 100);
    c.glfwMakeContextCurrent(window);
    
    _ = c.gladLoadGLLoader(@ptrCast(c.GLADloadproc, c.glfwGetProcAddress));
    
    var buffer: c_uint = 0;
    c.glGenBuffers(1, &buffer);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, buffer);
    c.glBufferData(c.GL_ARRAY_BUFFER, 6 * @sizeOf(f32), &[_]f32{
        -0.5, -0.5, // p0
         0.5, -0.5, // p1
         0.0,  0.5, // p2
    }, c.GL_STATIC_DRAW);
    
    c.glEnableVertexAttribArray(0);
    c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, @sizeOf(f32) * 2, @intToPtr(*const c_void, 8));
    
    
    
    var time_begin = std.time.milliTimestamp();
    mainloop: while (c.glfwWindowShouldClose(window) == 0) {
        c.glfwPollEvents();
        
        const frame_duration = std.time.milliTimestamp() - time_begin;
        if (frame_duration < 16) {
            continue :mainloop; // Go back and poll events if time step isn't in sync.
        } else time_begin = std.time.milliTimestamp();
        
        
        
    }
    
}

const Buffer = struct {
    id: c_uint,
    
    /// Must be destroyed with `.deinit`
    pub fn init() Buffer {
        var out: Buffer = undefined;
        c.glGenBuffers(1, &out.id);
        return out;
    }
    
    /// Must be destroyed with `.deinit`
    pub fn initWith(comptime T: type, data: []const T, usage: UsageHint) Buffer {
        var out = Buffer.init();
        out.setData(T, data, usage);
        return out;
    }
    
    /// Use to destroy any buffer created with `.init`
    pub fn deinit(self: *Buffer) void {
        c.glDeleteBuffers(1, &self.id);
        self.* = undefined;
    }
    
    /// Must be destroyed with `.delete`
    pub fn generate(n: c_uint) []Buffer {
        var out: []Buffer = undefined;
        out.len = n;
        c.glGenBuffers(n, @ptrCast(*c_uint, out.ptr));
        return out;
    }
    
    /// Use to destroy any buffer slice created with `.generate`
    pub fn delete(buffers: []Buffer) void {
        c.glDeleteBuffers(buffers.len, @ptrCast(c_uint, buffers.ptr));
    }
    
    pub fn setData(self: *Buffer, comptime T: type, data: []const T, usage: UsageHint) void {
        self.bind();
        c.glBufferData(self.id, @sizeOf(T) * data.len, @ptrToInt(data.ptr), @enumToInt(usage));
    }
    
    pub fn bind(self: *Buffer, buffer_type: DataType) void {
        c.glBindBuffer(@enumToInt(buffer_type), self.id);
    }
    
    const UsageHint = enum(c_int) {
        stream_draw = c.GL_STREAM_DRAW,
        stream_read = c.GL_STREAM_READ,
        stream_copy = c.GL_STREAM_COPY,
        static_draw = c.GL_STATIC_DRAW,
        static_read = c.GL_STATIC_READ,
        static_copy = c.GL_STATIC_COPY,
        dynamic_draw = c.GL_DYNAMIC_DRAW,
        dynamic_read = c.GL_DYNAMIC_READ,
        dynamic_copy = c.GL_DYNAMIC_COPY,
    };
    
    const DataType = enum(c_int) {
        array              = c.GL_ARRAY_BUFFER,
        atomic_counter     = c.GL_ATOMIC_COUNTER_BUFFER,
        copy_read          = c.GL_COPY_READ_BUFFER,
        copy_write         = c.GL_COPY_WRITE_BUFFER,
        dispatch_indirect  = c.GL_DISPATCH_INDIRECT_BUFFER,
        draw_indirect      = c.GL_DRAW_INDIRECT_BUFFER,
        element_array      = c.GL_ELEMENT_ARRAY_BUFFER,
        pixel_pack         = c.GL_PIXEL_PACK_BUFFER,
        pixel_unpack       = c.GL_PIXEL_UNPACK_BUFFER,
        query              = c.GL_QUERY_BUFFER,
        shader_storage     = c.GL_SHADER_STORAGE_BUFFER,
        texture            = c.GL_TEXTURE_BUFFER,
        transform_feedback = c.GL_TRANSFORM_FEEDBACK_BUFFER,
        uniform            = c.GL_UNIFORM_BUFFER,
    };
    
};

pub fn generateBuffers(n: c_uint) []c_uint {
    var out: []c_uint = undefined;
    c.glGenBuffers(n, out.ptr);
    return out;
}

pub fn bindBuffersTo() void {
    
}
