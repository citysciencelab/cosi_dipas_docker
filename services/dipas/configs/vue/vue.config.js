/**
 * @license GPL-2.0-or-later
 */
 const webpack = require("webpack");

 // If not configured or in pipeline, fallback to the example config
 let config;
 
 try {
   config = require("./vue.config.local.js");
 }
 catch (e) {
   config = require("./example.vue.config.local.js");
 }
 
 
 // vue.config.js
 module.exports = {
   devServer: {
     disableHostCheck: true,
     proxy: {
       "^/drupal": {
         // eslint-disable-next-line
         target: {
           protocol: config.drupal.protocol + ":",
           host: config.drupal.baseHost,
           port: config.drupal.port,
         },
         changeOrigin: true,
         secure: config.useSSL,
         headers: {
           "Connection": "keep-alive",
           'X-Frame-Options': 'sameorigin'
         },
         /*
         pathRewrite: {
           //"^/drupal": "/drupal"
           "^/drupal": `${subdomain}/drupal`
         },*/
         pathRewrite: function(path, req) {
           var hostname = req.hostname;
           var subdomain = hostname.split(".")[0];
           
           return path.replace('/drupal/dipas/', `/drupal/dipas/${subdomain}/` )
         },
         logLevel: "debug",
         router (req) {
           /* eslint-disable no-console */
           console.log('#####HERE#######');
           //console.log(req)
           var hostname = req.hostname;
           var subdomain = hostname.split(".")[0];
           console.log(subdomain);
 
 
           
           return {
             protocol: config.drupal.protocol + ":",
             host: config.drupal.baseHost,
             port: config.drupal.port
           };
         }
       }
     },
     https: config.useSSL
   },
   publicPath: process.env.NODE_ENV === "production" ? "" : "/", // eslint-disable-line no-process-env
   css: {
     extract: process.env.NODE_ENV !== "production" ? false : { // eslint-disable-line no-process-env
       filename: "./css/style.css"
     }
   },
   chainWebpack: conf => {
     conf.optimization.splitChunks(false);
   },
   configureWebpack: {
     output: {
       filename: "./js/bundle.js"
     },
     devtool: "source-map",
     plugins: [
       new webpack.DefinePlugin({
         LOCALE: JSON.stringify(config.locale)
       })
     ]
   },
   transpileDependencies: [
     "@eli5/bootstrap-breakpoints-vue",
     "vue-page-title",
     "vue-resource",
     "vue-router",
     "vuex"
   ]
 };
 