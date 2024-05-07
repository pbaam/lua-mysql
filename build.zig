const std = @import("std");

pub fn build(b: *std.Build) void {
    const name = "mysql";
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lua_mysql = b.addSharedLibrary(.{
        .name = name,
        .target = target,
        .optimize = optimize,
    });
    lua_mysql.addCSourceFiles(.{
        .files = &.{"luamysql.c"},
        .flags = &.{ "-Wall", "-Werror", "-fPIC" },
    });

    const zig_lua = b.dependency("lua", .{});
    lua_mysql.linkLibrary(zig_lua.artifact("lua"));
    lua_mysql.linkSystemLibrary("mysqlclient");

    const lua_mysql_artifact = b.addInstallArtifact(lua_mysql, .{});
    lua_mysql_artifact.dest_sub_path = b.fmt("{s}.{s}", .{
        name,
        switch (target.result.os.tag) {
            .windows => "dll",
            else => "so",
        },
    });
    b.getInstallStep().dependOn(&lua_mysql_artifact.step);
}
