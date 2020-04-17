#!/bin/bash
BAZEL_VERSION='0.18.1'
wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh

# install bazel
chmod +x bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh --user

# export environment variable
export PATH="$PATH:$HOME/bin"

# download tensorflow source code
git clone --recursive -b v1.12.3 --single-branch https://github.com/tensorflow/tensorflow.git

# config
cd tensorflow
./configure

# install dependency packages
pip install -U --user pip six numpy wheel mock
pip install -U --user keras_applications==1.0.6 --no-deps
pip install -U --user keras_preprocessing==1.0.5 --no-deps

# soft link *.so
sudo ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libcudart.so.10.1.243 /usr/local/cuda/lib64/libcudart.so.10.1
sudo ln -s /usr/lib/x86_64-linux-gnu/libcudnn.so.7.6.5 /usr/local/cuda/lib64/libcudnn.so.7
sudo ln -s /usr/lib/x86_64-linux-gnu/libcublas.so.10.2.1.243 /usr/local/cuda/lib64/libcublas.so.10.1
sudo ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libcufft.so.10.1.1.243 /usr/local/cuda/lib64/libcufft.so.10.1
sudo ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libcurand.so.10.1.1.243 /usr/local/cuda/lib64/libcurand.so.10.1
sudo ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libcusolver.so.10.2.0.243 /usr/local/cuda/lib64/libcusolver.so.10.1
sudo ln -s /usr/local/cuda-10.1/targets/x86_64-linux/lib/libcusparse.so.10.3.0.243 /usr/local/cuda/lib64/libcusparse.so.10.1

# fix couldn't find cuda.h problem
sed -i '637i"@local_config_cuda//cuda:cuda_headers",' tensorflow/compiler/xla/service/gpu/BUILD
sed -i '6iload("@local_config_cuda//cuda:build_defs.bzl", "if_cuda")' tensorflow/compiler/xla/service/gpu/BUILD
# below line fix "cuda/include/cublas_v2.h: No such file or directory" problem
sudo ln -s /usr/include/cublas_v2.h /usr/local/cuda-10.1/include/cublas_v2.h

# build
bazel build --config=opt --config=cuda --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" //tensorflow/tools/pip_package:build_pip_package
