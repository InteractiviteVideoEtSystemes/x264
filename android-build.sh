#!/bin/sh
BUILD_ARCHS="armv5te armv7-a armv7-a-neon arm64 x86 x86_64"
#BUILD_ARCHS="x86"
SAV_PATH=$PATH
LOG=build.log

OUTPUT_LIB="android"

date >$LOG

build_arm(){
    clean_env
    ANDROID_PLATFORM=android-3
    GCC_VERSION=4.8
    ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-arm/
    CROSS_PREFIX=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/bin/arm-linux-androideabi-
    PREFIX="$OUTPUT_LIB/$1"

    ARM_LIB=$ANDROID_NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-arm/usr/lib
    ARM_TOOL=$ANDROID_NDK_ROOT/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/bin
    ANDROID_GCC_PREFIX=arm-linux-androideabi
    PATH=$ARM_TOOL:$NDK:$NDK/tools:$NDK/platform-tools:$NDK/toolchains/arm-linux-androideabi-$GCC_VERSION/prebuilt/linux-x86_64/arm-linux-androideabi/bin:$PATH

    CC=$ARM_TOOL/$ANDROID_GCC_PREFIX-gcc
    LD=$ARM_TOOL/$ANDROID_GCC_PREFIX-ld
    CPP=$ARM_TOOL/$ANDROID_GCC_PREFIX-cpp
    CXX=$ARM_TOOL/$ANDROID_GCC_PREFIX-g++
    AR=$ARM_TOOL/$ANDROID_GCC_PREFIX-ar
    AS=$ARM_TOOL/$ANDROID_GCC_PREFIX-as
    RANLIB=$ARM_TOOL/$ANDROID_GCC_PREFIX-ranlib
    ASFLAGS=""

    case "$1" in
        armv7-a)
        LDFLAGS="-Wl,--fix-cortex-a8 -L$ARM_LIB -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker  -lc -lm -ldl -lgcc"
        CFLAGS="-march=armv7-a -mfloat-abi=softfp -fPIC --sysroot=$ANDROID_SYSROOT"

        ./configure --enable-static \
                    --disable-cli \
                    --prefix=$PREFIX  \
                    --cross-prefix=${CROSS_PREFIX} \
                    --sysroot=$ANDROID_SYSROOT \
                    --host=arm-linux \
                    --extra-cflags="$CFLAGS" \
                    --extra-ldflags="$LDFLAGS" \
                    --enable-pic
        ;;
        armv7-a-neon)
        LDFLAGS="-Wl,--fix-cortex-a8 -L$ARM_LIB -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker  -lc -lm -ldl -lgcc"
        CFLAGS="-march=armv7-a -mfpu=neon -DANDROID -mfloat-abi=softfp --sysroot=$ANDROID_SYSROOT"

        ./configure --enable-static \
                    --disable-cli \
                    --prefix=$PREFIX  \
                    --cross-prefix=${CROSS_PREFIX} \
                    --sysroot=$ANDROID_SYSROOT \
                    --host=arm-linux \
                    --extra-cflags="$CFLAGS" \
                    --extra-ldflags="$LDFLAGS" \
                    --enable-pic
        ;;
        armv5te)
        LDFLAGS="-L$ARM_LIB -Wl,-rpath-link=$ARM_LIB,-dynamic-linker=/system/bin/linker  -lc -lm -ldl -lgcc"
        CFLAGS="-march=armv5te -mtune=xscale -mfloat-abi=softfp -fPIC --sysroot=$ANDROID_SYSROOT"

        ./configure --enable-static \
                    --disable-asm \
                    --disable-cli \
                    --prefix=$PREFIX \
                    --cross-prefix=${CROSS_PREFIX} \
                    --sysroot=$ANDROID_SYSROOT \
                    --host=arm-linux \
                    --extra-cflags="$CFLAGS" \
                    --extra-ldflags="$LDFLAGS" \
                    --enable-pic
        ;;
        *)
        ;;
        esac
}


build_arm64(){
    clean_env
    GCC_VERSION=4.9
    ANDROID_PLATFORM=android-21
    ANDROID_GCC_PREFIX=aarch64-linux-android
    ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/android-21/arch-arm64
    CROSS_PREFIX=$ANDROID_NDK_ROOT/toolchains/aarch64-linux-android-$GCC_VERSION/prebuilt/linux-x86_64/bin/aarch64-linux-android-
    EXTRA_CFLAGS="-march=armv8-a -fPIC -D__ANDROID__"
    EXTRA_LDFLAGS="-nostdlib"
    PREFIX="$OUTPUT_LIB/$arch"


    ARM_TOOL=$ANDROID_NDK_ROOT/toolchains/aarch64-linux-android-$GCC_VERSION/prebuilt/linux-x86_64/bin
    PATH=ARM_TOOL:$NDK:$NDK/tools:$NDK/platform-tools:$NDK/toolchains/aarch64-linux-android-$GCC_VERSION/prebuilt/linux-x86_64/aarch64-linux-android/bin:$SAV_PATH

    CC=$ARM_TOOL/$ANDROID_GCC_PREFIX-gcc
    LD=$ARM_TOOL/$ANDROID_GCC_PREFIX-ld
    CPP=$ARM_TOOL/$ANDROID_GCC_PREFIX-cpp
    CXX=$ARM_TOOL/$ANDROID_GCC_PREFIX-g++
    AS=$ARM_TOOL/$ANDROID_GCC_PREFIX-gcc # Don't use $ARM_TOOL/$ANDROID_GCC_PREFIX-as. Conflict with stack alignment.
    AR=$ARM_TOOL/$ANDROID_GCC_PREFIX-ar
    RANLIB=$ARM_TOOL/$ANDROID_GCC_PREFIX-ranlib
    ASFLAGS=""

    ./configure --prefix=$PREFIX \
            --host="aarch64-linux" \
            --sysroot="$ANDROID_SYSROOT" \
            --cross-prefix="$CROSS_PREFIX" \
            --extra-asflags="$ASFLAGS" \
            --extra-cflags="$EXTRA_CFLAGS" \
            --extra-ldflags="$EXTRA_LDFLAGS" \
            --enable-pic \
            --enable-static \
            --enable-strip \
            --disable-cli \
            --disable-win32thread \
            --disable-avs \
            --disable-swscale \
            --disable-lavf \
            --disable-ffms \
            --disable-gpac \
            --disable-lsmash
}

