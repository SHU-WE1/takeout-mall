const path = require('path')
const name = 'Vue Typescript Admin'
const IS_PROD = ['production', 'development'].includes(process.env.NODE_ENV)

// 在生产构建时禁用 TypeScript 类型检查
if (process.env.NODE_ENV === 'production') {
  process.env.TSC_COMPILE_ON_ERROR = 'true'
  process.env.VUE_CLI_TRANSPILE_ONLY = 'true'
}

// 在配置加载前就禁用 fibers（Apple Silicon Mac 兼容性）
process.env.SASS_FIBER_DISABLED = 'true'
process.env.FIBERS_SKIP = 'true'

// 创建一个假的 fibers 模块来阻止真实的 fibers 被加载
try {
  const Module = require('module')
  const originalRequire = Module.prototype.require
  Module.prototype.require = function(id) {
    if (id === 'fibers') {
      return null
    }
    return originalRequire.apply(this, arguments)
  }
} catch (e) {
  // 如果无法拦截 require，继续执行
}

module.exports = {
  'publicPath': process.env.NODE_ENV === 'production' ? './' : '/', // TODO: Remember to change this to fit your need
  'lintOnSave': process.env.NODE_ENV === 'development',
  'pwa': {
    'name': name
  },
  // 在生产构建时禁用 TypeScript 类型检查
  'pluginOptions': {
    'style-resources-loader': {
      'preProcessor': 'scss',
      'patterns': [
        path.resolve(__dirname, 'src/styles/_variables.scss'),
        path.resolve(__dirname, 'src/styles/_mixins.scss')
      ]
    },
    // 禁用 TypeScript 类型检查插件
    ...(process.env.NODE_ENV === 'production' ? {
      '@vue/cli-plugin-typescript': {
        typeCheck: false
    }
    } : {})
  },
  // 开启代理
  devServer: {
    port: 8888,
    open: true,
    disableHostCheck:true,
    hot:true,//自动保存
    overlay: {
      warnings: false,
      errors: true
    },
    proxy: {
      '/api': {
        target: process.env.VUE_APP_URL,
        ws: false,
        secure: false,
        changeOrigin: true,
        pathRewrite:{
          '^/api':''
        }
      }
    }
  },
  chainWebpack: (config) => {
    config.resolve.symlinks(true) // 修复热更新失效
    
    // 在生产构建时禁用 TypeScript 类型检查（避免 TypeScript 3.6.2 与新类型定义不兼容的问题）
    if (process.env.NODE_ENV === 'production') {
      // 删除 ForkTsCheckerWebpackPlugin（Vue CLI 使用此插件进行类型检查）
      try {
        config.plugins.delete('fork-ts-checker')
      } catch (e) {
        // 插件可能不存在或已删除，忽略错误
      }
    }
    
    // 配置所有 scss 规则不使用 fibers
    const scssRules = ['scss', 'sass']
    scssRules.forEach(rule => {
      ;['vue-modules', 'vue', 'normal-modules', 'normal'].forEach(oneOf => {
        config.module
          .rule(rule)
          .oneOf(oneOf)
          .use('sass-loader')
          .tap(options => {
            const newOptions = {
              ...options,
              implementation: require('sass'),
              sassOptions: {
                ...(options.sassOptions || {}),
                fiber: false
              }
            }
            // 明确禁用 fibers 的自动检测
            delete newOptions.fiber
            return newOptions
          })
      })
    })
  },
  configureWebpack: {
    devtool: 'source-map'
  },

  css: {
    // 是否使用css分离插件 ExtractTextPlugin
    extract: IS_PROD,
    // 开启 CSS source maps?
    sourceMap: false,
    // css预设器配置项
    loaderOptions: {
      sass: {
        // 禁用 fibers，避免在 Apple Silicon Mac 上出现兼容性问题
        sassOptions: {
          fiber: false
        }
      },
      scss: {
        // 禁用 fibers，避免在 Apple Silicon Mac 上出现兼容性问题
        sassOptions: {
          fiber: false
        }
      }
    },
    // 启用 CSS modules for all css / pre-processor files.
    modules: false,
},
};
