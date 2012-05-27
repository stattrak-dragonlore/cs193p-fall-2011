//
//  RecentPhotosViewController.m
//  TopPlaces
//
//  Created by deng zhiping on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotosViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface RecentPhotosViewController ()
@property (nonatomic, strong) NSArray *recentPhotos;
@end

@implementation RecentPhotosViewController

@synthesize recentPhotos = _recentPhotos;

#define RECENT_PHOTOS_KEY @"RECENT.PHOTOS"


+ (void)justViewPhoto:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *recents = [defaults objectForKey:RECENT_PHOTOS_KEY];
    if (!recents) {
        recents = [[NSArray alloc] init];
    }

    BOOL saved = NO;
    for (id p in recents) {
        if ([[p objectForKey:@"id"] isEqualToString:[photo objectForKey:@"id"]]) {
            saved = YES;
        }
    }

    if (!saved) {
        NSMutableArray *newRecents = [recents mutableCopy];
        [newRecents addObject:photo];

        [defaults setObject:newRecents forKey:RECENT_PHOTOS_KEY];
        [defaults synchronize];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.recentPhotos = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_PHOTOS_KEY];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentPhotos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photos";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //most recent on top
    NSDictionary *photo = [self.recentPhotos objectAtIndex:(self.recentPhotos.count -  indexPath.row - 1)];
    NSString *title = [photo objectForKey:@"title"];
    NSString *desription = [[photo objectForKey:@"description"] objectForKey:@"_content"];
    
    if ([title length] == 0) {
        if ([desription length]) {
            title = desription;
        } else {
            title = @"Unknown";
        }
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = desription;  
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
