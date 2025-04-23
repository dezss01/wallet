<script setup>
import { reactive, watch } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import { useAccountsStore } from '@/stores/accounts';

const router = useRouter();
const route = useRoute();
const accountsStore = useAccountsStore();

const formState = reactive({
  account: {
    id: null,
    name: '',
    description: '',
    balance: 0,
    currency: 'RUB',
  },
  isLoading: false,
  error: null,
  currencies: ['RUB', 'USD', 'EUR'],
});

// Function to fetch and populate account data
const fetchAccountData = async (accountId) => {
  formState.isLoading = true;
  formState.error = null;
  try {
    await accountsStore.fetchAccounts();
    const fetchedAccount = accountsStore.getAccountById(accountId);
    if (fetchedAccount) {
      // Merge fetched data into account object
      Object.assign(formState.account, fetchedAccount);
    } else {
      formState.error = 'Account not found.';
    }
  } catch (error) {
    console.error('Error fetching account:', error);
    formState.error = 'Failed to load account.';
  } finally {
    formState.isLoading = false;
  }
};

// Watch for route param changes
watch(
  () => route.params.id,
  (newId) => {
    if (newId) {
      fetchAccountData(parseInt(newId));
    }
  },
  { immediate: true }
);

const handleSubmit = async () => {
  formState.error = null;
  try {
    await accountsStore.updateAccount(formState.account.id, {
      name: formState.account.name,
      description: formState.account.description,
      balance: formState.account.balance,
      currency: formState.account.currency,
    });
    router.push(`/account/${formState.account.id}`);
  } catch (err) {
    console.error('Error submitting form:', err);
    formState.error = err.response?.data || 'Failed to update account.'; // Error handling from server
  }
};

const handleClear = () => {
  // Reset only form values, not loading or error
  formState.account.name = '';
  formState.account.description = '';
  formState.account.balance = 0;
  formState.account.currency = 'RUB';
};
</script>

<template>
  <form v-if="!formState.isLoading" @submit.prevent="handleSubmit">
    <div v-if="formState.error" class="error-message">
      {{ formState.error }}
    </div>
    <v-text-field v-model="formState.account.name" :counter="50" label="Account name"
      :error-messages="formState.error?.name">
    </v-text-field>

    <v-text-field v-model="formState.account.description" :counter="50" label="Account description"
      :error-messages="formState.error?.description">
    </v-text-field>

    <v-row>
      <v-col cols="6">
        <v-text-field v-model.number="formState.account.balance" type="number" label="Balance"
          :error-messages="formState.error?.balance">
        </v-text-field>
      </v-col>
      <v-col cols="6">
        <v-select v-model="formState.account.currency" label="Currency" :items="formState.currencies"
          variant="solo-filled" :error-messages="formState.error?.currency">
        </v-select>
      </v-col>
    </v-row>

    <v-btn class="me-4" type="submit" color="primary" :disabled="formState.isLoading">
      Submit
    </v-btn>

    <v-btn @click="handleClear" :disabled="formState.isLoading">
      Clear
    </v-btn>
  </form>
  <div v-else>Loading...</div>
</template>

<style scoped>
form {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.error-message {
  color: red;
  margin-bottom: 10px;
}
</style>
