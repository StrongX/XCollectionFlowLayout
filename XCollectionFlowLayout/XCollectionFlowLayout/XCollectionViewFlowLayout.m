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
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
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
        { // 手势改变
            //当前手指位置 截图视图位置随着手指移动而移动
            CGPoint currentPoint = [longPress locationInView:self.collectionView];
            _snapshotView.center = currentPoint;
            // 计算截图视图和哪个可见cell相交
            for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
                // 当前隐藏的cell就不需要交换了,直接continue
                if ([self.collectionView indexPathForCell:cell] == _oldIndexPath) {
                    continue;
                }
                // 计算中心距
                CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
                // 如果相交一半就移动
                if (space <= _snapshotView.bounds.size.width / 2) {
                    _moveIndexPath = [self.collectionView indexPathForCell:cell];
                    //移动 会调用willMoveToIndexPath方法更新数据源
                    [self.collectionView moveItemAtIndexPath:_oldIndexPath toIndexPath:_moveIndexPath];
                    //设置移动后的起始indexPath
                    _oldIndexPath = _moveIndexPath;
                    break;
                }
            }
        }
            break;
        default:
        { // 手势结束和其他状态
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_oldIndexPath];
            // 结束动画过程中停止交互,防止出问题
            self.collectionView.userInteractionEnabled = NO;
            // 给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                _snapshotView.center = cell.center;
                _snapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                // 移除截图视图,显示隐藏的cell并开始交互
                [_snapshotView removeFromSuperview];
                cell.hidden = NO;
                self.collectionView.userInteractionEnabled = YES;
            }];
        }
            break;
    }
    
}
-(void)prepareLayout{
    [super prepareLayout];
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
    NSLog(@"%f",maxY);
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
