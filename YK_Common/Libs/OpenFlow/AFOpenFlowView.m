/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
#import "AFOpenFlowView.h"
#import "AFOpenFlowConstants.h"
#import "AFUIImageReflection.h"


@interface AFOpenFlowView (hidden)

- (void)setUpInitialState;
- (AFItemView *)coverForIndex:(int)coverIndex;
- (void)updateCoverImage:(AFItemView *)aCover;
- (AFItemView *)dequeueReusableCover;
- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound;
- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated;
- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer;

@end

@implementation AFOpenFlowView (hidden)

const static CGFloat kReflectionFraction = 0.05;

- (void)setUpInitialState {
	// Set up the default image for the coverflow.
	self.defaultImage = [self.dataSource defaultImage];
	
	// Create data holders for onscreen & offscreen covers & UIImage objects.
	m_dict_coverImages = [[NSMutableDictionary alloc] init];
	m_dict_coverImageHeights = [[NSMutableDictionary alloc] init];
	m_set_offscreenCovers = [[NSMutableSet alloc] init];
	m_dict_onscreenCovers = [[NSMutableDictionary alloc] init];
	
	scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
	scrollView.userInteractionEnabled = NO;
	scrollView.multipleTouchEnabled = NO;
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self addSubview:scrollView];
	
	self.multipleTouchEnabled = NO;
	self.userInteractionEnabled = YES;
	self.autoresizesSubviews = YES;
	self.layer.position=CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
	
	// Initialize the visible and selected cover range.
	m_int_lowerVisibleCover = m_int_upperVisibleCover = -1;
	m_AFItemView_selectedCoverView = nil;
	
	// Set up the cover's left & right transforms.
	leftTransform = CATransform3DIdentity;
	leftTransform = CATransform3DRotate(leftTransform, SIDE_COVER_ANGLE, 0.0f, 1.0f, 0.0f);
	rightTransform = CATransform3DIdentity;
	rightTransform = CATransform3DRotate(rightTransform, SIDE_COVER_ANGLE, 0.0f, -1.0f, 0.0f);
	
	// Set some perspective
	CATransform3D sublayerTransform = CATransform3DIdentity;
	sublayerTransform.m34 = -0.01;
	[scrollView.layer setSublayerTransform:sublayerTransform];
	
	[self setBounds:self.frame];
}

- (AFItemView *)coverForIndex:(int)coverIndex 
{
	AFItemView *coverView = [self dequeueReusableCover];
	if (!coverView)
		coverView = [[[AFItemView alloc] initWithFrame:CGRectZero] autorelease];
	
	coverView.number = coverIndex;
	
	return coverView;
}

- (void)updateCoverImage:(AFItemView *)aCover {
	NSNumber *coverNumber = @(aCover.number);
	UIImage *coverImage = (UIImage *)[m_dict_coverImages objectForKey:coverNumber];
	if (coverImage) {
		NSNumber *coverImageHeightNumber = (NSNumber *)[m_dict_coverImageHeights objectForKey:coverNumber];
		if (coverImageHeightNumber)
			[aCover setImage:coverImage originalImageHeight:[coverImageHeightNumber floatValue] reflectionFraction:kReflectionFraction];
	} else {
		[aCover setImage:defaultImage originalImageHeight:defaultImageHeight reflectionFraction:kReflectionFraction];
		[self.dataSource openFlowView:self requestImageForIndex:aCover.number];
	}
}

- (AFItemView *)dequeueReusableCover {
	AFItemView *aCover = [m_set_offscreenCovers anyObject];
	if (aCover) {
		[[aCover retain] autorelease];
		[m_set_offscreenCovers removeObject:aCover];
	}
	return aCover;
}

