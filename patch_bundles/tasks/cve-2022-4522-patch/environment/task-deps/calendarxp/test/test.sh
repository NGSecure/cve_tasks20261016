#! /bin/bash
set -ex
if [[ "$1" == "-c" ]] ; then
    rm -rf work
fi
mkdir -p work
cd work
for m in mocha chai js-fixtures mocha-phantomjs ; do
    test -d node_modules/"${m}" || npm install "${m}"
done
test -s "jquery-3.2.1.js" || wget "https://code.jquery.com/jquery-3.2.1.js"
for js in ../test*.js ; do
    base="${js##*/}"
    name="${base#*-}"
    name="${name%.js}"
    mkdir -p "${name}"
    test ../test.html -ot "${name}/test.html" || sed -e "s/\${FILENAME}/${base}/g" < ../test.html > "${name}/test.html"
    test "${js}" -ot "${name}/test.js" || sed -e "s/\${FILENAME}/${base}/g" < "${js}" > "${name}/test.js"
    d="../../${name//-/\/}"
    test -d "${d}" || d="${d%/*}"
    cp -a "${d}/"* "${name}/"
    cd "${name}"
    ../node_modules/mocha-phantomjs/bin/mocha-phantomjs test.html
    cd ..
done
cd ..

