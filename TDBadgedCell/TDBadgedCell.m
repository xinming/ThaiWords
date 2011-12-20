//
//  TDBadgedCell.m
//  TDBadgedTableCell
//	TDBageView
//
//	Any rereleasing of this code is prohibited.
//	Please attribute use of this code within your application
//
//	Any Queries should be directed to hi@tmdvs.me | http://www.tmdvs.me
//	
//  Created by Tim on [Dec 30].
//  Copyright 2009 Tim Davies. All rights reserved.
//

#import "TDBadgedCell.h"

@interface TDBadgeView ()

@property (nonatomic, assign) NSUInteger width;

@end

@implementation TDBadgeView

@synthesize width, badgeString, parent, badgeColor, badgeColorHighlighted;


- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self)
	{		
		self.backgroundColor = [UIColor clearColor];
	}
	
	return self;	
}

- (void) drawRect:(CGRect)rect
{	
	NSString *countString = self.badgeString;
	
	CGSize numberSize = [countString sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
	
	self.width = numberSize.width + 16;
	
//	CGRect bounds = CGRectMake(0 , 0, numberSize.width + 14 , 18);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
//	float radius = bounds.size.height / 2.0;
	
//	CGContextSaveGState(context);
//	
	UIColor *col;
//	if (parent.highlighted || parent.selected) {
//		if (self.badgeColorHighlighted) {
//			col = self.badgeColorHighlighted;
//		} else {
//			col = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
//            fontColor = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
//		}
//	} else {
//		if (self.badgeColor) {
//			col = self.badgeColor;
//		} else {
//			col = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
//            fontColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
////			col = [UIColor colorWithRed:0.06 green:0.600 blue:0.91 alpha:1.000];
//		}
//	}
    col = self.badgeColor;
//
//	CGContextSetFillColorWithColor(context, [col CGColor]);
//	
//	CGContextBeginPath(context);
//	CGContextAddArc(context, radius, radius, radius, M_PI / 2 , 3 * M_PI / 2, NO);
//	CGContextAddArc(context, bounds.size.width - radius, radius, radius, 3 * M_PI / 2, M_PI / 2, NO);
//	CGContextClosePath(context);
//	CGContextFillPath(context);
//	CGContextRestoreGState(context);

    CGContextSaveGState(context);
    UIFont *dickBadgeFont = [UIFont boldSystemFontOfSize:11.0f];
    CGSize dickBadgeSize = [countString sizeWithFont:dickBadgeFont];
    CGFloat dickBadgePointY = lround((rect.size.height - dickBadgeSize.height) / 2);
    CGFloat dickBadgePointX = lround(rect.origin.x + rect.size.width - dickBadgePointY * 1.5 - dickBadgeSize.width);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat minX = dickBadgePointX - 10.0f;
    CGFloat maxX = dickBadgePointX + dickBadgeSize.width + 10.0f;
    CGFloat minY = dickBadgePointY - 5.0f;
    CGFloat maxY = dickBadgePointY + dickBadgeSize.height + 5.0f;
    
    CGPathMoveToPoint(path, NULL, minX, minY + 4.0f);
    CGPathAddArcToPoint(path, NULL, minX, minY, minX + 4.0f, minY , 4.0f);
    CGPathAddLineToPoint(path, NULL, maxX - 4.0f, minY);
    CGPathAddArcToPoint(path, NULL, maxX, minY, maxX, minY + 4.0f, 4.0f);
    CGPathAddLineToPoint(path, NULL, maxX, maxY - 4.0f);
    CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX - 4.0f, maxY, 4.0f);
    CGPathAddLineToPoint(path, NULL, minX + 4.0f, maxY);
    CGPathAddArcToPoint(path, NULL, minX, maxY, minX, maxY - 4.0f, 4.0f);
    CGPathAddLineToPoint(path, NULL, minX, minY + 4.0f);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
//    CGFloat colors[] =
//    {
//        1.0f, 0.957f, 0.573f, 1.0f,
//        0.996f, 0.843f, 0.506f, 1.0f,
//    };
    const CGFloat * comps = CGColorGetComponents([col CGColor]);
    CGFloat offset = 0.05;
    
    CGFloat colors[] =
    {
        comps[0] + offset, comps[1] + offset, comps[2] + offset, 1.0f,
        comps[0] - offset, comps[1] - offset, comps[2] - offset, 1.0f
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0., minY), CGPointMake(0., maxY), 0.);
    CGGradientRelease(gradient);                
    
    CFRelease(path);
    
