//
//  MenuView.m
//  MenuExample
//
//  Created by Sergio Cirasa on 08/07/13.
//  Copyright (c) 2013 Sergio Cirasa. All rights reserved.
//

#import "MenuView.h"
#import "UIColor+Category.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationVelocity 0.5  //sec per portion
#define kLineWidth 0.2
#define kIconSize 130.0
#define kShadowBrur 15
#define kStartDegree -90 // 12 hs
#define kBackgroundColor [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1]
#define kSelectedItemColor [UIColor colorWithRed:0.0/255.0 green:120.0/255.0 blue:200.0/255.0 alpha:1]
#define kLineColor [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.6]

#define kPopupSize CGSizeMake(272,76)

@interface MenuView ()
-(int) distanceToOriginPosition:(int) pos;
-(void) itemButtonAction:(id)sender;
-(void) adjustItemsToAngle:(float) angle;
-(void) showPopup;
-(void) hidePopup;
@end

@implementation MenuView
@synthesize direction,finalPositionOfSelectedItem,radioOfItems,selectedItemIndex,datasource,delegate,deltaAngle;

//------------------------------------------------------------------------------------------------------------------------------------------------
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 378, 470)];
    if (self) {
        finalPositionOfSelectedItem=1;
        direction = kRotateClockwise;
        radioOfItems=110.0;
        deltaAngle=0;
        datasource=nil;
        delegate=nil;
        enabled=TRUE;
        
        backgroundImageView = [[UIImageView alloc] initWithImage:[self backgroundImage]/*[UIImage imageNamed:@"menuBackground.png"]*/];
        backgroundImageView.userInteractionEnabled = YES;
        backgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        [self addSubview:backgroundImageView];
        
        selectedItemBackgroundImageView = [[UIImageView alloc] initWithImage:[self selectedBackgroundImage] /*[UIImage imageNamed:@"selectedItemBackground.png"]*/];
        selectedItemBackgroundImageView.alpha = 0;
        selectedItemBackgroundImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        [backgroundImageView addSubview:selectedItemBackgroundImageView];
        
        UIImageView *dot = [[UIImageView alloc] initWithImage:[self centerCircleImage]];
        dot.center = backgroundImageView.center;
        [backgroundImageView addSubview:dot];
        [dot release];
        
        
        titleItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 271, 60)];
        titleItemLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        titleItemLabel.textAlignment = NSTextAlignmentCenter;
        titleItemLabel.textColor = [UIColor whiteColor];
        titleItemLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleItemLabel];
        
        popup = [[UIImageView alloc] initWithImage:[self popupBackgroundImage]];
        popup.frame = CGRectMake(abs((self.frame.size.width-271)/2.0), 385, 271, 72);
        [popup addSubview:titleItemLabel];
        popup.alpha = 0.0;
        [self addSubview:popup];
        
    }
    return self;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(UIImage*) backgroundImage{
    
    if(!datasource)
        return nil;
    
    float diameter = self.frame.size.width - 2*kShadowBrur;
    
    float x = (self.frame.size.width - diameter)/2;
    float y = (self.frame.size.width - diameter)/2;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width,self.frame.size.width));
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.bounds);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGContextSetRGBFillColor(ctx, kBackgroundColor.red, kBackgroundColor.green, kBackgroundColor.blue, kBackgroundColor.alpha);  // white color
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), kShadowBrur);
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter, diameter));
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
    
    float nextStartDeg = 0;
    float endDeg = 0;
    
    for (int i=0; i<[datasource numberOfItemsInMenuView:self]; i++){
        endDeg = nextStartDeg+360/[datasource numberOfItemsInMenuView:self];
        
        CGContextSetRGBStrokeColor(ctx, kLineColor.red, kLineColor.green, kLineColor.blue, kLineColor.alpha);
        CGContextSetLineWidth(ctx, kLineWidth);
        CGContextMoveToPoint(ctx, origin_x, origin_y);
        CGContextAddArc(ctx, origin_x, origin_y, inner_radius, degreesToRadians(nextStartDeg+kStartDegree), degreesToRadians(endDeg+kStartDegree), 0);
  
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        
        nextStartDeg = endDeg;
    }
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(UIImage*) selectedBackgroundImage{
    if(!datasource)
        return nil;
    
    float diameter = self.frame.size.width - 2*kShadowBrur+1;
    
    float x = (self.frame.size.width - diameter)/2;
    float y = (self.frame.size.width - diameter)/2;
    float inner_radius = diameter/2;
    float origin_x = x + diameter/2;
    float origin_y = y + diameter/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width,self.frame.size.width));
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.bounds);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
       
    float nextStartDeg = 0;
    float endDeg = 360/[datasource numberOfItemsInMenuView:self];
    
    CGContextSetRGBFillColor(ctx, kSelectedItemColor.red, kSelectedItemColor.green, kSelectedItemColor.blue, kSelectedItemColor.alpha);
    CGContextMoveToPoint(ctx, origin_x, origin_y);
    CGContextAddArc(ctx, origin_x, origin_y, inner_radius, degreesToRadians(nextStartDeg+kStartDegree), degreesToRadians(endDeg+kStartDegree), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(UIImage*) centerCircleImage{
    
    float diameter = self.frame.size.width - 2*kShadowBrur;
    
    float x = (self.frame.size.width - diameter*0.2)/2;
    float y = (self.frame.size.width - diameter*0.2)/2;
    
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width,self.frame.size.width));
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.bounds);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, kLineColor.red, kLineColor.green, kLineColor.blue, kLineColor.alpha);
    CGContextSetLineWidth(ctx, kLineWidth+1);
    CGContextSetRGBFillColor(ctx, kBackgroundColor.red, kBackgroundColor.green, kBackgroundColor.blue, kBackgroundColor.alpha);
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, diameter*0.2, diameter*0.2));
    CGContextStrokeEllipseInRect(ctx, CGRectMake(x, y, diameter*0.2, diameter*0.2));
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(UIImage*) popupBackgroundImage{

    float margin = 8.0 ;
    CGSize triangleSize = CGSizeMake(32, 10);
    CGSize rectangleSize = CGSizeMake( kPopupSize.width-margin*2, kPopupSize.height-margin*2-triangleSize.height);
    
    UIGraphicsBeginImageContext(kPopupSize);
    CGContextClearRect(UIGraphicsGetCurrentContext(), self.bounds);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBStrokeColor(ctx, kLineColor.red, kLineColor.green, kLineColor.blue, kLineColor.alpha);
    CGContextSetLineWidth(ctx, kLineWidth);
    CGContextSetRGBFillColor(ctx, kSelectedItemColor.red, kSelectedItemColor.green, kSelectedItemColor.blue, kSelectedItemColor.alpha);
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), margin-2);
    
    float x0 = margin;
    float x1 = margin + rectangleSize.width;
    float y0 = margin + triangleSize.height;
    float y1 = margin + triangleSize.height + rectangleSize.height;
    
    CGContextMoveToPoint(ctx, x0, y0);
    CGContextAddLineToPoint(ctx, margin+abs((rectangleSize.width-triangleSize.width)/2.0), y0);
    CGContextAddLineToPoint(ctx, margin+abs(rectangleSize.width/2.0), margin);
    CGContextAddLineToPoint(ctx, margin+abs((rectangleSize.width+triangleSize.width)/2.0), y0);
    CGContextAddLineToPoint(ctx, x1, y0);
    CGContextAddLineToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x0, y1);
    CGContextAddLineToPoint(ctx, x0, y0);
    
    CGContextFillPath(ctx);
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void) reloadData{
    
    if(datasource==nil)
        return;
    
    backgroundImageView.image = [self backgroundImage];
    selectedItemBackgroundImageView.image = [self selectedBackgroundImage];
    
    selectedItemBackgroundImageView.alpha = 0.0;
    selectedItemBackgroundImageView.transform = CGAffineTransformIdentity;
    backgroundImageView.transform = CGAffineTransformIdentity;
    
    selectedItemIndex = finalPositionOfSelectedItem;
    
    if(items){
        [items makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [items release];
    }
    
    items = [[NSMutableArray alloc] initWithCapacity:4];
    
    float portion = 360.0 / [datasource numberOfItemsInMenuView:self];
    float degrees = abs(portion/2.0)+kStartDegree;
    CGPoint center = CGPointMake(selectedItemBackgroundImageView.frame.size.width/2, selectedItemBackgroundImageView.frame.size.height/2);
    
    for(int index = 0 ; index < [datasource numberOfItemsInMenuView:self]; index++){
        float xx = center.x + radioOfItems * cosf(degreesToRadians(degrees));
        float yy = center.y + radioOfItems * sinf(degreesToRadians(degrees));
        
        UIImage *image = [datasource menu:self imageForItemAtIndex:index];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateHighlighted];
        [btn setImage:[datasource menu:self imageForSelectedItemAtIndex:index] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(itemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, kIconSize, kIconSize);
        btn.center = CGPointMake(xx, yy);
        btn.tag = degrees-abs(portion/2.0)-kStartDegree;
        [backgroundImageView addSubview:btn];
        [items addObject:btn];
        degrees+=portion;
    }
    
    backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , degreesToRadians(deltaAngle));
    [self adjustItemsToAngle:degreesToRadians(deltaAngle)];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(int) distanceToOriginPosition:(int) pos{
    
    //antihorario
    if(pos>=finalPositionOfSelectedItem)
        return pos - finalPositionOfSelectedItem;
    else return ([datasource numberOfItemsInMenuView:self]-finalPositionOfSelectedItem)+pos;
    
    /*
     //horario
     if(pos>finalPositionOfSelectedItem)
     return 4-pos + finalPositionOfSelectedItem;
     else return finalPositionOfSelectedItem-pos;
     */
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void) adjustItemsToAngle:(float) angle{
    for(UIView *item in items)
        item.transform = CGAffineTransformRotate(item.transform , angle);
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)selectItemAtIndex:(int) index animated:(BOOL) animated{
    
    enabled=FALSE;
    [self hidePopup];
    
    selectedItemBackgroundImageView.alpha = 1;
    float portion = 360.0 / [datasource numberOfItemsInMenuView:self];
    
    ((UIButton*)[items objectAtIndex:selectedItemIndex]).selected=NO;
    ((UIButton*)[items objectAtIndex:index]).selected=YES;
    
    if(delegate && [delegate respondsToSelector:@selector(menu:willSelectItemAtIndex:)])
        [delegate menu:self willSelectItemAtIndex:index];
    
    float degrees = ([self distanceToOriginPosition:selectedItemIndex]-[self distanceToOriginPosition:index])*portion;
    
    if(direction==kRotateCounterClockwise){
        if(degrees>0)
            degrees=-360+degrees;
        
    }else if(direction==kRotateClockwise){
        if(degrees<0)
            degrees=360+degrees;
    }else if(direction==kRotateToTheNearest){
        
        if(degrees<-180)
            degrees=360+degrees;
        else if(degrees>180)
            degrees=degrees-360;
    }
    
    selectedItemBackgroundImageView.transform = CGAffineTransformMakeRotation(degreesToRadians(index*portion));
    
    float duration = kAnimationVelocity * (fabs(degrees)/portion);
    selectedItemIndex = index;
    
    if(!animated){
        backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , degreesToRadians(degrees));
        [self adjustItemsToAngle:degreesToRadians(-degrees)];
        [self showPopup];
        return;
    }
    
    if(direction==kRotateToTheNearest){
        float scale = 1.06;
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            selectedItemBackgroundImageView.transform = CGAffineTransformScale(selectedItemBackgroundImageView.transform,scale, scale);
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , degreesToRadians(degrees)-0.01);
                [self adjustItemsToAngle:degreesToRadians(-degrees)+0.01];
                
            } completion:^(BOOL finished){
                
                backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , +0.01);
                [self adjustItemsToAngle:-0.01];
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    selectedItemBackgroundImageView.transform = CGAffineTransformScale(selectedItemBackgroundImageView.transform,1.0/scale, 1.0/scale);
                } completion:^(BOOL finished){
                    [self showPopup];
                }];
            }];
        }];
        
        return;
    }
    
    [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , degreesToRadians(degrees/2.0));
        [self adjustItemsToAngle:(degreesToRadians(-degrees/2.0))];
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            backgroundImageView.transform=CGAffineTransformRotate(backgroundImageView.transform , degreesToRadians(degrees/2.0));
            [self adjustItemsToAngle:(degreesToRadians(-degrees/2.0))];
            
        } completion:^(BOOL finished){
            [self showPopup];
        }];
        
    }];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void) showPopup{
    
    titleItemLabel.text = [datasource menu:self titleForItemAtIndex:selectedItemIndex];
    popup.alpha=1.0;
    
    float duration = 0.4;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:.5f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.85f],
                    [NSNumber numberWithFloat:1.f],
                    nil];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.duration = duration * .4f;
    fadeIn.fromValue = [NSNumber numberWithFloat:0.f];
    fadeIn.toValue = [NSNumber numberWithFloat:1.f];
    fadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fadeIn.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeIn, nil]];
    group.delegate = self;
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    group.fillMode = kCAFillModeBoth;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [popup.layer addAnimation:group forKey:@"PopInAnimation"];
    
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
    enabled=TRUE;
    if(delegate && [delegate respondsToSelector:@selector(menu:didSelectItemAtIndex:)])
        [delegate menu:self didSelectItemAtIndex:selectedItemIndex];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void) hidePopup{
    
    if(!selectedItemBackgroundImageView.alpha)
        return;
    
    popup.alpha=0.0;
    float duration = 0.3;
    CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = duration;
    scale.removedOnCompletion = NO;
    scale.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.f],
                    [NSNumber numberWithFloat:1.2f],
                    [NSNumber numberWithFloat:.75f],
                    nil];
    
    CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOut.duration = duration * .4f;
    fadeOut.fromValue = [NSNumber numberWithFloat:1.f];
    fadeOut.toValue = [NSNumber numberWithFloat:0.f];
    fadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fadeOut.beginTime = duration * .6f;
    fadeOut.fillMode = kCAFillModeBoth;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = [NSArray arrayWithArray:[NSArray arrayWithObjects:scale, fadeOut, nil]];
    group.duration = duration;
    group.removedOnCompletion = YES;
    
    group.fillMode = kCAFillModeBoth;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [popup.layer addAnimation:group forKey:@"PopOutAnimation"];
    
}
//------------------------------------------------------------------------------------------------------------------------------------------------
-(void) itemButtonAction:(id)sender{
    
    if(!enabled)
        return;
    
    UIButton *btn = (UIButton*) sender;
    float portion = 360.0 / [datasource numberOfItemsInMenuView:self];
    [self selectItemAtIndex:btn.tag/portion animated:YES];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dealloc {
    [popup release];
    [titleItemLabel release];
    [items release];
    [backgroundImageView release];
    [selectedItemBackgroundImageView release];
    [super dealloc];
}
//------------------------------------------------------------------------------------------------------------------------------------------------
@end
