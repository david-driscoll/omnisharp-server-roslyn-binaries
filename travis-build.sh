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
if [ ! -d "lib/server/approot/packages/kre-clr-win-x86.1.0.0-beta3" ]; then
    echo 'ERROR: Can not find kre-clr-win-x86.1.0.0-beta3 in output exiting!'
    exit 1
fi
if [ ! -d "lib/server/approot/packages/kre-mono.1.0.0-beta3" ]; then
    echo 'ERROR: Can not find kre-mono.1.0.0-beta3 in output exiting!'
    exit 1
fi

cp -f omnisharp.cmd.patch lib/server/omnisharp.cmd
cp -f omnisharp.patch lib/server/omnisharp
chmod +x lib/server/omnisharp

if ! type kvm > /dev/null 2>&1; then
    curl -sSL https://raw.githubusercontent.com/aspnet/Home/release/kvminstall.sh | sh && source ~/.k/kvm/kvm.sh
fi
export KRE_FEED=https://www.nuget.org/api/v2
kvm install 1.0.0-beta3
kvm use 1.0.0-beta3

pushd src/OmniSharp.TypeScriptGeneration
kpm restore
k run ../../lib/server
popd

npm --no-git-tag-version version $TRAVIS_TAG -m "updating to $TRAVIS_TAG"
