<template>
  <div class="dashboard-container home">
    <!-- 営業データ -->
    <Overview :overviewData="overviewData" />
    <!-- end -->
    <!-- 注文管理 -->
    <Orderview :orderviewData="orderviewData" />
    <!-- end -->
    <div class="homeMain">
      <!-- 料理総覧 -->
      <CuisineStatistics :dishesData="dishesData" />
      <!-- end -->
      <!-- セットメニュー総覧 -->
      <SetMealStatistics :setMealData="setMealData" />
      <!-- end -->
    </div>
    <!-- 注文情報 -->
    <OrderList
      :order-statics="orderStatics"
      @getOrderListBy3Status="getOrderListBy3Status"
    />
    <!-- end -->
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import {
  getBusinessData,
  getDataOverView, //営業データ
  getOrderData, //注文管理今日の注文
  getOverviewDishes, //料理総覧
  getSetMealStatistics, //セットメニュー総覧
} from '@/api/index'
import { getOrderListBy } from '@/api/order'
// コンポーネント
// 営業データ
import Overview from './components/overview.vue'
// 注文管理
import Orderview from './components/orderview.vue'
// 料理総覧
import CuisineStatistics from './components/cuisineStatistics.vue'
// セットメニュー総覧
import SetMealStatistics from './components/setMealStatistics.vue'
// 注文リスト
import OrderList from './components/orderList.vue'
@Component({
  name: 'Dashboard',
  components: {
    Overview,
    Orderview,
    CuisineStatistics,
    SetMealStatistics,
    OrderList,
  },
})
export default class extends Vue {
  private todayData = {} as any
  private overviewData = {}
  private orderviewData = {} as any
  private flag = 2
  private tateData = []
  private dishesData = {} as any
  private setMealData = {}
  private orderListData = []
  private counts = 0
  private page: number = 1
  private pageSize: number = 10
  private status = 2
  private orderStatics = {} as any
  created() {
    this.init()
  }
  init() {
    this.$nextTick(() => {
      this.getBusinessData()
      this.getOrderStatisticsData()
      this.getOverStatisticsData()
      this.getSetMealStatisticsData()
    })
  }
  // 営業データを取得
  async getBusinessData() {
    const data = await getBusinessData()
    this.overviewData = data.data.data
  }
  // 今日の注文を取得
  async getOrderStatisticsData() {
    const data = await getOrderData()
    this.orderviewData = data.data.data
  }
  // 料理総覧データを取得
  async getOverStatisticsData() {
    const data = await getOverviewDishes()
    this.dishesData = data.data.data
  }
  // セットメニュー総覧データを取得
  async getSetMealStatisticsData() {
    const data = await getSetMealStatistics()
    this.setMealData = data.data.data
  }
  //処理待ち、配送待ち、配送中の数量を取得
  getOrderListBy3Status() {
    getOrderListBy({})
      .then((res) => {
        if (res.data.code === 1) {
          this.orderStatics = res.data.data
        } else {
          this.$message.error(res.data.msg)
        }
      })
      .catch((err) => {
        this.$message.error('リクエストエラー：' + err.message)
      })
  }
}
</script>

<style lang="scss">
</style>
