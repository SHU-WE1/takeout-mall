<template>
  <div class="title-index">
    <div class="month">
      <ul class="tabs">
        <li
          class="li-tab"
          v-for="(item, index) in tabsParam"
          @click="toggleTabs(index)"
          :class="{ active: index === nowIndex }"
          :key="index"
        >
          {{ item }}
          <span></span>
        </li>
      </ul>
    </div>
    <div class="get-time">
      <p>
        選択時間：{{ tateData[0] }} ～
        {{ tateData[tateData.length - 1] }}
      </p>
    </div>
    <el-button
      icon="iconfont icon-download"
      class="right-el-button"
      @click="handleExport"
      >データエクスポート</el-button
    >
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from 'vue-property-decorator'
import { exportInfor } from '@/api/index'
@Component({
  name: 'TitleIndex',
})
export default class extends Vue {
  @Prop() private flag!: any
  @Prop() private tateData!: any
  @Prop() private turnoverData!: any

  nowIndex = 2 - 1
  value = []
  tabsParam = ['昨日', '近7日', '近30日', '今週', '今月']
  @Watch('flag')
  getNowIndex(val) {
    this.nowIndex = val
  }
  // タブ切り替え
  toggleTabs(index: number) {
    this.nowIndex = index
    this.value = []
    this.$emit('sendTitleInd', index + 1)
  }
  //  データエクスポート
  /** エクスポートボタン操作 */
  handleExport() {
    this.$confirm('最近30日間の運営データをエクスポートしてもよろしいですか？', '確認', {
      confirmButtonText: '確定',
      cancelButtonText: 'キャンセル',
      type: 'warning',
    })
      .then(async function () {
        const { data } = await exportInfor()
        let url = window.URL.createObjectURL(data)
        var a = document.createElement('a')
        document.body.appendChild(a)
        a.href = url
        a.download = '運営データ統計レポート.xlsx'
        a.click()
        window.URL.revokeObjectURL(url)
      })
      .then((response) => {})
  }
}
</script>
