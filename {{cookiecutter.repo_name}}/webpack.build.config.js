var common = require("./webpack.config.js")
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var SaveAssetsJson = require("assets-webpack-plugin");
var webpack = require("webpack");

common.output.filename = "bundle.[hash].js"
common.plugins = [
    new ExtractTextPlugin("bundle.[hash].css"),
    new webpack.DefinePlugin({
        SOME_VAR: JSON.stringify("some value")
    }),
    new SaveAssetsJson({path: __dirname + "/build", filename: "assets.json"})
]

module.exports = common

