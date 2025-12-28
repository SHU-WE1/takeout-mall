<template>
  <div :key="vueRest"
       class="addBrand-container">
    <div :key="restKey"
         class="container">
      <el-form ref="ruleForm"
               :model="ruleForm"
               :rules="rules"
               :inline="true"
               label-width="180px"
               class="demo-ruleForm">
        <div>
          <el-form-item label="料理名："
                        prop="name">
            <el-input v-model="ruleForm.name"
                      placeholder="料理名を入力してください"
                      maxlength="20" />
          </el-form-item>
          <el-form-item label="料理分類："
                        prop="categoryId">
            <el-select v-model="ruleForm.categoryId"
                       placeholder="料理分類を選択してください">
              <el-option v-for="(item, index) in dishList"
                         :key="index"
                         :label="item.name"
                         :value="item.id" />
            </el-select>
          </el-form-item>
        </div>
        <div>
          <el-form-item label="料理価格："
                        prop="price">
            <el-input v-model="ruleForm.price"
                      placeholder="料理価格を設定してください" />
          </el-form-item>
          <el-form-item label="在庫数量："
                        prop="stock">
            <el-input-number v-model="ruleForm.stock"
                             :min="0"
                             :max="9999"
                             placeholder="在庫数量を入力してください"
                             style="width: 100%" />
          </el-form-item>
        </div>
        <el-form-item label="味付け・調理法設定：">
          <el-form-item>
            <div class="flavorBox">
              <span v-if="dishFlavors.length == 0"
                    class="addBut"
                    @click="addFlavore">
                + 味付けを追加</span>
              <div v-if="dishFlavors.length != 0"
                   class="flavor">
                <div class="title">
                  <span>味付け名（3文字以内）</span>
                  <!-- <span class="des-box">口味标签（输入标签回车添加）</span> -->
                </div>
                <div class="cont">
                  <div v-for="(item, index) in dishFlavors"
                       :key="index"
                       class="items">
                    <div class="itTit">
                      <!-- :dish-flavors-data="filterDishFlavorsData()" -->
                      <SelectInput :dish-flavors-data="leftDishFlavors"
                                   :index="index"
                                   :value="item.name"
                                   @select="selectHandle" />
                    </div>
                    <div class="labItems"
                         style="display: flex">
                      <span v-for="(it, ind) in item.value"
                            :key="ind">{{ it }}
                        <i @click="delFlavorLabel(index, ind)">X</i></span>
                      <div class="inputBox"
                           :style="inputStyle" />
                    </div>
                    <span class="delFlavor delBut non"
                          @click="delFlavor(item.name)">削除</span>
                  </div>
                </div>
                <div v-if="
                       !!this.leftDishFlavors.length &&
                         this.dishFlavors.length < this.dishFlavorsData.length
                     "
                     class="addBut"
                     @click="addFlavore">
                  味付けを追加
                </div>
              </div>
            </div>
          </el-form-item>
        </el-form-item>
        <div>
          <el-form-item label="料理画像："
                        prop="image">
            <image-upload :prop-image-url="imageUrl"
                          @imageChange="imageChange">
              画像サイズは2M以下<br>PNG、JPEG、JPG形式のみ<br>200×200または300×300サイズの画像を推奨
            </image-upload>
          </el-form-item>
        </div>
        <div class="address">
          <el-form-item label="料理説明："
                        prop="region">
            <el-input v-model="ruleForm.description"
                      type="textarea"
                      :rows="3"
                      maxlength="200"
                      placeholder="料理説明、最大200文字" />
          </el-form-item>
        </div>
        <div class="subBox address">
          <el-button @click="() => $router.back()">
            キャンセル
          </el-button>
          <el-button type="primary"
                     :class="{ continue: actionType === 'add' }"
                     @click="submitForm('ruleForm')">
            保存
          </el-button>
          <el-button v-if="actionType == 'add'"
                     type="primary"
                     @click="submitForm('ruleForm', 'goAnd')">
            保存して続けて追加
          </el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator'
import HeadLable from '@/components/HeadLable/index.vue'
import SelectInput from './components/SelectInput.vue'
import ImageUpload from '@/components/ImgUpload/index.vue'
// getFlavorList味付けリストは一時的にしない getDishTypeList
import {
  queryDishById,
  addDish,
  editDish,
  getCategoryList,
  commonDownload
} from '@/api/dish'
import { baseUrl } from '@/config.json'
import { getToken } from '@/utils/cookies'
@Component({
  name: 'addShop',
  components: {
    HeadLable,
    SelectInput,
    ImageUpload
  }
})
export default class extends Vue {
  private restKey: number = 0
  private textarea: string = ''
  private value: string = ''
  private imageUrl: string = ''
  private actionType: string = ''
  private dishList: string[] = []
  private dishFlavorsData: any[] = [] //元の味付けデータ
  private dishFlavors: any[] = [] //アップロード待ちの味付けデータ
  private leftDishFlavors: any[] = [] //ドロップダウンに残っている選択可能な味付けデータ
  private vueRest = '1'
  private index = 0
  private inputStyle = { flex: 1 }
  private headers = {
    token: getToken()
  }
  private ruleForm = {
    name: '',
    id: '',
    price: '',
    code: '',
    image: '',
    description: '',
    dishFlavors: [],
    status: true,
    categoryId: '',
    stock: 0
  }

