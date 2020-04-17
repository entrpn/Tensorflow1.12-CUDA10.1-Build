# Tensorflow1.12-CUDA10.1-Build
Build tensorflow 1.12 source code with CUDA 10.1 in Ubuntu

This repo provide bash script and jupyter notebook script

You can also use Colab to run jupyter notebook script, it take about 11 hours to compile (almost reach the Colab time limit !)

# Abstract
1. Install bazel 0.18.1 (0.15 ~ 0.17 will not work)
2. Soft link missing CUDA *.so file
3. Soft link missing CUDA header file
4. Add CUDA header to some bzl file which has compile problem
5. Compile with bazel, and that's all
