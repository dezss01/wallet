<template>
  <v-app>
    <v-app-bar app>
      <!-- <v-app-bar-nav-icon></v-app-bar-nav-icon> -->
      <v-toolbar-title>RoR 7 & VueJS 3 Auth</v-toolbar-title>
      <v-toolbar-items class='d-flex ga-2 justify-center align-center'>
        <router-link to='/accounts'>
          Accounts
        </router-link>
      </v-toolbar-items>
      <v-spacer />
      <v-toolbar-items>
        <the-menu />
      </v-toolbar-items>
    </v-app-bar>

    <v-navigation-drawer v-model="drawer" app>
      <!-- Содержимое бокового меню -->
      <v-list>
        <v-list-item-group>
          <v-list-item v-for="(item, i) in menuItems" :key="i" :to="item.to">
            <v-list-item-icon>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>

    <v-main>
      <v-container fluid>
        <router-view />
      </v-container>
    </v-main>

    <v-footer app height="50" class="d-flex flex-column">
      <div class="px-4 py-1 text-center w-100">
        {{ new Date().getFullYear() }} — <strong>@dezss</strong>
      </div>
    </v-footer>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
      drawer: true,
      menuItems: [
        { title: 'Home', icon: 'mdi-home', to: '/' },
        { title: 'Accounts', icon: 'mdi-home', to: '/accounts' },

      ]
    }
  }
}
</script>
