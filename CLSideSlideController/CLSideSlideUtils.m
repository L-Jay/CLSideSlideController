//
//  CLSideSlideUtils.m
//  CLSideSlideController
//
//  Created by L on 14-3-18.
//  Copyright (c) 2014年 Cui. All rights reserved.
//

#import "CLSideSlideUtils.h"

#pragma mark - UINavigationController(CLSideSlid)
@implementation UINavigationController(CLSideSlid)

- (UIView *)contentView
{
    return [[self.view.subviews objectAtIndex:0] isKindOfClass:[UINavigationBar class]] ? [self.view.subviews objectAtIndex:1] : [self.view.subviews objectAtIndex:0];
}

- (UIViewController *)rootController
{
    if (self.viewControllers.count > 0)
        return [self.viewControllers objectAtIndex:0];
    
    return nil;
}

@end

#pragma mark - UIBarButtonItem(CLSideSlid)
@implementation UIBarButtonItem(CLSideSlid)

static char const * const animationChar = "animation";

- (void)setAnimation:(BOOL)animation
{
    NSNumber *number = [NSNumber numberWithBool:animation];
    objc_setAssociatedObject(self, animationChar, number, OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)animation
{
    NSNumber *number = objc_getAssociatedObject(self, animationChar);
    
    return [number boolValue];
}

@end


@implementation UIView(CLSideSlid)

- (CGFloat)ssMinX {
	return self.frame.origin.x;
}

- (void)setSsMinX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x;
	self.frame = frame;
}

- (CGFloat)ssMinY {
	return self.frame.origin.y;
}

- (void)setSsMinY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y;
	self.frame = frame;
}

- (CGFloat)ssMaxX {
	return self.frame.origin.x + self.frame.size.width;
}

- (void)setSsMaxX:(CGFloat)x {
	CGRect frame = self.frame;
	frame.origin.x = x - frame.size.width;
	self.frame = frame;
}

- (CGFloat)ssMaxY {
	return self.frame.origin.y + self.frame.size.height;
}

- (void)setSsMaxY:(CGFloat)y {
	CGRect frame = self.frame;
	frame.origin.y = y - frame.size.height;
	self.frame = frame;
}

- (CGFloat)ssWidth {
	return self.frame.size.width;
}

- (void)setSsWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (CGFloat)ssHeight {
	return self.frame.size.height;
}

- (void)setSsHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

@end

