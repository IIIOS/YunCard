//
//  AFNManager.m
//  TGOMarket
//
//  Created by  YangShengchao on 14-5-4.
//  Copyright (c) 2014年 SCSD_TGO_TEAM. All rights reserved.
//

#import "AFNManager.h"
#import "AFNetworking.h"
#import "ImageUtils.h"
#import <UIImage+Resize.h>
#import "StringUtils.h"
#import "JSON.h"
#import "SecurityUtil.h"
#import "GTMBase64.h"

#define KEY @"JYZ@(##&~&##)@CY" //key可修改
@implementation AFNManager

#pragma mark - GET
+ (NSString *)baseUrl{
    return [StringUtils resBaseUrl];
}

+ (NSString *)getSignWithTime:(NSString *)time{
    
    /*
     ============== 接口鉴定 ===============
     $tmpArr = array("07A4A8DAC4D7C27AFF893F2208B0D60B", "1439777692", "1111000");
     
     implode之后= 07A4A8DAC4D7C27AFF893F2208B0D60B14397776921111000
     md5之后=2ca1d5a9a1b7df8bae8df8d0f4713ccb
     sha1之后=3226b90488c449d9e239adc6fa490227c295a804
     
     
     对应POST的参数
     t = 1439777692（unix时间戳，精确到秒）
     n = 1111000（这个值可以自己随便定，只要传人的参数中有这个就行）
     sign = 3226b90488c449d9e239adc6fa490227c295a804
     
     ===========测试账号==========
     "studentNo"："000020700003","password"："111111"
     */
    NSString *sign = nil;
    
    NSString *token = @"07A4A8DAC4D7C27AFF893F2208B0D60B";
    NSString *t = time;
    NSString *nonce = [[StringUtils md5FromString:t] substringWithRange:NSMakeRange(10, 6)];
    NSString *implode = [NSString stringWithFormat:@"%@%@%@",token,t,nonce];
    NSString *md5key = [StringUtils md5FromString:implode];
    sign = [StringUtils sha1FromString:md5key];
    
    return sign;
}

//+ (void)setRequestDefaultHeader:(NSMutableURLRequest *)request{
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"1" forHTTPHeaderField:@"type"];
//    [request setValue:kDefaultAppType forHTTPHeaderField:@"User-Agent"];
//    [request setValue:kAppSignature forHTTPHeaderField:@"signature"];
//    if (BundleVersion) [request setValue:BundleVersion forHTTPHeaderField:@"version"];
//    
//    NSLog(@"URL = %@", request.URL);
//    NSLog(@"Headers = %@", [request allHTTPHeaderFields]);
//}

+ (void)getObject:(NSDictionary*)paramDict
          apiName:(NSString *)apiName
        modelName:(NSString *)modelName
 requestSuccessed:(RequestSuccessed)requestSuccessed
   requestFailure:(RequestFailure)requestFailure {
    
    NSString *urlStr = apiName?[NSString stringWithFormat:@"%@%@",[self baseUrl],apiName]:[self baseUrl];
    
    if (TGO_DEBUG_LOG) NSLog(@"urlStr = %@", urlStr);
    NSArray *allKeys = [paramDict allKeys];
    for (NSString *key in allKeys) {
        id param = paramDict[key];
        if (param) {
            NSInteger index = [allKeys indexOfObject:key];
            if (index==0) {
                urlStr = [NSString stringWithFormat:@"%@?%@=%@",urlStr,key,param];
            }else{
                urlStr = [NSString stringWithFormat:@"%@&%@=%@",urlStr,key,param];
            }
        }
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"GET"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    [AFNManager setRequestDefaultHeader:request];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        [self handleResponseData:data modelName:modelName requestSuccessed:requestSuccessed requestFailure:requestFailure];
    }];
}

