//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

@implementation RatingView

-(void)setImagesDeselected:(NSString *)deselectedImage
			partlySelected:(NSString *)halfSelectedImage
			  fullSelected:(NSString *)fullSelectedImage
			   andDelegate:(id<RatingViewDelegate>)d {
	unselectedImage = [UIImage imageNamed:deselectedImage];
	partlySelectedImage = halfSelectedImage == nil ? unselectedImage : [UIImage imageNamed:halfSelectedImage];
	fullySelectedImage = [UIImage imageNamed:fullSelectedImage];
	viewDelegate = d;
	
	height=0.0; width=0.0;
	if (height < [fullySelectedImage size].height) {
		height = [fullySelectedImage size].height;
	}
	if (height < [partlySelectedImage size].height) {
		height = [partlySelectedImage size].height;
	}
	if (height < [unselectedImage size].height) {
		height = [unselectedImage size].height;
	}
	if (width < [fullySelectedImage size].width) {
		width = [fullySelectedImage size].width;
	}
	if (width < [partlySelectedImage size].width) {
		width = [partlySelectedImage size].width;
	}
	if (width < [unselectedImage size].width) {
		width = [unselectedImage size].width;
	}
	
	starRating = 0;
	lastRating = 0;
	self.s1 = [[UIImageView alloc] initWithImage:unselectedImage];
	self.s2 = [[UIImageView alloc] initWithImage:unselectedImage];
	self.s3 = [[UIImageView alloc] initWithImage:unselectedImage];
	self.s4 = [[UIImageView alloc] initWithImage:unselectedImage];
	self.s5 = [[UIImageView alloc] initWithImage:unselectedImage];
	
	[self.s1 setFrame:CGRectMake(0,         0, width, height)];
	[self.s2 setFrame:CGRectMake(width,     0, width, height)];
	[self.s3 setFrame:CGRectMake(2 * width, 0, width, height)];
	[self.s4 setFrame:CGRectMake(3 * width, 0, width, height)];
	[self.s5 setFrame:CGRectMake(4 * width, 0, width, height)];
	
	[self.s1 setUserInteractionEnabled:NO];
	[self.s2 setUserInteractionEnabled:NO];
	[self.s3 setUserInteractionEnabled:NO];
	[self.s4 setUserInteractionEnabled:NO];
	[self.s5 setUserInteractionEnabled:NO];
	
	[self addSubview:self.s1];
	[self addSubview:self.s2];
	[self addSubview:self.s3];
	[self addSubview:self.s4];
	[self addSubview:self.s5];
	
	CGRect frame = [self frame];
	frame.size.width = width * 5;
	frame.size.height = height;
	[self setFrame:frame];
}

-(void)displayRating:(float)rating {
	[self.s1 setImage:unselectedImage];
	[self.s2 setImage:unselectedImage];
	[self.s3 setImage:unselectedImage];
	[self.s4 setImage:unselectedImage];
	[self.s5 setImage:unselectedImage];
	
	if (rating >= 0.5) {
		[self.s1 setImage:partlySelectedImage];
	}
	if (rating >= 1) {
		[self.s1 setImage:fullySelectedImage];
	}
	if (rating >= 1.5) {
		[self.s2 setImage:partlySelectedImage];
	}
	if (rating >= 2) {
		[self.s2 setImage:fullySelectedImage];
	}
	if (rating >= 2.5) {
		[self.s3 setImage:partlySelectedImage];
	}
	if (rating >= 3) {
		[self.s3 setImage:fullySelectedImage];
	}
	if (rating >= 3.5) {
		[self.s4 setImage:partlySelectedImage];
	}
	if (rating >= 4) {
		[self.s4 setImage:fullySelectedImage];
	}
	if (rating >= 4.5) {
		[self.s5 setImage:partlySelectedImage];
	}
	if (rating >= 5) {
		[self.s5 setImage:fullySelectedImage];
	}
	
	starRating = rating;
	lastRating = rating;
	[viewDelegate ratingChanged:rating];
}

-(void) touchesBegan: (NSSet *)touches withEvent: (UIEvent *)event
{
	[self touchesMoved:touches withEvent:event];
}

-(void) touchesMoved: (NSSet *)touches withEvent: (UIEvent *)event
{
	CGPoint pt = [[touches anyObject] locationInView:self];
	int newRating = (int) (pt.x / width) + 1;
	if (newRating < 1 || newRating > 5)
		return;
	
	if (newRating != lastRating)
        //取整吧
		[self displayRating:(int)(newRating+0.5)];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self touchesMoved:touches withEvent:event];
}

-(float)rating {
	return starRating;
}

@end