build_x64(){
    clean_env

    ANDROID_PLATFORM=android-21
    GCC_VERSION=4.9
    ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/$ANDROID_PLATFORM/arch-x86_64
    PREFIX="$OUTPUT_LIB/x86_64"
    CROSS_PREFIX="$NDK/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/bin/x86_64-linux-android-"
    
    LDFLAGS=""
    CFLAGS="-march=x86-64 -fPIC --sysroot=$ANDROID_SYSROOT"

    ARM_TOOL=$ANDROID_NDK_ROOT/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/bin
    ANDROID_GCC_PREFIX=x86_64-linux-android

    export PATH=$ARM_TOOL:$SAV_PATH
    export PATH=$NDK:$NDK/tools:$NDK/platform-tools:$NDK/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/x86_64-linux-android/bin:$PATH

    export CC=$ARM_TOOL/$ANDROID_GCC_PREFIX-gcc
    export LD=$ARM_TOOL/$ANDROID_GCC_PREFIX-ld
    export CPP=$ARM_TOOL/$ANDROID_GCC_PREFIX-cpp
    export CXX=$ARM_TOOL/$ANDROID_GCC_PREFIX-g++
    export AR=$ARM_TOOL/$ANDROID_GCC_PREFIX-ar
    export ASFLAGS=""

    ./configure --disable-asm \
                --enable-static \
                --enable-pic \
                --extra-cflags="$CFLAGS" \
                --extra-ldflags="$LDFLAGS" \
                --prefix="$OUTPUT_LIB/$arch" \
                --sysroot=$ANDROID_SYSROOT \
                --host=x86_64-linux \
                --cross-prefix=${CROSS_PREFIX}
}

build_x86(){
    clean_env
    
    GCC_VERSION=4.8
    ANDROID_GCC_PREFIX=i686-linux-android
    HOST=i686-linux-android
    ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/android-9/arch-x86
    CROSS_PREFIX=$ANDROID_NDK_ROOT/toolchains/x86-$GCC_VERSION/prebuilt/linux-x86_64/bin/i686-linux-android-
    EXTRA_CFLAGS="-march=i686 -fPIC -D__ANDROID__"
    EXTRA_LDFLAGS=""
    PREFIX="$OUTPUT_LIB/$arch"


    ARM_TOOL=$ANDROID_NDK_ROOT/toolchains/x86-$GCC_VERSION/prebuilt/linux-x86_64/bin
    PATH=$ARM_TOOL:$SAV_PATH
    PATH=$NDK:$NDK/tools:$NDK/platform-tools:$NDK/toolchains/x86_64-$GCC_VERSION/prebuilt/linux-x86_64/i686-linux-android/bin:$PATH

    CC=$ARM_TOOL/$ANDROID_GCC_PREFIX-gcc
    LD=$ARM_TOOL/$ANDROID_GCC_PREFIX-ld
    CPP=$ARM_TOOL/$ANDROID_GCC_PREFIX-cpp
    CXX=$ARM_TOOL/$ANDROID_GCC_PREFIX-g++
    AR=$ARM_TOOL/$ANDROID_GCC_PREFIX-ar
    AS=$ARM_TOOL/$ANDROID_GCC_PREFIX-as
    RANLIB=$ARM_TOOL/$ANDROID_GCC_PREFIX-ranlib
    ASFLAGS=""

    ./configure --disable-asm \
                --enable-static \
                --enable-pic \
                --disable-cli \
                --host=$HOST \
                --prefix=$OUTPUT_LIB/$arch \
                --sysroot=$ANDROID_SYSROOT \
                --cross-prefix=${CROSS_PREFIX} \
                --extra-cflags="$CFLAGS" \
                --extra-ldflags="$LDFLAGS"
}


clean_env()
{
    CPPFLAGS=""
    ASFLAGS=""
    SYSROOT=""
    CC=""
    AR=""
    CXX=""
    CPP=""
    AS=""
    RANLIB=""
    STRIP=""
    CFLAGS=""
    CPPFLAGS=""
    LDFLAGS=""
    ANDROID_PREFIX=""
    ANDROID_TOOLCHAIN=""
    HOST=""
    ANDROID_PLATFORM=""
    GCC_VERSION=""
    ANDROID_SYSROOT=""
    ARM_LIB=""
    ARM_TOOL=""
}

echo build for $BUILD_ARCHS
for arch in $BUILD_ARCHS
do
	echo -e building for ARCH="$arch ...\n"

    echo "Cleaning output folder"
    rm -r $OUTPUT_LIB/$arch

 	case "$arch" in
      x86)
      build_x86
      ;;
      arm64)
      build_arm64
      ;;
      x86_64)
      build_x64
      ;;
      *)
      build_arm $arch
      ;;
  esac

  
    make clean  >>$LOG 
    make uninstall  >>$LOG
    make -j4 >>$LOG #all  >>$LOG
    make install  >>$LOG

    export PATH=$SAV_PATH
done

	

