Name:      x264
Version:   %_version
#Ne pas enlever le .ives a la fin de la release !
#Cela est utilise par les scripts de recherche de package.
Release:   1.ives%{?dist}
Summary:   [IVeS] Library for encoding and decoding H264/AVC video streams
Vendor:   IVeS
Group:     System Environment/Libraries
License: GPL
URL:       http://www.videolan.org/developers/x264.html
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
#BuildRequires: 

%description
Utility and library for encoding H264/AVC video streams. This version includes
a patch that enable to limit the size of slices and cut a signle picutre in
several slices (the so called multi slice option). This is primarily beused
for RTP encofing in order to conform to single NAL packetization mode.

%package devel
Summary: Libraries, includes to develop applications with %{name}.
Group: Development/Libraries
Requires: %{name} = %{version}

%description devel
The %{name}-devel package contains the header files and static libraries for
building apps and func which use %{name}.
  
%clean
echo "############################# Clean"
echo Clean du repertoire $RPM_BUILD_ROOT
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"

%build
echo "Build"
echo "############################# Build"
echo $PWD
%configure --enable-shared --enable-static --enable-pic --disable-thread --disable-ffms --disable-swscale 
make

%install
echo "############################# Install"
echo Clean du repertoire $RPM_BUILD_ROOT
[ "$RPM_BUILD_ROOT" != "/" ] && rm -rf "$RPM_BUILD_ROOT"
echo "Install" $PWD
mkdir -p $RPM_BUILD_ROOT
%makeinstall

%files
%defattr(-,root,root,-)
%{_libdir}/*.so*
%{_libdir}/pkgconfig/
/usr/bin/*

%files devel
%defattr(-,root,root)
%attr(0644,root,root) /usr/include/x264.h
%attr(0644,root,root) /usr/include/x264_config.h
%{_libdir}/*.a

%changelog
* Fri May 24 2013 Olivier Maquin <olivier.maquin@ives.fr>
- packaging version 0.6.1 
* Mon May 14 2012  Philippe Verney <philippe.verney@ives.fr>
- Compilation sans thread  
- version 0.5.0
* Thu Apr 17 2012  Philippe Verney <philippe.verney@ives.fr>
- Ajout compilation espace adressage indepandant ( PIC ) position-independent code 
- version 0.5.0
* Wed Jan 25 2012  Emmanuel BUU <emmanuel.buu@ives.fr>
- reintegration derniere version de GIT
- versio 0.5.0
* Tue Nov 29 2011 Emmanuel BUU <emmanuel.buu@ives.fr> 
- version IVeS 0.4.0
- got the latest version from GIT
* Mon Mar 09 2009 Didier Chabanol <didier.chabanol@ives.fr> 0.1.0-1.ives
- Initial package

