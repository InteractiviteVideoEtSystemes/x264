## !C:\msys64\msys-jenkins.bat
export THIRDPARTIES=../doubango/doubango/thirdparties/win64
export CC=cl
# export PATH="/mingw64/bin:/usr/local/bin:/usr/bin:/bin:/c/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE/CommonExtensions/Microsoft/TestWindow:/c/Program Files (x86)/MSBuild/14.0/bin/amd64:/c/Program Files (x86)/Microsoft Visual Studio 14.0/VC/BIN/amd64:/c/Windows/Microsoft.NET/Framework64/v4.0.30319:/c/Program Files (x86)/Microsoft Visual Studio 14.0/VC/VCPackages:/c/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/IDE:/c/Program Files (x86)/Microsoft Visual Studio 14.0/Common7/Tools:/c/Program Files (x86)/HTML Help Workshop:/c/Program Files (x86)/Microsoft Visual Studio 14.0/Team Tools/Performance Tools/x64:/c/Program Files (x86)/Microsoft Visual Studio 14.0/Team Tools/Performance Tools:/c/Program Files (x86)/Windows Kits/10/bin/x64:/c/Program Files (x86)/Windows Kits/10/bin/x86:/c/Program Files (x86)/Microsoft SDKs/Windows/v10.0A/bin/NETFX 4.6.1 Tools/x64:/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/c/Program Files/Microsoft MPI/Bin:/c/Windows/system32:/c/Windows:/c/Windows/System32/Wbem:/c/Windows/System32/WindowsPowerShell/v1.0:/c/Windows/System32/OpenSSH:/c/Program Files/dotnet:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"

# Remove old versions
rm -f $THIRDPARTIES/bin/x264.exe
rm -f $THIRDPARTIES/lib/x86_64/pkgconfig/x264.pc
rm -f $THIRDPARTIES/include/x264*h
rm -f $THIRDPARTIES/lib/x86_64/libx264.*

# Configure and compile
./configure --enable-debug --enable-pic --enable-static --disable-swscale --prefix=$THIRDPARTIES --libdir=$THIRDPARTIES/lib/x86_64
make

#Install lib and headers
make install
make clean