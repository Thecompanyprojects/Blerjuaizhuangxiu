//
//  CelebrityInterviewsTypeSelected.m
//  iDecoration
//
//  Created by 张毅成 on 2018/6/20.
//  Copyright © 2018 RealSeven. All rights reserved.
//

#import "CelebrityInterviewsTypeSelected.h"

@implementation CelebrityInterviewsTypeSelected

- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self createTableView];
    CelebrityInterviewsTypeSelectedModel *model = [CelebrityInterviewsTypeSelectedModel new];
    self.arrayData = model.arrayData;
    [self.tableView reloadData];
}

- (void)createTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = 0;
    self.tableView.scrollEnabled = false;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CelebrityInterviewsTypeSelectedTableViewCell *cell = [CelebrityInterviewsTypeSelectedTableViewCell cellWithTableView:tableView];
    CelebrityInterviewsTypeSelectedModel *model = self.arrayData[indexPath.row];
    cell.labelTitle.text = model.title;
    cell.viewLine.hidden = !model.isSelected;
    [cell setBackgroundColor:model.isSelected?[UIColor hexStringToColor:@"f2f2f2"]:[UIColor whiteColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"");
    [self.arrayData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CelebrityInterviewsTypeSelectedModel *model = obj;
        model.isSelected = false;
        if (idx == indexPath.row) {
            model.isSelected = true;
        }
    }];
    [self.tableView reloadData];
    CelebrityInterviewsTypeSelectedModel *model = self.arrayData[indexPath.row];
    if (self.blockDidTouchCell) {
        self.blockDidTouchCell(model.title);
    }
    [self removeFromSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    static UIEvent *e = nil;

    if (e != nil && e == event) {
        e = nil;
        return [super hitTest:point withEvent:event];
    }

    e = event;

    if (event.type == UIEventTypeTouches) {
        NSSet *touches = [event touchesForView:self];
        UITouch *touch = [touches anyObject];
        if (touch.phase == UITouchPhaseBegan) {
            NSLog(@"Touches began");
            if (point.y > 130) {
                [self removeFromSuperview];
            }
        }else if(touch.phase == UITouchPhaseEnded){
            NSLog(@"Touches Ended");

        }else if(touch.phase == UITouchPhaseCancelled){
            NSLog(@"Touches Cancelled");

        }else if (touch.phase == UITouchPhaseMoved){
            NSLog(@"Touches Moved");
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
