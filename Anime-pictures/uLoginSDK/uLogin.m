//
//  uLogin.m
//
//  Created by Alexey Talkan on 10.04.13.
//  Copyright (c) 2013 Alexey Talkan. All rights reserved.
//

#import "uLogin.h"
#import "ULProvidersViewController.h"

@implementation uLogin

+(uLogin*)sharedInstance{
    static uLogin* _instance;
    static dispatch_once_t onceToken;
	
    dispatch_once(&onceToken, ^{
        NSLog(@"instances was shared");
        _instance = [[uLogin alloc] init];
    });
	
    return _instance;
}

-(void)startLogin{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginComplete:) name:[kuLoginLoginSuccess stringByAppendingString:@".internal"] object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:) name:[kuLoginLoginFail stringByAppendingString:@".internal"] object:nil];
	
}

-(void)refreshLogsAction:(UIBarButtonItem*)sender{
    [rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)loginComplete:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    [rootViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kuLoginLoginSuccess object:self userInfo:notification.userInfo];
}

-(void)loginFail:(NSNotification*)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
