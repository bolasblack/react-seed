module.exports = (opts = {}) => ({
  "plugins": [
    ["transform-object-rest-spread"],
    ["transform-class-properties"],
    ["jsx-pragmatic", {
      module: "react",
      import: "React",
    }],
  ],
  "presets": [
    "react",
    ["es2015", {"modules": (process.env.NODE_ENV === 'test' || opts.modules) ? (opts.modules || 'commonjs') : false}],
  ],
})
