<template>
  <form @submit.prevent="submit(userData)">
    <v-text-field v-model="userData.first_name" :counter="50" label="First name" :error-messages='errors?.first_name' />
    <v-text-field v-model="userData.last_name" :counter="50" label="Last name" :error-messages='errors?.last_name' />
    <v-text-field v-model="userData.user_name" :counter="50" label="Nickname" :error-messages='errors?.user_name' />
    <v-text-field v-model="userData.email" label="E-mail" :error-messages='errors?.email' />
    <v-text-field v-model="userData.password" label="Password" type="password" :error-messages='errors?.password' />

    <v-btn class="me-4" type="submit">
      submit
    </v-btn>

    <v-btn @click="handleClear">
      clear
    </v-btn>
  </form>
</template>
<script setup>
import { useAuthStore } from "@/stores/auth";
import { useRouter } from "vue-router";
import { reactive, ref } from "vue";

const authStore = useAuthStore();
const router = useRouter()

const errors = ref({})
const userData = reactive({
  first_name: '',
  last_name: '',
  user_name: '',
  email: '',
  password: ''
})

const handleClear = () => {
  Object.keys(userData).forEach(key => {
    userData[key] = ''
  })
}

const submit = async (userData) => {
  errors.value = {}
  try {
    const result = await authStore.signUp({ registration: userData })
    if (result.errors) {
      errors.value = result.errors
    } else {
      router.push('/')
    }
  } catch (error) {
    errors.value = { base: ['An unexpected error occurred. Please try again.'] }
  }
};

</script>
