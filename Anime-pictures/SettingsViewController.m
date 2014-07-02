//
//  SettingsViewController.m
//  Anime-pictures
//
//  Created by iButs on 03.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "SettingsViewController.h"
#import "Searchcontroller.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize itsX;
@synthesize itsY;
@synthesize itsHowRecent;
@synthesize itsSortingsBy;
@synthesize sortingOrder;
@synthesize recentOrder;

-(void)viewDidLoad{
    itsX.delegate = self;
    itsY.delegate = self;
    sortingOrder = @"date";
    recentOrder = @"0";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
     [self.presentingViewController parentViewController];
}


- (IBAction)pressAutosizing:(id)sender {
    UIScreen *MainScreen = [UIScreen mainScreen];
    UIScreenMode *ScreenMode = [MainScreen currentMode];
    CGSize Size = [ScreenMode size];
    itsY.text = [NSString stringWithFormat:@"%f",Size.height];
    itsX.text = [NSString stringWithFormat:@"%f",Size.width];
}

- (IBAction)sortingsByWasChangesd:(id)sender {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
   int forCase = (int)segmentedControl.selectedSegmentIndex;

    if(forCase == 0)
            sortingOrder = @"date";
    else if(forCase == 1)
            sortingOrder = @"raiting";
    else  if(forCase == 2)
            sortingOrder = @"views";
    else if(forCase == 3)
            sortingOrder = @"size";
    NSLog(@"Sorting order is %@",sortingOrder);
}

- (IBAction)howRecentWasChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    NSNumber *forCase = [NSNumber numberWithInt:(int)segmentedControl.selectedSegmentIndex];
    recentOrder = [NSString stringWithFormat:@"%@",forCase];
    NSLog(@"Recent order is:%@",recentOrder);
}



#pragma - mark  color controller methods
- (IBAction)pressedColor:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone_1" bundle:nil];
    UINavigationController *vc = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    vc.modalPresentationStyle = UIModalPresentationFormSheet;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    NSLog(@"nsv controller is kind of %@",[self.view.superview nextResponder]);
    if ([[self.view.superview nextResponder]isMemberOfClass:[Searchcontroller class]]){
        Searchcontroller *mainViewController = (Searchcontroller*)[self.view.superview nextResponder];
        [mainViewController.navigationController presentViewController:vc animated:YES completion:nil];
    }else{
        SettingsViewController *mainViewController = (SettingsViewController*)[self.view nextResponder];
        [mainViewController.navigationController presentViewController:vc animated:YES completion:nil];
    }
}


@end
