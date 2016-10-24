//
//  EnumType.h
//  SCSDTGO
//
//  Created by  YangShengchao on 14-3-6.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

typedef NS_ENUM(NSUInteger, BackType) {
    BackTypePop = 0,        //显示返回上一级箭头
    BackTypeSliding         //显示侧边栏按钮
};

typedef NS_ENUM(NSUInteger, CommentUserType) {
    CommentUserTypeMyself = 0,
    CommentUserTypeAdmin
};

// 订单状态   //-1未提交  0待付款 1已取消 2待发货 3已发货 4已完成 5退款中 6已退款
typedef NS_ENUM(NSInteger, GAOrderStatusType) {
        GAOrderStatusTypeAll = -2,    //全部订单
    GAOrderStatusTypeUnSubmit = -1,   //未提交
    GAOrderStatusTypeToPay = 0,       //待付款
    GAOrderStatusTypeCancle = 1,      //已取消
    GAOrderStatusTypePaid = 2,        //待发货
    GAOrderStatusTypeSent = 3,        //已发货
    GAOrderStatusTypeDone = 4,        //已完成
    GAOrderStatusTypeRefunding = 5,   //退款中
    GAOrderStatusTypeRefunded = 6,    //已退款
    GAOrderStatusTypeReviewed = 7,    //已评价
};

//订单操作类型
typedef NS_ENUM(NSInteger, GAOrderActionType) {
    
    GAOrderActionTypeReview = 1,
    GAOrderActionTypeCancle = 2,
    GAOrderActionTypePay = 3
};

// Banner操作  1-打开网页，2-打开小区公告，3-打开商品分类
typedef NS_ENUM(NSUInteger, GABannerType) {
    GABannerTypeNormal = 0,      
    GABannerTypeLink = 1,
    GABannerTypeAreaNoti = 2,
    GABannerTypeProductCategory = 3,
};


// 支付方式  1-支付宝，2-余额支付，3-货到付款
typedef NS_ENUM(NSUInteger, GAPayWay) {
    GAPayWayAlipay = 1,
    GAPayWayBalance = 2,
    GAPayWayCOD = 3,
};

// 配送方式 1-物业配送
typedef NS_ENUM(NSUInteger, GADeliveryType) {
    GADeliveryProperty = 1,  //
};

typedef NS_ENUM(NSInteger, AFFindPswType) {
    
    AFFindPswTypeAccount = 0, //找回登录密码
    AFFindPswTypePay    = 1, //找回支付密码
};
