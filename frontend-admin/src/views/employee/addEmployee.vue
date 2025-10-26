<template>
  <div class="addBrand-container">
    <div class="container">
      <el-form :model="ruleForm" :rules="rules" ref="ruleForm" label-width="180px">
        <el-form-item label="アカウント" prop="username">
          <el-input v-model="ruleForm.username"></el-input>
        </el-form-item>
        <el-form-item label="従業員名" prop="name">
          <el-input v-model="ruleForm.name"></el-input>
        </el-form-item>
        <el-form-item label="携帯電話番号" prop="phone">
          <el-input v-model="ruleForm.phone"></el-input>
        </el-form-item>
        <el-form-item label="性別" prop="sex">
            <el-radio v-model="ruleForm.sex" label="1">男性</el-radio>
            <el-radio v-model="ruleForm.sex" label="2">女性</el-radio>
        </el-form-item>
        <el-form-item label="身分証番号" prop="idNumber">
          <el-input v-model="ruleForm.idNumber"></el-input>
        </el-form-item>
        <div class="subBox">
          <el-button type="primary" @click="submitForm('ruleForm',false)">保存</el-button>
          <el-button
            v-if="this.optType === 'add'"
            type="primary"
            @click="submitForm('ruleForm',true)">保存して従業員追加を続行
          </el-button>
          <el-button @click="() => this.$router.push('/employee')">戻る</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script lang="ts">
import {addEmployee,queryEmployeeById,updateEmployee} from '@/api/employee'
import router from '@/router';
export default {
  data() {
    return {
      optType: '',//当前操作的类型，新增或者修改
      ruleForm: {
        name: '',
        username: '',
        sex: '1',
        phone: '',
        idNumber: ''
      },
      rules: {
        name: [
            { required: true, message: '従業員名を入力してください', trigger: 'blur' }
        ],
        username: [
            { required: true, message: '従業員アカウントを入力してください', trigger: 'blur' }
        ],
        phone: [
          { required: true, trigger: 'blur',validator: (rule,value,callback) => {
              if(value === '' || (!/^1(3|4|5|6|7|8)\d{9}$/.test(value))){
                callback(new Error('正しい携帯電話番号を入力してください！'))
              }else{
                callback()
              }
            }
          }
        ],
        idNumber: [
          { required: true, trigger: 'blur',validator: (rule,value,callback) => {
              if(value === '' || (!/(^\d{15}$)|(^\d{18}$)|(^\d{17}(X|x)$)/.test(value))){
                callback(new Error('正しい身分証番号を入力してください！'))
              }else{
                callback()
              }
            }
          }
        ]
      }
    }
  },
  created() {
    //获取路由参数（id），如果有则为修改操作，否则为新增操作
    this.optType = this.$route.query.id ? 'update' : 'add'
    if (this.optType === 'update') {
      //修改操作，需要根据id查询原始数据，用于回显
      queryEmployeeById(this.$route.query.id)
      .then(res => {
        if (res.data.code === 1) {
          this.ruleForm = res.data.data
        }
      }).catch(err => {
        console.log(err)
      })
    }
  },
  methods: {
    submitForm(formName,isContinue){
      //进行表单校验
      this.$refs[formName].validate((valid) => {
        if(valid) {
          //表单校验通过，发起Ajax请求，将数据提交到后端
          if(this.optType === 'add'){
            //新增操作
            addEmployee(this.ruleForm).then((res) => {
                if(res.data.code === 1){
                  this.$message.success('従業員追加に成功しました！')
                  if(isContinue){
                  this.ruleForm = {
                      name: '',
                      username: '',
                      sex: '1',
                      phone: '',
                      idNumber: ''
                    }
                  }else {
                    this.$router.push('/employee')
                  }
                }else {
                  this.$message.error(res.data.msg)
                }
              })
          }else{
            //修改操作
            updateEmployee(this.ruleForm).then(res => {
              if(res.data.code === 1){
                this.$message.success('従業員情報の編集に成功しました！')
                this.$router.push('/employee')
              }
            })
          }
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.addBrand {
  &-container {
    margin: 30px;
    margin-top: 30px;
    .HeadLable {
      background-color: transparent;
      margin-bottom: 0px;
      padding-left: 0px;
    }
    .container {
      position: relative;
      z-index: 1;
      background: #fff;
      padding: 30px;
      border-radius: 4px;
      // min-height: 500px;
      .subBox {
        padding-top: 30px;
        text-align: center;
        border-top: solid 1px $gray-5;
      }
    }
    .idNumber {
      margin-bottom: 39px;
    }

    .el-form-item {
      margin-bottom: 29px;
    }
    .el-input {
      width: 293px;
    }
  }
}
</style>
