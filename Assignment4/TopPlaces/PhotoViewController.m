//
//  PhotoViewController.m
//  TopPlaces
//
//  Created by deng zhiping on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "RecentPhotosViewController.h"


@interface PhotoViewController () <UIScrollViewDelegate>

@end

@implementation PhotoViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize photo = _photo;


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSURL *url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatMedium640];
    NSLog(@"%@", url);
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.image.size.width, self.imageView.image.size.height);
    self.title = [self.photo objectForKey:FLICKR_PHOTO_TITLE];

    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.imageView.image.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    [RecentPhotosViewController justViewPhoto:self.photo];
    /*
    NSLog(@"scrollview: %f %f %f %f\n%f %f %f %f", 
          self.scrollView.frame.origin.x, self.scrollView.frame.origin.y,
          self.scrollView.frame.size.width, self.scrollView.frame.size.height,
          self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, 
          self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    NSLog(@"view: %f %f %f %f\n%f %f %f %f", 
          self.view.frame.origin.x, self.view.frame.origin.y,
          self.view.frame.size.width, self.view.frame.size.height,
          self.view.bounds.origin.x, self.view.bounds.origin.y, 
          self.view.bounds.size.width, self.view.bounds.size.height);
    
    NSLog(@"imageView: %f %f %f %f\n%f %f %f %f", 
          self.imageView.frame.origin.x, self.imageView.frame.origin.y,
          self.imageView.frame.size.width, self.imageView.frame.size.height,
          self.imageView.bounds.origin.x, self.imageView.bounds.origin.y, 
          self.imageView.bounds.size.width, self.imageView.bounds.size.height);
     */
    
    float scale = self.imageView.bounds.size.width / self.imageView.image.size.width;
    float scale2 = self.imageView.bounds.size.height / self.imageView.image.size.height;
    if (scale < scale2)
        scale = scale2;
    [self.scrollView setZoomScale:scale];
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
@end
