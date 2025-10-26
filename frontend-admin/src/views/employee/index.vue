import { getEmployeeList } from '../../api/employee';
<template>
  <div class="dashboard-container">
    <div class="container">
      <div class="tableBar">
        <label style="margin-right: 5px">
          従業員名：
        </label>
        <el-input v-model='name' placeholder="従業員名を入力してください" style="width: 15%"/>
        <el-button type="primary" style="margin-left: 20px" @click="pageQuery">検索</el-button>
        <el-button type="primary" style="float: right " @click="handleAddEmp">+従業員追加</el-button>

      </div>
      <el-table
        :data="records"
        stripe
        style="width: 100%">
        <el-table-column
          prop="name"
          label="従業員名"
          width="180">
        </el-table-column>
        <el-table-column
          prop="username"
          label="アカウント"
          width="180">
        </el-table-column>
        <el-table-column
          prop="phone"
          label="携帯電話番号">
        </el-table-column>
        <el-table-column
          prop="status"
          label="アカウント状態">
          <template slot-scope="scope">
            {{scope.row.status ===0 ? '無効' : '有効'}}
          </template>
        </el-table-column>
        <el-table-column
          prop="updateTime"
          label="最終操作時間">
        </el-table-column>
        <el-table-column label="操作">
          <template slot-scope="scope">
            <el-button type="text" @click="handleUpdateEmp(scope.row)">編集</el-button>
            <el-button type="text" size="small" @click="handleStartOrStop(scope.row)">
              {{scope.row.status ===0 ? '有効' : '無効'}}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        class="pageList"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
        :current-page="page"
        :page-sizes="[10, 20, 30, 40]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="400">
      </el-pagination>
    </div>
  </div>
</template>
<script lang="ts">
import { enableOrDisableEmployee, getEmployeeList } from '@/api/employee'
import { getCategoryByType } from '@/api/category'
export default {
  //模型数据
  data(){
    return{
      name: '',
      page: 1,
      pageSize: 10,
      total: 0,
      records:[]
    }
  },
  created(){
    this.pageQuery();
  },
  methods: {
    //分页查询
    pageQuery() {
      //准备参数
      const params = {
        page: this.page,
        pageSize: this.pageSize,
        name: this.name
      }
      getEmployeeList(params).then(res => {
        //解析结果
        if (res.data.code === 1) {
          this.total = res.data.data.total;
          this.records = res.data.data.records;
        }
      })
        .catch(error => {
          this.$message.error(error.message);
        })
      },
    handleSizeChange(pageSize) {
      this.pageSize = pageSize
      this.pageQuery()
    },
    handleCurrentChange(page){
      this.page = page
      this.pageQuery()
    },
    //启用禁用员工账号
    handleStartOrStop(row) {
      if(row.username == 'admin'){
        this.$message.error('adminは管理者アカウントのため、アカウント状態を変更できません！')
        return
      }
      // alert(`id=${row.id} status=${row.status}`);
      this.$confirm('現在の従業員アカウント状態を変更しますか？', '警告', {
        confirmButtonText: '確定',
        cancelButtonText: 'キャンセル',
        type: 'warning'
      }).then(() => {
        enableOrDisableEmployee({ id: row.id, status: !row.status ? 1 : 0 }).then(res => {
          if (res.data.code === 200) {
            this.$message.success('アカウント状態の変更に成功しました')
            this.pageQuery()
          }
        })
          .catch(error => {
            this.$message.error('リクエストエラー：' + error.message)
          })
      })
    },
    handleAddEmp(){
      this.$router.push('/employee/add')
    },
    handleUpdateEmp(row){
      if(row.username == 'admin'){
        this.$message.error('adminは管理者アカウントのため、編集は許可されません！')
        return
      }
      this.$router.push({path: '/employee/add', query: {id: row.id}})
    }
  }
}

</script>

<style lang="scss" scoped>
.disabled-text {
  color: #bac0cd !important;
}
</style>