#pragma mark - POST
+ (void)postObject:(NSDictionary*)paramDict
           apiName:(NSString *)apiName
         modelName:(NSString *)modelName
  requestSuccessed:(RequestSuccessed)requestSuccessed
    requestFailure:(RequestFailure)requestFailure {
    NSString *urlStr;
    if (apiName) {
        urlStr = apiName;
    }else{
        urlStr = [self baseUrl];
    }
    NSString *userToken = [YCUserModel currentUser].token;
    NSString *t = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    NSString *token;
    if (userToken.length !=0) {
        token = userToken;
    }
    NSString *n = [[StringUtils md5FromString:t] substringWithRange:NSMakeRange(10, 6)];
    NSString *implode = [NSString stringWithFormat:@"%@%@%@",token,t,n];
    NSString *md5key = [StringUtils md5FromString:implode];
    NSString *sign = [StringUtils sha1FromString:md5key];
   
    NSMutableDictionary *dict = [paramDict mutableCopy];
    if (nil==dict) {
        dict = [@{} mutableCopy];
    }
    [dict setObject:@"ios" forKey:@"system"];
    if (t) [dict setObject:t forKey:@"t"];
    if (n) [dict setObject:n forKey:@"n"];
    if (sign) [dict setObject:sign forKey:@"sign"];
    if(![dict[@"action"] isEqualToString:@"getVersionInfo"] || ![dict[@"action"] isEqualToString:@"login"] ) {
        if (token) [dict setObject:token forKey:@"token"];
    }
    [dict setObject:@"13816" forKey:@"schoolCode"];
    if (TGO_DEBUG_LOG) NSLog(@"***********IOS***********%@",[dict JSONFragment]);
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:NULL];
    NSString *tmpstr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    int y = (arc4random() % 10000000) + 10000000;
    NSString *nStr = [NSString stringWithFormat:@"%@%d",tmpstr,y];
    nStr = [nStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    nStr = [nStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    nStr = [nStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *nData = [(NSString*)[SecurityUtil encryptAESData:nStr app_key:KEY] dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"lanweijie__%@",dict[@"action"]);
    NSString *postLength = [NSString stringWithFormat:@"%ld", (long)[nData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:nData];
    [request setTimeoutInterval:5];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [self handleResponseData:data modelName:modelName requestSuccessed:requestSuccessed requestFailure:requestFailure];
    }];
}

+ (void)handleResponseData:(NSData *)data
                 modelName:(NSString *)modelName
          requestSuccessed:(RequestSuccessed)requestSuccessed
            requestFailure:(RequestFailure)requestFailure{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (data) {
            NSData* dataStr = [[SecurityUtil decryptAESData:data app_key:KEY]dataUsingEncoding:NSUTF8StringEncoding];
            NSString *stringData=[[NSString alloc]initWithData:dataStr encoding:NSUTF8StringEncoding];
            NSLog(@"%@ thats data",stringData);
            CGFloat length = stringData.length;
            for (int i = length; i > 0; i --) {
                NSString *str = [stringData substringWithRange:NSMakeRange(i-1, 1)];
                if ([str isEqualToString:@"}"]) {
                    break;
                }
                stringData = [stringData substringWithRange:NSMakeRange(0, i - 1)];
            }
            NSData *tmpData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
            id dataDic = [NSJSONSerialization JSONObjectWithData:tmpData options:NSJSONReadingMutableContainers error:nil];
            
            if (TGO_DEBUG_LOG) NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (TGO_DEBUG_LOG) NSLog(@"dataDic = %@", dataDic);
            
            JSONModelError *initError;
            BaseModel *baseModel = nil;
            if ([dataDic isKindOfClass:[NSDictionary class]]) {
                baseModel = [[BaseModel alloc] initWithDictionary:dataDic error:&initError];
            }
            else if ([dataDic isKindOfClass:[NSString class]]) {
                baseModel = [[BaseModel alloc] initWithString:dataDic error:&initError];
            }
            if (TGO_DEBUG_LOG) NSLog(@"message = %@", baseModel);
            if (baseModel && (baseModel.code==AFRequestCodeSuccess)) {  //接口访问成功
                NSObject *dataModel = baseModel.data;
                JSONModelError *initError = nil;
                if ([dataModel isKindOfClass:[NSArray class]]) {
                    if ( [modelName length] > 0 && [NSClassFromString(modelName) isSubclassOfClass:[CommonBaseModel class]]) {
                        dataModel = [NSClassFromString(modelName) arrayOfModelsFromDictionaries:(NSArray *)dataModel error:&initError];
                    }
                }
                else if ([dataModel isKindOfClass:[NSDictionary class]]) {
                    if ( [modelName length] > 0 && [NSClassFromString(modelName) isSubclassOfClass:[CommonBaseModel class]]) {
                        dataModel = [[NSClassFromString(modelName) alloc] initWithDictionary:(NSDictionary *)dataModel error:&initError];
                    }
                }
                
                //针对转换映射后的处理
                if (initError) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        requestFailure(1101, initError.localizedDescription);
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        requestSuccessed(dataModel);
                    });
                }
            }
            else if (baseModel.code==AFRequestCodeTokenInvalid){
                //token失效 需要登录
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AFLoginController forceLoginAndShowMessage:YES];
                    requestFailure(AFRequestCodeTokenInvalid, baseModel.message.length?baseModel.message:nil);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    requestFailure(1103, baseModel.message.length?baseModel.message:@"未知接口错误");
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                requestFailure(1004, @"无法连接服务器,请确保网络通畅!");
            });
        }
    });
}

