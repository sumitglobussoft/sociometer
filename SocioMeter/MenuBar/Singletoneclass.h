//
//  Singletoneclass.h
//  Around Dubuque
//
//  Created by Sumit Ghosh on 27/08/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singletoneclass : NSObject
{
    
}
@property(nonatomic,assign)float  currentLocationLat,currentLocationLang;
@property(nonatomic,strong)NSString * deviceId,*categorySelected,*graphSelected;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)int itemCount;
@property(nonatomic,assign)int hotelMapCount;
@property(nonatomic,strong)NSString * languageChanged,*dateOfBirth;
@property(atomic,strong) NSNumber * phoneUsageTime,*phoneLockCount;
@property(nonatomic,assign)int totalAddictionScore;
@property(nonatomic,assign)CGFloat *currentDegree;
+(Singletoneclass*)sharedSingleton;
-(NSString*)returnTheKeyForYelp:(NSString*)searchString;
-(NSString*)returnTheKeyForFourSquare:(NSString*)searchString;
-(NSString*) languageSelectedStringForKey:(NSString*) key;
+(BOOL)checkBackgroundAppRefreshIsOn;

@end
