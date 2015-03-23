echo update submodules...
git submodule update --init --recursive
git submodule foreach git pull origin master	
pushd omnisharp-roslyn
./build.sh
popd
rm -rf lib/server
mkdir -p lib/server
cp -a omnisharp-roslyn/artifacts/build/omnisharp/* lib/server
curl -LO http://nuget.org/nuget.exe
mono nuget.exe install kre-clr-win-x86 -Prerelease -OutputDirectory lib/server/approot/packages
cp -f omnisharp.cmd.patch lib/server/omnisharp.cmd

#cd OmniSharpServer
#xbuild
#cd ..
git commit  -am "updated omnisharp server"
npm version patch -m "updating to %s"
npm publish
git push origin master


