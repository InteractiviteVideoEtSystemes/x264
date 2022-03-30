Installations nécessaires :

 * Installer MSYS2, voir l'installation sur https://www.msys2.org/
 * Lancer "MSYS2 MSYS" et faire la dernière étape :
   $ pacman -S --needed base-devel mingw-w64-x86_64-toolchain
 * Faire aussi les installation de nasm et git :
   $ pacman -S --needed nasm
   $ pacman -S --needed git
   
Compilation :
Pour la version 32 Release,32 Debug, 64 Release et 64 Debug, lancer les batchs dos respectifs suivants, 
l'installation se fait dans doubango si les deux projets sont dans un même dossier racine.
build_x264_x86release.bat
build_x264_x86debug.bat
build_x264_x64release.bat
build_x264_x64debug.bat

Si le fichier .depend existe penser à le supprimer en cas d'erreurs de compilations
   