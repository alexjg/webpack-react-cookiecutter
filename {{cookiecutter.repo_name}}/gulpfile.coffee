gulp = require("gulp")
gutil = require("gulp-util")
webpack = require("webpack")
WebpackDevServer = require("webpack-dev-server")
webpackConfig = require("./webpack.config.js")
express = require "express"
proxy = require "proxy-middleware"
url = require "url"

gulp.task("default", ["webpack-dev-server"])

gulp.task("build-dev", ["webpack:build-dev"],  ->
    gulp.watch(["app/**/*"], ["webpack:build-dev"])
)

gulp.task("build", ["webpack:build"])

gulp.task("webpack:build", (callback) ->
    myConfig = Object.create(webpackConfig)
    myConfig.plugins = myConfig.plugins.concat(
        new webpack.DefinePlugin(
            "process.env":
                "NODE_ENV": JSON.stringify("production")
        ),
        new webpack.optimize.DedupePlugin(),
        new webpack.optimize.UglifyJsPlugin()
    )

    webpack(myConfig (err, stats) ->
        if(err)
            throw new gutil.PluginError("webpack:build", err)
        gutil.log(["webpack:build"], stats.toString(
            colors: true
        ))
        callback()
    )
)

myDevConfig = Object.create(webpackConfig)
myDevConfig.devtool = "sourcemap"
myDevConfig.debug = true

devCompiler = webpack(myDevConfig)

gulp.task("webpackbuild-dev", (callback) ->
    devCompiler.run((err, stats) ->
        if err
            throw new gutil.PluginError("webpack:build-dev", err)
        gutil.log(["webpack:build-dev"], stats.toString(colors:true))
        callback()
    )
)

gulp.task("webpack-dev-server", (callback) ->
    myConfig = Object.create(webpackConfig)
    myConfig.devtool = "source-map"
    myConfig.debug = true

    app = express()
    app.use("/assets", proxy(url.parse("http://localhost:8081/assets")))
    app.use("/api", proxy(url.parse("http://localhost:5000")))
    app.get("/*", (req, res) ->
        res.sendFile(__dirname + "/index.html")
    )

    new WebpackDevServer(webpack(myConfig),
        publicPath: "/assets",
        contentBase: __dirname
        stats:
            colors: true
    ).listen(8081, "localhost", (err) ->
        if err
            throw new gutil.PluginError("webpack-dev-server", err)
        gutil.log(["webpack-dev-server"], "http://localhost:8080/webpack-dev-server/index.html")
    )
    app.listen(8080)
)

