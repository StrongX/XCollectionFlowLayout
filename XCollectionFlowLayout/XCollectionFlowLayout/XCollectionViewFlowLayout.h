//
//  XCollectionViewFlowLayout.h
//  XCollectionFlowLayout
//
//  Created by xlx on 17/3/19.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XCollectionViewFlowLayoutDelegate <NSObject>

-(void)moveEndOldIndexPath:(NSIndexPath *)OldIndexPath toMoveIndexPath:(NSIndexPath *)moveIndexPath;

@end

@protocol XCollectionViewFlowLayoutDataSource <NSObject>

-(CGFloat)XCollectionViewItem:(NSIndexPath *)indexPath;

@end

@interface XCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, ) int columnCount;    //定义列数

@property (nonatomic, ) CGFloat offset;     //列之间的间距

@property (nonatomic, weak) id<XCollectionViewFlowLayoutDataSource>dataSource;

@property (nonatomic, weak) id<XCollectionViewFlowLayoutDelegate>delegate;

-(void)setCellCanMove;
@end
