<template>
  <v-alert closable title="Update profile" text="Updating profile successfully" type="success" v-if="success"></v-alert>
  <v-form @submit.prevent="onSubmit(userData)">
    <v-text-field v-model="userData.first_name" :counter="50" label="First name" :error-messages="errors?.first_name" />
    <v-text-field v-model="userData.last_name" :counter="50" label="Last name" :error-messages="errors?.last_name" />
    <v-text-field v-model="userData.user_name" :counter="50" label="Last name" :error-messages="errors?.last_name" />

    <v-text-field v-model="userData.email" label="E-mail" :error-messages="errors?.email" />
    <v-text-field v-model="userData.password" label="Password" type="password" :error-messages="errors?.password" />
    <v-text-field v-model="userData.password_confirmation" label="Password confirmation" type="password"
      :error-messages="errors?.password_confirmation" />
    <v-text-field v-model="userData.current_password" label="Current Password" type="password"
      :error-messages="errors?.current_password" />

    <v-btn class="me-4" type="submit">
      Submit
    </v-btn>

    <v-btn @click="handleClear">Clear</v-btn>
  </v-form>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()

const success = ref(false)
const errors = ref({})
const clearError = () => {
  errors.value = ''
}
const userData = reactive({
  first_name: authStore.currentUser.first_name,
  last_name: authStore.currentUser.last_name,
  user_name: authStore.currentUser.user_name,
  email: authStore.currentUser.email,
  password: '',
  password_confirmation: '',
  current_password: ''
})

const handleClear = () => {
  Object.assign(userData, {
    first_name: authStore.currentUser.first_name,
    last_name: authStore.currentUser.last_name,
    email: authStore.currentUser.email,
    password: '',
    password_confirmation: '',
    current_password: ''
  }), clearError()
}

// const isFormValid = computed(() => Object.keys(errors.value).length === 0)

const onSubmit = async (userData) => {
  clearError()
  try {
    const result = await authStore.updateUser(userData)
    if (!result.success) {
      errors.value = result.message || 'An error occurred while updating the profile.'
    } else {
      success.value = true
    }
  } catch (error) {
    // console.error('An error occurred while updating profile:', error)
    errors.value = 'An unexpected error occurred. Please try again.'
  }
}
</script>
