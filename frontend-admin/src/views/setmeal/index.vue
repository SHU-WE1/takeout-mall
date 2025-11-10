<template>
  <div class="dashboard-container">
    <div class="container">
      <div class="tableBar">
        <label style="margin-right: 5px">
          セットメニュー名：
        </label>
        <el-input v-model="name" placeholder="セットメニュー名を入力してください" style="width: 15%" />
        <label style="margin-right: 5px">セットメニュー分類：</label>
        <el-select v-model="categoryId" placeholder="選択してください">
          <el-option
            v-for="item in options"
            :key="item.id"
            :label="item.name"
            :value="item.id"
          >
          </el-option>
        </el-select>
        <label style="margin-right: 5px">販売状態：</label>
        <el-select v-model="saleStatus" placeholder="選択してください">
          <el-option
            v-for="item in statusArr"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          >
          </el-option>
        </el-select>
        <el-button type="primary" style="margin-left: 20px" @click="pageQuery">検索</el-button>
        <div style="float: right">
          <el-button type="danger" @click="handleDelete">一括削除</el-button>
          <el-button type="info" @click="handleAdd">+新規セットメニュー</el-button>
        </div>
      </div>
    </div>
    <el-table :data="records" stripe class="tableBox" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="25" />
      <el-table-column prop="name" label="セットメニュー名" />
      <el-table-column label="画像">
        <template slot-scope="scope">
          <el-image style="width: 80px; height: 40px; border: none" :src="scope.row.image"></el-image>
        </template>
      </el-table-column>
      <el-table-column prop="categoryName" label="セットメニュー分類" />
      <el-table-column prop="price" label="セットメニュー価格"/>
      <el-table-column label="販売状態">
        <template slot-scope="scope">
          <div class="tableColumn-status" :class="{ 'stop-use': scope.row.status === 0 }">
            {{ scope.row.status === 0 ? '販売停止' : '販売開始' }}
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="updateTime" label="最終操作時間" />
      <el-table-column label="操作" align="center" width="250px">
        <template slot-scope="scope">
          <el-button type="text" size="small"> 修正 </el-button>
          <el-button type="text" size="small" @click="handleStartOrStop(scope.row)">
            {{ scope.row.status == '1' ? '販売停止' : '販売開始' }}
          </el-button>
          <el-button type="text" size="small" @click="handleDelete('S',scope.row.id)"> 削除 </el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-pagination class="pageList"
                   :page-sizes="[10, 20, 30, 40]"
                   :page-size="pageSize"
                   layout="total, sizes, prev, pager, next, jumper"
                   :total="total"
                   @size-change="handleSizeChange"
                   @current-change="handleCurrentChange" />
  </div>
</template>

<script lang="ts">
import { getCategoryByType } from '@/api/category'
import category from '@/views/category/index.vue'
import {getSetmealPage,enableOrDisableSetmeal,deleteSetmeal} from '@/api/setMeal'

export default {
  computed: {
    category() {
      return category
    }
  },
  data() {
    return {
      page: 1,
      pageSize: 10,
      name: '',
      status: '', //售卖状态
      categoryId: '', //分类id
      total: 0,
      records:[],
      options: [],
      statusArr: [{
        value: 1,
        label: '販売開始'
      }, {
        value: 2,
        label: '販売停止'
      }
      ],
      saleStatus: '',
      multipleSelection: []//現在選択されている行
    }
  },
  created() {
    //セットメニュー分類を検索、検索ページのドロップダウンを埋めるため
    getCategoryByType({ type: 2 }).then(res => {
      if (res.data.code === 1) {
        this.options = res.data.data
      }
    })
    //セットメニューページネーションデータを検索
    this.pageQuery()
  },
  methods: {
    //セットメニューページネーション検索
    pageQuery() {
      const params = {
        page: this.page,
        pageSize: this.pageSize,
        name: this.name,
        categoryId: this.categoryId,
        status: this.status
      }
      //ページネーション検索を呼び出し
      getSetmealPage(params).then(res => {
        if (res.data.code === 1) {
          this.records = res.data.data.records
          this.total = res.data.data.total
        }
      })
    },
    handleSizeChange(pageSize){
      this.pageSize = pageSize
      this.pageQuery()
    },
    handleCurrentChange(page){
      this.page = page
      this.pageQuery()
    },
    handleStartOrStop(row){
      this.$confirm('このセットメニューの販売状態を調整してもよろしいですか？', '確認', {
        confirmButtonText: '確定',
        cancelButtonText: 'キャンセル',
        type: 'warning'
      }).then(() => {
        enableOrDisableSetmeal({id: row.id, status: row.status === 1 ? 0 : 1}).then(res => {
          if(res.status === 200){
            this.$message.success('セットメニュー販売状態が正常に変更されました')
            this.pageQuery()
          }
        })
          .catch(error => {
            this.$message.error('リクエストエラー：' + error.message)
          })
      })

    },
    handleDelete(type: string, id: number) {
      if (type === 'B' && this.multipleSelection.length == 0) {
        this.$message('削除するセットメニューを選択してください！')
        return
      }
      this.$confirm('セットメニューを削除してもよろしいですか？', '削除確認', {
        confirmButtonText: '削除',
        cancelButtonText: 'キャンセル',
        type: 'warning'
      }).then(() => {
        let params: string | number = ''
        if (type === 'S') {
          //単一削除
          params = id
        } else {
          const arr = new Array
          this.multipleSelection.forEach(element => {
            arr.push(element.id)
          })
          params = arr.join(',')//配列内のIDを結合、カンマで区切る
        }
        deleteSetmeal(params).then(res => {
          if (res.data.code === 1) {
            this.$message.success('削除成功！')
            this.pageQuery()
          } else {
            this.$message.error(res.data.message)
          }
        })
      })
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
      console.log('現在のテーブルで選択された項目数：' + val.length)
      val.forEach(element => {
        console.log('id:' + element.id)
      })
    },
    handleAdd(){
      this.$router.push('/setmeal/add'
      )
    }
  }
}
</script>
<style lang="scss">
.el-table-column--selection .cell {
  padding-left: 10px;
}
</style>
<style lang="scss" scoped>
.dashboard {
  &-container {
    margin: 30px;

    .container {
      background: #fff;
      position: relative;
      z-index: 1;
      padding: 30px 28px;
      border-radius: 4px;

      .tableBar {
        margin-bottom: 20px;

        .tableLab {
          float: right;

          span {
            cursor: pointer;
            display: inline-block;
            font-size: 14px;
            padding: 0 20px;
            color: $gray-2;
          }
        }
      }

      .tableBox {
        width: 100%;
        border: 1px solid $gray-5;
        border-bottom: 0;
      }

      .pageList {
        text-align: center;
        margin-top: 30px;
      }

      //查询黑色按钮样式
      .normal-btn {
        background: #333333;
        color: white;
        margin-left: 20px;
      }
    }
  }
}
</style>
