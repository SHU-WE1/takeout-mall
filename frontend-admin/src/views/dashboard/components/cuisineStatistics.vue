<template>
  <div class="container">
    <h2 class="homeTitle">
      料理総覧<span><router-link to="dish">料理管理</router-link></span>
    </h2>
    <div class="orderviewBox">
      <ul>
        <li>
          <span class="status"><i class="iconfont icon-open"></i>販売開始</span>
          <span class="num">{{ dishesData.sold }}</span>
        </li>
        <li>
          <span class="status"><i class="iconfont icon-stop"></i>販売停止</span>
          <span class="num">{{ dishesData.discontinued }}</span>
        </li>
        <li class="add">
          <router-link to="/dish/add">
            <i></i>
            <p>新規料理</p>
          </router-link>
        </li>
      </ul>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from 'vue-property-decorator'
import orderList from './orderList.vue'
@Component({
  components: { orderList },
  name: 'cuisineview',
})
export default class extends Vue {
  @Prop() private dishesData!: any
}
</script>
