
# https://github.com/tensorflow/tensorflow/issues/36465

from numba import cuda

cuda.select_device(0)
cuda.close()
