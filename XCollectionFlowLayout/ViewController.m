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

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XCollectionViewFlowLayoutDataSource,XCollectionViewFlowLayoutDelegate>

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
        [_dataSource addObject:@{@"color":[self randomColor],@"height":@([self randomHeight])}];
    }
    
    _layout = [XCollectionViewFlowLayout new];
    _layout.columnCount = 3;
    _layout.offset = 10;
    _layout.dataSource = self;
    _layout.delegate = self;
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_layout];
    [_layout setCellCanMove];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    
}
-(void)moveEndOldIndexPath:(NSIndexPath *)OldIndexPath toMoveIndexPath:(NSIndexPath *)moveIndexPath{
    NSDictionary *temp = _dataSource[OldIndexPath.item];
    [_dataSource removeObjectAtIndex:OldIndexPath.item];
    [_dataSource insertObject:temp atIndex:moveIndexPath.item];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = _dataSource[indexPath.item];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = dict[@"color"];
    return cell;
}

-(UIColor *)randomColor{
    int r = random()%255;
    int g = random()%255;
    int b = random()%255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}
-(CGFloat)randomHeight{
    return random()%100+50;
}
-(CGFloat)XCollectionViewItem:(NSIndexPath *)indexPath{
    NSDictionary *data = _dataSource[indexPath.item];
    NSNumber *height = data[@"height"];
    return height.floatValue;
}
@end






























