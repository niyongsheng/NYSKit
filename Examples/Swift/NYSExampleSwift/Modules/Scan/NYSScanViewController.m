//
//  NYSScanViewController.m
//  NYSAppSwift
//
//  Created by niyongsheng on 2024/1/4.
//

#import "NYSScanViewController.h"
#import "NYSToolBar.h"

@interface NYSScanViewController () <SGScanCodeDelegate, SGScanCodeSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    SGScanCode *scanCode;
}
@property (nonatomic, strong) SGScanView *scanView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NYSToolBar *toolBar;
@end

@implementation NYSScanViewController

- (void)dealloc {
    
    [self stop];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setIsHidenNaviBar:YES];
    [self start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self setIsHidenNaviBar:NO];
    [self stop];
}

- (void)start {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->scanCode startRunning];
    });
    [self.scanView startScanning];
}

- (void)stop {
    if (scanCode) [scanCode stopRunning];
    if (_scanView) [self.scanView stopScanning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self configScanCode];
    
//    [self configNavigationBar];
}

- (void)configUI {
    
    [self.view addSubview:self.scanView];
    
    [self.view addSubview:self.bottomView];
    
    [self.view addSubview:self.toolBar];
}

- (void)configNavigationBar {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn addTarget:self action:@selector(cancelBtnOnclicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)cancelBtnOnclicked:(UIButton *)sender {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)configScanCode {
    scanCode = [[SGScanCode alloc] init];
    if (![scanCode checkCameraDeviceRearAvailable]) {
        return;
    }
    scanCode.delegate = self;
    scanCode.sampleBufferDelegate = self;
    scanCode.preview = self.view;
}

- (void)scanCode:(SGScanCode *)scanCode result:(NSString *)result {
    [self stop];
    
    [scanCode playSoundEffect:@"SGQRCode.bundle/scan_end_sound.caf"];
    
    NYSRootWebViewController *jumpVC = [[NYSRootWebViewController alloc] init];
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    if ([result hasPrefix:@"http"]) {
        jumpVC.urlStr = result;
    } else {
        jumpVC.urlStr = result;
    }
}

- (void)scanCode:(SGScanCode *)scanCode brightness:(CGFloat)brightness {
    if (brightness < - 1.5) {
        [self.toolBar showTorch];
    }
    
    if (brightness > 0) {
        [self.toolBar dismissTorch];
    }
}

- (SGScanView *)scanView {
    if (!_scanView) {
        SGScanViewConfigure *configure = [[SGScanViewConfigure alloc] init];
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = self.view.frame.size.width;
        CGFloat h = self.view.frame.size.height;
        _scanView = [[SGScanView alloc] initWithFrame:CGRectMake(x, y, w, h) configure:configure];
        
        CGFloat scan_x = 0;
        CGFloat scan_y = 0.18 * self.view.frame.size.height;
        CGFloat scan_w = self.view.frame.size.width - 2 * x;
        CGFloat scan_h = self.view.frame.size.height - 2.55 * scan_y;
        _scanView.scanFrame = CGRectMake(scan_x, scan_y, scan_w, scan_h);
        
        __weak typeof(self) weakSelf = self;
        _scanView.doubleTapBlock = ^(BOOL selected) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (selected) {
                [strongSelf->scanCode setVideoZoomFactor:4.0];
            } else {
                [strongSelf->scanCode setVideoZoomFactor:1.0];
            }
        };
    }
    return _scanView;
}

- (NYSToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [(NYSToolBar *)[NYSToolBar alloc] init];
        CGFloat h = 220;
        CGFloat y = CGRectGetMinY(self.bottomView.frame) - h;
        _toolBar.frame = CGRectMake(0, y, self.view.frame.size.width, h);
        [_toolBar addQRCodeTarget:self action:@selector(qrcode_action)];
        [_toolBar addAlbumTarget:self action:@selector(album_action)];
    }
    return _toolBar;
}

- (void)qrcode_action {
    [self stop];
    
    NYSQRCodeViewController *vc = [[NYSQRCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)album_action {
    [SGPermission permissionWithType:SGPermissionTypePhoto completion:^(SGPermission * _Nonnull permission, SGPermissionStatus status) {
        if (status == SGPermissionStatusNotDetermined) {
            [permission request:^(BOOL granted) {
                if (granted) {
                    [self _enterImagePickerController];
                }
            }];
        } else if (status == SGPermissionStatusAuthorized) {
            [self _enterImagePickerController];
        } else if (status == SGPermissionStatusDenied) {
            NSLog(@"SGPermissionStatusDenied");
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *app_Name = [infoDict objectForKey:@"CFBundleDisplayName"];
            if (app_Name == nil) {
                app_Name = [infoDict objectForKey:@"CFBundleName"];
            }
            
            NSString *messageString = [NSString stringWithFormat:@"[前往：设置 - 隐私 - 照片 - %@] 允许应用访问", app_Name];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:messageString preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                // 跳转应用设置
                UIApplication *application = [UIApplication sharedApplication];
                NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [application openURL:URL options:@{} completionHandler:nil];
            }];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        } else if (status == SGPermissionStatusRestricted) {
            NSLog(@"SGPermissionStatusRestricted");
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"由于系统原因, 无法访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
    }];
}

- (void)_enterImagePickerController {
    [self stop];
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - - UIImagePickerControllerDelegate 的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self start];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [scanCode readQRCode:image completion:^(NSString *result) {
        if (result == nil) {
            [self dismissViewControllerAnimated:YES completion:nil];
            [self start];
        } else {
            [self->scanCode playSoundEffect:@"SGQRCode.bundle/scan_end_sound.caf"];
            
            [self dismissViewControllerAnimated:YES completion:^{
                NYSRootWebViewController *jumpVC = [[NYSRootWebViewController alloc] init];
                [self.navigationController pushViewController:jumpVC animated:YES];
                
                if ([result hasPrefix:@"http"]) {
                    jumpVC.urlStr = result;
                } else {
                    jumpVC.urlStr = result;
                }
            }];
        }
    }];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        CGFloat h = 100;
        CGFloat x = 0;
        CGFloat y = self.view.frame.size.height - h;
        CGFloat w = self.view.frame.size.width;
        _bottomView.frame = CGRectMake(x, y, w, h);
        _bottomView.backgroundColor = [UIColor blackColor];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"扫一扫";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor whiteColor];
        lab.frame = CGRectMake(0, 0, w, h - 34);
//        [_bottomView addSubview:lab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"delete_icon"] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 40, 40);
        btn.center = CGPointMake(w/2, h/2);
        [btn addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
    }
    return _bottomView;
}

- (void)close_action {
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
