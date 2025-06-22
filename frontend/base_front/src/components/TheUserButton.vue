<script setup>
import { computed } from 'vue'
import { useAuthStore } from "@/stores/auth";
import { useRouter } from "vue-router";

const router = useRouter()
const authStore = useAuthStore()
const currentUser = computed(() => authStore.currentUser)

const logout = async () => {
  await authStore.logout()
  await router.push('/')
}

const editProfile = () => router.push('/edit')

const userInitials = computed(() => {
  if (currentUser.value) {
    return currentUser.value.first_name[0].toUpperCase() + currentUser.value.last_name[0].toUpperCase()
  }
  return ''
})

</script>

<template>
  <v-container style="height: 300px" fluid>
    <v-row justify="center">
      <v-menu min-width="200px" rounded>
        <template v-slot:activator="{ props }">
          <v-btn icon v-bind="props">
            <v-avatar color="brown" size="large">
              <span class="text-h5">{{ userInitials }}</span>
            </v-avatar>
          </v-btn>
        </template>
        <v-card>
          <v-card-text>
            <div class="mx-auto text-center">
              <v-avatar color="brown">
                <span class="text-h5">{{ userInitials }}</span>
              </v-avatar>
              <h3>{{ currentUser.first_name }}</h3>
              <p class="text-caption mt-1">
                {{ currentUser.email }}
              </p>
              <v-divider class="my-3"/>
              <v-btn variant="text" rounded @click="editProfile">
                Edit Account
              </v-btn>
              <v-divider class="my-3"/>
              <v-btn variant="text" rounded @click="logout">
                Logout
              </v-btn>
            </div>
          </v-card-text>
        </v-card>
      </v-menu>
    </v-row>
  </v-container>
</template>
