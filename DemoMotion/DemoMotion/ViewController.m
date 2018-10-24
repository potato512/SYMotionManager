//
//  ViewController.m
//  DemoMotion
//
//  Created by Herman on 2018/10/24.
//  Copyright © 2018年 Herman. All rights reserved.
//

#import "ViewController.h"
#import "LightVC.h"
#import "ShakeVC.h"
#import "DistanceVC.h"
#import "TouchVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"传感器";
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:table];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [UIView new];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *title = self.array[indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *nextVC = nil;
    if (0 == indexPath.row) {
        nextVC = [LightVC new];
    } else if (1 == indexPath.row) {
        nextVC = [ShakeVC new];
    } else if (2 == indexPath.row) {
        nextVC = [DistanceVC new];
    } else if (3 == indexPath.row) {
        
    } else if (4 == indexPath.row) {
        nextVC = [TouchVC new];
    }
    [self.navigationController pushViewController:nextVC animated:YES];
}


- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@"环境光感", @"摇一摇", @"距离传感", @"磁力计", @"指纹", @"面容", @"运动", @"加速计", @"陀螺仪"];
    }
    return _array;
}



@end
