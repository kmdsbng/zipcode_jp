var webpack = require('webpack');

module.exports = {
  entry: {
    src: './src/main.js'
  },

  output: {
    filename: 'api.js',
    //chunkFilename: '[id].chunk.js',
    path: __dirname + '/docs',
    publicPath: '/',
    sourceMapFilename: "api.map"
  },

  devtool: "source-map",
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['es2015']
        }
      }
    ]
  }

};


