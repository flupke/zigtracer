const vec3 = @import("./vec3.zig");
const Ray = @import("./ray.zig").Ray;
const Intersection = @import("./intersection.zig").Intersection;

pub const Sphere = struct {
    center: vec3.Vec3,
    radius: f32,

    pub fn intersect(self: Sphere, ray: Ray) Intersection {
        const o_minus_c = ray.origin - self.center;
        const p = vec3.dot(ray.direction, o_minus_c);
        const q = vec3.dot(o_minus_c, o_minus_c) - (self.radius * self.radius);
        const discriminant = (p * p) - q;

        if (discriminant < 0) {
            return Intersection{};
        }

        const dRoot = @sqrt(discriminant);
        const dist1 = -p - dRoot;

        return Intersection{ .hit = true, .at = dist1 };
    }

    pub fn normal(self: Sphere, at: vec3.Vec3) vec3.Vec3 {
        return vec3.normalize(at - self.center);
    }
};
