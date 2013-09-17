//
//  Session.m
//  AwayDay2012
//
//  Created by xuehai zeng on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Session.h"

@implementation Session
@synthesize sessionID=_sessionID;
@synthesize sessionTitle=_sessionTitle;
@synthesize sessionStartTime=_sessionStartTime;
@synthesize sessionEndTime=_sessionEndTime;
@synthesize sessionNote=_sessionNote;
@synthesize sessionSpeaker=_sessionSpeaker;
@synthesize sessionAddress=_sessionAddress;


-(Session *)createSession:(NSDictionary *)sessionProperies{
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'+0800'"];
    [dateFormatter2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:(5.5 * 3600)]];
    
    Session *session = [[Session alloc] init];
    [session setSessionTitle:[sessionProperies objectForKey:@"session_title"]];
    [session setSessionSpeaker:[sessionProperies objectForKey:@"session_speaker"]];
    NSNumber *sessionID=[sessionProperies objectForKey:@"session_id"];
    [session setSessionID:[sessionID stringValue]];
    [session setSessionStartTime:[dateFormatter2 dateFromString:[sessionProperies objectForKey:@"session_start"]]];
    [session setSessionEndTime:[dateFormatter2 dateFromString:[sessionProperies objectForKey:@"session_end"]]];
    
    NSString *note=[sessionProperies objectForKey:@"session_description"];
    if(note==nil) note=@"";
    if([note isEqual:[NSNull null]])note=@"";
    [session setSessionNote:note];
    [session setSessionAddress:[sessionProperies objectForKey:@"session_location"]];
    return session;
}

@end
