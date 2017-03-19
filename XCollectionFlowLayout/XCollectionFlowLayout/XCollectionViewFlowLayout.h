//
//  XCollectionViewFlowLayout.h
//  XCollectionFlowLayout
//
//  Created by xlx on 17/3/19.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XCollectionViewFlowLayoutDataSource <NSObject>

-(CGFloat)XCollectionViewItem:(NSIndexPath *)indexPath;

@end

@interface XCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, ) int columnCount;    //定义列数

@property (nonatomic, ) CGFloat offset;     //列之间的间距

@property (nonatomic, weak) id<XCollectionViewFlowLayoutDataSource>dataSource;
@end
