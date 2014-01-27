//
//  BHDemoTableViewController.m
//  BHRevealTableViewCell
//
//  Created by Brian Hammond on 1/27/14.
//  Copyright (c) 2014 Fictorial. All rights reserved.
//

#import "BHDemoTableViewController.h"
#import "BHRevealTableViewCell.h"

@interface BHDemoTableViewController () <BHRevealTableViewCellDelegate>

@property(strong, nonatomic) NSMutableArray *rowTitles;

@end

@implementation BHDemoTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];

  if (self) {
    self.rowTitles = [NSMutableArray array];

    for (NSInteger i = 0; i < 100; i++) {
      [_rowTitles addObject:[NSString stringWithFormat:@"Row %d", i]];
    }

    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
      [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    self.tableView.separatorColor = [UIColor colorWithWhite:0.33 alpha:1];

    self.title = @"BHRevealTableViewCell Demo";
  }

  return self;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _rowTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  BHRevealTableViewCell *cell = (BHRevealTableViewCell *)
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (!cell) {
    cell =
        [[BHRevealTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:CellIdentifier];

    cell.delegate = self;

    cell.contentView.backgroundColor =
        [UIColor colorWithHue:(arc4random() % 255) / 255.0
                   saturation:0.25
                   brightness:1
                        alpha:1];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }

  cell.textLabel.text = _rowTitles[indexPath.row];
  cell.textLabel.backgroundColor = [UIColor clearColor];

  [self setRightViewForCell:cell indexPath:indexPath];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)setRightViewForCell:(BHRevealTableViewCell *)cell
                  indexPath:(NSIndexPath *)indexPath {

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
  label.backgroundColor = [UIColor redColor];
  label.textAlignment = NSTextAlignmentCenter;

  label.text = @"Remove";
  [label sizeToFit];

  CGRect bounds = label.bounds;
  bounds.size.width += 30;
  bounds.size.height =
      [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
  label.bounds = bounds;

  label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
  cell.rightView = label;
}

- (void)revealTableViewCell:(BHRevealTableViewCell *)cell didPan:(CGFloat)dx {
  UILabel *label = (UILabel *)cell.rightView;
  CGFloat percentage = -dx / label.bounds.size.width; // < 0 since pan left only
  CGFloat alpha = MIN(1, MAX(0, percentage));
  [label setAlpha:alpha];

  if (alpha == 1) {
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:17];
  } else {
    label.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    label.font = [UIFont systemFontOfSize:17];
  }
}

- (void)revealTableViewCellDidTrigger:(BHRevealTableViewCell *)cell {
  NSInteger row = [_rowTitles indexOfObject:cell.textLabel.text];
  [_rowTitles removeObjectAtIndex:row];

  NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:row inSection:0] ];

  [self.tableView deleteRowsAtIndexPaths:indexPaths
                        withRowAnimation:UITableViewRowAnimationLeft];
}

@end