#pragma mark - 最常用的GET和POST

+ (void)getDataWithAPI:(NSString *)apiName
         andArrayParam:(NSArray *)arrayParam
          andDictParam:(NSDictionary *)dictParam
             dataModel:(NSString *)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure {
	NSString *url = [self baseUrl];
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:nil dataModel:modelName requestType:RequestTypeGET requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

+ (void)postDataWithAPI:(NSString *)apiName
          andArrayParam:(NSArray *)arrayParam
           andDictParam:(NSDictionary *)dictParam
              dataModel:(NSString *)modelName
       requestSuccessed:(RequestSuccessed)requestSuccessed
         requestFailure:(RequestFailure)requestFailure {
	NSString *url = [self baseUrl];
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:nil dataModel:modelName requestType:RequestTypePOST requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

+ (void)postBodyDataWithAPI:(NSString *)apiName
              andArrayParam:(NSArray *)arrayParam
               andDictParam:(NSDictionary *)dictParam
               andBodyParam:(NSString *)bodyParam
                  dataModel:(NSString *)modelName
           requestSuccessed:(RequestSuccessed)requestSuccessed
             requestFailure:(RequestFailure)requestFailure {
	NSString *url = [self baseUrl];
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:bodyParam dataModel:modelName requestType:RequestTypePostBodyData requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

#pragma mark - 自定义url前缀的GET和POST

+ (void)getDataFromUrl:(NSString *)url
               withAPI:(NSString *)apiName
         andArrayParam:(NSArray *)arrayParam
          andDictParam:(NSDictionary *)dictParam
             dataModel:(NSString *)modelName
      requestSuccessed:(RequestSuccessed)requestSuccessed
        requestFailure:(RequestFailure)requestFailure {
	[self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:nil dataModel:modelName requestType:RequestTypeGET requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

+ (void)postDataToUrl:(NSString *)url
              withAPI:(NSString *)apiName
        andArrayParam:(NSArray *)arrayParam
         andDictParam:(NSDictionary *)dictParam
            dataModel:(NSString *)modelName
     requestSuccessed:(RequestSuccessed)requestSuccessed
       requestFailure:(RequestFailure)requestFailure {
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:nil dataModel:modelName requestType:RequestTypePOST requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

+ (void)postBodyDataToUrl:(NSString *)url
                  withAPI:(NSString *)apiName
            andArrayParam:(NSArray *)arrayParam
             andDictParam:(NSDictionary *)dictParam
             andBodyParam:(NSString *)bodyParam
                dataModel:(NSString *)modelName
         requestSuccessed:(RequestSuccessed)requestSuccessed
           requestFailure:(RequestFailure)requestFailure {
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:bodyParam dataModel:modelName requestType:RequestTypePostBodyData requestSuccessed:requestSuccessed requestFailure:requestFailure];
}

#pragma mark - 上传文件

+ (void)uploadImage:(UIImage *)image
              toUrl:(NSString *)url
            withApi:(NSString *)apiName
      andArrayParam:(NSArray *)arrayParam
       andDictParam:(NSDictionary *)dictParam
          dataModel:(NSString *)modelName
       imageQuality:(ImageQuality)quality
   requestSuccessed:(RequestSuccessed)requestSuccessed
     requestFailure:(RequestFailure)requestFailure {
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *picturePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld.jpg", timestamp]];
    UIImage *scaledImage1 = [ImageUtils adjustImage:image toQuality:quality];
    UIImage *scaledImage = [scaledImage1 resizedImage:CGSizeMake(76, 76) interpolationQuality:kCGInterpolationDefault];
    
    [self requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:nil imageData:UIImagePNGRepresentation(scaledImage)
           requestType:RequestTypeUploadFile
      requestSuccessed:^(id responseObject) {
          [[NSFileManager defaultManager] removeItemAtPath:picturePath error:NULL];
          BaseModel *baseModel = (BaseModel *)responseObject;
          if ([baseModel isKindOfClass:NSClassFromString(modelName)]) {
              if (baseModel && (baseModel.code==AFRequestCodeSuccess)) {  //接口访问成功
                  NSLog(@"success message = %@", baseModel);
                  requestSuccessed(baseModel);
              }
              else {
                  requestFailure(1101, baseModel.message);
              }
          }
          else {
              requestFailure(1102, @"本地数据映射错误！");
          }
          
      } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
          [[NSFileManager defaultManager] removeItemAtPath:picturePath error:NULL];
          requestFailure(1103, errorMessage);
      }];
}

#pragma mark - 通用的GET和POST（只返回BaseModel的Data内容）

/**
 *  发起get & post网络请求
 *
 *  @param url              接口前缀 最后的'/'可有可无
 *  @param apiName          方法名称 前面不能有'/'
 *  @param arrayParam       数组参数，用来组装url/param1/param2/param3，参数的顺序很重要
 *  @param dictParam        字典参数，key-value
 *  @param modelName        模型名称字符串
 *  @param requestType      RequestTypeGET 和 RequestTypePOST
 *  @param requestSuccessed 请求成功的回调
 *  @param requestFailure   请求失败的回调
 */
+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           dataModel:(NSString *)modelName
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure {
    [self   requestByUrl:url withAPI:apiName andArrayParam:arrayParam andDictParam:dictParam andBodyParam:bodyParam imageData:nil requestType:requestType
	    requestSuccessed: ^(id responseObject) {
            BaseModel *baseModel = (BaseModel *)responseObject;
            if (baseModel && (baseModel.code==AFRequestCodeSuccess)) {  //接口访问成功
                NSObject *dataModel = baseModel.data;
                JSONModelError *initError = nil;
                if ([dataModel isKindOfClass:[NSArray class]]) {
                    if ( [modelName length] > 0 && [NSClassFromString(modelName) isSubclassOfClass:[CommonBaseModel class]]) {
                        dataModel = [NSClassFromString(modelName) arrayOfModelsFromDictionaries:(NSArray *)dataModel error:&initError];
                    }
                }
                else if ([dataModel isKindOfClass:[NSDictionary class]]) {
                    if ( [modelName length] > 0 && [NSClassFromString(modelName) isSubclassOfClass:[CommonBaseModel class]]) {
                        dataModel = [[NSClassFromString(modelName) alloc] initWithDictionary:(NSDictionary *)dataModel error:&initError];
                    }
                }
                
                //针对转换映射后的处理
                if (initError) {
                    requestFailure(1101, initError.localizedDescription);
                }
                else {
                    requestSuccessed(dataModel);
                }
            }
            else {
                requestFailure(1103, baseModel.message);
            }
        } requestFailure:requestFailure];
}


#pragma mark - 表单数据
#define KSTRequestStringBoundary    @"0xKhTmLbOuNdArY"

+(NSData *)bodyFormDataForParameter:(NSDictionary *)parametersDic
{
    if(parametersDic == nil)return nil;
    
    NSMutableData *body = [NSMutableData data];
    //开始
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", KSTRequestStringBoundary];
    [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSArray *allKey = parametersDic.allKeys;
    for (int i=0; i<allKey.count; i++) {
        NSString *key = [parametersDic.allKeys objectAtIndex:i];
        id value = parametersDic[key];
        if([value isKindOfClass:[UIImage class]])
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n",key, key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            UIImage *image = (UIImage *)value;
            NSData *imageData = UIImagePNGRepresentation(image);
            [body appendData:(NSData*)imageData];
            
            NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",KSTRequestStringBoundary];
            [body appendData:[endItemBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, value] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[bodyPrefixString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    //结束
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", KSTRequestStringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
    
}


#pragma mark - 通用的GET和POST（返回BaseModel的所有内容）

/**
 *  发起get & post & 上传图片 请求
 *
 *  @param url              接口前缀 最后的'/'可有可无
 *  @param apiName          方法名称 前面不能有'/'
 *  @param arrayParam       数组参数，用来组装url/param1/param2/param3，参数的顺序很重要
 *  @param dictParam        字典参数，key-value
 *  @param imageData        图片资源
 *  @param requestType      RequestTypeGET 和 RequestTypePOST
 *  @param requestSuccessed 请求成功的回调
 *  @param requestFailure   请求失败的回调
 */
+ (void)requestByUrl:(NSString *)url
             withAPI:(NSString *)apiName
       andArrayParam:(NSArray *)arrayParam
        andDictParam:(NSDictionary *)dictParam
        andBodyParam:(NSString *)bodyParam
           imageData:(NSData *)imageData
         requestType:(RequestType)requestType
    requestSuccessed:(RequestSuccessed)requestSuccessed
      requestFailure:(RequestFailure)requestFailure {
	//1. url合法性判断
	if (![NSURL URLWithString:url]) {
		requestFailure(1005, [NSString stringWithFormat:@"传递的url[%@]不合法！", url]);
		return;
	}
    
	//2. apiName简单判断
	if ([apiName length] < 1) {
		requestFailure(1006, [NSString stringWithFormat:@"传递的apiName[%@]为空！", apiName]);
		return;
	}
    
	//3. 组装完整的url地址
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];   //create new AFHTTPRequestOperationManager
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:kDefaultAppType forHTTPHeaderField:@"User-Agent"];
//    [manager.requestSerializer setValue:[[Login sharedInstance] authorization] forHTTPHeaderField:@"Authorization"];
    //解决返回的Content-Type始终是application/xml问题！
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//    
//    
    //add by helfy
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //4. 设置请求的加密回调
    //    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
    //        NSMutableArray *mutablePairs = [NSMutableArray array];
    //        for (AFQueryStringPair *pair in AFQueryStringPairsFromDictionary(parameters)) {
    //            [mutablePairs addObject:[pair URLEncodedStringValueWithEncoding:stringEncoding]];
    //        }
    //
    //        return [mutablePairs componentsJoinedByString:@"&"];
    //    }];
    
	NSString *urlString = [url stringByAppendingFormat:@"%@%@",
	                       ([url hasSuffix:@"/"] ? @"" : @"/"),     //确保url前缀后面有1个字符'/'
	                       ([apiName hasPrefix:@"/"] ? [apiName substringFromIndex:1] : apiName)   //确保apiName前面没有字符'/'
                           ];                                                         //组装后的完整url地址
    
	//5. 组装数组参数
	NSMutableString *newUrlString = [NSMutableString stringWithString:urlString];
	for (NSObject *param in arrayParam) {
		[newUrlString appendString:@"/"];
		[newUrlString appendFormat:@"%@",param];
	}
    
	//6. 发起网络请求
    //   定义返回成功的block
    void (^requestSuccessed1)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get success! operation = %@\r\nresponseObject = %@", operation, responseObject);
        
        JSONModelError *initError;
        BaseModel *baseModel = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            baseModel = [[BaseModel alloc] initWithDictionary:responseObject error:&initError];
        }
        else if ([responseObject isKindOfClass:[NSString class]]) {
            baseModel = [[BaseModel alloc] initWithString:responseObject error:&initError];
        }
        
        if (baseModel) {
            requestSuccessed(baseModel);
        }
        else {
            if (initError) {
                requestFailure(1001, initError.localizedDescription);
            }
            else {
                requestFailure(1002, @"本地对象映射出错！");
            }
        }
    };
    //   定义返回失败的block
    void (^requestFailure1)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post failure! operation = %@\r\nerror = %@", operation, error);
        
        if (operation.response.statusCode != 200) {
            [LogManager saveLog:[NSString stringWithFormat:@"请求参数%@", dictParam]];
            [LogManager saveLog:error.localizedDescription];
            if (operation.response.statusCode == 401) {
                requestFailure(1003, @"您还未登录呢！");
//                [[Login sharedInstance] clearLoginData];
            }
            else {
                requestFailure(1004, @"网络错误！");
            }
        }
        else {
            requestFailure(operation.response.statusCode, error.localizedDescription);
        }
    };
    
	NSLog(@"requestType = %ld, dictParam = %@", (long)requestType, dictParam);
	if (requestType == RequestTypeGET) {
		NSLog(@"getting data...");
		[manager   GET:newUrlString
		    parameters:dictParam
		       success:requestSuccessed1
		       failure:requestFailure1];
	}
	else if (requestType == RequestTypePOST) {
		NSLog(@"posting data...");
		[manager  POST:newUrlString
		    parameters:dictParam
		       success:requestSuccessed1
		       failure:requestFailure1];
	}
	else if (requestType == RequestTypeUploadFile) {
		NSLog(@"uploading data...");
        
		[manager       POST:newUrlString
                 parameters:dictParam
  constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
      [formData appendPartWithFileData:imageData name:@"file" fileName:@"avatar.png" mimeType:@"application/octet-stream"];
  }
                    success:requestSuccessed1
                    failure:requestFailure1];
	}
    else if (requestType == RequestTypePostBodyData) {
        NSLog(@"posting bodydata...");
        NSMutableURLRequest *mutableRequest = [manager.requestSerializer requestWithMethod:@"POST" URLString:newUrlString parameters:nil error:nil];
        mutableRequest.HTTPBody = [bodyParam dataUsingEncoding:manager.requestSerializer.stringEncoding];
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:mutableRequest success:requestSuccessed1 failure:requestFailure1];
        [manager.operationQueue addOperation:operation];
    }
    else if (requestType == RequestTypePostFormData)
    {
       NSMutableURLRequest* requst = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [requst setHTTPMethod:@"POST"];
        NSData *body = [self bodyFormDataForParameter:dictParam];
        [requst setHTTPBody:body];
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",KSTRequestStringBoundary];
        //设置HTTPHeader
        [requst setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [requst setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:requst success:requestSuccessed1 failure:requestFailure1];
        [manager.operationQueue addOperation:operation];
    }
}




@end
