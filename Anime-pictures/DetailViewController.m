//
//  DetailViewController.m
//  Anime-pictures
//
//  Created by iButs on 27.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) NSString* JSON;
@property BOOL isVoted;
@property BOOL isFavorite;

@end

@implementation DetailViewController
@synthesize imgIdent;
@synthesize fullScreen;
@synthesize tagsField;
@synthesize acitivityIndicator = _acitivityIndicator;
@synthesize favoutiteButoon;
@synthesize shreButton;
@synthesize JSON;
@synthesize star1;
@synthesize isFavorite;
@synthesize isVoted;
@synthesize connectionManager = _connectionManager;


-(ConnectionManager*)connectionManager{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if (!_connectionManager)
        _connectionManager = [[ConnectionManager alloc]init];
    return _connectionManager;
}


-(UIActivityIndicatorView*)acitivityIndicator{
    if (!_acitivityIndicator){
        _acitivityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        [_acitivityIndicator setColor:[UIColor lightGrayColor]];
    }
    return _acitivityIndicator;
}

-(NSURLSession *)currentSession{
    return [NSURLSession sharedSession];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.acitivityIndicator startAnimating];
    [self.acitivityIndicator setHidden:NO];
    [self.view addSubview:_acitivityIndicator];
    CGPoint point;
    self.connectionManager.delegate = (id<downloadingConnectionManagerDelegate>)self;
    [self.connectionManager setImageID:imgIdent];
    [self.connectionManager downloadingPathesForDetailsForImage];

    
    fullScreen = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];         //origin
    if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice]orientation]))
        point = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    else {
        point = CGPointMake(self.view.bounds.size.height/2, self.view.bounds.size.width/2);
        fullScreen.center = point;
    }
    self.acitivityIndicator.center = point;
    fullScreen.center = point;
    [self.view addSubview:fullScreen];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addActionSheetForSaving{
    NSLog(@"HERE");
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"Save image" delegate:self cancelButtonTitle:@"No, thanks" destructiveButtonTitle:nil otherButtonTitles:@"Oh,sure", nil];
    CGRect rect = self.fullScreen.bounds;
    [as showFromRect:rect inView:self.fullScreen animated:YES];

}

#pragma-mark save image methods
//Need make preview medium_preview (for ipad) & big_preview (for iphone).
//Download full size with nsurlsession when gesture tap.

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self saveImage];
        });
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

//incapsulated function to downloading

-(void)saveImage{
    UIImage *image1 = [self.connectionManager downloadFullSizeImage];
    UIImageWriteToSavedPhotosAlbum(image1, nil, nil, nil);
}

#pragma-mark buttons that call actions

- (IBAction)addToFavouritesClicked:(id)sender {
    UIColor *currentColor;
    if (![self.connectionManager isFavoriteImage])
        currentColor = [UIColor redColor];
     else
         currentColor = [UIColor blackColor];
    [self.connectionManager addImageToFavourites];
    [favoutiteButoon setTintColor:currentColor];
}

- (IBAction)shreButoonClicked:(id)sender {
    [shreButton setTintColor:[UIColor blueColor]];
}

- (IBAction)starButtonPressed:(id)sender {
     UIColor *currentColor;
    if(![self.connectionManager isVotedImage])
        currentColor = [UIColor orangeColor];
     else
        currentColor = [UIColor blackColor];
    [self.connectionManager voteFromImage];
    [star1 setTintColor:currentColor];
}

#pragma mark - buttons actions
-(void)imageDidLoad{
    dispatch_sync(dispatch_get_main_queue(), ^{
    NSLog(@"image is load");
    UIImage *image = [self.connectionManager getImage];
        
    [self.view reloadInputViews];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [self.fullScreen setImage:image];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [self.fullScreen setBounds:bounds];
    [UIView commitAnimations];
    
    [self.fullScreen setUserInteractionEnabled:TRUE];
    [self.fullScreen addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addActionSheetForSaving)]];
    });
}

-(void)imageDetailsDidParsing{
    [self.fullScreen setImage:[self.connectionManager downloadBigPreviewImage]];
    dispatch_sync(dispatch_get_main_queue(), ^{
    if ([self.connectionManager isFavoriteImage])
        NSLog(@"is fav : %hhd", (BOOL)self.connectionManager.isFavoriteImage);
        favoutiteButoon.tintColor = [UIColor redColor];

    if ([self.connectionManager isVotedImage])
        star1.tintColor = [UIColor orangeColor];
        NSString *author = [[NSString alloc]initWithFormat:@"Author: %@",[self.connectionManager getAuthorName]];
        [self setTitle:author];
    for (NSString* tag in [self.connectionManager getTagsArray]){
            NSString *string = [[NSString alloc]initWithFormat:@"%@%@, ",self.tagsField.text,tag];
            [self.tagsField setText:string];
    }
    });
}
@end

