//
//  ViewController.m
//  MenuExample
//
//  Created by Sergio Cirasa on 05/07/13.
//  Copyright (c) 2013 Sergio Cirasa. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CATransform3D.h>
#include <CoreGraphics/CoreGraphics.h>

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    menu = [[MenuView alloc] initWithFrame:CGRectMake(323, 146, 378, 378)];
    menu.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin   | UIViewAutoresizingFlexibleRightMargin  | UIViewAutoresizingFlexibleTopMargin   |UIViewAutoresizingFlexibleBottomMargin;
    menu.datasource=self;
    menu.delegate=self;
    menu.direction = kRotateToTheNearest;
    menu.deltaAngle = 0;
    
    [self.view addSubview:menu];
    items = [@[@"setting.png",@"leads.png",@"quote.png"] retain];
    titleItems = [@[@"Setting",@"Profile",@"Files"] retain];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [menu reloadData];
    self.playButton.alpha=0.0;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark MenuDataSource
- (UIImage*)menu:(MenuView *)menu imageForItemAtIndex:(int )index{
     UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"item_%@",[items objectAtIndex:index]]];
    return image;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImage*)menu:(MenuView *)menu imageForSelectedItemAtIndex:(int )index{
     UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"selectedItem_%@",[items objectAtIndex:index]]];
    return image;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfItemsInMenuView:(MenuView *)menuView{
    return [items count];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString*)menu:(MenuView *)menu titleForItemAtIndex:(int )index{
    return [titleItems objectAtIndex:index];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark MenuDelegate
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)menu:(MenuView *)menu willSelectItemAtIndex:(int )index{
    self.playButton.userInteractionEnabled=NO;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)menu:(MenuView *)menu didSelectItemAtIndex:(int )index{
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
        self.playButton.alpha=1.0;
    } completion:^(BOOL finished){
        self.playButton.userInteractionEnabled=YES;
    }];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
#pragma mark Button Events
- (IBAction)playButtonAction:(id)sender {
    menu.direction++;
    
    if(menu.direction>2)
        menu.direction = 0;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [titleItems release];
    [items release];
    [menu release];
    [_playButton release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------------------------------------------------

@end
