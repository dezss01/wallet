import { createRouter, createWebHistory } from 'vue-router/auto'
import UserRegistration from "@/pages/UserRegistration.vue";
import UserAuth from "@/pages/UserAuth.vue";
import TheAccounts from "@/pages/TheAccounts.vue";
import TheBasePage from "@/pages/TheBasePage.vue";
import UserEdit from "@/pages/UserEdit.vue";
import NewAccountPage from "@/pages/NewAccountPage.vue";
import ShowAccountPage from "@/pages/ShowAccountPage.vue";
import EditAccountPage from "@/pages/EditAccountPage.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
    path: '/sign-up',
    name: 'sign-up',
    component: UserRegistration
    },
    {
      path: '/auth',
      name: 'auth',
      component: UserAuth
    },
    {
      path: '/accounts',
      name: 'accounts',
      component: TheAccounts
    },
    {
      path: '/',
      name: 'home',
      component: TheBasePage
    },
    {
      path: '/edit',
      name: 'edit_user',
      component: UserEdit
    },
    {
      path: '/account/new',
      name: 'new_account',
      component: NewAccountPage,
    },
    {
      path: '/account/:id',
      name: 'accountId',
      component: ShowAccountPage,
    },
    {
      path: '/account/:id/edit',
      name: 'edit_account',
      component: EditAccountPage,
    }
  ],

})
// Workaround for https://github.com/vitejs/vite/issues/11804
router.onError((err, to) => {
  if (err?.message?.includes?.('Failed to fetch dynamically imported module')) {
    if (!localStorage.getItem('vuetify:dynamic-reload')) {
      console.log('Reloading page to fix dynamic import error')
      localStorage.setItem('vuetify:dynamic-reload', 'true')
      location.assign(to.fullPath)
    } else {
      console.error('Dynamic import error, reloading page did not fix it', err)
    }
  } else {
    console.error(err)
  }
})

router.isReady().then(() => {
  localStorage.removeItem('vuetify:dynamic-reload')
})

export default router
