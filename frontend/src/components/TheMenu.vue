<script setup>
import { computed, ref } from 'vue'
import { useAuthStore } from "@/stores/auth";
import { useRouter } from "vue-router";
import TheUserButton from '@/components/TheUserButton.vue'

const authStore = useAuthStore()
const router = useRouter()
const currentUser = computed(() => authStore.currentUser)
const isAuthenticated = computed(() => authStore.isAuthenticated)


const navigateTo = async (route) => {
  await router.push(route)
}

const signIn = () => navigateTo('auth')
const signUp = () => navigateTo('sign-up')
</script>

<template>
  <v-toolbar-items v-if="isAuthenticated">
    <the-user-button class="mx-3 my-1"/>
  </v-toolbar-items>
  <v-toolbar-items v-else>
    <v-btn @click="signUp">Sign Up</v-btn>
    <v-btn @click="signIn">Sign In</v-btn>
  </v-toolbar-items>
</template>
