//
//  BHRevealTableViewCell.h
//  BHRevealTableViewCell
//
//  Created by Brian Hammond on 1/27/14.
//  Copyright (c) 2014 Fictorial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BHRevealTableViewCell;

@protocol BHRevealTableViewCellDelegate <NSObject>

- (void)revealTableViewCell:(BHRevealTableViewCell *)cell didPan:(CGFloat)dx;
- (void)revealTableViewCellDidTrigger:(BHRevealTableViewCell *)cell;

@end

@interface BHRevealTableViewCell : UITableViewCell

@property(strong, nonatomic) UIView *rightView;
@property(weak, nonatomic) id<BHRevealTableViewCellDelegate> delegate;

@end
