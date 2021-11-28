const math = @import("std").math;
const vec3 = @import("./vec3.zig");
const Ray = @import("./ray.zig").Ray;

pub const PointAtCamera = struct {
    position: vec3.Vec3,
    point_at: vec3.Vec3,
    field_of_view: f32 = 90,
};

pub const Camera = struct {
    position: vec3.Vec3,
    eye: vec3.Vec3,
    up: vec3.Vec3,
    right: vec3.Vec3,
    half_width: f32,
    half_height: f32,
    pixel_width: f32,
    pixel_height: f32,

    pub fn pointAt(screen_width: u32, screen_height: u32, cam: PointAtCamera) Camera {
        const screen_width_f = @intToFloat(f32, screen_width);
        const screen_height_f = @intToFloat(f32, screen_height);
        const field_of_view_radians = (math.pi * (cam.field_of_view / 2)) / 180;
        const half_width = math.tan(field_of_view_radians);
        const ratio = screen_height_f / screen_width_f;
        const half_height = ratio * half_width;
        const camera_width = half_width * 2;
        const camera_height = half_height * 2;
        const pixel_width = camera_width / (screen_width_f - 1);
        const pixel_height = camera_height / (screen_height_f - 1);
        const eye = vec3.normalize(cam.point_at - cam.position);
        const right = vec3.normalize(vec3.cross(vec3.UP, eye));
        const up = vec3.normalize(vec3.cross(eye, right));
        return Camera{
            .position = cam.position,
            .eye = eye,
            .up = up,
            .right = right,
            .half_width = half_width,
            .half_height = half_height,
            .pixel_width = pixel_width,
            .pixel_height = pixel_height,
        };
    }

    pub fn eyeRay(self: Camera, screen_x: u32, screen_y: u32) Ray {
        const screen_x_f = @intToFloat(f32, screen_x);
        const screen_y_f = @intToFloat(f32, screen_y);
        const shift_x = vec3.mul(self.right, screen_x_f * self.pixel_width - self.half_width);
        const shift_y = vec3.mul(self.up, screen_y_f * self.pixel_height - self.half_height);
        return Ray{ .origin = self.position, .direction = vec3.normalize(self.eye + shift_x + shift_y) };
    }
};