  get rules() {
    return {
      name: [
        {
          required: true,
          validator: (rule: any, value: string, callback: Function) => {
            if (!value) {
              callback(new Error('料理名を入力してください'))
            } else {
              const reg = /^([A-Za-z0-9\u4e00-\u9fa5\u3040-\u309F\u30A0-\u30FF]){2,20}$/
              if (!reg.test(value)) {
                callback(new Error('料理名の入力が正しくありません、2-20文字で入力してください'))
              } else {
                callback()
              }
            }
          },
          trigger: 'blur'
        }
      ],
      categoryId: [
        { required: true, message: '料理分類を選択してください', trigger: 'change' }
      ],
      image: {
        required: true,
        message: '料理画像は空にできません'
      },
      price: [
        {
          required: true,
          // 'message': '请填写菜品价格',
          validator: (rules: any, value: string, callback: Function) => {
            const reg = /^([1-9]\d{0,5}|0)(\.\d{1,2})?$/
            if (!reg.test(value) || Number(value) <= 0) {
              callback(
                new Error(
                  '料理価格の形式が正しくありません、0より大きく、小数点以下2桁までの金額を入力してください'
                )
              )
            } else {
              callback()
            }
          },
          trigger: 'blur'
        }
      ],
      code: [{ required: true, message: '商品コードを入力してください', trigger: 'blur' }]
    }
  }

  created() {
    this.getDishList()
    // 味付け一時データ
    this.getFlavorListHand()
    this.actionType = this.$route.query.id ? 'edit' : 'add'
    if (this.$route.query.id) {
      this.init()
    }
  }

  mounted() {}
  @Watch('dishFlavors')
  changeDishFlavors() {
    this.getLeftDishFlavors()
  }

  //選択済みの味付けをフィルタリング、ドロップダウンで再度選択不可
  getLeftDishFlavors() {
    let arr = []
    this.dishFlavorsData.map(item => {
      if (
        this.dishFlavors.findIndex(item1 => item.name === item1.name) === -1
      ) {
        arr.push(item)
      }
    })
    this.leftDishFlavors = arr
  }

  private selectHandle(val: any, key: any, ind: any) {
    const arrDate = [...this.dishFlavors]
    const index = this.dishFlavorsData.findIndex(item => item.name === val)
    arrDate[key] = JSON.parse(JSON.stringify(this.dishFlavorsData[index]))
    this.dishFlavors = arrDate
  }

  private async init() {
    queryDishById(this.$route.query.id).then(res => {
      if (res && res.data && res.data.code === 1) {
        this.ruleForm = { ...res.data.data }
        this.ruleForm.price = String(res.data.data.price)
        this.ruleForm.status = res.data.data.status == '1'
        this.ruleForm.stock = res.data.data.stock || 0
        this.dishFlavors =
          res.data.data.flavors &&
          res.data.data.flavors.map(obj => ({
            ...obj,
            value: JSON.parse(obj.value)
          }))
        let arr = []
        this.getLeftDishFlavors()
        this.imageUrl = res.data.data.image
      } else {
        this.$message.error(res.data.msg)
      }
    })
  }

  // ボタン - 味付けを追加
  private addFlavore() {
    this.dishFlavors.push({ name: '', value: [] }) // JSON.parse(JSON.stringify(this.dishFlavorsData))
  }

  // ボタン - 味付けを削除
  private delFlavor(name: string) {
    let ind = this.dishFlavors.findIndex(item => item.name === name)
    this.dishFlavors.splice(ind, 1)
  }

  // ボタン - 味付けラベルを削除
  private delFlavorLabel(index: number, ind: number) {
    this.dishFlavors[index].value.splice(ind, 1)
  }

  //味付け位置を記録
  private flavorPosition(index: number) {
    this.index = index
  }

  // 味付けラベルを追加
  private keyDownHandle(val: any) {
    if (event) {
      event.cancelBubble = true
      event.preventDefault()
      event.stopPropagation()
    }

    if (val.target.innerText.trim() != '') {
      this.dishFlavors[this.index].flavorData.push(val.target.innerText)
      val.target.innerText = ''
    }
  }

  // 料理分類を取得
  private getDishList() {
    getCategoryList({ type: 1 }).then(res => {
      if (res.data.code === 1) {
        this.dishList = res && res.data && res.data.data
      } else {
        this.$message.error(res.data.msg)
      }
      // if (res.data.code == 200) {
      //   const {data} = res.data
      //   this.dishList = data
      // } else {
      //   this.$message.error(res.data.desc)
      // }
    })
  }