- (void)layoutCover:(AFItemView *)aCover selectedCover:(int)selectedIndex animated:(Boolean)animated  
{
	int coverNumber = aCover.number;
	CATransform3D newTransform;
	CGFloat newZPosition = SIDE_COVER_ZPOSITION;
	CGPoint newPosition;
	
	newPosition.x = halfScreenWidth + aCover.horizontalPosition;
	newPosition.y = halfScreenHeight + aCover.verticalPosition;
	if (coverNumber < selectedIndex) {
		newPosition.x -= CENTER_COVER_OFFSET;
		newTransform = leftTransform;
	} else if (coverNumber > selectedIndex) {
		newPosition.x += CENTER_COVER_OFFSET;
		newTransform = rightTransform;
	} else {
		newZPosition = 0;
		newTransform = CATransform3DIdentity;
	}
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationBeginsFromCurrentState:YES];
	}
	
	aCover.layer.transform = newTransform;
	aCover.layer.zPosition = newZPosition;
	aCover.layer.position = newPosition;
	
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutCovers:(int)selected fromCover:(int)lowerBound toCover:(int)upperBound {
	AFItemView *cover;
	NSNumber *coverNumber;
	for (int i = lowerBound; i <= upperBound; i++) {
		coverNumber = [[NSNumber alloc] initWithInt:i];
		cover = (AFItemView *)[m_dict_onscreenCovers objectForKey:coverNumber];
		[coverNumber release];
		[self layoutCover:cover selectedCover:selected animated:YES];
	}
}

- (AFItemView *)findCoverOnscreen:(CALayer *)targetLayer {
	// See if this layer is one of our covers.
	NSEnumerator *coverEnumerator = [m_dict_onscreenCovers objectEnumerator];
	AFItemView *aCover = nil;
	while (aCover = (AFItemView *)[coverEnumerator nextObject])
		if ([[aCover.imageView layer] isEqual:targetLayer])
			break;
	
	return aCover;
}
@end


#pragma mark -
@implementation AFOpenFlowView
@synthesize dataSource, viewDelegate, numberOfImages, defaultImage, m_AFItemView_selectedCoverView;

#define COVER_BUFFER 6

- (void)awakeFromNib {
	[self setUpInitialState];
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self setUpInitialState];
	}
	
	return self;
}

- (void)dealloc {
#ifdef GUWEI_MEMTEST
	NSLog(@"DeBug mark ============Dealloc Trace================");
	NSLog(@"%@ dealloc", self );
	NSLog(@"DeBug mark ================End======================");
#endif
	[defaultImage release];
	[scrollView release];
	
	[m_dict_coverImages release];
	[m_dict_coverImageHeights release];
	[m_set_offscreenCovers removeAllObjects];
	[m_set_offscreenCovers release];
	
	[m_dict_onscreenCovers removeAllObjects];
	[m_dict_onscreenCovers release];
	
	[super dealloc];
}

- (void)setBounds:(CGRect)newSize {
	[super setBounds:newSize];
	
	halfScreenWidth = self.bounds.size.width / 2;
	halfScreenHeight = self.bounds.size.height / 2;

	int lowerBound = MAX(-1, m_AFItemView_selectedCoverView.number - COVER_BUFFER);
	int upperBound = MIN(self.numberOfImages - 1, m_AFItemView_selectedCoverView.number + COVER_BUFFER);

	[self layoutCovers:m_AFItemView_selectedCoverView.number fromCover:lowerBound toCover:upperBound];
	[self centerOnSelectedCover:NO];
}

- (void)setNumberOfImages:(int)newNumberOfImages {
	numberOfImages = newNumberOfImages;
	scrollView.contentSize = CGSizeMake(newNumberOfImages * COVER_SPACING + self.bounds.size.width, self.bounds.size.height);

	int lowerBound = MAX(0, m_AFItemView_selectedCoverView.number - COVER_BUFFER);
	int upperBound = MIN(self.numberOfImages - 1, m_AFItemView_selectedCoverView.number + COVER_BUFFER);
	
	if (m_AFItemView_selectedCoverView)
		[self layoutCovers:m_AFItemView_selectedCoverView.number fromCover:lowerBound toCover:upperBound];
	else
		[self setSelectedCover:0];
	
	[self centerOnSelectedCover:NO];
}

- (void)setDefaultImage:(UIImage *)newDefaultImage {
	[defaultImage release];
	defaultImageHeight = newDefaultImage.size.height;
	defaultImage = [[newDefaultImage addImageReflection:kReflectionFraction] retain];
	//defaultImage = [newDefaultImage retain];
}

