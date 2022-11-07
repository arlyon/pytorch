load(
    "@prelude//cxx:cxx_toolchain_types.bzl",
    "CxxCompilerInfo",
    "CCompilerInfo",
    "CxxToolchainInfo",
    "CxxPlatformInfo",
    "LinkerInfo",
    "BinaryUtilitiesInfo",
)

load("@prelude//cxx:headers.bzl",
    "HeaderMode",
)

load("@prelude//linking:link_info.bzl",
    "LinkStyle",
)

load(
    "@prelude//python:toolchain.bzl",
    "PythonToolchainInfo",
    "PythonPlatformInfo",
)

load(
    "@prelude//python_bootstrap/python_bootstrap.bzl", "PythonBootstrapToolchainInfo"
)

DEFAULT_MAKE_COMP_DB = "@prelude//cxx/tools:make_comp_db"
DEFAULT_MAKE_PEX_INPLACE = "@prelude//python/tools:make_pex_inplace"
DEFAULT_MAKE_PEX_MODULES = "@prelude//python/tools:make_pex_modules"
DEFAULT_MAKE_SOURCE_DB = "@prelude//python/tools:make_source_db"
DEFAULT_MAKE_ELF_SHLIB_INTF = "@toolchains//:mk_elf_shlib_intf"



def _cxx_toolchain(ctx):
    """
    A very simple toolchain that is hardcoded to the current environment.
    """

    return [
        DefaultInfo(),
        CxxToolchainInfo(
            mk_comp_db=ctx.attrs.make_comp_db,
            linker_info=LinkerInfo(
                linker=RunInfo(args=["gcc"]),
                linker_flags=["-lstdc++", "-lm"],
                archiver=RunInfo(args=["ar", "rcs"]),
                type="gnu",
                shlib_interfaces="disabled",
                mk_shlib_intf = None, # not needed if above is 'disabled'
                link_binaries_locally=True,
                archive_objects_locally=True,
                use_archiver_flags=False,
                static_dep_runtime_ld_flags = [],
                static_pic_dep_runtime_ld_flags = [],
                shared_dep_runtime_ld_flags = [],
                independent_shlib_interface_linker_flags = [],
                link_style=LinkStyle(ctx.attrs.link_style),
                link_weight=1,
            ),
            bolt_enabled=False,
            binary_utilities_info=BinaryUtilitiesInfo(
                nm=RunInfo(args=["nm"]),
                # objcopy = ctx.attrs.objcopy_for_shared_library_interface[RunInfo],
                # ranlib = ctx.attrs.ranlib[RunInfo],
                ranlib = RunInfo(args=["raninfo"]),
                strip=RunInfo(args=["strip"]),
                dwp=None,
                bolt_msdk=None,
            ),
            cxx_compiler_info=CxxCompilerInfo(
                compiler=RunInfo(args=["clang++"]),
                preprocessor_flags=[],
                compiler_flags=[],
                compiler_type="clang",  # one of CxxToolProviderType
            ),
            c_compiler_info=CCompilerInfo(
                compiler=RunInfo(args=["clang"]),
                compiler_flags=[],
                preprocessor_flags=[],
                compiler_type="clang",  # one of CxxToolProviderType
            ),
            # asm_compiler_info=[],
            # cuda_compiler_info=[],
            as_compiler_info=CCompilerInfo(compiler=RunInfo(args=["clang"]), preprocessor_flags=[], compiler_flags=[], 
                compiler_type="clang",  # one of CxxToolProviderType
                ),
            # hip_compiler_info=[],
            header_mode = HeaderMode("symlink_tree_only"),
        ),
        CxxPlatformInfo(name="x86_64"),
    ]


cxx_toolchain = rule(
    impl=_cxx_toolchain,
    attrs={
        "make_comp_db": attrs.dep(providers=[RunInfo], default=DEFAULT_MAKE_COMP_DB),
        "link_style": attrs.string(default="static"),
    },
    is_toolchain_rule=True,
)



def _python_toolchain(ctx):
    """
    A very simple toolchain that is hardcoded to the current environment.
    """

    return [
        DefaultInfo(),
        PythonToolchainInfo(
            make_source_db=ctx.attrs.make_source_db,
            host_interpreter = RunInfo(args=["python3"]),
            interpreter = RunInfo(args=["python3"]),
            make_pex_modules = ctx.attrs.make_pex_modules,
            make_pex_inplace = ctx.attrs.make_pex_inplace,
            compile = RunInfo(args=["echo", "COMPILEINFO"]),
            package_style = "inplace",
            native_link_strategy = "merged",

        ),
        PythonPlatformInfo(name="x86_64"),
    ]

def _python_bootstrap_toolchain(ctx):
    return [
           DefaultInfo(),
        PythonBootstrapToolchainInfo(
            interpreter = "python3"
        )
    ]

python_toolchain = rule(
    impl=_python_toolchain,
    attrs={
        "make_source_db": attrs.dep(providers=[RunInfo], default=DEFAULT_MAKE_SOURCE_DB),
        "make_pex_modules": attrs.dep(providers=[RunInfo], default=DEFAULT_MAKE_PEX_MODULES),
        "make_pex_inplace": attrs.dep(providers=[RunInfo], default=DEFAULT_MAKE_PEX_INPLACE),
    },
    is_toolchain_rule=True,
)

python_bootstrap_toolchain = rule(
    impl=_python_bootstrap_toolchain,
    attrs={},
    is_toolchain_rule=True,
)
