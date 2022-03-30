##!C:\msys64\msys-jenkins32.bat
export THIRDPARTIES=../doubango/doubango/thirdparties/win32
export CC=cl

# Remove old versions
rm -f $THIRDPARTIES/bin/x264.exe
rm -f $THIRDPARTIES/lib/x86_32/pkgconfig/x264.pc
rm -f $THIRDPARTIES/include/x264*h
rm -f $THIRDPARTIES/lib/x86_32/libx264.*

# Configure and compile
./configure --enable-pic --enable-static --disable-swscale --prefix=$THIRDPARTIES --libdir=$THIRDPARTIES/lib/x86_32
make

#Install lib and headers
make install
make clean