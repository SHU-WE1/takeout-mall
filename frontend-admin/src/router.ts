import Vue from "vue";
import Router from "vue-router";
import Layout from "@/layout/index.vue";
// import {
//   getToken,
//   setToken,
//   removeToken,
//   getStoreId,
//   setStoreId,
//   removeStoreId,
//   setUserInfo,
//   getUserInfo,
//   removeUserInfo
// } from "@/utils/cookies";
// import store from "@/store";

Vue.use(Router);

const router = new Router({
  scrollBehavior: (to, from, savedPosition) => {
    if (savedPosition) {
      return savedPosition;
    }
    return { x: 0, y: 0 };
  },
  base: process.env.BASE_URL,
  routes: [
    {
      path: "/login",
      component: () => import("@/views/login/index.vue"),
      meta: { title: "テイクアウトモール", hidden: true, notNeedAuth: true }
    },
    {
      path: "/404",
      component: () => import("@/views/404.vue"),
      meta: { title: "テイクアウトモール", hidden: true, notNeedAuth: true }
    },
    {
      path: "/",
      component: Layout,
      redirect: "/dashboard",
      children: [
        {
          path: "dashboard",
          component: () =>  import("@/views/dashboard/index.vue"),
          name: "Dashboard",
          meta: {
            title: "ダッシュボード",
            icon: "dashboard",
            affix: true
          }
        },
		    {
          path: "/statistics",
          component: () => import("@/views/statistics/index.vue"),
          meta: {
            title: "データ統計",
            icon: "icon-statistics"
          }
        },
        {
          path: "order",
          component: () => import("@/views/orderDetails/index.vue"),
          meta: {
            title: "注文管理",
            icon: "icon-order"
          }
        },
        {
          path: "setmeal",
          component: () => import("@/views/setmeal/index.vue"),
          meta: {
            title: "セットメニュー管理",
            icon: "icon-combo"
          }
        },
        {
          path: "dish",
          component: () => import("@/views/dish/index.vue"),
          meta: {
            title: "料理管理",
            icon: "icon-dish"
          }
        },
        {
          path: "/dish/add",
          component: () => import("@/views/dish/addDishtype.vue"),
          meta: {
            title: "料理追加",
            hidden: true
          }
        },
        
        {
          path: "category",
          component: () => import("@/views/category/index.vue"),
          meta: {
            title: "分類管理",
            icon: "icon-category"
          }
        },
        {
          path: "employee",
          component: () => import("@/views/employee/index.vue"),
          meta: {
            title: "従業員管理",
            icon: "icon-employee"
          }
        },
        
        {
          path: "/employee/add",
          component: () => import("@/views/employee/addEmployee.vue"),
          meta: {
            title: "従業員追加/編集",
            hidden: true
          }
        },
        
        {
          path: "/setmeal/add",
          component: () => import("@/views/setmeal/addSetmeal.vue"),
          meta: {
            title: "セットメニュー追加",
            hidden: true
          }
        }
      ]
    },
    {
      path: "*",
      redirect: "/404",
      meta: { hidden: true }
    }
  ]
});

export default router;
