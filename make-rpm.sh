#!/bin/sh
if [ -z "$1" ]; then
  echo "usage: ./make-rpm.sh 0.4"
  exit 1
fi
version=$1
cur=`pwd`

rm -f fluent-agent-lite.v$version.tar.gz
rm -fr fluent-agent-lite
wget --no-check-certificate https://github.com/downloads/tagomoris/fluent-agent-lite/fluent-agent-lite.v$version.tar.gz
tar xvzf fluent-agent-lite.v$version.tar.gz

# setup rpmbuild env
echo "%_topdir $cur/rpmbuild/" > ~/.rpmmacros
rm -fR rpmbuild
mkdir rpmbuild
pushd rpmbuild
mkdir BUILD RPMS SOURCES SPECS SRPMS
# locate spec
cp ../fluent-agent-lite/SPECS/fluent-agent-lite.spec SPECS
# locate source tarball
mv ../fluent-agent-lite.v$version.tar.gz SOURCES
# locate conf
cp ../fluent-agent-lite/package/fluent-agent-lite.conf SOURCES
# locate init.d script
cp ../fluent-agent-lite/package/fluent-agent-lite.init SOURCES
# build
rpmbuild -v -ba --clean SPECS/fluent-agent-lite.spec
popd
