//
//  ApiHelperClass.m
//  SocioMeter
//
//  Created by Sumit Ghosh on 28/01/16.
//  Copyright © 2016 Sumit Ghosh. All rights reserved.
//

#import "ApiHelperClass.h"

@implementation ApiHelperClass

#pragma mark User details
-(id)userSignUpMethod:(NSDictionary*)dataDict
{

    NSString *postString;
     //Normal Signup
            NSString * deviceName=[dataDict objectForKey:@"deviceName"];
            NSString * deviceId=[dataDict objectForKey:@"deviceId"];
           NSString * deviceType=[dataDict objectForKey:@"deviceType"];
           NSString *appVersion=[dataDict objectForKey:@"appVersion"];
          // NSString *gcmRegIdString=[dataDict objectForKey:@"gcmRegId"];
          NSString * birthday=[dataDict objectForKey:@"birthDay"];
           NSString * gender=[dataDict objectForKey:@"gender"];
      NSString * countryName=[dataDict objectForKey:@"country"];
    NSString *osType=[dataDict objectForKey:@"OsType"];
     postString = [NSString stringWithFormat:@"deviceName=%@&deviceId=%@&country=%@&birthDay=%@&gender=%@&deviceType=%@&appVersion=%@&OsType=%@",deviceName,deviceId,countryName,birthday,gender,deviceType,appVersion,osType];
    NSURL * url=[NSURL URLWithString:@"http://185.112.248.71/Api/User/UserInstallation"];
    return [self postRequest:url postString:postString];
}


#pragma Mark UserSociometer

-(id)userSociometerDetails:(NSDictionary*)dataDict
{
    
    
    //userId,lockCount,phoneUsageSeconds,addScore,timeStamp
    
    NSString *postString;
    
    NSString * userIdStr=[dataDict objectForKey:@"userId"];
    NSString * lockCountStr=[dataDict objectForKey:@"lockCount"];
    NSString * phoneUsageSecondsStr=[dataDict objectForKey:@"phoneUsageSeconds"];
    NSString *addScoreStr=[dataDict objectForKey:@"addScore"];
    NSString * timeStampStr=[dataDict objectForKey:@"timeStamp"];
    
    
    postString = [NSString stringWithFormat:@"userId=%@&lockCount=%@&phoneUsageSeconds=%@&addScore=%@&timeStamp=%@",userIdStr,lockCountStr,phoneUsageSecondsStr,addScoreStr,timeStampStr];
    
    NSURL * url=[NSURL URLWithString:@"http://185.112.248.71/Api/User/UserSociometer"];
    return [self postRequest:url postString:postString];
}
#pragma mark Update User
-(id)userFeedBackMessage:(NSDictionary *)dataDict
{
    
    NSString *postString;
    
    NSString * userIdStr=[dataDict objectForKey:@"userId"];
    NSString *feedbackStr=[dataDict objectForKey:@"feedbackMessage"];
    
    
    postString = [NSString stringWithFormat:@"userId=%@&feedbackMessage=%@",userIdStr,feedbackStr];
    
    NSURL * url=[NSURL URLWithString:@"http://185.112.248.71/Api/User/Feedback"];
    return [self postRequest:url postString:postString];
}
#pragma mark UpdateusersummeryforAchivementView
-(id)updateUserSummery:(NSDictionary *)dataDict
{
    //redStones,yellowStones,greenStones,userId
    NSString *postString;
    
    NSString * userIdStr=[dataDict objectForKey:@"userId"];
    NSString * yellowStonesStr=[dataDict objectForKey:@"yellowStones"];
    NSString * greenStonesStr=[dataDict objectForKey:@"greenStones"];
    NSString *redStonesStr=[dataDict objectForKey:@"redStones"];
    
    
    postString = [NSString stringWithFormat:@"redStones=%@&yellowStones=%@&greenStones=%@&userId=%@",redStonesStr,yellowStonesStr,greenStonesStr,userIdStr];
    
    NSURL * url=[NSURL URLWithString:@"http://185.112.248.71/Api/User/UserSummary"];
    return [self postRequest:url postString:userIdStr];
}
-(id)postRequest:(NSURL*)potsUrl postString:(NSString*)postString

{
    NSError * error=nil;
    NSURLResponse * urlResponse;
    NSData *myRequestData = [ NSData dataWithBytes: [ postString UTF8String ] length: [ postString length ] ];
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc]initWithURL:potsUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPBody: myRequestData];
    [request setHTTPMethod:@"POST"];
    
    NSData * data =[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if (!data)
    {
        return nil;
    }
    
    id jsonnResponse =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    //---------------------------------------
    
 
    
    
    //-----------------------------------------
    NSLog(@"%@",jsonnResponse);
    return jsonnResponse;
}




@end
