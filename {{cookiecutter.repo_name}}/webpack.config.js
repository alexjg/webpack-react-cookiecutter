var path = require("path");
var webpack = require("webpack");

module.exports = {
    entry: './app/entry.coffee',
    output: {
        path: __dirname,
        filename: 'bundle.js',
        publicPath: "/assets/",
    },
    module: {
        loaders: [
            {test: /\.css$/, loader: "style!css"},
            {test: /\.coffee$/, loader: "coffee-loader"},
            {test: /\.cjsx$/, loaders: ['coffee-loader', 'cjsx']},
            {test: /bootstrap\/js\//, loader: 'imports?jQuery=jquery' },

            { test: /\.woff2?$/,   loader: "url-loader?limit=10000&minetype=application/font-woff" },
            { test: /\.ttf$/,    loader: "file-loader" },
            { test: /\.eot$/,    loader: "file-loader" },
            { test: /\.svg$/,    loader: "file-loader" }
        ]
    },
    resolveLoader:  {
        modulesDirectories: ['node_modules']
    },
    resolve: {
        root: [path.join(__dirname), "bower_components"],
        extensions: ['', '.js', '.coffee', '.cjsx'],
        packageMains: ["webpack", "web", "browserify", ["jam", "main"], "main"]
    },
    externals:[{
        xmlhttprequest: '{XMLHttpRequest:XMLHttpRequest}'
    }]
}
