const vec3 = @import("./vec3.zig");
const Color = @import("./color.zig").Color;

pub const PointLight = struct {
    position: vec3.Vec3,
    color: Color,

    pub fn diffuse(self: PointLight, at: vec3.Vec3, normal: vec3.Vec3) Color {
        const to_point = vec3.normalize(self.position - at);
        const intensity = vec3.dot(to_point, normal);
        return self.color.mul(intensity);
    }
};
