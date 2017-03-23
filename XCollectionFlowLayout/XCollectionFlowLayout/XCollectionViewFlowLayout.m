//
//  XCollectionViewFlowLayout.m
//  XCollectionFlowLayout
//
//  Created by xlx on 17/3/19.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "XCollectionViewFlowLayout.h"

@implementation XCollectionViewFlowLayout
{
    NSMutableArray *_cellInfo;
    NSMutableArray *_maxYofCol;
    
    NSIndexPath *_oldIndexPath;
    UIView *_snapshotView;
    NSIndexPath *_moveIndexPath;
}
-(id)init{
    self = [super init];
    _cellInfo = [@[] mutableCopy];
    _maxYofCol = [@[] mutableCopy];
   
    
    return self;
}
-(void)setCellCanMove{
    if (self.collectionView) {
        // 添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
        [self.collectionView addGestureRecognizer:longPress];
    }else{
        NSLog(@"warning:please after init collection use this method");
    }
}
- (void)handlelongGesture:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [longPress locationInView:self.collectionView];
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            _oldIndexPath = indexPath;
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
            snapshotView.frame = cell.frame;
            [self.collectionView addSubview:_snapshotView = snapshotView];
            cell.hidden = YES;
            
            CGPoint currentPoint = [longPress locationInView:self.collectionView];
            [UIView animateWithDuration:0.25 animations:^{
                snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshotView.center = currentPoint;
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [longPress locationInView:self.collectionView];
            CGPoint offset = self.collectionView.contentOffset;
            if (currentPoint.y>offset.y+self.collectionView.frame.size.height-200) {
                CGFloat offsetY = offset.y+200;
                if (offsetY<self.collectionView.contentSize.height-self.collectionView.frame.size.height) {
                    [self.collectionView setContentOffset:CGPointMake(0, offsetY) animated:true];
                }else{
                    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height-self.collectionView.frame.size.height) animated:true];
                }
            }
            if (currentPoint.y<offset.y+200) {
                CGFloat offsetY = offset.y-200;
                if (offsetY>0) {
                    [self.collectionView setContentOffset:CGPointMake(0, offsetY) animated:true];
                }else{
                    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:true];
                }
            }
            _snapshotView.center = currentPoint;
            
            _moveIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            if (!_moveIndexPath) {
                return;
            }
            if (_moveIndexPath.item == _oldIndexPath.item) {
                return;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_moveIndexPath];
            CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
            if (space <= _snapshotView.bounds.size.width / 2) {
                _moveIndexPath = [self.collectionView indexPathForCell:cell];
                [self moveEndOldIndexPath:_oldIndexPath toMoveIndexPath:_moveIndexPath];
                [self.collectionView moveItemAtIndexPath:_oldIndexPath toIndexPath:_moveIndexPath];
                _oldIndexPath = _moveIndexPath;
                
                break;
            }

            
        /*    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                if ([self.collectionView indexPathForCell:cell] == _oldIndexPath) {
                    continue;
                }
                CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
                if (space <= _snapshotView.bounds.size.width / 2) {
                    _moveIndexPath = [self.collectionView indexPathForCell:cell];
               //     NSLog(@"%ld 与 %ld 交换",_oldIndexPath.item,_moveIndexPath.item);
                    [self replaceMoveIndexPath:_moveIndexPath withOldIndexPath:_oldIndexPath];
                    [self.collectionView moveItemAtIndexPath:_oldIndexPath toIndexPath:_moveIndexPath];
                    _oldIndexPath = _moveIndexPath;

                    break;
                }
            }*/
        }
            break;
        default:
        {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_oldIndexPath];
            self.collectionView.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.25 animations:^{
                _snapshotView.center = cell.center;
                _snapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                [_snapshotView removeFromSuperview];
                cell.hidden = NO;
                self.collectionView.userInteractionEnabled = YES;
            }];
        }
            break;
    }
    
}
-(void)moveEndOldIndexPath:(NSIndexPath *)OldIndexPath toMoveIndexPath:(NSIndexPath *)moveIndexPath{
    [_delegate moveEndOldIndexPath:OldIndexPath toMoveIndexPath:moveIndexPath];
    [self makeAttribute];
}

-(void)prepareLayout{
    [super prepareLayout];
    [self makeAttribute];
}
-(void)makeAttribute{
    [_cellInfo removeAllObjects];
    [_maxYofCol removeAllObjects];
    for(int i = 0;i<_columnCount;i++){
        _maxYofCol[i] = @(_offset);
    }
    NSInteger rowCout = [self.collectionView numberOfItemsInSection:0];
    for (int row = 0; row<rowCout; row++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
        UICollectionViewLayoutAttributes* attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGFloat width = self.collectionView.frame.size.width;
        CGFloat colWidth = (width-_offset*(_columnCount+1))/_columnCount;
        
        CGFloat height = [_dataSource XCollectionViewItem:indexPath];
        CGFloat minY = ((NSNumber *)_maxYofCol.firstObject).floatValue;
        int minCol = 0;
        for (int i = 0; i<_columnCount; i++) {
            NSNumber *Y = _maxYofCol[i];
            if (Y.floatValue<minY) {
                minY = Y.floatValue;
                minCol = i;
            }
        }
        _maxYofCol[minCol] = @(height+minY+_offset);
        
        attr.frame= CGRectMake((_offset+colWidth)*minCol+_offset, minY, colWidth, height);
        [_cellInfo addObject:attr];
        
    }

}
-(CGSize)collectionViewContentSize{
    CGFloat maxY = 0;
    for (NSNumber *Y in _maxYofCol) {
        if (Y.floatValue>maxY) {
            maxY = Y.floatValue;
        }
    }
    return CGSizeMake(self.collectionView.frame.size.width, MAX(maxY, self.collectionView.frame.size.height));
}
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = _cellInfo[indexPath.item];
    return attr;
}
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return _cellInfo;
}

@end
