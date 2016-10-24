//
//  BaseModel.h
//  SCSDTGO
//
//  Created by  YangHangbin on 14-3-3.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import <JSONModel/JSONModel.h>


typedef NS_ENUM(NSInteger, AFRequestCode){
    
    AFRequestCodeSuccess = 0,
    AFRequestCodeXXX = 1002,
    AFRequestCodeSignFaild = 1098,
    AFRequestCodeTradeFaild = 1099,
    AFRequestCodeTokenInvalid = 1666,
    AFRequestCodeServerError = 9999
};

@class AFPageInfoModel;
@interface BaseModel : JSONModel
@property (strong, nonatomic) NSString        *message;
@property (assign, nonatomic) AFRequestCode   code;
@property (strong, nonatomic) AFPageInfoModel *pageInfo;
@property (strong, nonatomic) NSObject<ConvertOnDemand> *data;
@end

@interface AFPageInfoModel : JSONModel
@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSInteger hasMore;
@end