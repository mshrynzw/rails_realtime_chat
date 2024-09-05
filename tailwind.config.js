/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/**/*.{html,js,rb}',
    './node_modules/preline/dist/*.js',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require('preline/plugin'),
  ]
}

