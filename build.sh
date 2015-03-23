echo update submodules...
git submodule update --init --recursive
git submodule foreach git pull origin master	
pushd omnisharp-roslyn
./build.sh
popd
rm -rf lib/server
mkdir -p lib/server
cp -a omnisharp-roslyn/artifacts/build/omnisharp/* lib/server

echo ---------------------------
echo build for mono, manually build for windows now 
echo -- copy its kre-clr-* folder in lib/server/approot/packages
echo -- copy its omnisharp.cmd to lib/server/approot
echo then call ./release

#cd OmniSharpServer
#xbuild
#cd ..
#git commit  -am "updated omnisharp server"
#npm version patch -m "updating to %s"
#npm publish
#git push origin master


