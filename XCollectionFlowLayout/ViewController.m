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
    
    NSIndexPath *_oldIndexPath;
    UIView *_snapshotView;
    NSIndexPath *_moveIndexPath;
    
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
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collection];
    
    [_collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collection addGestureRecognizer:longPress];
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longPress
{
    [self action:longPress];
 
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
#pragma mark - iOS9 之前的方法
- (void)action:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        { // 手势开始
            //判断手势落点位置是否在row上
            NSIndexPath *indexPath = [_collection indexPathForItemAtPoint:[longPress locationInView:_collection]];
            _oldIndexPath = indexPath;
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [_collection cellForItemAtIndexPath:indexPath];
            // 使用系统的截图功能,得到cell的截图视图
            UIView *snapshotView = [cell snapshotViewAfterScreenUpdates:NO];
            snapshotView.frame = cell.frame;
            [_collection addSubview:_snapshotView = snapshotView];
            // 截图后隐藏当前cell
            cell.hidden = YES;
            
            CGPoint currentPoint = [longPress locationInView:_collection];
            [UIView animateWithDuration:0.25 animations:^{
                snapshotView.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshotView.center = currentPoint;
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        { // 手势改变
            //当前手指位置 截图视图位置随着手指移动而移动
            CGPoint currentPoint = [longPress locationInView:_collection];
            _snapshotView.center = currentPoint;
            // 计算截图视图和哪个可见cell相交
            for (UICollectionViewCell *cell in _collection.visibleCells) {
                // 当前隐藏的cell就不需要交换了,直接continue
                if ([_collection indexPathForCell:cell] == _oldIndexPath) {
                    continue;
                }
                // 计算中心距
                CGFloat space = sqrtf(pow(_snapshotView.center.x - cell.center.x, 2) + powf(_snapshotView.center.y - cell.center.y, 2));
                // 如果相交一半就移动
                if (space <= _snapshotView.bounds.size.width / 2) {
                    _moveIndexPath = [_collection indexPathForCell:cell];
                    //移动 会调用willMoveToIndexPath方法更新数据源
                    [_collection moveItemAtIndexPath:_oldIndexPath toIndexPath:_moveIndexPath];
                    //设置移动后的起始indexPath
                    _oldIndexPath = _moveIndexPath;
                    break;
                }
            }
        }
            break;
        default:
        { // 手势结束和其他状态
            UICollectionViewCell *cell = [_collection cellForItemAtIndexPath:_oldIndexPath];
            // 结束动画过程中停止交互,防止出问题
            _collection.userInteractionEnabled = NO;
            // 给截图视图一个动画移动到隐藏cell的新位置
            [UIView animateWithDuration:0.25 animations:^{
                _snapshotView.center = cell.center;
                _snapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                // 移除截图视图,显示隐藏的cell并开始交互
                [_snapshotView removeFromSuperview];
                cell.hidden = NO;
                _collection.userInteractionEnabled = YES;
            }];
        }
            break;
    }
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






























