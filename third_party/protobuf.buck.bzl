
load("@prelude//:rules.bzl", "genrule", "filegroup", "cxx_library", "cxx_binary")
load("//tools/build_defs:glob_defs.bzl", "subdir_glob")


COPTS =  [
    "-DHAVE_PTHREAD",
    "-DHAVE_ZLIB",
    "-Woverloaded-virtual",
    "-Wno-sign-compare",
    "-Wno-unused-function",
    # Prevents ISO C++ const string assignment warnings for pyext sources.
    "-Wno-write-strings",
    "-Wno-deprecated-declarations",
]

LINK_OPTS = [ "-lpthread",
        "-lm"]

_ZLIB_HEADERS = [
    "crc32.h",
    "deflate.h",
    "gzguts.h",
    "inffast.h",
    "inffixed.h",
    "inflate.h",
    "inftrees.h",
    "trees.h",
    "zconf.h",
    "zlib.h",
    "zutil.h",
]

_ZLIB_PREFIXED_HEADERS = ["protobuf/third_party/zlib/" + hdr for hdr in _ZLIB_HEADERS]


def define_protobuf():


    cxx_library(
        name = "zlib",
        srcs = [
            "protobuf/third_party/zlib/adler32.c",
            "protobuf/third_party/zlib/compress.c",
            "protobuf/third_party/zlib/crc32.c",
            "protobuf/third_party/zlib/deflate.c",
            "protobuf/third_party/zlib/gzclose.c",
            "protobuf/third_party/zlib/gzlib.c",
            "protobuf/third_party/zlib/gzread.c",
            "protobuf/third_party/zlib/gzwrite.c",
            "protobuf/third_party/zlib/infback.c",
            "protobuf/third_party/zlib/inffast.c",
            "protobuf/third_party/zlib/inflate.c",
            "protobuf/third_party/zlib/inftrees.c",
            "protobuf/third_party/zlib/trees.c",
            "protobuf/third_party/zlib/uncompr.c",
            "protobuf/third_party/zlib/zutil.c",
            # Include the un-prefixed headers in srcs to work
            # around the fact that zlib isn't consistent in its
            # choice of <> or "" delimiter when including itself.
        ],
        headers = _ZLIB_PREFIXED_HEADERS,
        compiler_flags = [
                "-Wno-unused-variable",
                "-Wno-implicit-function-declaration",
            ],
        # exported_headers = ["zlib/include/"],
        visibility = ["PUBLIC"],
    )

    cxx_library(
        name = "protobuf_lite",
        srcs = [
            # AUTOGEN(protobuf_lite_srcs)
            "protobuf/src/google/protobuf/any_lite.cc",
            "protobuf/src/google/protobuf/arena.cc",
            "protobuf/src/google/protobuf/extension_set.cc",
            "protobuf/src/google/protobuf/generated_enum_util.cc",
            "protobuf/src/google/protobuf/generated_message_table_driven_lite.cc",
            "protobuf/src/google/protobuf/generated_message_util.cc",
            "protobuf/src/google/protobuf/implicit_weak_message.cc",
            "protobuf/src/google/protobuf/io/coded_stream.cc",
            "protobuf/src/google/protobuf/io/io_win32.cc",
            "protobuf/src/google/protobuf/io/strtod.cc",
            "protobuf/src/google/protobuf/io/zero_copy_stream.cc",
            "protobuf/src/google/protobuf/io/zero_copy_stream_impl.cc",
            "protobuf/src/google/protobuf/io/zero_copy_stream_impl_lite.cc",
            "protobuf/src/google/protobuf/message_lite.cc",
            "protobuf/src/google/protobuf/parse_context.cc",
            "protobuf/src/google/protobuf/repeated_field.cc",
            "protobuf/src/google/protobuf/stubs/bytestream.cc",
            "protobuf/src/google/protobuf/stubs/common.cc",
            "protobuf/src/google/protobuf/stubs/int128.cc",
            "protobuf/src/google/protobuf/stubs/status.cc",
            "protobuf/src/google/protobuf/stubs/statusor.cc",
            "protobuf/src/google/protobuf/stubs/stringpiece.cc",
            "protobuf/src/google/protobuf/stubs/stringprintf.cc",
            "protobuf/src/google/protobuf/stubs/structurally_valid.cc",
            "protobuf/src/google/protobuf/stubs/strutil.cc",
            "protobuf/src/google/protobuf/stubs/time.cc",
            "protobuf/src/google/protobuf/wire_format_lite.cc",
        ],
        header_namespace = "",
        headers = glob([
            "protobuf/src/**/*.h",
            "protobuf/src/**/*.inc",
        ]),
        exported_headers = subdir_glob([
            ("protobuf/src", "google/protobuf/**/*.h"),
            ("protobuf/src", "google/protobuf/**/*.inc"),
        ]),
        compiler_flags = COPTS,
        # exported_headers = ["src/"],
        linker_flags = LINK_OPTS,
        visibility = ["//visibility:public"],
    )

    cxx_library(
        name = "protobuf",
        srcs = [
            # AUTOGEN(protobuf_srcs)
            "protobuf/src/google/protobuf/any.cc",
            "protobuf/src/google/protobuf/any.pb.cc",
            "protobuf/src/google/protobuf/api.pb.cc",
            "protobuf/src/google/protobuf/compiler/importer.cc",
            "protobuf/src/google/protobuf/compiler/parser.cc",
            "protobuf/src/google/protobuf/descriptor.cc",
            "protobuf/src/google/protobuf/descriptor.pb.cc",
            "protobuf/src/google/protobuf/descriptor_database.cc",
            "protobuf/src/google/protobuf/duration.pb.cc",
            "protobuf/src/google/protobuf/dynamic_message.cc",
            "protobuf/src/google/protobuf/empty.pb.cc",
            "protobuf/src/google/protobuf/extension_set_heavy.cc",
            "protobuf/src/google/protobuf/field_mask.pb.cc",
            "protobuf/src/google/protobuf/generated_message_reflection.cc",
            "protobuf/src/google/protobuf/generated_message_table_driven.cc",
            "protobuf/src/google/protobuf/io/gzip_stream.cc",
            "protobuf/src/google/protobuf/io/printer.cc",
            "protobuf/src/google/protobuf/io/tokenizer.cc",
            "protobuf/src/google/protobuf/map_field.cc",
            "protobuf/src/google/protobuf/message.cc",
            "protobuf/src/google/protobuf/reflection_ops.cc",
            "protobuf/src/google/protobuf/service.cc",
            "protobuf/src/google/protobuf/source_context.pb.cc",
            "protobuf/src/google/protobuf/struct.pb.cc",
            "protobuf/src/google/protobuf/stubs/substitute.cc",
            "protobuf/src/google/protobuf/text_format.cc",
            "protobuf/src/google/protobuf/timestamp.pb.cc",
            "protobuf/src/google/protobuf/type.pb.cc",
            "protobuf/src/google/protobuf/unknown_field_set.cc",
            "protobuf/src/google/protobuf/util/delimited_message_util.cc",
            "protobuf/src/google/protobuf/util/field_comparator.cc",
            "protobuf/src/google/protobuf/util/field_mask_util.cc",
            "protobuf/src/google/protobuf/util/internal/datapiece.cc",
            "protobuf/src/google/protobuf/util/internal/default_value_objectwriter.cc",
            "protobuf/src/google/protobuf/util/internal/error_listener.cc",
            "protobuf/src/google/protobuf/util/internal/field_mask_utility.cc",
            "protobuf/src/google/protobuf/util/internal/json_escaping.cc",
            "protobuf/src/google/protobuf/util/internal/json_objectwriter.cc",
            "protobuf/src/google/protobuf/util/internal/json_stream_parser.cc",
            "protobuf/src/google/protobuf/util/internal/object_writer.cc",
            "protobuf/src/google/protobuf/util/internal/proto_writer.cc",
            "protobuf/src/google/protobuf/util/internal/protostream_objectsource.cc",
            "protobuf/src/google/protobuf/util/internal/protostream_objectwriter.cc",
            "protobuf/src/google/protobuf/util/internal/type_info.cc",
            "protobuf/src/google/protobuf/util/internal/type_info_test_helper.cc",
            "protobuf/src/google/protobuf/util/internal/utility.cc",
            "protobuf/src/google/protobuf/util/json_util.cc",
            "protobuf/src/google/protobuf/util/message_differencer.cc",
            "protobuf/src/google/protobuf/util/time_util.cc",
            "protobuf/src/google/protobuf/util/type_resolver_util.cc",
            "protobuf/src/google/protobuf/wire_format.cc",
            "protobuf/src/google/protobuf/wrappers.pb.cc",
        ],
        header_namespace = "",
        headers = glob([
            "protobuf/src/**/*.h",
            "protobuf/src/**/*.inc",
        ]),
        exported_headers = subdir_glob([
            ("protobuf/src", "google/protobuf/**/*.h"),
            ("protobuf/src", "google/protobuf/**/*.inc"),
        ]),
        compiler_flags = COPTS,
        # exported_headers = ["src/"],
        linker_flags = LINK_OPTS,
        visibility = ["PUBLIC"],
        deps = [":protobuf_lite", ":zlib"],
    )

    # This provides just the header files for use in projects that need to build
    # shared libraries for dynamic loading. This target is available until Bazel
    # adds native support for such use cases.
    # TODO(keveman): Remove this target once the support gets added to Bazel.
    cxx_library(
        name = "protobuf_headers",
        exported_headers = glob([
            "protobuf/src/**/*.h",
            "protobuf/src/**/*.inc",
        ]),
        # exported_headers = ["src/"],
        visibility = ["PUBLIC"],
    )