- (void)setImage:(UIImage *)image forIndex:(int)index {
	// Create a reflection for this image.
	UIImage *imageWithReflection = image;//[image addImageReflection:kReflectionFraction];
	NSNumber *coverNumber = @(index);
	[m_dict_coverImages setObject:imageWithReflection forKey:coverNumber];
	[m_dict_coverImageHeights setObject:@(image.size.height) forKey:coverNumber];
	
	// If this cover is onscreen, set its image and call layoutCover.
	AFItemView *aCover = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(index)];
	if (aCover) {
		[aCover setImage:imageWithReflection originalImageHeight:image.size.height reflectionFraction:kReflectionFraction];
		[self layoutCover:aCover selectedCover:m_AFItemView_selectedCoverView.number animated:NO];
	}
}

#pragma mark -
#pragma mark - touches event
BOOL isTouchMove;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	CGPoint startPoint = [[touches anyObject] locationInView:self];
	isTouchMove = NO;
	isDraggingACover = NO;
	
	// Which cover did the user tap?
	CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:startPoint];
	AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
	isDraggingACover = (targetCover != nil);

	m_int_beginningCover = m_AFItemView_selectedCoverView.number;
	// Make sure the user is tapping on a cover.
	startPosition = (startPoint.x / 4.0) + scrollView.contentOffset.x;
	
	if (isSingleTap)
		isDoubleTap = YES;
		
	isSingleTap = ([touches count] == 1);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	isSingleTap = NO;
	isDoubleTap = NO;
	isTouchMove = YES;
	
	// Only scroll if the user started on a cover.
	if (!isDraggingACover)
		return;
	
	CGPoint movedPoint = [[touches anyObject] locationInView:self];
	CGFloat offset = startPosition - (movedPoint.x / 4.0);
	CGPoint newPoint = CGPointMake(offset, 0);
	scrollView.contentOffset = newPoint;
	int newCover = offset / COVER_SPACING;
	if (newCover != m_AFItemView_selectedCoverView.number) 
	{
		if (newCover < 0)
			[self setSelectedCover:0];
		else if (newCover >= self.numberOfImages)
			[self setSelectedCover:self.numberOfImages - 1];
		else
			[self setSelectedCover:newCover];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (isSingleTap) 
	{
		// Which cover did the user tap?
		CGPoint targetPoint = [[touches anyObject] locationInView:self];
		CALayer *targetLayer = (CALayer *)[scrollView.layer hitTest:targetPoint];
		AFItemView *targetCover = [self findCoverOnscreen:targetLayer];
		if (targetCover && (targetCover.number != m_AFItemView_selectedCoverView.number))
		{
			[self setSelectedCover:targetCover.number];
		}
		else
		{
			if([self.viewDelegate respondsToSelector:@selector(openFlowView:clickSelected:)])
			{
				[self.viewDelegate openFlowView:self clickSelected:m_AFItemView_selectedCoverView.number];
			}
		}
		
	}
	[self centerOnSelectedCover:YES];
	
	// And send the delegate the newly selected cover message.
	if (m_int_beginningCover != m_AFItemView_selectedCoverView.number)
		if ([self.viewDelegate respondsToSelector:@selector(openFlowView:selectionDidChange:)])
			[self.viewDelegate openFlowView:self selectionDidChange:m_AFItemView_selectedCoverView.number];
}

#pragma mark -
- (void)centerOnSelectedCover:(BOOL)animated {
	CGPoint selectedOffset = CGPointMake(COVER_SPACING * m_AFItemView_selectedCoverView.number, 0);
	[scrollView setContentOffset:selectedOffset animated:animated];
}


