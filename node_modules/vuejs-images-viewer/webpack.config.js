/**
 * Created by fm on 2017/10/18.
 */
const path = require('path');
const webpack = require('webpack')
const merge = require('webpack-merge');

var config = {
    /*
    entry: {
        main: path.join(__dirname, 'src', 'main')
    },*/
    output: {
        path: path.resolve(__dirname + '/dist/'),
        // filename: 'plugin.js',
        // publicPath: '/dist/'
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                loader: ['babel-loader'],
                exclude: /node_modules/
            },
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.css$/,
                loader: 'style!less!css'
            }
        ]
    },
    resolve: {
        extensions: ['.js', '.vue'],
        alias: {
            vue: 'vue/dist/vue.js'
        }
    },
    externals: {
        //moment: 'moment'
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin(),
        new webpack.optimize.UglifyJsPlugin( {
            minimize : true,
            sourceMap : false,
            mangle: true,
            compress: {
                warnings: false
            }
        })
    ]

}

//module.exports = config;


module.exports = [
    merge(config, {
        entry: path.resolve(__dirname + '/src/plugin.js'),
        output: {
            filename: 'app.min.js',
            libraryTarget: 'window',
            library: 'ImagesViewer',
        }
    }),
    merge(config, {
        entry: path.resolve(__dirname + '/src/components/app.vue'),
        output: {
            filename: 'app.js',
            libraryTarget: 'umd',
            library: 'images-viewer',
            umdNamedDefine: true
        }
    })
];