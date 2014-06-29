//
//  ProvidersTableViewController.h
//  Anime-pictures
//
//  Created by iButs on 18.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "uLoginSDK/Providers/ULProvider.h"
#import "uLogin.h"
@interface ProvidersTableViewController : UITableViewController<UITableViewDelegate>
@property (strong, nonatomic) NSArray *providersArray;

@end
