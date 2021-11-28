const c = @cImport(@cInclude("SDL2/SDL.h"));
const std = @import("std");
const vec3 = @import("./vec3.zig");
const Sphere = @import("./sphere.zig").Sphere;
const Ray = @import("./ray.zig").Ray;
const Camera = @import("./camera.zig").Camera;
const PointLight = @import("./light.zig").PointLight;

const width = 800;
const height = 600;
const Pixel = [4]u8;
const ScreenBuffer = [width * height]Pixel;

pub fn main() anyerror!u8 {
    if (c.SDL_Init(c.SDL_INIT_VIDEO) != 0) {
        std.log.err("Failed to initialize SDL", .{});
        return 1;
    }
    defer c.SDL_Quit();

    const screen = c.SDL_CreateWindow("zigtracer", c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, width, height, 0) orelse {
        std.log.err("Failed to create window", .{});
        return 1;
    };
    defer c.SDL_DestroyWindow(screen);

    const renderer = c.SDL_CreateRenderer(screen, -1, 0) orelse {
        std.log.err("Failed to create renderer", .{});
        return 1;
    };
    defer c.SDL_DestroyRenderer(renderer);

    const sphere = Sphere{ .center = vec3.init(.{}), .radius = 1 };
    const camera = Camera.pointAt(width, height, .{
        .position = vec3.init(.{ .z = -3 }),
        .point_at = vec3.init(.{}),
    });
    const light = PointLight{ .position = vec3.init(.{ .x = 5, .y = 10, .z = -5 }) };
    std.debug.print("{}", .{camera});

    var quit = false;
    var event: c.SDL_Event = undefined;
    while (!quit) {
        if (c.SDL_WaitEvent(&event) != 1) {
            std.log.err("Error waiting on event", .{});
            return 1;
        }

        var y: u32 = 0;
        while (y < height) : (y += 1) {
            var x: u32 = 0;
            while (x < width) : (x += 1) {
                const ray = camera.eyeRay(x, height - 1 - y);
                const intersection = sphere.intersect(ray);
                if (intersection.hit) {
                    const intersection_point = ray.at(intersection.t);
                    const intersection_normal = sphere.normal(intersection_point);
                    const diffuse = light.diffuse(intersection_point, intersection_normal);
                    const r = floatToByte(diffuse);
                    const g = r;
                    const b = r;
                    _ = c.SDL_SetRenderDrawColor(renderer, r, g, b, 255);
                } else {
                    _ = c.SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
                }
                _ = c.SDL_RenderDrawPoint(renderer, @intCast(c_int, x), @intCast(c_int, y));
            }
        }
        c.SDL_RenderPresent(renderer);

        switch (event.type) {
            c.SDL_QUIT => quit = true,
            else => continue,
        }
    }

    return 0;
}

fn floatToByte(value: f32) u8 {
    if (value < 0) {
        return 0;
    } else if (value > 1) {
        return 255;
    } else {
        return @floatToInt(u8, value * 255);
    }
}
