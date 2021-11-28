const expect = @import("std").testing.expect;
const std = @import("std");

const Vec3Init = struct {
    x: f32 = 0,
    y: f32 = 0,
    z: f32 = 0,
};

pub const Vec3 = @Vector(3, f32);
pub const UP = init(.{ .y = 1 });

pub fn init(values: Vec3Init) Vec3 {
    return [_]f32{ values.x, values.y, values.z };
}

pub fn dot(v1: Vec3, v2: Vec3) f32 {
    const multiplied = v1 * v2;
    return multiplied[0] + multiplied[1] + multiplied[2];
}

pub fn cross(v1: Vec3, v2: Vec3) Vec3 {
    return [_]f32{
        v1[1] * v2[2] - v1[2] * v2[1],
        v1[2] * v2[0] - v1[0] * v2[2],
        v1[0] * v2[1] - v1[1] * v2[0],
    };
}

pub fn length(vec: Vec3) f32 {
    return @sqrt(dot(vec, vec));
}

pub fn normalize(vec: Vec3) Vec3 {
    const vlen = length(vec);
    return vec / @splat(3, vlen);
}

pub fn equal(v1: Vec3, v2: Vec3) bool {
    return v1[0] == v2[0] and v1[1] == v2[1] and v1[2] == v2[2];
}

pub fn mul(vec: Vec3, value: f32) Vec3 {
    return vec * @splat(3, value);
}

test "init" {
    var v: Vec3 = init(.{});
    try expect(v[0] == 0);
    try expect(v[1] == 0);
    try expect(v[2] == 0);

    v = init(.{ .x = 1 });
    try expect(v[0] == 1);
    try expect(v[1] == 0);
    try expect(v[2] == 0);

    v = init(.{ .y = 1 });
    try expect(v[0] == 0);
    try expect(v[1] == 1);
    try expect(v[2] == 0);

    v = init(.{ .z = 1 });
    try expect(v[0] == 0);
    try expect(v[1] == 0);
    try expect(v[2] == 1);
}

test "add vectors" {
    const v1: Vec3 = [_]f32{ 0, 0, 0 };
    const v2: Vec3 = [_]f32{ 1, 2, 3 };
    const v3 = v1 + v2;
    try expect(v3[0] == 1);
    try expect(v3[1] == 2);
    try expect(v3[2] == 3);
}

test "sub vectors" {
    const v1: Vec3 = [_]f32{ 0, 0, 0 };
    const v2: Vec3 = [_]f32{ 1, 2, 3 };
    const v3 = v1 - v2;
    try expect(v3[0] == -1);
    try expect(v3[1] == -2);
    try expect(v3[2] == -3);
}

test "mul vectors" {
    const v1: Vec3 = [_]f32{ 1, 1, 1 };
    const v2: Vec3 = [_]f32{ 1, 2, 3 };
    const v3 = v1 * v2;
    try expect(v3[0] == 1);
    try expect(v3[1] == 2);
    try expect(v3[2] == 3);
}

test "div vectors" {
    const v1: Vec3 = [_]f32{ 2, 4, 8 };
    const v2: Vec3 = [_]f32{ 2, 2, 2 };
    const v3 = v1 / v2;
    try expect(v3[0] == 1);
    try expect(v3[1] == 2);
    try expect(v3[2] == 4);
}

test "dot product" {
    const v1: Vec3 = [_]f32{ 1, 1, 1 };
    const v2: Vec3 = [_]f32{ 1, 2, 3 };
    const dotproduct = dot(v1, v2);
    try expect(dotproduct == 6);
}

test "length" {
    const v1: Vec3 = [_]f32{ 5, 10, -10 };
    const vlen = length(v1);
    try expect(vlen == 15);
}

test "normalize" {
    const v1: Vec3 = [_]f32{ 2, 0, 0 };
    const v2 = normalize(v1);
    const v3: Vec3 = [_]f32{ 1, 0, 0 };
    try expect(equal(v2, v3));
}

test "cross" {
    const v1: Vec3 = [_]f32{ -1, 0, 0 };
    const v2: Vec3 = [_]f32{ 0, 1, 0 };
    const v3: Vec3 = [_]f32{ 0, 0, -1 };
    try expect(equal(cross(v1, v2), v3));
}
