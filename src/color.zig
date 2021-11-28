pub const Color = struct {
    r: f32 = 1,
    g: f32 = 1,
    b: f32 = 1,

    /// Linearly blend two colors.
    ///
    /// If ratio is 0, the resulting color is this color, if it's 1 the
    /// resulting color is *other*.
    pub fn linearBlend(self: Color, other: Color, ratio: f32) Color {
        return Color{
            .r = lerp(self.r, other.r, ratio),
            .g = lerp(self.g, other.g, ratio),
            .b = lerp(self.b, other.b, ratio),
        };
    }

    pub fn toBytes(self: Color) [3]u8 {
        return .{ floatToByte(self.r), floatToByte(self.g), floatToByte(self.b) };
    }

    pub fn mul(self: Color, value: f32) Color {
        return Color{ .r = self.r * value, .g = self.g * value, .b = self.b * value };
    }
};

fn lerp(from: f32, to: f32, ratio: f32) f32 {
    return from + (to - from) * ratio;
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
