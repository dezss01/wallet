<script setup>
import { ref, reactive } from 'vue';
import router from "@/router";


const user = ref(null);

const snackbar = reactive({
  show: false,
  text: '',
  color: 'error'
})
try {
  const storedUser = JSON.parse(localStorage.getItem('user'));
  if (storedUser) {
    user.value = storedUser;
  } else {
    throw new Error('User data not found 111');
  }
} catch (error) {
    snackbar.text = 'User not login'
    snackbar.show = true
}

const authButton = () => {
  router.push('auth')
}
</script>

<template>
<h1>This is Base Page!</h1>
  <v-snackbar
  v-model="snackbar.show"
  :color="snackbar.color"
  :timeout="3000">
    {{ snackbar.text }}
  </v-snackbar>
</template>

<style scoped>

</style>
