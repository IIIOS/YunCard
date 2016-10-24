//
//  DataModels.h
//  TGOMarket
//
//  Created by  YangShengchao on 14-4-29.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import "BaseModel.h"
#import "EnumType.h"

@class YCShowerSettingModel,YCVersionModel;

/**
 *  数组映射关系
 */
@protocol BannerModel               @end
@protocol YCTradeHisModel           @end
/**
 *  要使用的model在本类里
 */

/**
 *  公共model的基类，主要是设置所有参数都是optional的
 */
@interface CommonBaseModel : JSONModel
+ (NSString *)modelName;
- (NSTimeInterval)getRealTimeInteral:(NSTimeInterval)interval;
@end


@interface YCUserModel : CommonBaseModel
@property (nonatomic,strong) NSString *studentNo;
@property (nonatomic,strong) NSString *cardNo;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,assign) CGFloat  bright;
@property (nonatomic,strong) NSString  *fromBackground;

@property (nonatomic,strong) NSString *headImg;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *token;
@property (nonatomic,assign) NSInteger cardBalance; //卡余额，单位分
@property (nonatomic,assign) NSInteger monthlyAmt;  //当月消费，登录时间点至本月1日0点，用户消费流水合计，单位分。金额与用户刷卡机显示余额一致


@property (nonatomic,assign) NSInteger sex;         //int(0-男 1 女)
@property (nonatomic,strong) NSString *department;
@property (nonatomic,strong) NSString *school_zone;
@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *graduated;
@property (nonatomic,strong) NSString *home_address;
@property (nonatomic,strong) NSString *nation;
@property (nonatomic,strong) NSString *grade;
@property (nonatomic,strong) NSString *major;

@property (nonatomic,strong) NSString *wash_setting;
+ (instancetype)currentUser;
+ (void)saveLoginUser:(YCUserModel *)newUser;
+ (void)logout;
+ (BOOL)isLogin;

+ (void)saveLoginInfo:(NSString*)phone password:(NSString *)pwd forUser:(NSString *)uid;
+ (NSString *)passwordForUser:(NSString *)uid;
+ (NSString *)phoneForUser:(NSString *)uid;
@end

typedef NS_ENUM(NSInteger, YCDeviceStatus) {
    
    YCDeviceStatusOff = 0,//空闲
    YCDeviceStatusOpenByMe = 1,//自己开启
    YCDeviceStatusOpenByOther = 2,//是他人开启
    YCDeviceStatusClose = 3,//设备维护中
    YCDeviceStatusOpen = 4,//关闭种
    YCDeviceStatusRepair = 5
};

typedef NS_ENUM(NSInteger, YCDeviceType) {
    YCDeviceTypeWasher = 2,
    YCDeviceTypeShower = 1,
    YCDeviceTypeShared = 3
    
    /*"1"=>"淋浴房","2"=>"洗衣机","3"=>"公用设备"*/
};

@interface YCDeviceModel : CommonBaseModel
@property (nonatomic,strong) NSString *DEV_Position;
@property (nonatomic,strong) NSString *floor;
@property (nonatomic,strong) NSString *room;
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSString *DEV_No;
@property (nonatomic,strong) NSString *DVTP_ID;

@property (nonatomic,strong) NSString *deviceIcon;
@property (nonatomic,assign) NSInteger lt;      //已经使用的时长
@property (nonatomic,assign) YCDeviceStatus deviceStatus;
@property (nonatomic,assign) YCDeviceType deviceType;
@property (nonatomic,strong) NSDate *startUseDate;

@property (nonatomic,assign) BOOL isOpenByMe;
@property (nonatomic,readonly) NSString *deviceStatusString;
@end


@interface YCOrderModel : CommonBaseModel
@property (nonatomic,strong) NSString *order_no;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,assign) CGFloat amt;
@property (nonatomic,strong) NSString *school_code;
@property (nonatomic,strong) NSString *school_account;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sign;
@end

@interface YCTradeMonthModel : CommonBaseModel
@property (nonatomic, assign) CGFloat cardBalance;
@property (nonatomic,strong) NSArray<YCTradeHisModel> *list;
@end

@interface YCTradeHisModel : CommonBaseModel
/*
 "data": {
 "list" : [
 {
 "mercName"       : "食堂",
 "tranName"       : "荤菜",
 "tranAmt"        : "2",
 "tranDate"       : "20150103122130",
 "subSystemName" : "环境工程",
 "posNo"       : "5427"
 },{
 "mercName"       : "食堂",
 "tranName"       : "荤菜",
 "tranAmt"        : "1",
 "tranDate"       : "20150103122030",
 "subSystemName" : "环境工程",
 "posNo"       : "5427"
 }
 ],
 "cardBalance"    : 5427,
 "currentpage"     : 2,
 "totalpage"       : 1
 */
@property (nonatomic,strong) NSString *mercName; //商户名称
@property (nonatomic,strong) NSString *tranName; //交易名称
@property (nonatomic,assign) CGFloat tranAmt;       //交易金额
@property (nonatomic,strong) NSString *tranDate;    //交易时间
@property (nonatomic,strong) NSString *DepositNo;
@property (nonatomic,strong) NSString *posNo;   //pos号
@property (nonatomic,strong) NSString *subSystemName; //子系统名称，如：商务子系

- (NSString *)timeString;
@end


@interface YCShowerSettingModel : CommonBaseModel

@property (nonatomic,assign) CGFloat delay_close;      //最长使用时间,   默认10*60
@property (nonatomic,assign) CGFloat delay_time;       //延时开启时间，默认0

@end


@interface YCUseResultModel : CommonBaseModel
/*
 "fee_rate": "5元/分钟",
 "time": "00:00",
 "total_fee": "0元"
 */

@property (nonatomic,strong) NSString *fee_rate; //商户名称
@property (nonatomic,strong) NSString *time; //商户名称
@property (nonatomic,strong) NSString *total_fee; //商户名称

@end

@interface YCVersionCheckModel : CommonBaseModel
@property (nonatomic, strong) YCVersionModel *android;
@property (nonatomic, strong) YCVersionModel *ios;
@end

@interface YCVersionModel : CommonBaseModel
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *release_notes;
@property (nonatomic,strong) NSString *download_url;
@property (nonatomic,assign) BOOL isForcedUpdate;
@end



@interface YCLoudongModel : CommonBaseModel
@property (nonatomic,strong) NSString *loudong;
@property (nonatomic,strong) NSArray *room;
@end

@interface YCNotiModel : CommonBaseModel
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) NSTimeInterval time;
@end

