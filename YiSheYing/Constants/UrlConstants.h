//
//  UrlConstants.h
//  SCSDEnterprise
//
//  Created by  YangShengchao on 14-2-13.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//  FORMATED!
//

#ifndef SCSDEnterprise_UrlConstants_h
#define SCSDEnterprise_UrlConstants_h


#define TGO_DEBUG_MODEL 0     //0-正式发布 1-测试环境
#define TGO_DEBUG_LOG   1     //0-关闭调试日志 1-打开调试日志


/**
 *  定义项目的配置文件路径
 */
#define ConfigPlistPath             [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]
#define ConfigValue(x)              [[StorageManager sharedInstance] valueInAppConfig:x]                //获取项目动态的配置信息


/**
 *  定义各种正式和测试的接口地址
 */
#pragma mark - define urls

//#define kResPathBaseUrl            @"http://123.59.143.144:50000/yuncard/Htdoc/index.php"
//#define kResPathBaseUrl2           @"http://123.59.143.144:50000/yuncard/Htdoc/index.php"
#define kResPathBaseUrl              @"http://123.59.143.144:50000/yuncard/Htdoc/index.php"
#define kResPathBaseUrl2             @"http://123.59.143.144:50000/yuncard/Htdoc/index.php"
#define kAppChannel               @"内测版"


/**
 *  第三方登录、分享平台key定义
 */
#pragma mark - 第三方平台key控制

#define TgoAppKeyOfShareSDK         @"14f56e096690"
#define RedirectUrlTencentWeibo     ConfigValue(@"AppRedirectUrlTencentWeibo")
#define RedirectUrlSinaWeibo        ConfigValue(@"AppRedirectUrlSinaWeibo")

//qq互联
#define AppKeyQQ                ConfigValue(@"AppKeyQQ")
#define AppSecretQQ             ConfigValue(@"AppSecretQQ")

//腾讯微博
#define AppKeyTencentWeibo      ConfigValue(@"AppKeyTencentWeibo")
#define AppSecretTencentWeibo   ConfigValue(@"AppSecretTencentWeibo")

//新浪微博(Johnny_ZW天购APP)
#define AppKeySinaWeibo         ConfigValue(@"AppKeySinaWeibo")
#define AppSecretSinaWeibo      ConfigValue(@"AppSecretSinaWeibo")

//微信
#define AppKeyWeiXin            ConfigValue(@"AppKeyWeiXin")



/**
 *  接口地址
 */
#pragma mark - 接口访问地址

//Account
#define kResPathLogin                       @"api/Account/Login"               //登录
#define kResPathExternalLogin               @"api/Account/ExternalLogin"       //第三方平台登录
#define kResPathUserRegister                @"api/Account/UserRegister"        //用户注册

//Product
#define kResPathGetRecommendProducts        @"api/Product/GetRecommendProducts" //获取首页推荐商品列表
#define kResPathGetSeriesProducts           @"api/Product/GetSeriesProducts"    //
#define kResPathProductInfo                 @"api/Product/ProductInfo"          //获取商品基本信息

#define kResPathGetProductComments          @"api/Product/GetProductComments"    //获取商品评价
#define kResPathSubmitProductComment        @"api/Product/SubmitProductComment"  //发表评论
#define kResPathSubmitProductQuestion       @"api/Product/SubmitProductQuestion" //发表咨询
#define kResPathJudgeUserToComment          @"api/Product/JudgeUserToComment"    //判断用户是否可以评论
#define kResPathGetProductNews              @"api/Product/GetProductNews"        //获取商品咨询
#define kResPathGetProductDealRecord        @"api/Product/GetProductDealRecord"  //获取商品成交记录
#define kResPathGetRelateProducts           @"api/Product/GetRelateProducts"     //获取相关商品
#define kResPathGetBanners                  @"api/Product/GetBanners"
#define kResPathGetCategoryListByParentId   @"api/Product/GetCategoryListByParentId"
#define kResPathGetProductListByCategoryAndSortType     @"api/Product/GetProductListByCategoryAndSortType"
#define kResPathGetPriceByAttributes        @"api/Product/GetPriceByAttributes"  //根据规格返回价格
#define kResPathHotGoodsRank                @"api/Product/HotGoodsRank"
#define kResPathHotSearchKey                @"api/Product/HotSearchKey"
#define kResPathGetSearchProducts           @"api/Product/GetSearchProducts"
#define kResPathGetHotGoodsRank             @"api/Product/HotGoodsRank"         //获取热销排行
#define kResPathGetHotSearchKey             @"api/Product/HotSearchKey"         //获取热门搜索

