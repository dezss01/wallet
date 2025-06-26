import { defineStore } from "pinia";
import apiClient from "@/services/api";
import { ref, computed, handleError } from 'vue';

export const useAccountsStore = defineStore('accounts', () => {
  const accounts = ref([]);
  const loading = ref(false);
  const error = ref(null);

  // Геттеры
  const getAllAccounts = computed(() => accounts.value);

  const getTotalBalance = computed(() => {
    return accounts.value.reduce((total, account) => total + parseFloat(account.balance), 0);
  });

  // Функция для получения аккаунта по ID
  const getAccountById = computed(() => (accountId) => {
    return accounts.value.find(account => account.id === accountId);
  });

  // Действия
  async function fetchAccounts() {
    loading.value = true;
    error.value = null;
    try {
      const data = await apiClient.get('/accounts');
      accounts.value = data;
    } catch (err) {
      handleError(err);
    } finally {
      loading.value = false;
    }
  }

  async function addAccount(accountData) {
    try {
      const data = await apiClient.post('/accounts', accountData);
      accounts.value.push(data);
    } catch (err) {
      handleError(err);
      throw err;
    }
  }

  async function updateAccount(accountId, updatedAccountData) {
    try {
      const data = await apiClient.put(`/accounts/${accountId}`, updatedAccountData);
      const index = accounts.value.findIndex(account => account.id === accountId);
      if (index !== -1) {
        accounts.value[index] = data;
      }
    } catch (err) {
      handleError(err);
      throw err;
    }
  }

  async function deleteAccount(accountId) {
    try {
      await apiClient.delete(`accounts/${accountId}`);
      accounts.value = accounts.value.filter(account => account.id !== accountId);
    } catch (err) {
      handleError(err);
      throw err;
    }
    function handleError(err) {
      console.error('API Error:', err);
      error.value = err.data?.data?.errors || err.message || 'An unexpected error occurred!';
    }
  }

  return {
    accounts,
    loading,
    error,
    getAllAccounts,
    getTotalBalance,
    getAccountById,
    fetchAccounts,
    addAccount,
    updateAccount,
    deleteAccount
  }
})
