//
//  FavouritesViewController.m
//  Anime-pictures
//
//  Created by iButs on 25.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "FavouritesViewController.h"
#import "PicturesCell.h"
#import "imageCellForIpad.h"
#import "DetailViewController.h"

@interface FavouritesViewController ()
@end

@implementation FavouritesViewController
@synthesize JSON;
//@synthesize pathes;
@synthesize images;
@synthesize imgIDS;
//@synthesize reloadButton;
@synthesize pageNumber;
@synthesize connectionManager =_connectionManager;

-(ConnectionManager*)connectionManager{
    if (!_connectionManager)
        _connectionManager = [[ConnectionManager alloc]init];
    return _connectionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pageNumber = 0;
    self.tableView.delegate = self;
    self.connectionManager.delegate = (id<downloadingConnectionManagerDelegate>)self;
   // NSLog(@"user id is:%@",[self.connectionManager getUserID]);
    NSHTTPCookieStorage *cookie = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSLog(@"Cookies is:%@",cookie.cookies);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"id is :%@", [defaults objectForKey:@"user_id"]);
    [self.connectionManager setUserID:[defaults objectForKey:@"user_id"]];
    [self.connectionManager downloadingPathesForFavoritesWithPageNumber:0];

    NSLog(@"Imges  is %@", self.images);
}


-(void)viewWillAppear:(BOOL)animated{
    //not reload when arrays is not equeal
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tableView reloadData];
    [[self.navigationController.toolbar.subviews lastObject]removeFromSuperview];
    [self.navigationController.toolbar removeGestureRecognizer:[self.navigationController.toolbar.gestureRecognizers lastObject]];
}

-(void)viewDidAppear:(BOOL)animated{
    UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"reload1.png"]];
    [view setFrame:CGRectMake(0, 0, 48, 48)];
    [self.navigationController.toolbar addSubview:view];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reload)];
    [self.navigationController.toolbar addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int n = 2;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        n = 5;
    return [self.images count]%n?[self.images count]/n+1:[self.images count]/n;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Images array is:%@",self.images);
    NSLog(@"%s",__PRETTY_FUNCTION__);
    static NSString *CellIdentifier = @"Cell";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        imageCellForIpad *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSMutableArray *arrayIDS = [[NSMutableArray alloc]init];
        if ([self.images count]){
            for (int i = 0; i<5; i++){
                if (indexPath.row*5+i < [self.images count]){
                    [array addObject:[self.images objectAtIndex:indexPath.row*5+i]];
                    [arrayIDS addObject:[self.imgIDS objectAtIndex:indexPath.row*5+i]];
                }else{
                    [array addObject:[UIImage imageNamed:@"No_image_available.svg.png"]];
                    
                    [arrayIDS addObject:[NSNumber numberWithDouble:-1]];
                }
            }
        }
        [cell setImagesFromArray:array andSetIDS:arrayIDS];
        
        NSArray *imageses = @[cell.firstImage, cell.secondImage, cell.thirdImage, cell.fourthImage, cell.fivethImage];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidTapped:)];
        UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDelete:)];
        swipeGesture.direction = (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight);
        
        for (UIImageView *image in imageses){
            if (image.tag != -1){
                [image setUserInteractionEnabled:TRUE];
                [image addGestureRecognizer:tapGesture];
             //   [image addGestureRecognizer:swipeGesture];
            }
        }
        return cell;
    }
    
    PicturesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setImagesFormURL:[self.images objectAtIndex:indexPath.row*2] :[self.images objectAtIndex:indexPath.row*2+1]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

- (IBAction)logOutPressed:(id)sender {
    [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchPressed:(id)sender {
    [self performSegueWithIdentifier:@"gotoSearch" sender:self];
}

- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture {
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPad" bundle:nil];
    DetailViewController *vc = (DetailViewController*)[storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
    vc.imgIdent = [NSNumber numberWithLong:(long)tappedImageView.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)swipeToDelete:(UIGestureRecognizer *)aGesture{
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
    
    UIView *view = [[UIView alloc]initWithFrame:tappedImageView.frame];
    [view setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5]];
    [tappedImageView addSubview:view];
}

-(void)reload{
    //self.images = nil;
    [self.connectionManager reloadImagesArray];
    self.images= 0;
    NSLog(@"Images array is:%@",self.images);
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self runSpinAnimationOnView:(UIView*)[self.navigationController.toolbar.subviews lastObject]duration:0.5 rotations:2 repeat:2];
    [self.connectionManager downloadingPathesForFavoritesWithPageNumber:0];

}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)parsingPathesForSmallPreviews{
        NSLog(@"%s",__PRETTY_FUNCTION__);
    [self.connectionManager downloadSmallPreviewsImagesForPage:pageNumber];
}

-(void)imagesDidLoad{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    self.images = [self.connectionManager returnSmallPreviews];
    self.imgIDS = [self.connectionManager getImagesIDs];
    NSLog(@"%s",__PRETTY_FUNCTION__);
    NSLog(@"======================Images is :%@",self.images);
        dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    });
    
}

@end
