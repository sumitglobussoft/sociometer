//
//  ApiHelperClass.h
//  SocioMeter
//
//  Created by Sumit Ghosh on 28/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiHelperClass : NSObject
-(id)userSignUpMethod:(NSDictionary*)dataDict;
-(id)postRequest:(NSURL*)potsUrl postString:(NSString*)postString;
-(id)userSociometerDetails:(NSDictionary*)dataDict;
-(id)userFeedBackMessage:(NSDictionary *)dataDict;
-(id)updateUserSummery:(NSDictionary *)dataDict;
- (void)loadDataWithOperation:(NSDictionary*)dataDict;
@end
