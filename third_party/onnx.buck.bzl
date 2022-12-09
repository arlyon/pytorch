load("@prelude//:rules.bzl", "genrule", "cxx_library", "cxx_binary")
load("//tools/build_defs:glob_defs.bzl", "subdir_glob")

def define_onnx():

    cxx_library(
        name = "onnx",
        srcs = glob(
            [
                "onnx/onnx/*.cc",
                "onnx/onnx/common/*.cc",
                "onnx/onnx/defs/*.cc",
                "onnx/onnx/defs/controlflow/*.cc",
                "onnx/onnx/defs/experiments/*.cc",
                "onnx/onnx/defs/generator/*.cc",
                "onnx/onnx/defs/logical/*.cc",
                "onnx/onnx/defs/math/*.cc",
                "onnx/onnx/defs/nn/*.cc",
                "onnx/onnx/defs/object_detection/*.cc",
                "onnx/onnx/defs/optional/*.cc",
                "onnx/onnx/defs/quantization/*.cc",
                "onnx/onnx/defs/reduction/*.cc",
                "onnx/onnx/defs/rnn/*.cc",
                "onnx/onnx/defs/sequence/*.cc",
                "onnx/onnx/defs/tensor/*.cc",
                "onnx/onnx/defs/traditionalml/*.cc",
                "onnx/onnx/defs/training/defs.cc",
                "onnx/onnx/shape_inference/*.cc",
                "onnx/onnx/version_converter/*.cc",
            ],
            exclude = [
                "onnx/onnx/cpp2py_export.cc",
            ],
        ),
        visibility = ["PUBLIC"],
        deps = [
            ":onnx_proto_lib",
            ":onnx_headers",
        ],
        exported_preprocessor_flags = [
            "-DONNX_NAMESPACE=onnx_torch",
            "-DONNX_ML=1",
        ]
    )

    cxx_library(
        name = "onnx_headers",
        header_namespace = "",
        exported_headers = subdir_glob([
            ("onnx", "onnx/*.h"),
            ("onnx", "onnx/version_converter/*.h"),
            ("onnx", "onnx/common/*.h"),
            ("onnx", "onnx/defs/*.h"),
            ("onnx", "onnx/defs/tensor/*.h"),
            ("onnx", "onnx/shape_inference/*.h"),
            ("onnx", "onnx/version_converter/adapters/*.h"),
        ]),
        visibility = ["PUBLIC"],
        exported_deps = [
            ":onnx_proto_headers",
        ],
        exported_preprocessor_flags = [
            "-DONNX_NAMESPACE=onnx_torch",
            "-DONNX_ML=1",
        ]
    )

    cxx_library(
        name = "onnx_proto_headers",
        header_namespace="",
        headers = glob([
            "onnx/*_pb.h",
            "onnx/*.pb.h",
        ]),
        exported_headers = subdir_glob([
            ("onnx", "onnx/*_pb.h"),
            ("onnx", "onnx/*.pb.h")
        ]),
        visibility = ["PUBLIC"],
        deps = [
            ":onnx_proto_lib",
        ],
        exported_deps = [
            "//third_party:protobuf",
            ":onnx_compiled_proto",
        ],
        exported_preprocessor_flags = [
            "-DONNX_NAMESPACE=onnx_torch",
            "-DONNX_ML=1",
        ]
    )

    cxx_library(
        name = "onnx_compiled_proto",
        header_namespace="onnx",
        srcs = glob([
            "onnx/compiled_proto/*.cc",
        ]),
        exported_headers = subdir_glob([
            ("onnx/compiled_proto", "*_pb.h"),
            ("onnx/compiled_proto", "*.pb.h"),
        ]),
        exported_preprocessor_flags = [
            "-DONNX_NAMESPACE=onnx_torch",
            "-DONNX_ML=1",
        ],
        exported_deps = [
            "//third_party:protobuf",
        ]
    )

    cxx_library(
        name = "onnx_proto_lib",
        # src = []
    )
