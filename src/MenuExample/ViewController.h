//
//  ViewController.h
//  MenuExample
//
//  Created by Sergio Cirasa on 05/07/13.
//  Copyright (c) 2013 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"

@interface ViewController : UIViewController <MenuDataSource,MenuDelegate>{
    NSArray *items;
     NSArray *titleItems;
    MenuView *menu;
}

@property (retain, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playButtonAction:(id)sender;

@end
