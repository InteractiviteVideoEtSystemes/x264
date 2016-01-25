#!/usr/bin/ksh

#Nom du paquetage
PROJET=x264
VERSION=0.6.3
#Repertoire temporaire utiliser pour preparer les packages
TEMPDIR=/tmp

function svn_export
{
        svn export http://svn.ives.fr/svn-libs-dev/asterisk/libsmedia/${PROJET}
}

#Creation de l'environnement de packaging rpm
function create_rpm
{
    #Cree l'environnement de creation de package
    #Creation des macros rpmbuild
    rm ~/.rpmmacros
    touch ~/.rpmmacros
    echo "%_prefix" "/usr" >> ~/.rpmmacros
    echo "%_version" $VERSION >> ~/.rpmmacros
    echo "%_topdir" $PWD"/rpmbuild" >> ~/.rpmmacros
    echo "%_tmppath %{_topdir}/TMP" >> ~/.rpmmacros
    echo "%_signature gpg" >> ~/.rpmmacros
    echo "%_gpg_name IVeSkey" >> ~/.rpmmacros
    echo "%_gpg_path" $PWD"/gnupg" >> ~/.rpmmacros
    echo "%vendor IVeS" >> ~/.rpmmacros
    #Import de la clef gpg IVeS
    if [[ -z $1 || $1 -ne nosign ]]
    then
        svn export https://svn.ives.fr/svn-libs-dev/gnupg
    fi
    mkdir -p rpmbuild
    mkdir -p rpmbuild/SOURCES
    mkdir -p rpmbuild/SPECS
    mkdir -p rpmbuild/BUILD
    mkdir -p rpmbuild/SRPMS
    mkdir -p rpmbuild/TMP
    mkdir -p rpmbuild/RPMS
    mkdir -p rpmbuild/RPMS/noarch
    mkdir -p rpmbuild/RPMS/i386
    mkdir -p rpmbuild/RPMS/i686
    mkdir -p rpmbuild/RPMS/i586
    #Recuperation de la description du package 
    cd ./rpmbuild/SPECS/
    cp ../../${PROJET}.spec ${PROJET}.spec
    cd ../../
    git checkout -b $VERSION $VERSION
	
    git status | grep nothing
    if [ $? == 0 ]
    then
        #Cree le package
        if [[ -z $1 || $1 -ne nosign ]]
        then
            rpmbuild -bb --sign $PWD/rpmbuild/SPECS/${PROJET}.spec
        else
            rpmbuild -bb $PWD/rpmbuild/SPECS/${PROJET}.spec
        fi
        if [[ $? -eq 0 ]]
        then
            echo "************************* fin du rpmbuild ****************************"
            #Recuperation du rpm
            mv -f $PWD/rpmbuild/RPMS/i386/*.rpm $PWD/.
            mv -f $PWD/rpmbuild/RPMS/x86_64/*.rpm $PWD/.
	    clean
        else
	    echo "** build failed **"
            clean
            exit 20
        fi
    else
        clean
	echo "*** error during build - some source files are not commited ***"
	exit 20
    fi
}

function clean
{
  	# On efface les liens ainsi que le package precedemment créé
  	echo Effacement des fichiers et liens gnupg rpmbuild ${PROJET}.rpm ${TEMPDIR}/${PROJET}
  	rm -rf gnupg rpmbuild ${PROJET}.rpm ${TEMPDIR}/${PROJET}
}

case $1 in
  	"clean")
  		echo "Nettoyage des liens et du package crees par la cible dev"
  		clean ;;
  	"rpm")
  		echo "Creation du rpm"
  		create_rpm $2;;
  	*)
  		echo "usage: install.ksh [options]" 
  		echo "options :"
  		echo "  rpm		Generation d'un package rpm"
  		echo "  clean		Nettoie tous les fichiers cree par le present script, liens, tar.gz et rpm";;
esac
