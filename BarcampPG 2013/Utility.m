//
//  Utility.m
//  mBay
//
//  Created by Daddycat on 3/16/13.
//  Copyright (c) 2013 Genesis Merchant. All rights reserved.
//

#import "Utility.h"
#import "MACIdentifier.h"

@implementation Utility
+(NSString *)pathForFile:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:filename];
}

+(NSString*)udid
{
    NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile.uuid"];
    if (!uuid)
    {
        if (!NSClassFromString(@"NSUUID"))
            uuid = [MACIdentifier MACAddress];
        else
            uuid = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:@"profile.uuid"];
    }
    return uuid;
}

+(BOOL)isIPAD
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+(void)prompt:(NSString *)title message:(NSString *)message 
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}
@end

@implementation UIImage(Tools)
-(NSData *)base64
{
    return UIImageJPEGRepresentation(self, 1.0);
}
@end

// cool plist
@implementation NSMutableArray(Plist)

-(BOOL)writeToPlistFile:(NSString*)path{
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL didWriteSuccessfull = [data writeToFile:path atomically:YES];
    return didWriteSuccessfull;
}

+(NSMutableArray*)readFromPlistFile:(NSString*)path{
    NSMutableArray *test = [NSArray arrayWithContentsOfFile:path];
    if (test) return test;
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    if (!data) return test;
    
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end

@implementation NSMutableDictionary(Plist)

-(BOOL)writeToPlistFile:(NSString*)path{
    //    return [self writeToFile:path atomically:YES];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
    BOOL didWriteSuccessfull = [data writeToFile:path atomically:YES];
    return didWriteSuccessfull;
}

+(NSMutableDictionary*)readFromPlistFile:(NSString*)path{
    //    return [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSData * data = [NSData dataWithContentsOfFile:path];
    if (!data) return nil;
    
    return  [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
