const vec3 = @import("./vec3.zig");

pub const Ray = struct {
    origin: vec3.Vec3,
    direction: vec3.Vec3,

    pub fn at(self: Ray, t: f32) vec3.Vec3 {
        return self.origin + vec3.mul(self.direction, t);
    }
};