  // 味付けリストを取得
  private getFlavorListHand() {
    // flavor flavorData
    this.dishFlavorsData = [
      { name: '甘味', value: ['無糖', '少糖', '半糖', '多糖', '全糖'] },
      { name: '温度', value: ['ホット', '常温', '氷抜き', '少氷', '多氷'] },
      { name: 'アレルギー', value: ['ネギ抜き', 'ニンニク抜き', '香菜抜き', '辛さ抜き'] },
      { name: '辛さ', value: ['辛くない', '微辛', '中辛', '大辛'] }
    ]
  }

  private submitForm(formName: any, st: any) {
    ;(this.$refs[formName] as any).validate((valid: any) => {
      console.log(valid, 'valid')
      if (valid) {
        if (!this.ruleForm.image) return this.$message.error('料理画像は空にできません')
        let params: any = { ...this.ruleForm }
        // params.flavors = this.dishFlavors
        params.status =
          this.actionType === 'add' ? 0 : this.ruleForm.status ? 1 : 0
        // params.price *= 100
        params.categoryId = this.ruleForm.categoryId
        params.flavors = this.dishFlavors.map(obj => ({
          ...obj,
          value: JSON.stringify(obj.value)
        }))
        delete params.dishFlavors
        if (this.actionType == 'add') {
          delete params.id
          addDish(params)
            .then(res => {
              if (res.data.code === 1) {
                this.$message.success('料理追加成功！')
                if (!st) {
                  this.$router.push({ path: '/dish' })
                } else {
                  this.dishFlavors = []
                  // this.dishFlavorsData = []
                  this.imageUrl = ''
                  this.ruleForm = {
                    name: '',
                    id: '',
                    price: '',
                    code: '',
                    image: '',
                    description: '',
                    dishFlavors: [],
                    status: true,
                    categoryId: '',
                    stock: 0
                  }
                  this.restKey++
                }
              } else {
                this.$message.error(res.data.desc || res.data.msg)
              }
            })
            .catch(err => {
              this.$message.error('リクエストエラー：' + err.message)
            })
        } else {
          delete params.createTime
          delete params.updateTime
          editDish(params)
            .then(res => {
              if (res && res.data && res.data.code === 1) {
                this.$router.push({ path: '/dish' })
                this.$message.success('料理修正成功！')
              } else {
                this.$message.error(res.data.desc || res.data.msg)
              }
              // if (res.data.code == 200) {
              //   this.$router.push({'path': '/dish'})
              //   this.$message.success('菜品修改成功！')
              // } else {
              //   this.$message.error(res.data.desc || res.data.message)
              // }
            })
            .catch(err => {
              this.$message.error('リクエストエラー：' + err.message)
            })
        }
      } else {
        return false
      }
    })
  }

  imageChange(value: any) {
    this.ruleForm.image = value
  }
}
</script>
<style lang="scss" scoped>
.addBrand-container {
  .el-form--inline .el-form-item__content {
    width: 293px;
  }

  .el-input {
    width: 350px;
  }

  .address {
    .el-form-item__content {
      width: 777px !important;
    }
  }
}
</style>
<style lang="scss" scoped>
.addBrand {
  &-container {
    margin: 30px;

    .container {
      position: relative;
      z-index: 1;
      background: #fff;
      padding: 30px;
      border-radius: 4px;
      min-height: 500px;

      .subBox {
        padding-top: 30px;
        text-align: center;
        border-top: solid 1px $gray-5;
      }
      .upload-item {
        .el-form-item__error {
          top: 90%;
        }
      }
    }
  }
}

.flavorBox {
  width: 777px;

  .addBut {
    background: #ffc200;
    display: inline-block;
    padding: 0px 20px;
    border-radius: 3px;
    line-height: 40px;
    cursor: pointer;
    border-radius: 4px;
    color: #333333;
    font-weight: 500;
  }

  .flavor {
    border: solid 1px #dfe2e8;
    border-radius: 3px;
    padding: 15px;
    background: #fafafb;

    .title {
      color: #606168;
      .des-box {
        padding-left: 44px;
      }
    }

    .cont {
      .items {
        display: flex;
        margin: 10px 0;

        .itTit {
          width: 150px;
          margin-right: 15px;

          input {
            width: 100%;
            // line-height: 40px;
            // border-radius: 3px;
            // padding: 0 10px;
          }
        }

        .labItems {
          flex: 1;
          display: flex;
          flex-wrap: wrap;
          border-radius: 3px;
          min-height: 39px;
          border: solid 1px #d8dde3;
          background: #fff;
          padding: 0 5px;

          span {
            display: inline-block;
            color: #ffc200;
            margin: 5px;
            line-height: 26px;
            padding: 0 10px;
            background: #fffbf0;
            border: 1px solid #fbe396;
            border-radius: 4px;
            font-size: 12px;

            i {
              cursor: pointer;
              font-style: normal;
            }
          }

          .inputBox {
            display: inline-block;
            width: 100%;
            height: 36px;
            line-height: 36px;
            overflow: hidden;
          }
        }

        .delFlavor {
          display: inline-block;
          padding: 0 10px;
          color: #f19c59;
          cursor: pointer;
        }
      }
    }
  }
}
</style>
