//
//  Searchcontroller.m
//  Anime-pictures
//
//  Created by iButs on 22.03.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "Searchcontroller.h"
#import "SettingsCell.h"
#import "PicturesCell.h"
#import "imageCellForIpad.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation Searchcontroller

@synthesize identifier;
@synthesize mySearchBar;
@synthesize images;
@synthesize fullRequest;
@synthesize cellIdentifier;
@synthesize requestTag;
@synthesize imgIDS;
@synthesize svc = _svc;
@synthesize pageNumber;
@synthesize requestSortingPart;
@synthesize requestRecentPart;
@synthesize bluerbar;
@synthesize connectionManager = _connectionManager;

//how define


-(ConnectionManager*)connectionManager{
    if (!_connectionManager)
        _connectionManager = [[ConnectionManager alloc]init];
    return _connectionManager;
}

-(void)viewDidLoad{
    pageNumber = 0;
    showSettings = 0;
    cellIdentifier = @"Cell";
    mySearchBar.delegate = self;
    tapped = 0;
    self.requestRecentPart =@"0";
    self.requestSortingPart = @"0";
    self.connectionManager.delegate = (id<downloadingConnectionManagerDelegate>)self;
    self.svc.view.bounds = CGRectMake(0,0,250,self.view.bounds.size.height-30);
    self.svc.view.center = CGPointMake(self.view.frame.size.width-125,self.view.bounds.size.height/2+30);
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped)]];
    
    self.bluerbar = [[UIToolbar alloc] initWithFrame:self.view.bounds];
   // [self.bluerbar setBarTintColor:[UIColor whiteColor]];
//    self.bluerbar.barStyle = UIBarStyleDefault;
//    [self.view insertSubview:self.bluerbar belowSubview:self.svc.view];
//    self.bluerbar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:@"UIApplicationDidChangeStatusBarOrientationNotification" object:nil];
    self.view.backgroundColor = [UIColor blackColor];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

-(void)didRotate{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    if ( UIDeviceOrientationIsLandscape([[UIDevice currentDevice]orientation])){
         self.svc.view.center = CGPointMake(self.view.frame.size.width-125,245);
        tapped = TRUE;
        [self imageViewDidTapped];
        //self.svc.view.frame = CGRectMake(350,50, 320, 200);
        //[self.svc.view setHidden:NO];
    }
}

-(SettingsViewController*)svc{
    if (_svc == nil){
        _svc = [[SettingsViewController alloc]init];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard_iPhone_1" bundle:nil];
        _svc = (SettingsViewController*)[storyboard instantiateViewControllerWithIdentifier:@"settingsController"];
    }
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return _svc;
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

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (180.0*M_PI)/360, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        UILongPressGestureRecognizer *swipeGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(swipeToDelete:)];
        for (UIImageView *image in imageses){
            if (image.tag != -1){
                [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)]];
                [image addGestureRecognizer:swipeGesture];
                [image setUserInteractionEnabled:TRUE];
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

#pragma mark - searching

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.images = nil;
    self.pageNumber = 0;
    //[self.tableView clearsContextBeforeDrawing];
    [self.tableView reloadData];
    self.requestSortingPart = self.svc.sortingOrder;
    self.requestRecentPart = self.svc.recentOrder;
    NSLog(@"Pressed");
    NSLog(@"recent is %@ and request is %@",self.requestRecentPart, self.requestSortingPart);
    [self.connectionManager reloadImagesArray];
    [self.connectionManager downloadingPathesForImagesFromSearchTag:searchBar.text forPageWithNumber:pageNumber withHeight:self.svc.itsY.text andWeight:self.svc.itsX.text withOrderBY:self.requestSortingPart andRecentBy:self.requestRecentPart];
    [searchBar resignFirstResponder];
    searchBar.text = nil;
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = nil;
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.requestTag = searchBar.text;
}

#pragma mark - methods for advanced search          //bags

- (void)imageViewDidTapped:(UIGestureRecognizer *)aGesture {
    UITapGestureRecognizer *tapGesture = (UITapGestureRecognizer *)aGesture;
    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
    identifier = [NSNumber numberWithLong:(long)tappedImageView.tag];
    [self performSegueWithIdentifier:@"Detail" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"id is %@", identifier);
    DetailViewController *vc = [segue destinationViewController];
    vc.imgIdent = identifier;
}

