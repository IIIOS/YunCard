//
//  AFNManager.h
//  TGOMarket
//
//  Created by  YangShengchao on 14-5-4.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import <JSONModel/JSONModel.h>


/*
 $token = “07A4A8DAC4D7C27AFF893F2208B0D60B”;      //随意值
 $t = time(); 									//时间戳，精确到秒
 $nonce = substr(md5($t),10,6);					 	//time md5的10-15位
 $tmpArr = array($token, $timestamp, $nonce);			//token，t，t的md5数组
 $tmpStr = md5(implode( $tmpArr ));					//implede是什么？？
 $sign = sha1( $tmpStr );							//sha1
 */

#pragma mark - block定义

typedef void (^RequestSuccessed)(id responseObject);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *errorMessage);

typedef NS_ENUM (NSInteger, RequestType) {
	RequestTypeGET = 0,
	RequestTypePOST,
    RequestTypeUploadFile,
    RequestTypePostBodyData,
    RequestTypePostFormData   //表单提交
};


@interface AFNManager : NSObject
+ (NSString *)baseUrl;

+ (void)getObject:(NSDictionary*)paramDict
          apiName:(NSString *)apiName
        modelName:(NSString *)modelName
 requestSuccessed:(RequestSuccessed)requestSuccessed
   requestFailure:(RequestFailure)requestFailure;

+ (void)postObject:(id)object
           apiName:(NSString *)apiName
         modelName:(NSString *)modelName
  requestSuccessed:(RequestSuccessed)requestSuccessed
    requestFailure:(RequestFailure)requestFailure;

#pragma mark - 最常用的GET和POST

+ (void)getDataWithAPI:(NSString *)apiName
         andArrayParam:(NSArray *)arrayParam
          andDictParam:(NSDictionary *)dictParam
             dataModel:(NSString *)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure;
+ (void)postDataWithAPI:(NSString *)apiName
          andArrayParam:(NSArray *)arrayParam
           andDictParam:(NSDictionary *)dictParam
              dataModel:(NSString *)modelName
       requestSuccessed:(RequestSuccessed)requestSuccessed
         requestFailure:(RequestFailure)requestFailure;
+ (void)postBodyDataWithAPI:(NSString *)apiName
              andArrayParam:(NSArray *)arrayParam
               andDictParam:(NSDictionary *)dictParam
               andBodyParam:(NSString *)bodyParam
                  dataModel:(NSString *)modelName
           requestSuccessed:(RequestSuccessed)requestSuccessed
             requestFailure:(RequestFailure)requestFailure;

#pragma mark - 自定义url前缀的GET和POST

+ (void)getDataFromUrl:(NSString *)url
               withAPI:(NSString *)apiName
         andArrayParam:(NSArray *)arrayParam
          andDictParam:(NSDictionary *)dictParam
             dataModel:(NSString *)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure;
+ (void)postDataToUrl:(NSString *)url
              withAPI:(NSString *)apiName
        andArrayParam:(NSArray *)arrayParam
         andDictParam:(NSDictionary *)dictParam
            dataModel:(NSString *)modelName
     requestSuccessed:(RequestSuccessed)requestSuccessed
       requestFailure:(RequestFailure)requestFailure;
+ (void)postBodyDataToUrl:(NSString *)url
                  withAPI:(NSString *)apiName
            andArrayParam:(NSArray *)arrayParam
             andDictParam:(NSDictionary *)dictParam
             andBodyParam:(NSString *)bodyParam
                dataModel:(NSString *)modelName
         requestSuccessed:(RequestSuccessed)requestSuccessed
           requestFailure:(RequestFailure)requestFailure;

#pragma mark - 上传文件

+ (void)uploadImage:(UIImage *)image
              toUrl:(NSString *)url
            withApi:(NSString *)apiName
      andArrayParam:(NSArray *)arrayParam
       andDictParam:(NSDictionary *)dictParam
          dataModel:(NSString *)modelName
       imageQuality:(ImageQuality)quality
   requestSuccessed:(RequestSuccessed)requestSuccessed
     requestFailure:(RequestFailure)requestFailure;

#pragma mark - 通用的GET和POST（只返回BaseModel的Data内容）

+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           dataModel:(NSString *)modelName
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;

#pragma mark - 通用的GET、POST和上传图片（返回BaseModel的所有内容）

+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure;
@property (nonatomic,strong)NSMutableDictionary *laladic;
@end
