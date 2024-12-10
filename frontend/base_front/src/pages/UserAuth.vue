<template>
  <form @submit.prevent="submit(userData)">

    <v-text-field v-model="userData.email" label="E-mail" :error-messages='errors'></v-text-field>
    <v-text-field v-model="userData.password" label="Password" type="password" :error-messages='errors'></v-text-field>
    <!-- <v-text-field v-model="userData.password_confirmation" label="Password confirmation"
      :error-messages='errors'></v-text-field> -->

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
import { reactive } from 'vue'

const router = useRouter()
const authStore = useAuthStore()

const userData = reactive({
  email: '',
  password: '',
  // password_confirmation: '',
})
const errors = ref({})

const clearError = () => {
  errors.value = ''
}
const handleClear = () => {
  Object.assign(userData, {
    email: '',
    password: '',
    // password_confirmation: '',
  }), clearError()
}

const submit = async (userData) => {
  clearError()
  try {
    const result = await authStore.signIn(userData)
    if (!result.success) {
      errors.value = result.message || 'An error occurred while Login.'
    } else {
      router.push('/')
    }
  } catch (error) {
    errors.value = 'An unexpected error occurred. Please try again.'
  }

};

</script>
