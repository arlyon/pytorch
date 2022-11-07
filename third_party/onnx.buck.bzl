load("@prelude//:rules.bzl", "genrule", "cxx_library", "cxx_binary")
load("//tools/build_defs:glob_defs.bzl", "subdir_glob")

def define_onnx():

    cxx_library(
        name = "onnx",
        srcs = glob(
            [
                "onnx/*.cc",
                "onnx/common/*.cc",
                "onnx/defs/*.cc",
                "onnx/defs/controlflow/*.cc",
                "onnx/defs/experiments/*.cc",
                "onnx/defs/generator/*.cc",
                "onnx/defs/logical/*.cc",
                "onnx/defs/math/*.cc",
                "onnx/defs/nn/*.cc",
                "onnx/defs/object_detection/*.cc",
                "onnx/defs/optional/*.cc",
                "onnx/defs/quantization/*.cc",
                "onnx/defs/reduction/*.cc",
                "onnx/defs/rnn/*.cc",
                "onnx/defs/sequence/*.cc",
                "onnx/defs/tensor/*.cc",
                "onnx/defs/traditionalml/*.cc",
                "onnx/defs/training/defs.cc",
                "onnx/shape_inference/*.cc",
                "onnx/version_converter/*.cc",
            ],
            exclude = [
                "onnx/cpp2py_export.cc",
            ],
        ),
        headers = glob([
            "onnx/*.h",
            "onnx/version_converter/*.h",
            "onnx/common/*.h",
            "onnx/defs/*.h",
            "onnx/defs/tensor/*.h",
            "onnx/shape_inference/*.h",
            "onnx/version_converter/adapters/*.h",
        ]),
        visibility = ["PUBLIC"],
        deps = [
            ":onnx_proto_lib",
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
        exported_headers = subdir_glob([
            ("onnx/compiled_proto", "*_pb.h"),
            ("onnx/compiled_proto", "*.pb.h")
        ]),
        exported_preprocessor_flags = [
            "-DONNX_NAMESPACE=onnx_torch",
            "-DONNX_ML=1",
        ]
    )

    cxx_library(
        name = "onnx_proto_lib",
        # src = []
    )
