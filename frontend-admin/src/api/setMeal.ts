import request from '@/utils/request'
/**
 *
 * 套餐管理
 *
 **/

// 套餐分页查询
export const getSetmealPage = (params: any) => {
  return request({
    url: '/setmeal/page',
    method: 'get',
    params: params
  })
}

// 删除套餐接口
export const deleteSetmeal = (ids: string) => {
  return request({
    url: '/setmeal',
    method: 'delete',
    params: { ids:ids }
  })
}

// 修改数据接口
export const editSetmeal = (params: any) => {
  return request({
    url: '/setmeal',
    method: 'put',
    data: { ...params }
  })
}

// 新增数据接口
export const addSetmeal = (params: any) => {
  return request({
    url: '/setmeal',
    method: 'post',
    data: { ...params }
  })
}

// 查询详情接口
export const querySetmealById = (id: string | (string | null)[]) => {
  return request({
    url: `/setmeal/${id}`,
    method: 'get'
  })
}

// 批量起售禁售
export const setmealStatusByStatus = (params: any) => {
  return request({
    url: `/setmeal/status/${params.status}`,
    method: 'post',
    params: { id: params.ids }
  })
}

// 套餐起售禁售
export const enableOrDisableSetmeal = (params: any) => {
  return request({
    url: `/setmeal/status/${params.status}`,
    method: 'post',
    params: { id: params.id }
  })
}

//菜品分类数据查询
export const dishCategoryList = (params: any) => {
  return request({
    url: `/category/list`,
    method: 'get',
    params: { ...params }
  })
}
