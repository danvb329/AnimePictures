//
//  LoginController.h
//  Anime-pictures
//
//  Created by iButs on 22.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "ConnectionManager.h"
#import "uLogin.h"
@interface LoginController : UIViewController<UITextFieldDelegate,NSURLSessionDelegate,downloadingConnectionManagerDelegate>
{
    IBOutlet UITextField *nickTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UILabel *errorLabel;
    BOOL tapped;
    NSNumber *userID;
}
@property (strong, nonatomic) ConnectionManager *connectionManager;
@property (strong, nonatomic) uLogin *ulogin;
@end
