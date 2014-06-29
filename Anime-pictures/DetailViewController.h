//
//  DetailViewController.h
//  Anime-pictures
//
//  Created by iButs on 27.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionManager.h"

@interface DetailViewController : UIViewController<UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSNumber *imgIdent;
@property (strong, nonatomic) UIImageView *fullScreen;

@property (strong, nonatomic) NSURLSession *currentSession;
@property (strong, nonatomic) UIActivityIndicatorView *acitivityIndicator;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *favoutiteButoon;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *shreButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *star1;
@property (strong, nonatomic) IBOutlet UITextView *tagsField;
@property (strong, nonatomic) ConnectionManager *connectionManager;

@end
