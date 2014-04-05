//
//  UIColor+Category.m
//
//  Created by sergio on 03/04/11.
//  Copyright 2011 Creative Coefficient All rights reserved.
//

#import "UIColor+Category.h"


@implementation UIColor (Category)
@dynamic red,green,blue,alpha;

-(CGFloat) red{    
    int n = CGColorGetNumberOfComponents(self.CGColor);
    
    if(n==0)
        return 0.0;
    
    const CGFloat *coms = CGColorGetComponents(self.CGColor);
    return  coms[0];
}

-(CGFloat) green{
    int n = CGColorGetNumberOfComponents(self.CGColor);
    
    if(n<2)
        return 0.0;
    
    const CGFloat *coms = CGColorGetComponents(self.CGColor);
    return  coms[1];
}

-(CGFloat) blue{
    int n = CGColorGetNumberOfComponents(self.CGColor);
    
    if(n<3)
        return 0.0;
    
    const CGFloat *coms = CGColorGetComponents(self.CGColor);
    return  coms[2];
}

-(CGFloat) alpha{
    int n = CGColorGetNumberOfComponents(self.CGColor);
    
    if(n<4)
        return 1.0;
    
    const CGFloat *coms = CGColorGetComponents(self.CGColor);
    return  coms[3];
}

@end
