import { defineStore } from "pinia";
import apiClient from "@/services/api";
import { ref, computed, handleError } from 'vue';
import { useRouter } from "vue-router";

export const useAccountsTransactionsStore = defineStore('account_transactions', () => {
  const accountTransactions = ref([]);
  const loading = ref(false);
  const error = ref(null);
  const router = useRouter();


  const getAllAccountTransactions = computed(() => accountTransactions.value);
  const getAccountTransactionById = computed(() => (accountTransactionId) => {
    return accountTransactions.value.find(account_transaction => account_transaction.id === accountTransactionId);
  });

  async function fetchAllAccountTransactions() {
    loading.value = true;
    error.value = null;
    try {
      const data = await apiClient.get(`/accounts/${router.currentRoute.value.params.id}/transactions`);
      accountTransactions.value = data
    } catch (err) {
      handleError(err, 'Ошибка загрузки транзакций');
      throw err;
    } finally {
      loading.value = false;
    }
  };

  async function createTransaction(transactionData) {
    try {
      const data = await apiClient.post(`/accounts/${router.currentRoute.value.params.id}/transactions`, transactionData);
      accountTransactions.value.push(data);
    } catch (err) {
      handleError(err, 'Ошибка создания транзакций');
      throw err;
    }
  };

  const updateTransaction = async (id, updateData) => {
    try {
      const { data } = await apiClient.put(`/transactions/${id}`, updateData);
      const index = transactions.value.findIndex(t => t.id === id);
      if (index !== -1) transactions.value[index] = data;
      return data;
    } catch (error) {
      handleError(err, 'Ошибка обновления транзакций');
      throw err;
    }
  };

  const deleteTransaction = async (id) => {
    try {
      await apiClient.delete(`/transactions/${id}`);
      accountTransactions.value = accountTransactions.value.filter(t => t.id !== id);
    } catch (err) {
      handleError(err, 'Ошибка удаления транзакций');
      throw err;
    }
  };

  const fetchAccount = async (id) => {
    const { data } = await apiClient.get(`/accounts/${id}`);
    const index = accounts.value.findIndex(a => a.id === id);
    if (index !== -1) accounts.value[index] = data;
  };

  return {
    // accounts,
    loading,
    error,
    getAllAccountTransactions,
    getAccountTransactionById,
    fetchAllAccountTransactions,
    createTransaction,
    updateTransaction,
    deleteTransaction,
    fetchAccount
  }
})
