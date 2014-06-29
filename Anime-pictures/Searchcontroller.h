//
//  Searchcontroller.h
//  Anime-pictures
//
//  Created by iButs on 22.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "ConnectionManager.h"

@interface Searchcontroller : UITableViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>{
    BOOL showSettings;
    BOOL tapped;
}

@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) SettingsViewController *svc;

@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSDictionary *JSON;
@property (strong, nonatomic) UISearchDisplayController *strongSearchDisplayController;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imgIDS;
@property (strong, nonatomic) NSString *cellIdentifier;
@property (strong, nonatomic) NSString *fullRequest;
@property (strong, nonatomic) NSString *requestTag;
@property (strong, nonatomic) NSNumber *idForSegue;
@property (strong, nonatomic) NSString *requestSortingPart;
@property (strong, nonatomic) NSString *requestRecentPart;
@property (strong, nonatomic) UIToolbar *bluerbar;
@property (strong, nonatomic) ConnectionManager *connectionManager;
@property int pageNumber;

@end
