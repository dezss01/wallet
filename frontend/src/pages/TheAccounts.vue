<script setup>
import { onMounted, computed, ref } from 'vue';
import { storeToRefs } from 'pinia';
import { useAccountsStore } from '@/stores/accounts';
import { useRouter } from 'vue-router';

const router = useRouter();
const accountsStore = useAccountsStore();
const { accounts, error } = storeToRefs(accountsStore);
const loading = ref(false);
const dialog = ref(false);
const snackbar = ref(false);
const snackbarText = ref('');
const dialogAccountId = ref(null);

const generateAccountLink = (account) => `/account/${account.id}`;
const totalBalance = computed(() => accountsStore.getTotalBalance);

const updateAccountsList = async () => {
  loading.value = true;
  try {
    await accountsStore.fetchAccounts();
  } catch (fetchError) {
    console.error('Ошибка загрузки счетов:', fetchError);
    snackbarText.value = 'При загрузке счетов произошла ошибка';
    snackbar.value = true;
  } finally {
    loading.value = false;
  }
};

const handleDeleteAccount = async () => {
  dialog.value = false;
  const accountId = dialogAccountId.value;
  try {
    await accountsStore.deleteAccount(accountId);
    accounts.value = accounts.value.filter(account => account.id !== accountId);
    snackbarText.value = 'Счет успешно удален';
    snackbar.value = true;
  } catch (deleteError) {
    console.error('Ошибка удаления счета:', deleteError);
    snackbarText.value = 'При удалении счета произошла ошибка';
    snackbar.value = true;
  }
};

onMounted(async () => {
  await updateAccountsList();
});
const openDialog = (accountId) => {
  dialogAccountId.value = accountId
  dialog.value = true;
};
</script>

<template>
  <section>
    <h2>Мои счета</h2>
    <section class="full-balance-container">
      <div>Общий баланс: {{ totalBalance }} RUB</div>
      <v-btn color="success" @click="router.push('/account/new')">Добавить счет</v-btn>
    </section>

    <section v-if="loading" class="loading">
      <v-progress-linear indeterminate color="primary"/>
    </section>

    <section v-if="error" class="error">{{ error }}</section>

    <section v-else-if="accounts.length" class="accounts-grid">
      <v-card v-for="account in accounts" :key="account.id" class="account-card" elevation="16">
        <v-card-title>
          <v-btn :to="generateAccountLink(account)" text class="text-decoration-none text-start">
            {{ account.name }}
          </v-btn>
        </v-card-title>
        <v-card-subtitle>{{ account.description }}</v-card-subtitle>
        <v-card-text>
          <p>Баланс: {{ account.balance }} {{ account.currency }}</p>
        </v-card-text>
        <v-card-actions>
          <v-btn class="full-width" color="info" @click="router.push(`/account/${account.id}/edit`)">
            Редактировать
          </v-btn>
          <v-btn class="full-width" color="error" @click="openDialog(account.id)">Удалить</v-btn>
        </v-card-actions>
      </v-card>

    </section>

    <section v-else class="no-accounts">
      У вас пока нет счетов.
      <v-btn color="success" @click="router.push('/account/new')">Добавить счет</v-btn>
    </section>
    <v-dialog v-model="dialog" width="auto">
      <v-card>
        <v-card-title>Подтверждение удаления</v-card-title>
        <v-card-text>Вы уверены, что хотите удалить этот счет?</v-card-text>
        <v-card-actions>
          <v-btn text @click="dialog = false">Отмена</v-btn>
          <v-btn color="error" @click="handleDeleteAccount">Удалить</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
    <v-snackbar v-model="snackbar" timeout="3000" color="success">
      {{ snackbarText }}
    </v-snackbar>
  </section>
</template>

<style scoped>
section {
  padding: 20px;
}

.accounts-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.account-card {
  max-width: 344px;
  width: 100%;
  height: auto;
}

.v-card-actions {
  display: flex;
  gap: 10px;
  justify-content: space-between;
  flex-direction: column;
}

.loading {
  text-align: center;
  font-size: 1.2em;
}

.error {
  color: red;
  margin: 10px 0;
}

.full-balance-container {
  display: flex;
  flex-direction: column;
  margin-bottom: 20px;
}

.no-accounts {
  text-align: center;
  font-size: 1.2em;
  margin-top: 20px;
}

.full-width {
  width: 100%;
}

@media (max-width: 768px) {
  .v-card-actions {
    flex-direction: column;
  }
}
</style>
