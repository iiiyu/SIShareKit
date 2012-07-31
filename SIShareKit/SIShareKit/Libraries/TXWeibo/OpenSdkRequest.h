//
//  OpenSdkRequest.h
//  OpenSdkTest
//
//  Created by aine sun on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenSdkOauth.h"
#import "OpenSdkBase.h"
#import "JSONKit.h"

@class OpenSdkRequest;

@protocol OpenSdkRequestDelegate <NSObject>

@optional
- (void)authorizationFailedOrDidNotAuthorize:(OpenSdkRequest *)request;

@end

@interface OpenSdkRequest : NSObject
{
//    id<OpenSdkRequestDelegate> delegate;
}

@property (unsafe_unretained, nonatomic) id<OpenSdkRequestDelegate> delegate;

/*
 * 发送API接口请求，并接受返回的数据
 */

- (NSString *)sendApiRequest:(NSString *)url 
					  httpMethod:(NSString *)httpMethod 
                        oauth:(OpenSdkOauth *)oauth
					  params:(NSMutableDictionary *)params 
						   files:(NSDictionary *)files
                        oauthType:(uint16_t)oauthType
                        retCode:(uint16_t *)retCode;


@end



