//
//  ProvidersTableViewController.m
//  Anime-pictures
//
//  Created by iButs on 18.04.14.
//  Copyright (c) 2014 iButs. All rights reserved.
//

#import "ProvidersTableViewController.h"
#import "uLoginSDK/ULWebViewController.h"
@interface ProvidersTableViewController ()
@property (strong, nonatomic) id<ULProvider> selectedProvider;
@property (strong, nonatomic) ULDefaultConfigurator *selectedConfiguator;
@property (strong, nonatomic) uLogin *login;
@end

@implementation ProvidersTableViewController
@synthesize providersArray;
@synthesize selectedProvider;
@synthesize selectedConfiguator;

-(uLogin*)login{
    return [uLogin sharedInstance];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[uLogin sharedInstance]startLogin];
    providersArray = [self providers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(NSArray *)providers{
    ULProviderGoogle         *googleProv = [[ULProviderGoogle        alloc] init];
    ULProviderVkontakte          *vkProv = [[ULProviderVkontakte     alloc] init];
    ULProviderFacebook     *facebookProv = [[ULProviderFacebook      alloc] init];
    ULProviderTwitter       *twitterProv = [[ULProviderTwitter       alloc] init];

    
    return [NSArray arrayWithObjects:googleProv,vkProv,facebookProv,twitterProv,nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [providersArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[providersArray objectAtIndex:indexPath.row] name];
    cell.imageView.image = [UIImage imageNamed:cell.textLabel.text];
    return cell;
}

- (IBAction)cancelLogining:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  //  ULWebViewController *vc = [segue destinationViewController];
  //  [vc initWithProvider:self.selectedProvider andConfigurator:self.selectedConfiguator];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedProvider = [providersArray objectAtIndex:indexPath.row];
    ULDefaultConfigurator *config = [[ULDefaultConfigurator alloc]init];
    self.selectedConfiguator = config;
    ULWebViewController *vc = [[ULWebViewController alloc]initWithProvider:self.selectedProvider andConfigurator:self.selectedConfiguator];
  //  [vc initWithProvider:self.selectedProvider andConfigurator:self.selectedConfiguator];
    [self.navigationController pushViewController:vc animated:YES];
   // [self performSegueWithIdentifier:@"Details" sender:self];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
