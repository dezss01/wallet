import vuePlugin from 'eslint-plugin-vue';

export default [
  {
    files: ['**/*.vue', '**/*.js'],
    plugins: {
      vue: vuePlugin
    },
    rules: {
      'vue/multi-word-component-names': 'off',
      'vue/html-self-closing': ['error', {
        html: {
          void: 'always',
          normal: 'always',
          component: 'always'
        }
      }]
    }
  }
];
