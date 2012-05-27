//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by deng zhiping on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "CityTableViewController.h"
#import "FlickrFetcher.h"


@interface TopPlacesTableViewController ()
@property (nonatomic) NSArray *topPlaces;

@end

@implementation TopPlacesTableViewController

@synthesize topPlaces = _topPlaces;


- (void)setTopPlaces:(NSArray *)topPlaces
{
    _topPlaces = topPlaces;
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
    self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingComparator:^(id obj1, id obj2) {
        NSString *first = [obj1 objectForKey:FLICKR_PLACE_NAME];
        NSString *second = [obj2 objectForKey:FLICKR_PLACE_NAME];
        return [first caseInsensitiveCompare:second];
    }];

//    NSLog(@"%@", self.topPlaces);
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Photos in Place"]) {
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
        CityTableViewController *dest = segue.destinationViewController;
        NSString *location = [place objectForKey:FLICKR_PLACE_NAME];
        NSRange range = [location rangeOfString:@", "];
        dest.title = [location substringToIndex:range.location];

        [dest setPlace:place];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSLog(@"no reuseable cell");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *place = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *location = [place objectForKey:FLICKR_PLACE_NAME];
    NSRange range = [location rangeOfString:@", "];
    
    cell.textLabel.text = [location substringToIndex:range.location];
    cell.detailTextLabel.text = [location substringFromIndex:range.location + 2];
    
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
