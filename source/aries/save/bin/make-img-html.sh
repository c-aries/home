#! /bin/sh

# FIXME:
# for name in *.png; do new=$(echo $name | sed -n 's/jtag-\([0-9]*\).png/\1/pg'); new=$(printf "%02d\n" $new); mv $name jtag-$new.png; done

width=
height=

type_is()
{
# $1= file_type_message $2= file_name
    if [ $# -ne 2 ] ; then
	echo "error occured in type_is function!"
	echo "usage: type_is file_type_message file_name"
	exit 1
    fi
    filetype=`file "$2"`
    filetype="${filetype#* }"
    echo "$filetype" | grep -q "$1"
    return $?
}

make_html()
{
    rm -f img.html
    total=$(ls -1 | wc | awk '{ print $1 }')
    num=0
    percent=$(echo "$num * 100 / $total" | bc 2>/dev/null)
    echo -ne "generate percent: ${percent:-0}%\r"
    for name in *
    do
	if [ -f "$name" ] ; then
 	    type_is "JPEG image" "$name"
	    temp1=$?
	    type_is "PNG image" "$name"
	    temp2=$?
 	    type_is "GIF image" "$name"
	    temp3=$?
	    type_is "PC bitmap" "$name"
	    temp4=$?
	    if [ $temp1 -eq 0 ] || [ $temp2 -eq 0 ] || [ $temp3 -eq 0 ] || [ $temp4 -eq 0 ] ; then
		echo "<img src=\"$name\" width=\"$width\" height=\"$height\">" >> img.html
		echo "<img src=\"$name\" width=\"$width\" height=\"$height\">" > img-${name}.html
	    fi
	fi
	num=$((num+1))
	percent=$(echo "$num * 100 / $total" | bc 2>/dev/null)
	echo -n
	echo -ne "generate percent: ${percent:-0}%\r"
    done
    echo
}

make_sed()
{
cat > img-sed.sh <<EOF
#! /bin/sh

prefix=\$1

if [ \$# -eq 0 ] ; then
    echo "error: must have arguments"
    exit 1
fi

for name in *.png;
do
    new=\$(echo \$name | sed -n "s/\${prefix}-\([0-9]*\).png/\1/pg");
    new=\$(printf "%03d\n" \$new);
    mv \$name \$prefix-\$new.png;
done 
EOF
chmod +x img-sed.sh
}

rm -f *~

if [ x"$1" == x"--size" ] ; then
    width=$(echo "$2" | cut -dx -f 1)
    height=$(echo "$2" | cut -dx -f 2)
    echo "width = ${width}, height = ${height}"
    shift 2
fi

if [ x"$1" == x"--sed" ] ; then
    make_sed
    exit 0
fi

make_html
