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
}
-(id)init{
    self = [super init];
    _cellInfo = [@[] mutableCopy];
    _maxYofCol = [@[] mutableCopy];
    return self;
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
