#! /bin/sh

tmpdir=tmpdir-$$
installdir=/usr/share/info
#change
info0=emacs
info1=elisp
info2=eintr

check_root()
{
    myid=$(id -u)
    if [ $myid -ne 0 ] ; then
	echo "error: only root can run this program" >&2
	exit 1
    fi
}

check_root

if [ -e $tmpdir ] ; then
    echo "tmpdir already exists."
    exit 1
fi

mkdir $tmpdir

#change
tar xvf emacs.info.tar.gz -C $tmpdir
tar xvf elisp.info.tar.gz -C $tmpdir
cp emacs-lisp-intro.info.gz $tmpdir

cd $tmpdir

#change
gunzip emacs-lisp-intro.info.gz
mv emacs-lisp-intro.info eintr.info

gzip *
mv * $installdir

cd $installdir

ginstall-info --info-file=$info0.info --dir-file=dir --delete
ginstall-info --info-file=$info1.info --dir-file=dir --delete
ginstall-info --info-file=$info2.info --dir-file=dir --delete
ginstall-info --info-file=$info0.info --dir-file=dir
ginstall-info --info-file=$info1.info --dir-file=dir
ginstall-info --info-file=$info2.info --dir-file=dir

cd -

cd ..

rm -R $tmpdir
