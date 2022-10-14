load(":toolchain.bzl", "python_toolchain", "python_bootstrap_toolchain")
load("@prelude//toolchains/cxx/zig:defs.bzl", "download_zig_distribution", "cxx_zig_toolchain")
load(":toolchain.bzl", "cxx_toolchain")

# download_zig_distribution(
#     name = "zig",
#     version = "0.9.1",
# )

# cxx_zig_toolchain(
#     name = "cxx",
#     distribution = ":zig",
#     visibility = ["PUBLIC"],
# )

python_toolchain(
    name="python",
    visibility=["PUBLIC"],
)

# the bootstrap toolchain is used
# to poentially initialize other
python_bootstrap_toolchain(
    name="python_bootstrap",
    visibility=["PUBLIC"],
)

cxx_toolchain(
    name="cxx",
    visibility=["PUBLIC"],
)

export_file(
    name = "mk_elf_shlib_intf",
    src = "mk_elf_shlib_intf",
)