//ShoppingCart
#define kResPathGetProductsInShoppingCart   @"api/ShoppingCart/GetProductsInShoppingCart"
#define kResPathAddProductToShoppingCart    @"api/ShoppingCart/AddProductToShoppingCart"///加入购物车
#define kResPathDeleteProductInShoppingCart @"api/ShoppingCart/DeleteProductInShoppingCart"
#define kResPathUpdateShoppingCartProductQuantity  @"api/ShoppingCart/UpdateShoppingCartProductQuantity"


//Addresses
#define kResPathGetAddresses                @"api/Addresses/GetAddresses"     //获取收货地址列表
#define kResPathDeleteAddress               @"api/Addresses/DeleteAddress"    //删除收货地址
#define kResPathAddNewAddress               @"api/Addresses/AddNewAddress"    //新增收货地址
#define kResPathUpdateAddress               @"api/Addresses/UpdateAddress"    //修改收货地址


//News
#define kResPathGetCenterNews               @"api/News/GetCenterNews"         //新闻中心
#define kResPathGetNews                     @"api/News/GetNews"               //获取分类新闻列表
#define kResPathGetNewsDetail               @"api/News/GetNewDetail"          //获取新闻详细信息


//Member
#define kResPathGetUserInfo                 @"api/Member/GetUserInfo"          //获取用户信息
#define kResPathModifyUser                  @"api/Member/ModifyUser"           //修改个人资料
#define kResPathChangePassword              @"api/Member/ChangePassword"       //修改密码
#define kResPathGetProtectQuestions         @"api/Member/GetProtectQuestions"  //获取密保问题列表
#define kResPathUserExists                  @"api/Member/UserExists"           //检测用户名是否存在
#define kResPathResetPassword               @"api/Member/ResetPassword"        //重置密码(用于找回密码)
#define kResPathDeleteCollection            @"api/Member/DeleteCollecion"     //删除我的收藏
#define kResPathGetMyCollections            @"api/Member/GetMyCollections"     //获取我的收藏列表
#define kResPathCollectProduct              @"api/Member/CollectProduct"       //添加商品到我的收藏列表
#define kResPathGetMyOrderNumber            @"api/Order/GetMyOrderNumber"       //获取订单个数



//ComplainAndAdvice
#define kResPathComplainAndAdvice           @"api/AndAdvice/ComplainAndAdvice"  //提交意见反馈


//HelpCenter
#define kResPathGetHelpCatalogs             @"api/HelpCenter/GetHelpCatalogs"   //获取帮助中心列表
#define kResPathGetHelpDetail               @"api/HelpCenter/GetHelpDetail"     //获取帮助中心详情


//Order
#define kResPathGetMyOrderNumber            @"api/Order/GetMyOrderNumber"
#define kResPathGetMyOrders                 @"api/Order/GetMyOrders"            //获取订单列表
#define kResPathSubmitOrder                 @"api/Order/SubmitOrder"
#define kResPathConfirmOrder                @"api/Order/ConfirmOrder"           //确认收货
#define kResPathCloseOrder                  @"api/Order/CloseOrder"
#define kResPathGetExpressDelivery          @"api/Order/GetExpressDelivery"
#define kResPathGetPaymentList              @"api/Order/GetPaymentList"
#define kResPathGetOrderInfo                @"api/Order/GetOrderInfo"
#define kResPathDeleteMyOrder               @"api/Order/DeleteMyOrder"          //关闭订单



#define kResPathGetArticles                 @"api/Info/GetArticles"
#define kResPathCheckNewVersion             @"api/Setting/CheckNewVersion"


/**
 *  定义网络POST提交、GET提交、页面间传递的参数
 */
#pragma mark - Param Name of POST & GET

