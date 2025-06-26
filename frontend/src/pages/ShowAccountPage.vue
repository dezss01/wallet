<script setup>
import { onMounted, computed, ref, watch, onUpdated } from "vue";
import { useAccountsStore } from "@/stores/accounts";
import { useRoute } from "vue-router";
import { useAccountsTransactionsStore } from "@/stores/account_transactions";

const snackbar = ref(false);
const snackbarText = ref('');
const accountsStore = useAccountsStore();
const transactionsStore = useAccountsTransactionsStore();
const route = useRoute();
const showForm = ref(false);
const currentTransactionId = ref(null);
const editMode = ref(false);
const loading = ref(false);
const error = ref(null);

const newTransaction = ref({
  amount: '',
  currency: 'RUB',
  description: '',
  transaction_type: 'deposit'
});
const accountId = computed(() => parseInt(route.params.id));

const refreshData = async () => {
  try {
    loading.value = true;
    await accountsStore.fetchAccounts();
    await transactionsStore.fetchAllAccountTransactions();
  } finally {
    loading.value = false;
  }
}

const fetchData = async () => {
  loading.value = true;
  error.value = null;
  try {
    if (accountsStore.accounts.length === 0) {
      await accountsStore.fetchAccounts()
    }
    await transactionsStore.fetchAllAccountTransactions();

    if (!accountsStore.getAccountById(accountId.value)) {
      throw new Error('Нет аккаунта с таким id или пошел на хуй!');
    }
  } catch (fetchError) {
    console.error('Ошибка загрузки счетов:', fetchError);
    snackbarText.value = 'При загрузке счетов произошла ошибка';
    snackbar.value = true;
  } finally {
    loading.value = false;
  }
}

const createTransaction = async () => {
  try {
    await transactionsStore.createTransaction({
      ...newTransaction.value,
      account_id: accountId.value
    });
    await refreshData();
    resetForm();
    snackbarText.value = 'Транзакция успешно создана';
    snackbar.value = true;
  } catch (fetchError) {
    snackbarText.value = 'При создании транзакции произошла ошибка';
    snackbar.value = true;
  }
};

const editTransaction = (transaction) => {
  newTransaction.value = {
    amount: transaction.amount,
    transaction_type: transaction.transaction_type,
    description: transaction.description,
    currency: transaction.currency
  };
  currentTransactionId.value = transaction.id;
  editMode.value = true;
  showForm.value = true;
};

const updateTransaction = async () => {
  try {
    await transactionsStore.updateTransaction(currentTransactionId.value, newTransaction.value);
    await refreshData();
    resetForm();
    snackbarText.value = 'Транзакция успешно обновлена';
    snackbar.value = true;
  } catch (error) {
    snackbarText.value = 'Ошибка при обновлении транзакции';
    snackbar.value = true;
  }
};

const deleteTransaction = async (id) => {
  if (confirm('Вы уверены, что хотите удалить транзакцию?')) {
    try {
      await transactionsStore.deleteTransaction(id);
      await refreshData();
      snackbarText.value = 'Транзакция успешно удалена';
      snackbar.value = true;
    } catch (error) {
      snackbarText.value = 'Ошибка при удалении транзакции';
      snackbar.value = true;
    }
  }
};
watch(accountId, fetchData)

onMounted(fetchData);

const account = computed(() => accountsStore.getAccountById(accountId.value));
const transactions = computed(() => transactionsStore.getAllAccountTransactions);

const resetForm = () => {
  newTransaction.value = {
    amount: '',
    transaction_type: 'deposit',
    currency: 'RUB',
    description: ''
  };
  currentTransactionId.value = null;
  showForm.value = false;
}

</script>

<template>
  <section v-if="loading">
    <v-progress-linear indeterminate color="primary"/>
    <div class="text-center mt-4">Загрузка данных...</div>
  </section>

  <section v-else-if="error" class="error-message">
    <v-alert type="error" dense>
      {{ error }}
    </v-alert>
  </section>

  <template v-else-if="account">
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

    <v-divider class="my-8"/>

    <h3 class="mb-4">Транзакции ({{ transactions.length }}):</h3>
    <v-list v-if="transactions.length > 0">
      <v-list-item v-for="transaction in transactions" :key="transaction.id" class="mb-4">
        <template v-slot:prepend>
          <v-icon :color="transaction.transaction_type == 'deposit' ? 'green' : 'red'"
            :icon="transaction.transaction_type == 'deposit' ? 'mdi-arrow-up' : 'mdi-arrow-down'"/>
        </template>

        <v-list-item-title>
          {{ transaction.description }}
        </v-list-item-title>

        <v-list-item-subtitle>
          {{ new Date(transaction.created_at).toLocaleDateString() }}
        </v-list-item-subtitle>

        <template v-slot:append>
          <div class="d-flex gap-2">
            <v-btn icon="mdi-pencil" size="small" @click="editTransaction(transaction)" class='mr-3'/>

            <v-btn icon="mdi-delete" color="error" size="small" @click="deleteTransaction(transaction.id)"
              class='mr-3'/>

            <div>
              {{ transaction.transaction_type === 'deposit' ? '+' : '-' }}
              {{ transaction.amount.toFixed(2) }}
              {{ transaction.currency }}
            </div>
          </div>
        </template>
      </v-list-item>
    </v-list>

    <v-alert v-else type="info">
      Нет транзакций для отображения
    </v-alert>
  </template>

  <section v-else class="text-center">
    <v-alert type="warning">
      Аккаунт не найден!
    </v-alert>
  </section>
  <v-divider class='my-8'/>
  <v-btn color="primary" @click="showForm = !showForm" class="mb-4">
    {{ showForm ? 'Скрыть форму' : 'Добавить транзакцию' }}
  </v-btn>
  <v-form v-if="showForm" @submit.prevent="editMode ? updateTransaction() : createTransaction()">
    <v-select v-model="newTransaction.transaction_type" :items="['deposit', 'withdrawal']" label="Тип транзакции"
      required class="mb-4"/>

    <v-text-field v-model.number="newTransaction.amount" type="number" label="Сумма" required
      :rules="[v => v > 0 || 'Сумма должна быть больше 0']" class="mb-4"/>

    <v-text-field v-model="newTransaction.description" label="Описание" required class="mb-4"/>

    <v-select v-model="newTransaction.currency" :items="['RUB', 'USD', 'EUR']" label="Валюта" required
      class="mb-4"/>

    <div class="d-flex gap-2">
      <v-btn color="primary" type="submit">
        {{ editMode ? 'Обновить' : 'Создать' }}
      </v-btn>

      <v-btn color="secondary" @click="resetForm">
        Отмена
      </v-btn>
    </div>
  </v-form>
</template>

<style scoped>
.error-message {
  color: red;
  margin-bottom: 10px;
}

.v-list-item {
  border: 1px solid #eee;
  border-radius: 8px;
}
</style>
