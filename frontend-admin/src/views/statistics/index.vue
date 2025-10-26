<template>
  <div class="dashboard-container home">
    <!-- タイトル -->
    <TitleIndex @sendTitleInd="getTitleNum" :flag="flag" :tateData="tateData" />
    <!-- end -->
    <div class="homeMain">
      <!-- 売上統計 -->
      <TurnoverStatistics :turnoverdata="turnoverData" />
      <!-- end -->
      <!-- ユーザー統計 -->
      <UserStatistics :userdata="userData" />
      <!-- end -->
    </div>
    <div class="homeMain homecon">
      <!-- 注文統計 -->
      <OrderStatistics :orderdata="orderData" :overviewData="overviewData" />
      <!-- end -->
      <!-- 売上ランキングTOP10 -->
      <Top :top10data="top10Data" />
      <!-- end -->
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator'
import {
  get1stAndToday,
  past7Day,
  past30Day,
  pastWeek,
  pastMonth,
} from '@/utils/formValidate'
import {
  getDataOverView, //データ概要
  getTurnoverStatistics,
  getUserStatistics,
  getOrderStatistics,
  getTop,
} from '@/api/index'
// コンポーネント
// タイトル
import TitleIndex from './components/titleIndex.vue'
// 売上統計
import TurnoverStatistics from './components/turnoverStatistics.vue'
// ユーザー統計
import UserStatistics from './components/userStatistics.vue'
// 注文統計
import OrderStatistics from './components/orderStatistics.vue'
// ランキング
import Top from './components/top10.vue'
@Component({
  name: 'Dashboard',
  components: {
    TitleIndex,
    TurnoverStatistics,
    UserStatistics,
    OrderStatistics,
    Top,
  },
})
export default class extends Vue {
  private overviewData = {} as any
  private flag = 2
  private tateData = []
  private turnoverData = {} as any
  private userData = {}
  private orderData = {
    data: {},
  } as any
  private top10Data = {}
  created() {
    //this.init(this.flag)
    this.getTitleNum(2);
  }
  // 基本データを取得
  init(begin: any,end:any) {
    this.$nextTick(() => {
      this.getTurnoverStatisticsData(begin,end)
      this.getUserStatisticsData(begin,end)
      this.getOrderStatisticsData(begin,end)
      this.getTopData(begin,end)
    })
  }

  // 売上統計データを取得
  async getTurnoverStatisticsData(begin: any ,end:any) {
    const data = await getTurnoverStatistics({ begin: begin,end:end })
    const turnoverData = data.data.data
    this.turnoverData = {
      dateList: turnoverData.dateList.split(','),
      turnoverList: turnoverData.turnoverList.split(',')
    }
    // this.tateData = this.turnoverData.date
    // const arr = []
    // this.tateData.forEach((val) => {
    //   let date = new Date()
    //   let year = date.getFullYear()
    //   arr.push(year + '-' + val)
    // })
    // this.tateData = arr
  }
  // ユーザー統計データを取得
  async getUserStatisticsData(begin: any ,end:any) {
    const data = await getUserStatistics({ begin: begin,end:end })
    const userData = data.data.data
    this.userData = {
      dateList: userData.dateList.split(','),
      totalUserList: userData.totalUserList.split(','),
      newUserList: userData.newUserList.split(','),
    }
  }
  // 注文統計データを取得
  async getOrderStatisticsData(begin: any ,end:any) {
    const data = await getOrderStatistics({begin: begin,end:end })
    const orderData = data.data.data
    this.orderData = {
      data: {
        dateList: orderData.dateList.split(','),
        orderCountList: orderData.orderCountList.split(','),
        validOrderCountList: orderData.validOrderCountList.split(','),
        //orderCompletionRateList: orderData.orderCompletionRateList.split(','),
      },
      totalOrderCount: orderData.totalOrderCount,
      validOrderCount: orderData.validOrderCount,
      orderCompletionRate: orderData.orderCompletionRate
    }
  }
  // 获取排行数据
  async getTopData(begin: any ,end:any) {
    const data = await getTop({begin: begin,end:end })
    const top10Data = data.data.data
    this.top10Data = {
      nameList: top10Data.nameList.split(',').reverse(),
      numberList: top10Data.numberList.split(',').reverse(),
    }
    console.log(this.top10Data)
  }
  // 获取当前选中的tab时间
  getTitleNum(data) {
    switch (data) {
      case 1:
        this.tateData = get1stAndToday()
        break
      case 2:
        this.tateData = past7Day()
        break
      case 3:
        this.tateData = past30Day()
        break
      case 4:
        this.tateData = pastWeek()
        break
      case 5:
        this.tateData = pastMonth()
        break
    }
    this.init(this.tateData[0],this.tateData[1])
  }
}
</script>

<style lang="scss">
</style>
