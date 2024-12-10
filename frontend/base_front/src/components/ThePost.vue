<script setup>
import axios from "axios";

const title = ref('')
const description = ref('')

const handleSubmit = () => {
  axios.post('/api/new_post', {title: title.value, descriptions: description.value})
}


</script>
<template>
  <form @submit.prevent="submit">
  <v-text-field
    v-model="title"
    label="Title"
  ></v-text-field>
  <v-textarea
    v-model="description"
    label="Text area"
  ></v-textarea>

  <v-btn
    class="me-4"
    type="submit"
    @click="handleSubmit"
  >
    submit
  </v-btn>

  </form>
</template>