#define kParamEmail                         @"Email"
#define kParamTelPhone                      @"TelPhone"
#define kParamCellPhone                     @"CellPhone"                    //手机号
#define kParamOpenId                        @"OpenId"                       //第三方用户的唯一标识
#define kParamUserId                        @"UserId"                       //平台内部用户唯一编号
#define kParamUserName                      @"UserName"                     //用户名
#define kParamUserFrom                      @"UserFrom"                     //第三方用户来源
#define kParamGender                        @"Gender"                       //性别
#define kParamAddress                       @"Address"                      //用户地址
#define kParamProvider                      @"Provider"                     //第三方登录类型
#define kParamPassword                      @"Password"                     //密码
#define kParamQuestion                      @"Question"
#define kParamQuestionId                    @"QuestionId"
#define kParamAnswer                        @"Answer"
#define kParamCaptcha                       @"Captcha"                      //验证码
#define kParamConfirmPassword               @"ConfirmPassword"              //重复密码
#define kParamValue                         @"Value"
#define kParamName                          @"Name"                         //第三方用户名或昵称等表示称谓的信息
#define kParamRealName                      @"RealName"                     //真实姓名
#define kParamBirthday                      @"Birthday"                     //生日的时间戳
#define kParamProvince                      @"Province"                     //省份编号
#define kParamCity                          @"City"                         //城市编号
#define kParamCounty                        @"County"                       //县城编号
#define kParamQQ                            @"QQ"
#define kParamMSN                           @"MSN"
#define kParamNewPassword                   @"NewPassword"                  //新密码
#define kParamOldPassword                   @"OldPassword"                  //旧密码
#define kParamOrderStatus                   @"OrderStatus"                  //订单状态
#define kParamPageSize                      @"PageSize"
#define kParamLastId                        @"LastId"
#define kParamCollectionId                  @"CollectionId"                 //我的收藏id
#define kParamCollectionIds                 @"CollectionIds"                //要删除的收藏ids
#define kParamAttributeId                   @"AttributeId"
#define kParamValueId                       @"ValueId"
#define kParamProductId                     @"ProductId"                    //商品的ID
#define kParamOptions                       @"Options"
#define kParamHelpId                        @"HelpId"
#define kParamTitle                         @"Title"
#define kParamOrderStatusType               @"OrderStatusType"
#define kParamBannerType                    @"BannerType"
#define kParamCount                         @"Count"
#define kParamSeriesIds                     @"SeriesIds"
#define kParamSeriesId                      @"SeriesId"
#define kParamBrowsingHistory               @"BrowsingHistoryDictionary"
#define kParamSearchKey                     @"SearchKey"
#define kParamIsSearchBarVisible            @"IsSearchBarVisible"
#define kParamCategoryId                    @"CategoryId"
#define kParamPageIndex                     @"PageIndex"
#define kParamSortType                      @"SortType"
#define kParamIsAscending                   @"IsAscending"
#define kParamUpdateNumber                  @"UpdateNumber"
#define kParamUpdateType                    @"UpdateType"
#define kParamOrderModel                    @"OrderModel"
#define kParamOrderProducts                 @"OrderProducts"
#define kParamSkuId                         @"SkuId"
#define kParamSkuIds                        @"SkuIds"
#define kParamQuantity                      @"Quantity"
#define kParamPublishContent                @"PublishContent"
#define kParamRemark                        @"Remark"
#define kParamShippingRegion                @"ShippingRegion"
#define kParamZipCode                       @"ZipCode"
#define kParamShipTo                        @"ShipTo"
#define kParamShippingModeId                @"ShippingModeId"
#define kParamRegionId                      @"RegionId"
#define kParamPaymentTypeId                 @"PaymentTypeId"
#define kParamBuyCount                      @"BuyCount"
#define kParamIsShoppingCart                @"IsShoppingCart"
#define kParamOrderLookupItem               @"OrderLookupItem"
#define kParamLookupId                      @"LookupId"
#define kParamInputValue                    @"InputValue"
#define kParamIsShoppingCart                @"IsShoppingCart"
#define kParamPaymentStatus                 @"PaymentStatus"
#define kParamPaymentError                  @"PaymentError"
#define kParamOrderId                       @"OrderId"
#define kParamProductName                   @"ProductName"
#define kParamProductDescription            @"ProductDescription"
#define kParamTotalPrice                    @"TotalPrice"






/**
 *  支付宝（商家服务）常量对应
 */
#ifndef MQPDemo_PartnerConfig_h
    #define MQPDemo_PartnerConfig_h

    #define AlipayNotifyURL         @"AlipayNotifyURL"
    #define AlipayReturnURL         @"AlipayReturnURL"
    #define AlipayPartnerID         @"AlipayPartnerID"
    #define AlipaySellerID          @"AlipaySellerID"



    //安全校验码（MD5）密钥，以数字和字母组成的32位字符
//    #define AlipayMD5KEY            ConfigValue(@"AlipayMD5KEY")

    //商户私钥，自助生成
    #define AlipayPartnerPrivKey    @"AlipayPartnerPrivKey"


    //支付宝公钥
    #define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbMJM0dSylF/6v29Us83CG7nemkbdzUwKIPH6Lz1n7kks0u1RgpDRakyLgzN8v1OSFbD05RE/FHI6ooTMuNDhPHEKr+p7l/fty6K0ed1C2nlm6mbb3QifRv6+iIFYuwREFr+3lvro01zbRrz4uDYhZfbAqvGydiPZt6unig4NKMwIDAQAB"
#endif





#endif
