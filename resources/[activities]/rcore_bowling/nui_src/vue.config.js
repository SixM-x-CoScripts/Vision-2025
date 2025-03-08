module.exports = {
    outputDir: "..\\assets",
    assetsDir: "assets",
    productionSourceMap: false,
    filenameHashing: false,
  
    publicPath: process.env.NODE_ENV === "production" ? "/assets/" : "/"
  };
  