-(void)swipeToDelete:(UIPanGestureRecognizer *)aGesture{
    NSLog(@"gesture");
    UILongPressGestureRecognizer *tapGesture = (UILongPressGestureRecognizer *)aGesture;
    UIImageView *tappedImageView = (UIImageView *)[tapGesture view];
    
    CGRect rect = tappedImageView.frame;
    UIColor *color = [UIColor redColor];

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    [tappedImageView setImage:image];
    UIGraphicsEndImageContext();
}

-(void)imageViewDidTapped{
    tapped = !tapped;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];

    if (tapped){
        CALayer *layer = self.svc.view.layer;
        [self.view addSubview:self.svc.view];
        self.svc.view.bounds = CGRectMake(0, 0, 250, self.view.bounds.size.height-30);
        self.svc.view.center = CGPointMake(self.view.frame.size.width-125,self.view.bounds.size.height/2+30);
        layer.shouldGroupAccessibilityChildren = YES;
        layer.shadowOffset = CGSizeMake(20, 30);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowRadius = 10.0f;
        layer.shadowOpacity = 0.70f;
        layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        self.tableView.scrollEnabled = NO;
    } else {

        self.svc.view.center = CGPointMake(self.view.frame.size.width+125,self.view.bounds.size.height/2+30);

        self.tableView.scrollEnabled = YES;
        
    }
    [UIView commitAnimations];
    
}

- (void)roundedLayerWithShadow:(CALayer *)viewLayer
                        radius:(float)r
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [viewLayer setMasksToBounds:YES];
    [viewLayer setCornerRadius:r];
    [viewLayer setBorderColor:[UIColor grayColor].CGColor];
    [viewLayer setBorderWidth:1.0f];
    
    [viewLayer setShadowColor:[UIColor lightGrayColor].CGColor];
    [viewLayer setShadowOffset:CGSizeMake(0, 0)];
    [viewLayer setShadowOpacity:1];
    [viewLayer setShadowRadius:2.0];
    return;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Root");
}

//more pages  methods
- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView
                  willDecelerate:(BOOL)decelerate{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        NSLog(@"Load more");
        
        [self.connectionManager reloadImagesArray];
        [self.connectionManager downloadingPathesForImagesFromSearchTag:self.mySearchBar.text forPageWithNumber:pageNumber withHeight:self.svc.itsY.text andWeight:self.svc.itsX.text withOrderBY:self.requestSortingPart andRecentBy:self.requestRecentPart];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        self.tableView.scrollEnabled = NO;
       // self.tableView.pagingEnabled = NO;
    }
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog (@"Content offset is : %f",self.tableView.scrollIndicatorInsets.top);
//    NSLog (@"real size is %f", self.tableView.contentSize.height);
//    if (scrollView.contentOffset.y > self.images.count * 170+50){
//        [self.tableView setContentOffset:CGPointZero animated:YES];
//    }
//}

#pragma - mark ----delegates methods-----

-(void)parsingPathesForSmallPreviews{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [self.connectionManager downloadSmallPreviewsImagesForPage:pageNumber];
}

-(void)imagesDidLoad{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSLog(@"%s",__PRETTY_FUNCTION__);
        if ([self.images count]){
            NSArray *first = [self.connectionManager returnSmallPreviews];
            if (first){
                NSArray *second = self.images;
                NSMutableArray *third = [[NSMutableArray alloc]initWithArray:second];
                self.images = (NSMutableArray*)[third arrayByAddingObjectsFromArray:first];
            
                NSArray *idsFirst = [self.connectionManager getImagesIDs];
                NSArray *idsSecond = self.imgIDS;
                NSMutableArray *idsThird = [[NSMutableArray alloc]initWithArray:idsSecond];
                self.imgIDS = (NSMutableArray*)[idsThird arrayByAddingObjectsFromArray:idsFirst];
            }
        } else {
            self.images = (NSMutableArray*)[self.connectionManager returnSmallPreviews];
            self.imgIDS = (NSMutableArray*)[self.connectionManager getImagesIDs];

        }
            
        
        NSLog(@"Third is:%@",self.images);
        NSLog(@"Returned images is:%@",[self.connectionManager returnSmallPreviews]);
        NSLog(@"======================Images is :%@",self.images);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            self.tableView.scrollEnabled = YES;
           // self.tableView.pagingEnabled = YES;
            
            pageNumber++;
        });
    });
}


@end
