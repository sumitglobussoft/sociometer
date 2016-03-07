//
//  Singletoneclass.m
//  Around Dubuque
//
//  Created by Sumit Ghosh on 27/08/15.
//  Copyright (c) 2015 Sumit Ghosh. All rights reserved.
//

#import "Singletoneclass.h"



static Singletoneclass *sharedSingleton;

@implementation Singletoneclass
+(Singletoneclass*)sharedSingleton{
    
    
    @synchronized(self){
        
        if(!sharedSingleton){
            sharedSingleton=[[Singletoneclass alloc]init];
        }
    }return sharedSingleton;
}


+(BOOL)checkBackgroundAppRefreshIsOn
{
    if ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        NSLog(@"Background updates are available for the app.");
        return true;
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied)
    {
        NSLog(@"The user explicitly disabled background behavior for this app or for the whole system.");
        return false;
    }else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted)
    {
        NSLog(@"Background updates are unavailable and the user cannot enable them again. For example, this status can occur when parental controls are in effect for the current user.");
        return false;
    }
    return false;
}
@end
