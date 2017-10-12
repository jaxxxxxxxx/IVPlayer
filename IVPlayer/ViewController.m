//
//  ViewController.m
//  IVPlayer
//
//  Created by nbd on 2017/9/30.
//  Copyright © 2017年 IV. All rights reserved.
//

#import "ViewController.h"
#import "UploadManager.h"
#import "FileManager.h"
#import "VideoViewController.h"

@interface ViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)addVideo:(UIBarButtonItem *)sender {
    [[UploadManager shareInstance] startObserverWithBlock:^(NSString *serverURL) {
        [self showServerAlertWithServerURL:serverURL];
    }];
}

- (IBAction)editVideo:(id)sender {
}

- (void)showServerAlertWithServerURL:(NSString *) serverURL {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"文件上传中"
                                                        message:[NSString stringWithFormat:@"请在浏览器中输入:%@ \n点击停止关闭传输", serverURL]
                                                       delegate:self
                                              cancelButtonTitle:@"停止"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

- (void)reloadData {
    [[FileManager shareInstance] reloadFileArray];
    [self.tableView reloadData];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[UploadManager shareInstance] endObserver];
    [self reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[FileManager shareInstance] fileArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cell.textLabel.text = [[[FileManager shareInstance] fileArray] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *fileName = [[[FileManager shareInstance] fileArray] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewToVideoSegue" sender:fileName];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ViewToVideoSegue"]) {
        VideoViewController *videoVC = segue.destinationViewController;
        videoVC.fileName = sender;
    }
}

@end
