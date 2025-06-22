module.exports = {
  root: true,
  env: {
    node: true,
  },
  extends: [
    'plugin:vue/vue3-recommended',
    '@vue/typescript/recommended',
    'vuetify',
    './.eslintrc-auto-import.json',
  ],
  rules: {
    'vue/multi-word-component-names': 'off',
  },
}
