webpack --config webpack.build.config.js
bundleFilename=$(cat ./build/assets.json | jq '.main' | cut -d "/" -f 3)
cat index.html | sed "s/bundle.js/$bundleFilename/" > build/index.html
