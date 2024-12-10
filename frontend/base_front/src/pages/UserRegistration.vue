<template>
  <form @submit.prevent="submit(userData)">
    <v-text-field v-model="userData.first_name" :counter="50" label="First name"
      :error-messages='errors?.first_name'></v-text-field>
    <v-text-field v-model="userData.last_name" :counter="50" label="Last name"
      :error-messages='errors?.last_name'></v-text-field>
    <v-text-field v-model="userData.email" label="E-mail" :error-messages='errors?.email'></v-text-field>
    <v-text-field v-model="userData.password" label="Password" type="password"
      :error-messages='errors?.password'></v-text-field>

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
  email: '',
  password: ''
})

const handleClear = () => {
  Object.keys(userData).forEach(key => {
    userData[key] = ''
  })
}
const submit = async (userData) => {
  errors.value = ''
  try {
    const result = await authStore.signUp(userData)
    // TO-DO: Написать логику после успешной регистрации (переход куда-то или еще что)
    if (!result.success) {
      errors.value = result.message || 'An error occurred while creating the profile.'
    } else {
      router.push('/')
    }
  } catch (error) {
    errors.value = 'An unexpected error occurred. Please try again.'
  }
};

</script>