- (void)setSelectedCover:(int)newSelectedCover 
{
	if (m_AFItemView_selectedCoverView && (newSelectedCover == m_AFItemView_selectedCoverView.number))
		return;
	
	AFItemView *cover;
	int newLowerBound = MAX(0, newSelectedCover - COVER_BUFFER);
	int newUpperBound = MIN(self.numberOfImages - 1, newSelectedCover + COVER_BUFFER);
	if (!m_AFItemView_selectedCoverView) {
		// Allocate and display covers from newLower to newUpper bounds.
		for (int i=newLowerBound; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[m_dict_onscreenCovers setObject:cover forKey:@(i)];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			//[scrollView addSubview:cover];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		
		m_int_lowerVisibleCover = newLowerBound;
		m_int_upperVisibleCover = newUpperBound;
		m_AFItemView_selectedCoverView = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(newSelectedCover)];
		
		return;
	}
	
	// Check to see if the new & current ranges overlap.
	if ((newLowerBound > m_int_upperVisibleCover) || (newUpperBound < m_int_lowerVisibleCover)) {
		// They do not overlap at all.
		// This does not animate--assuming it's programmatically set from view controller.
		// Recycle all onscreen covers.
		AFItemView *cover;
		for (int i = m_int_lowerVisibleCover; i <= m_int_upperVisibleCover; i++) {
			cover = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(i)];
			[m_set_offscreenCovers addObject:cover];
			[cover removeFromSuperview];
			[m_dict_onscreenCovers removeObjectForKey:@(cover.number)];
		}
			
		// Move all available covers to new location.
		for (int i=newLowerBound; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[m_dict_onscreenCovers setObject:cover forKey:@(i)];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
		}

		m_int_lowerVisibleCover = newLowerBound;
		m_int_upperVisibleCover = newUpperBound;
		m_AFItemView_selectedCoverView = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(newSelectedCover)];
		[self layoutCovers:newSelectedCover fromCover:newLowerBound toCover:newUpperBound];
		
		return;
	} else if (newSelectedCover > m_AFItemView_selectedCoverView.number) {
		// Move covers that are now out of range on the left to the right side,
		// but only if appropriate (within the range set by newUpperBound).
		for (int i=m_int_lowerVisibleCover; i < newLowerBound; i++) {
			cover = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(i)];
			if (m_int_upperVisibleCover < newUpperBound) {
				// Tack it on the right side.
				m_int_upperVisibleCover++;
				cover.number = m_int_upperVisibleCover;
				[self updateCoverImage:cover];
				[m_dict_onscreenCovers setObject:cover forKey:@(cover.number)];
				[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
			} else {
				// Recycle this cover.
				[m_set_offscreenCovers addObject:cover];
				[cover removeFromSuperview];
			}
			[m_dict_onscreenCovers removeObjectForKey:@(i)];
		}
		m_int_lowerVisibleCover = newLowerBound;
		
		// Add in any missing covers on the right up to the newUpperBound.
		for (int i=m_int_upperVisibleCover + 1; i <= newUpperBound; i++) {
			cover = [self coverForIndex:i];
			[m_dict_onscreenCovers setObject:cover forKey:@(i)];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		m_int_upperVisibleCover = newUpperBound;
	} else {
		// Move covers that are now out of range on the right to the left side,
		// but only if appropriate (within the range set by newLowerBound).
		for (int i=m_int_upperVisibleCover; i > newUpperBound; i--) {
			cover = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(i)];
			if (m_int_lowerVisibleCover > newLowerBound) {
				// Tack it on the left side.
				m_int_lowerVisibleCover --;
				cover.number = m_int_lowerVisibleCover;
				[self updateCoverImage:cover];
				[m_dict_onscreenCovers setObject:cover forKey:@(m_int_lowerVisibleCover)];
				[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
			} else {
				// Recycle this cover.
				[m_set_offscreenCovers addObject:cover];
				[cover removeFromSuperview];
			}
			[m_dict_onscreenCovers removeObjectForKey:@(i)];
		}
		m_int_upperVisibleCover = newUpperBound;
		
		// Add in any missing covers on the left down to the newLowerBound.
		for (int i=m_int_lowerVisibleCover - 1; i >= newLowerBound; i--) {
			cover = [self coverForIndex:i];
			[m_dict_onscreenCovers setObject:cover forKey:@(i)];
			[self updateCoverImage:cover];
			[scrollView.layer addSublayer:cover.layer];
			//[scrollView addSubview:cover];
			[self layoutCover:cover selectedCover:newSelectedCover animated:NO];
		}
		m_int_lowerVisibleCover = newLowerBound;
	}

	if (m_AFItemView_selectedCoverView.number > newSelectedCover)
		[self layoutCovers:newSelectedCover fromCover:newSelectedCover toCover:m_AFItemView_selectedCoverView.number];
	else if (newSelectedCover > m_AFItemView_selectedCoverView.number)
		[self layoutCovers:newSelectedCover fromCover:m_AFItemView_selectedCoverView.number toCover:newSelectedCover];
	
	m_AFItemView_selectedCoverView = (AFItemView *)[m_dict_onscreenCovers objectForKey:@(newSelectedCover)];
}

@end