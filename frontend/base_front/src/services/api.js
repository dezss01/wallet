import axios from "axios";

axios.defaults.withCredentials = true

const apiClient = axios.create({
  baseURL: 'http://localhost:3000/api/v1/',
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
})

apiClient.interceptors.response.use((response) => {
  return response.data
}, (error) => {
  console.error('Error:', error)
  throw error
});

apiClient.interceptors.request.use((config) => {
  return config  // было request.data, исправлено на config
}, (error) => {
  console.error('Error:', error)
  throw error
});

export default apiClient;
