//
//  CityTableViewController.m
//  TopPlaces
//
//  Created by deng zhiping on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CityTableViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface CityTableViewController ()
@property (nonatomic, strong) NSArray *photosInPlace;
@end

@implementation CityTableViewController

@synthesize photosInPlace = _photosInPlace;
@synthesize place = _place;

- (void)setPlace:(NSDictionary *)place
{
    _place = place;
    self.photosInPlace = [FlickrFetcher photosInPlace:place maxResults:50];
//    NSLog(@"%@", self.photosInPlace);
}

- (void)setPhotosInPlace:(NSArray *)photosInPlace
{
    _photosInPlace = photosInPlace;
    [self.tableView reloadData];
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

/*

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photo"]) {

        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *photo = [self.photosInPlace objectAtIndex:path.row];
        NSURL *url = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatLarge];
        [segue.destinationViewController setPhotoUrl:url];
    }
}
 */

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photosInPlace count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Info";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *photo = [self.photosInPlace objectAtIndex:indexPath.row];
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
    PhotoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"photoViewController"];

    vc.photo = [self.photosInPlace objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:vc animated:YES];

}

@end
