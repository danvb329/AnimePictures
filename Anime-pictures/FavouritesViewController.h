//
//  FavouritesViewController.h
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface FavouritesViewController : UITableViewController<UITableViewDelegate,downloadingConnectionManagerDelegate>
@property (strong, nonatomic) NSURLSession *currentSession;
@property (strong, nonatomic) NSDictionary *JSON;
@property (strong, nonatomic) NSArray *images;
//@property (strong, nonatomic) NSArray *pathes;
@property (strong, nonatomic) NSArray *imgIDS;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (strong, nonatomic) ConnectionManager *connectionManager;
@property int pageNumber;
@end
