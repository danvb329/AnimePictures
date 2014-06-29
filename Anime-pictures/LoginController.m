//
//  LoginController.m
//  Anime-pictures
//
//  Created by iButs on 22.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "LoginController.h"
#import "FavouritesViewController.h"


@implementation LoginController
@synthesize connectionManager = _connectionManager;
@synthesize ulogin;
-(ConnectionManager*)connectionManager{
    if (!_connectionManager)
        _connectionManager = [[ConnectionManager alloc]initForLoginController];
    return _connectionManager;
}

- (IBAction)loginPressed:(id)sender {
    [passwordTextField resignFirstResponder];
    [self.connectionManager loginUserWithName:nickTextField.text andPassword:passwordTextField.text];
}


-(void)viewDidLoad{
    self.connectionManager.loginDelegate = (id<loginUserDelegate>)self;
    tapped = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:) name:kuLoginLoginSuccess object:nil];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    nickTextField.delegate = self;
    passwordTextField.delegate = self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [textField resignFirstResponder];
    return YES;
}


-(void)userIdDidParsing{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[self.connectionManager userID]forKey:@"user_id"];
    NSLog(@"daf val is :%@", [defaults valueForKey:@"user_id"]);
    if ([self.connectionManager userID])
        [self performSegueWithIdentifier:@"gotoFavourites" sender:self];
    else
        NSLog(@"Password or name is nor correct, try again");
}

- (IBAction)uLoginTapped:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"uLogining" bundle:nil];
    UINavigationController *nc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    nc.modalPresentationStyle=UIModalPresentationFormSheet;
    nc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:nc animated:YES completion:nil];


}

-(void)loginSuccess:(id) success{
    NSLog(@"success is : %@",success);
}
@end
