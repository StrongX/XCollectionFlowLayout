//
//  ViewController.m
//  XCollectionFlowLayout
//
//  Created by xlx on 17/3/19.
//  Copyright © 2017年 xlx. All rights reserved.
//

#import "ViewController.h"
#import "XCollectionViewFlowLayout.h"



#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XCollectionViewFlowLayoutDataSource>

@end

@implementation ViewController
{
    UICollectionView *_collection;
    XCollectionViewFlowLayout *_layout;
    
    
    
    NSMutableArray *_dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _dataSource = [@[] mutableCopy];
    for(int i =0;i<100;i++){
        [_dataSource addObject:[self randomColor]];
    }
    
    _layout = [XCollectionViewFlowLayout new];
    _layout.columnCount = 3;
    _layout.offset = 10;
    _layout.dataSource = self;
    
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_layout];
    [_layout setCellCanMove];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //取出移动row数据
    id color = _dataSource[sourceIndexPath.row];
    //从数据源中移除该数据
    [_dataSource removeObject:color];
    //将数据插入到数据源中的目标位置
    [_dataSource insertObject:color atIndex:destinationIndexPath.row];
  
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = _dataSource[indexPath.item];
    return cell;
}

-(UIColor *)randomColor{
    int r = random()%255;
    int g = random()%255;
    int b = random()%255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}
-(CGFloat)XCollectionViewItem:(NSIndexPath *)indexPath{
    return indexPath.item*10+50;
}
@end






























