#import "ViewController.h"
#import "DDYCompress.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button1 = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(20, DDYTopH + 40, [UIScreen mainScreen].bounds.size.width-40, 40)];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setTitle:@"zip解压" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    button1.tag = 101;
    
    UIButton *button2 = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(20, DDYTopH + 120, [UIScreen mainScreen].bounds.size.width-40, 40)];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setTitle:@"rar解压" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    button2.tag = 102;
    
    UIButton *button3 = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(20, DDYTopH + 200, [UIScreen mainScreen].bounds.size.width-40, 40)];
        [button setBackgroundColor:[UIColor lightGrayColor]];
        [button setTitle:@"7z解压" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        button;
    });
    button3.tag = 103;
}

- (void)handleButton:(UIButton *)button {
    if (button.tag == 101) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"zip" ofType:@"zip"];
        [DDYCompress ddy_DecopressFile:filePath destinationPath:nil password:nil complete:^(NSError *error, NSString *destPath) {
            NSLog(@"zip: %@ %@",error?error:@"no error", destPath?destPath:@"no destPath");
        }];
    } else if (button.tag == 102) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"rar" ofType:@"rar"];
        [DDYCompress ddy_DecopressFile:filePath destinationPath:nil password:nil complete:^(NSError *error, NSString *destPath) {
            NSLog(@"rar: %@ %@",error?error:@"no error", destPath?destPath:@"no destPath");
        }];
    } else if (button.tag == 103) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"7z" ofType:@"7z"];
        [DDYCompress ddy_DecopressFile:filePath destinationPath:nil password:nil complete:^(NSError *error, NSString *destPath) {
            NSLog(@"7z: %@ %@",error?error:@"no error", destPath?destPath:@"no destPath");
        }];
    }
}


@end

