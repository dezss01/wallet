<script setup>
import { onMounted, computed, ref, watch } from "vue";
import { useAccountsStore } from "@/stores/accounts";
import { useRoute } from "vue-router";

const accountsStore = useAccountsStore();
const route = useRoute();

const accountId = computed(() => parseInt(route.params.id));
const loading = ref(false);
const error = ref(null);

const fetchAccountData = async () => {
  loading.value = true;
  error.value = null;
  try {
    await accountsStore.fetchAccounts();
  } catch (err) {
    console.error('Ошибка загрузки счетов:', err);
    error.value = 'При загрузке счетов произошла ошибка';
  } finally {
    loading.value = false;
  }
}

watch(accountId, async (newId) => {
  await fetchAccountData();
});

onMounted(async () => {
  await fetchAccountData();
});

const account = computed(() => {
  if (!accountId.value) {
    return null;
  }
  return accountsStore.getAccountById(accountId.value);
});

</script>

<template>
  <section v-if="loading">
    <v-progress-linear indeterminate color="primary"></v-progress-linear>
  </section>

  <section v-else-if="error" class="error-message">{{ error }}</section>

  <section v-else-if="account" class="account-details">
    <v-card class="mx-auto my-8" elevation="16" max-width="344">
      <v-card-title>
        {{ account.name }}
      </v-card-title>
      <v-card-subtitle>
        {{ account.description }}
      </v-card-subtitle>
      <v-card-text class="d-flex ga-2">
        <div>Баланс:</div>
        <div>
          {{ account.balance }}
          {{ account.currency }}
        </div>
      </v-card-text>
    </v-card>
  </section>
  <section v-else>
    Account not found
  </section>
</template>

<style scoped>
.error-message {
  color: red;
  margin-bottom: 10px;
}
</style>
