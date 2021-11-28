const vec3 = @import("./vec3.zig");

pub const PointLight = struct {
    position: vec3.Vec3,

    pub fn diffuse(self: PointLight, at: vec3.Vec3, normal: vec3.Vec3) f32 {
        const to_point = vec3.normalize(self.position - at);
        return vec3.dot(to_point, normal);
    }
};
