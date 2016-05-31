//
//  DDQProjectNetWork.h
//  artistadmin
//
//  Created by Min-Fo_003 on 16/1/19.
//  Copyright © 2016年 Min_Fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQProjectNetWork : NSObject

+(instancetype)instanceObjc;

- (void)asy_netWithUrlString:(NSString *)url_s ParamArray:(NSArray *)param_a Success:(void(^)(id source,NSError *analysis_error))success Failure:(void(^)(NSError *net_error))failure;

-(void)asyPOST_url:(NSString *)url Photo:(NSMutableArray *)imageArray Data:(NSArray *)data Success:(void (^)(id objc))success andFailure:(void (^)(NSError *error))failure;

@end
