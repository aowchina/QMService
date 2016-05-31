//
//  DDQPOSTEncryption.m
//  Tool
//
//  Created by Min-Fo_003 on 15/11/17.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQPOSTEncryption.h"
#import "Alg.h"

@implementation DDQPOSTEncryption

+(instancetype)instanceObjc {

    static DDQPOSTEncryption *post = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        post = [[self alloc] init];
    });
    return post;
}

+(NSString *)stringWithDic:(NSDictionary *)dic {
    
    NSString *getString = @"";
    @try {
        for (int i=0; i<[[[dic objectForKey:@"data"]objectForKey:@"cnt"] intValue]; i++) {
            NSString *data_item = [[dic objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%d",i]];
            char ret_out[512];
            memset(ret_out,0,sizeof(ret_out));
            decryptedString([data_item cStringUsingEncoding:NSUTF8StringEncoding], ret_out);
            
            getString = [getString stringByAppendingString:[[NSString alloc] initWithCString:(const char*)ret_out encoding:NSUTF8StringEncoding]];
        }

    }
    @catch (NSException *exception) {
//        NSLog(@"exception = %@",exception);
    }
    return getString;
}

+(NSString *)stringWithPost:(NSString *)postStr projectId:(NSString *)projectId {
    
    postStr = [postStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char * a_basePostString = [postStr UTF8String];
    long int str_counter;
    if((strlen(a_basePostString) % 60) != 0){
        str_counter = (long int)(strlen(a_basePostString) / 60) +1;
    } else {
        str_counter = (long int)(strlen(a_basePostString) / 60);
    }
    long int total_counter = str_counter + 3;
    NSString *t_counter = [NSString stringWithFormat:@"%ld",total_counter];
    
    NSString *postString = @"p0=";
    postString = [postString stringByAppendingString:t_counter];

    NSString *temp_string = [NSString stringWithFormat:@"&p1=%@&p2=2",projectId];
    postString = [postString stringByAppendingString:temp_string];
    for (int i = 0; i < str_counter; i++) {
        postString = [postString stringByAppendingString:@"&p"];
        postString = [postString stringByAppendingString:[NSString stringWithFormat:@"%d",(i + 3)]];
        postString = [postString stringByAppendingString:@"="];
        
        char sub_text[100];
        memset(sub_text, 0, sizeof(sub_text));
        //strncpy(sub_text,a_basePostString+(i * 60), 60);
        
        if (i == (str_counter - 1)) {
            
            strncpy(sub_text,a_basePostString+(i * 60), (strlen(a_basePostString) - (i * 60)));
        } else {
            strncpy(sub_text,a_basePostString+(i * 60), 60);
        }
        
        char ret[512];
        memset(ret,0,sizeof(ret));
        encryptedString(sub_text,ret);
        
        NSString *en_postString = [[NSString alloc] initWithCString:(const char*)ret encoding:NSUTF8StringEncoding];
        en_postString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)en_postString, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        postString = [postString stringByAppendingString:en_postString];
    }
    return postString;
}

+(id)encrption_jsonDic:(id)objc {

    if ([objc[@"active"] intValue] == 1) {
        
        //解密
        NSString *str = [DDQPOSTEncryption stringWithDic:objc];
        
        //json
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (object == nil) {
            return str;
        } else {
            return object;
        }
        
    } else {
    
        return objc;
        
    }
   
    
}

@end
