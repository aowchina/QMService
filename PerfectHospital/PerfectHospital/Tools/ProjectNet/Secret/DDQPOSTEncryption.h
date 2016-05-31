//
//  DDQPOSTEncryption.h
//  Tool
//
//  Created by Min-Fo_003 on 15/11/17.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^EncryptionSuccess)(id responseObjc);
typedef void(^EncryptionFailure)(NSError *error);

@interface DDQPOSTEncryption : NSObject

@property (copy,nonatomic) EncryptionSuccess encryptionSuccess;
@property (copy,nonatomic) EncryptionFailure encryptionFailure;

+(instancetype)instanceObjc;

+(NSString *)stringWithDic:(NSDictionary *)dic;
+(NSString *)stringWithPost:(NSString *)postStr projectId:(NSString *)projectId;

+(id)encrption_jsonDic:(id)objc;

@end
