load("@prelude//:rules.bzl", "genrule", "cxx_library", "cxx_binary", "python_binary", "python_library")
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
        exported_headers = dict(subdir_glob([
            ("onnx", "onnx/*_pb.h"),
            ("onnx", "onnx/*.pb.h")
        ]).items() + {
            "onnx/onnx-ml.pb.h": ":generate_onnx_proto[onnx-ml.pb.h]",
        }.items()),
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

    python_library(
        name = "gen_proto_lib",
        srcs = [
            "onnx/onnx/onnx.in.proto",
            "onnx/onnx/onnx-operators.in.proto",
            "onnx/onnx/onnx-data.in.proto"
        ],
        visibility = ["PUBLIC"],
    )


    python_binary(
        name = "gen_proto",
        main = "onnx/onnx/gen_proto.py",
        deps = [":gen_proto_lib"],
    )

    genrule(
        name = "generate_onnx_proto",
        outs = {
            "onnx_onnx_torch-ml.proto": ["onnx_onnx_torch-ml.proto"],
            "onnx-ml.pb.h": ["onnx-ml.pb.h"],
        },
        cmd = "$(location :gen_proto) -p onnx_torch -o $OUT onnx -m >/dev/null && sed -i 's/onnx_onnx_torch-ml.pb.h/onnx\\/onnx_onnx_torch-ml.pb.h/g' $OUT/onnx-ml.pb.h",
    )

    genrule(
        name = "generate_onnx_operators_proto",
        outs = {
            "onnx-operators_onnx_torch-ml.proto": ["onnx-operators_onnx_torch-ml.proto"],
            "onnx-operators-ml.pb.h": ["onnx-operators-ml.pb.h"],
        },
        cmd = "$(location :gen_proto) -p onnx_torch -o $OUT onnx-operators -m >/dev/null && sed -i 's/onnx-operators_onnx_torch-ml.pb.h/onnx\\/onnx-operators_onnx_torch-ml.pb.h/g' $OUT/onnx-operators-ml.pb.h",
    )

    genrule(
        name = "generate_onnx_data_proto",
        outs = {
            "onnx-data_onnx_torch.proto": ["onnx-data_onnx_torch.proto"],
            "onnx-data.pb.h": ["onnx-data.pb.h"],
        },
        cmd = "$(location :gen_proto) -p onnx_torch -o $OUT onnx-data -m >/dev/null && sed -i 's/onnx-data_onnx_torch.pb.h/onnx\\/onnx-data_onnx_torch.pb.h/g' $OUT/onnx-data.pb.h",
    )
