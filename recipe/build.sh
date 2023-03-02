# Get an updated config.sub and config.guess
set -ex
cp $BUILD_PREFIX/share/gnuconfig/config.* .
mkdir build
cd build

# Manually disable SSE for platforms that don't support it
# in hardware 
# https://github.com/strukturag/libde265/issues/308
EXTRA_FLAGS=
if [[ "${target_platform}" == "osx-arm64" ]]; then
  EXTRA_FLAGS="${EXTRA_FLAGS} -DDISABLE_SSE=ON"
fi

cmake ${CMAKE_ARGS} -G "Ninja" \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_PREFIX_PATH="$PREFIX" \
  -DCMAKE_SYSTEM_PREFIX_PATH="$PREFIX" \
  -DCMAKE_BUILD_TYPE="Release" \
  ${EXTRA_FLAGS} \
  ..

ninja

ninja install
