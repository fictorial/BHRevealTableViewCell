//
//  BHRevealTableViewCell.m
//  BHRevealTableViewCell
//
//  Created by Brian Hammond on 1/27/14.
//  Copyright (c) 2014 Fictorial. All rights reserved.
//

#import "BHRevealTableViewCell.h"

static const CGFloat kAnimationDuration = 0.33333;

@interface BHRevealTableViewCell () <UIGestureRecognizerDelegate>
@end

@implementation BHRevealTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {

  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

  if (self) {
    UIPanGestureRecognizer *panner =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(didPan:)];

    [self.contentView addGestureRecognizer:panner];

    panner.delegate = self;
  }
  return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {

  return YES;
}

- (void)prepareForReuse {
  [super prepareForReuse];

  [_rightView removeFromSuperview];

  CGRect frame = self.contentView.frame;
  frame.origin = CGPointZero;
  self.contentView.frame = frame;
}

- (void)setRightView:(UIView *)rightView {
  [_rightView removeFromSuperview];

  if (rightView != _rightView) {
    _rightView = rightView;
    [self addSubview:rightView];
    self.rightView.alpha = 0;
  }
}

- (void)layoutSubviews {
  [super layoutSubviews];

  if (self.rightView) {
    CGRect frame = self.rightView.frame;
    frame.origin = CGPointMake(
        self.bounds.size.width - self.rightView.bounds.size.width, 0);
    self.rightView.frame = frame;
    [self sendSubviewToBack:_rightView];
  }
}

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
  CGRect frame = self.contentView.frame;

  if (recognizer.state == UIGestureRecognizerStateCancelled ||
      recognizer.state == UIGestureRecognizerStateFailed) {

    frame.origin = CGPointMake(0, frame.origin.y);

    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                       self.contentView.frame = frame;
                       self.rightView.alpha = 0;
                     }];

    return;
  }

  if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [recognizer translationInView:self.contentView];
    CGFloat dx = MAX(-_rightView.bounds.size.width, MIN(0, translation.x));
    frame.origin = CGPointMake(dx, 0);
    self.contentView.frame = frame;

    [self.delegate revealTableViewCell:self didPan:translation.x];
    return;
  }

  if (recognizer.state == UIGestureRecognizerStateEnded) {
    if (CGRectGetMaxX(self.contentView.frame) <=
        CGRectGetMinX(_rightView.frame)) {
      [self.delegate revealTableViewCellDidTrigger:self];
    }

    frame.origin = CGPointMake(0, frame.origin.y);

    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                       self.contentView.frame = frame;
                       self.rightView.alpha = 0;
                     }];
  }
}

@end
