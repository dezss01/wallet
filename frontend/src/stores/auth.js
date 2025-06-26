import { defineStore } from "pinia";
import axios from "axios";

const API_BASE_URL = '/api';


const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  withCredentials: true
})

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    authToken: null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.user,
    currentUser: (state) => state.user,
  },
  actions: {
    async signUp(userData) {
      try {
        const response = await apiClient.post('/users/signup', userData);
        this.setUser(response.data.user);
        this.setToken(response.headers.authorization);
        return { success: true, data: response.data };
      } catch (error) {
        // console.error('Registration failed:', error.response?.data || error.message);
        this.clearAuth();
        return { success: false, message: error.response?.data || 'An error occurred' };
      }
    },
    async signIn(userData) {
      try {
        const response = await apiClient.post('users/login', { user: userData } );
        this.setUser(response.data.user);
        this.setToken(response.headers.authorization);
        return { success: true, data: response.data };
      } catch (error) {
        console.error('Login failed:', error.response?.data || error.message);
        this.clearAuth();
        return { success: false, message: error.response?.data || 'An error occurred' };
      }
    },
    async updateUser(newUserData) {
      try {
        const response = await apiClient.patch("/users", { user: newUserData });
        this.setUser(response.data.user);
        return { success: true, data: response.data };
      } catch (error) {
        // console.log('---------------------------------------------')
        // console.error('Edit profile failed:', error.response?.data);
        return { success: false, message: error.response?.data || error.message };
      }
    },
    async logout() {
      try {
        await apiClient.delete('/users/logout');
        this.clearAuth();
        return { success: true };
      } catch (error) {
        console.error('Logout failed:', error.response?.data || error.message);
        if (error.response?.status === 401) {
          this.clearAuth();
        }
        return { success: false, message: error.response?.data?.error || 'An error occurred' };
      }
    },
    setUser(user) {
      this.user = user;
      localStorage.setItem('user', JSON.stringify(user));
    },
    setToken(token) {
      this.authToken = token;
      localStorage.setItem("authToken", token);
      apiClient.defaults.headers.common["Authorization"] = token;
    },
    clearAuth() {
      this.user = null;
      this.authToken = null;
      localStorage.removeItem('user');
      localStorage.removeItem('authToken');
      delete apiClient.defaults.headers.common["Authorization"];
    },
    initializeAuth() {
      const storedUser = localStorage.getItem('user');
      const storedToken = localStorage.getItem('authToken');
      if (storedUser && storedToken) {
        try {
          const parsedUser = JSON.parse(storedUser);
          this.setUser(parsedUser);
          this.setToken(storedToken);
        } catch (error) {
          console.error('Failed to initialize auth:', error);
          this.clearAuth();
        }
      }
    },
    getUser() {
      return this.user;
    }
  }
});
