const std = @import("std");

pub fn build(b: *std.Build) void {
    const name = "mysql";
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    // TODO: Make this default to false and make it work
    const system_mariadb = b.option(bool, "system-mariadb", "Use system's MariaDB client library") orelse true;

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
    const mariadb_connector = b.dependency("mariadb", .{});
    lua_mysql.linkLibrary(zig_lua.artifact("lua"));
    if (system_mariadb) {
        lua_mysql.linkSystemLibrary("mysqlclient");
    } else {
        // Can't copy GPL code. It's just two expanded header files (ma_config.h, mariadb_version.h)
        lua_mysql.addIncludePath(b.path("mariadb-include"));
        lua_mysql.addIncludePath(.{ .dependency = .{
            .dependency = mariadb_connector,
            .sub_path = "include",
        } });
        lua_mysql.addCSourceFiles(.{
            .root = .{ .dependency = .{
                .dependency = mariadb_connector,
                .sub_path = "libmariadb",
            } },
            .files = &libmariadb_sources,
        });
    }

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

const libmariadb_sources = [_][]const u8{
    "mariadb_lib.c",

    // TODO: Parse Cmake's CONFIGURE_FILE
    //"libmariadb/ma_client_plugin.c.in", // tools/docgen.zig
    //"../plugins/auth/my_auth.c",
    //"ma_array.c",
    //"ma_charset.c",
    //"ma_decimal.c",
    //"ma_hashtbl.c",
    //"ma_net.c",
    //"mariadb_charset.c",
    //"ma_time.c",
    //"ma_default.c",
    //"ma_errmsg.c",
    //"ma_list.c",
    //"ma_pvio.c",
    //"ma_tls.c",
    //"ma_alloc.c",
    //"ma_compress.c",
    //"ma_init.c",
    //"ma_password.c",
    //"ma_ll2str.c",
    //"ma_sha1.c",
    //"mariadb_stmt.c",
    //"ma_loaddata.c",
    //"ma_stmt_codec.c",
    //"ma_string.c",
    //"ma_dtoa.c",
    //"mariadb_rpl.c",
    //"ma_io.c",
    //"secure/openssl.c",
    //"secure/gnutls.c",
    //"secure/schannel.c",
};