//    [[UIColor colorWithRed:0.522f green:0.249f blue:0.208f alpha:1.0f] set];
    [[UIColor colorWithWhite:1.0 alpha:1.0] set];
    [countString drawAtPoint:CGPointMake(dickBadgePointX, dickBadgePointY) withFont:dickBadgeFont];
    CGContextRestoreGState(context);
    
    
//	bounds.origin.x = (bounds.size.width - numberSize.width) / 2 +0.5;
	
//	CGContextSetBlendMode(context, kCGBlendModeClear);
	
//	[countString drawInRect:bounds withFont:[UIFont boldSystemFontOfSize: 14]];
}

- (void) dealloc
{
	parent = nil;
	[badgeString release];
	[badgeColor release];
	[badgeColorHighlighted release];
	
	[super dealloc];
}

@end


@implementation TDBadgedCell

@synthesize badgeString, badge, badgeColor, badgeColorHighlighted;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		badge = [[TDBadgeView alloc] initWithFrame:CGRectZero];
		badge.parent = self;
		
		//redraw cells in accordance to accessory
		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		if (version <= 3.0)
			[self addSubview:self.badge];
		else 
			[self.contentView addSubview:self.badge];
		
		[self.badge setNeedsDisplay];
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
	if(self.badgeString)
	{
		//force badges to hide on edit.
		if(self.editing)
			[self.badge setHidden:YES];
		else
			[self.badge setHidden:NO];
		
		
		CGSize badgeSize = [self.badgeString sizeWithFont:[UIFont boldSystemFontOfSize: 14]];
		
//		float version = [[[UIDevice currentDevice] systemVersion] floatValue];
		
		CGRect badgeframe;
		


        badgeframe = CGRectMake(self.contentView.frame.size.width - (badgeSize.width+16) - 20, 
                                round((self.contentView.frame.size.height - 28) / 2), 
                                badgeSize.width+26, 
                                28);

		
		[self.badge setFrame:badgeframe];
		[badge setBadgeString:self.badgeString];
		[badge setParent:self];
		
		if ((self.textLabel.frame.origin.x + self.textLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.textLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, badgeWidth, self.textLabel.frame.size.height);
		}
		
		if ((self.detailTextLabel.frame.origin.x + self.detailTextLabel.frame.size.width) >= badgeframe.origin.x)
		{
			CGFloat badgeWidth = self.detailTextLabel.frame.size.width - badgeframe.size.width - 10.0;
			
			self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, badgeWidth, self.detailTextLabel.frame.size.height);
		}
		//set badge highlighted colours or use defaults
		if(self.badgeColorHighlighted)
			badge.badgeColorHighlighted = self.badgeColorHighlighted;
		else 
			badge.badgeColorHighlighted = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.000];
		
		//set badge colours or impose defaults
		if(self.badgeColor)
			badge.badgeColor = self.badgeColor;
		else
			badge.badgeColor = [UIColor colorWithRed:0.530 green:0.600 blue:0.738 alpha:1.000];
	}
	else
	{
		[self.badge setHidden:YES];
	}
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[badge setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
	[badge setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[super setEditing:editing animated:animated];
	
	if (editing) {
		badge.hidden = YES;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
	else 
	{
		badge.hidden = NO;
		[badge setNeedsDisplay];
		[self setNeedsDisplay];
	}
}

- (void)dealloc {
	[badge release];
	[badgeColor release];
	[badgeString release];
	[badgeColorHighlighted release];
	
    [super dealloc];
}


@end