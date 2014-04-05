//
//  MenuView.h
//  MenuExample
//
//  Created by Sergio Cirasa on 08/07/13.
//  Copyright (c) 2013 Sergio Cirasa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuView;

typedef enum  {
    kRotateClockwise  = 0,
    kRotateCounterClockwise = 1,
    kRotateToTheNearest  = 2,
} DirectionOfRotation;

@protocol MenuDelegate <NSObject>
@optional
- (void)menu:(MenuView *)menu willSelectItemAtIndex:(int )index;
- (void)menu:(MenuView *)menu didSelectItemAtIndex:(int )index;
@end

@protocol MenuDataSource <NSObject>
- (UIImage*)menu:(MenuView *)menu imageForItemAtIndex:(int )index;
- (NSString*)menu:(MenuView *)menu titleForItemAtIndex:(int )index;
- (UIImage*)menu:(MenuView *)menu imageForSelectedItemAtIndex:(int )index;
- (NSInteger)numberOfItemsInMenuView:(MenuView *)menuView;
@end

@interface MenuView : UIView{
    int selectedItemIndex;
    DirectionOfRotation direction;
    int finalPositionOfSelectedItem;
    int radioOfItems;
    float deltaAngle; //
    id<MenuDataSource> datasource;
    id<MenuDelegate> delegate;
    NSMutableArray *items;
    BOOL enabled;
    
    UIImageView *backgroundImageView;
    UIImageView *selectedItemBackgroundImageView;
    UILabel *titleItemLabel;
    UIImageView *popup;
}

@property (assign, nonatomic) DirectionOfRotation direction;
@property (assign, nonatomic) int finalPositionOfSelectedItem;
@property (assign, nonatomic) int radioOfItems;
@property (assign, nonatomic, readonly) int selectedItemIndex;
@property (assign, nonatomic) float deltaAngle;

@property (assign, nonatomic) id<MenuDataSource> datasource;
@property (assign, nonatomic) id<MenuDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)reloadData;
- (void)selectItemAtIndex:(int) index animated:(BOOL) animated;

@end
