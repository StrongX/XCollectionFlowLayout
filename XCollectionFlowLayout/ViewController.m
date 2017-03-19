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

#define dataCount  20
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XCollectionViewFlowLayoutDataSource>

@end

@implementation ViewController
{
    UICollectionView *_collection;
    XCollectionViewFlowLayout *_layout;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _layout = [XCollectionViewFlowLayout new];
    _layout.columnCount = 3;
    _layout.offset = 10;
    _layout.dataSource = self;
    
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_layout];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [self randomColor];
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






























