<script setup>
import { reactive } from 'vue';
import { useAccountsStore } from "@/stores/accounts";
import { storeToRefs } from "pinia";
import { useRouter } from "vue-router";

const accountsStore = useAccountsStore();
const { error } = storeToRefs(accountsStore);
const router = useRouter();

const accountData = reactive({
  name: '',
  description: '',
  balance: 0,
  currency: 'RUB',
});

const handleSubmit = async () => {
  try {
    await accountsStore.addAccount(accountData);
    router.push('/accounts')
  } catch (err) {
    console.error('Error submiting form', err);
  }
};

const handleClear = () => {
  accountData.name = '';
  accountData.description = '';
  accountData.balance = 0;
  accountData.currency = 'RUB';
};

</script>

<template>
  <form @submit.prevent="handleSubmit">
    <v-text-field v-model="accountData.name" :counter="50" label="Account name" :error-messages="error?.name"/>

    <v-text-field v-model="accountData.description" :counter="50" label="Account description"
      :error-messages="error?.description"/>

    <v-row>
      <v-col cols="6">
        <v-text-field v-model.number="accountData.balance" type="number" label="Balance"
          :error-messages="error?.balance"/>
      </v-col>
      <v-col cols="6">
        <v-select v-model="accountData.currency" label="Currency" :items="['RUB', 'USD', 'EUR']" variant="solo-filled"
          :error-messages="error?.currency"/>
      </v-col>
    </v-row>

    <v-btn class="me-4" type="submit" color="primary">
      Submit
    </v-btn>

    <v-btn @click="handleClear">
      Clear
    </v-btn>
  </form>
</template>

<style scoped>
form {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}
</style>
