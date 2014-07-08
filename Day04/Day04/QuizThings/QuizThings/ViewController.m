//
//  ViewController.m
//  QuizThings
//
//  Created by techmaster on 6/13/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//

#import "ViewController.h"
#import "Thing.h"
#import "Animal.h"
#import "Fruit.h"
#import "AppDelegate.h" 
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController () <UITextFieldDelegate, UIAlertViewDelegate , AVAudioPlayerDelegate> //Adopt protocol : Ví dụ 2 anh da đen sinh đôi
// Delegate: uỷ nhiệm
{
    NSArray* array; //Không thay đổi được vị trí phần tử, hoặc bớt đi
    NSMutableArray* data;  //thêm, bớt phần tử thoải mái
   
    __weak IBOutlet UITextField *answer; //__weak không chủ động sở hữu đối tượng
    __weak IBOutlet UIButton *photo; // cùng = cấp vs property,nhưng lưu trên instant var nhanh hơn
    
    Thing* thing; //Phải sử dụng biến instant var (ivar) để lưu giữ đối tượng được chọn
    int countPlay;
    int countError;
    int countPoint;
    SystemSoundID right;
    SystemSoundID worng;
}
//@property (weak, nonatomic) IBOutlet UILabel *Point;

//@property (weak, nonatomic) IBOutlet UILabel *Point;
@property (weak, nonatomic) IBOutlet UILabel *hint;
@end

@implementation ViewController



//where you are about to add sound


- (void)viewDidLoad
{
    [super viewDidLoad];
	array = @[
              [[Thing alloc] init:@"iron" andImage:@"iron.png"],
              [[Animal alloc] init:@"cat" andImage:@"cat.png" andDangerous:NO],
              [[Animal alloc] init:@"dog" andImage:@"dog.png" andDangerous:YES],
              [[Animal alloc] init:@"elephant" andImage:@"elephant.png" andDangerous:YES],
              [[Fruit alloc] init:@"orange" andImage:@"orange.png" andEatable:YES],
              [[Fruit alloc] init:@"pepper" andImage:@"pepper.png" andEatable:NO],
              [[Fruit alloc] init:@"strawberry" andImage:@"strawberry.png" andEatable:YES]
              ];
    data = [NSMutableArray arrayWithArray:array];
    countPlay = 0;
    self->answer.delegate = self; //Có thể thay bằng kéo property delegate ở giao diện vào ViewController ẩn bàn phím ảo
    countPoint = 0;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self randomDisplayImage];
    
}



- (IBAction)onTapPhoto:(id)sender {
    [self randomDisplayImage];
    
}
- (void) randomDisplayImage
{
    //Phần là phần khởi tạo ban đầu
    countError = 0;
    self->answer.text = @"";
    long bound = [data count] - countPlay;
    
    //Phần logic
    if (bound < 1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Finish"
                                                        message:[NSString stringWithFormat:@" Your score : %d",countPoint]
                                                       delegate:self
                                              cancelButtonTitle:@"End game now!"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    int randomIndex = arc4random() % bound; //% chia lấy phần dư ~ modulo
    self->thing = (Thing*)data[randomIndex]; //(Thing*) ép kiểu: type casting
    
    [photo setImage:self->thing.image forState:UIControlStateNormal];
    [self displayHint:self->thing];
    [data exchangeObjectAtIndex:randomIndex withObjectAtIndex:bound - 1];
    countPlay ++;
}

- (IBAction) displayHint: (Thing*) athing
{
    if ([athing isMemberOfClass:[Animal class]]) {
        Animal* animal = (Animal*) athing;
        if (animal.dangerous) {
            self.hint.text = @"Con vật này nguy hiểm";
            return;
        }
    } else if ([athing isMemberOfClass:[Fruit class]]) {
        Fruit* fruit = (Fruit*) athing;
        if (fruit.eatable){
            self.hint.text = @"Quả này ăn được";
            return;
        }
        
    }
    self.hint.text = @"";
}

//-(void) displayPoint
//{
//    self.Point.text = [NSString stringWithFormat:@"%d",countPoint];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
   


   [self dismissViewControllerAnimated:YES completion:nil]; //Đóng lại modal view controller
}
- (IBAction)loopAllThings:(id)sender {
    // Vòng lặp lặp qua tất cả các phần tử trong mảng
    //id là con trỏ có gán vào đối tượng của bất kỳ kiểu nào
    //trong trường hợp này không được phép dùng instance type
    for (id object in array) {
        NSLog(@"%@", [object description]);  //%@ thực ra gọi [object description]
    }
    
    /*for (int i=0; i < 10; i++) {
        NSLog(@"%d", i);
    }*/
    
    for (int i=0; i < [array count]; i++) {
        NSLog(@"%@", [array[i] description]);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isFirstResponder]) { //Kiểm tra xem text field đang có bàn phím ảo dâng lên hay không?
        if ([[textField.text lowercaseString] isEqualToString:self->thing.name] ) { //isEqualToString: kiểm tra xem chuỗi có bằng nhau không
            [self displayCorrectOrNo:YES];
            [textField resignFirstResponder]; //Hạ bàn phím ảo xuống
            [self randomDisplayImage];
            [self soundRight];
            
        }
        else {
            self->countError ++;
            [self soundWorng];
            if (self->countError > 2) {
                [self displayCorrectOrNo:NO];
                [textField resignFirstResponder];
                [self randomDisplayImage];
                [self soundWorng];
            }
            
        }
    }
    return YES;
}
-(void)soundWorng
{
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"fog"ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath: path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &worng);
    AudioServicesPlaySystemSound(worng);

}
-(void)soundRight
{
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"electric"ofType:@"wav"];
    NSURL* url = [NSURL fileURLWithPath: path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &right);
    AudioServicesPlaySystemSound(right);
    //AudioServicesDisposeSystemSoundID(right);
    
}

- (void) displayCorrectOrNo: (BOOL) correct
{
    UIImageView *ball = (UIImageView*)[self.view viewWithTag:99 + countPlay]; //viewWithTag lấy ra UIView theo tag. Tag là số đếm
    if (correct) {
        ball.image = [UIImage imageNamed:@"green.png"];
        countPoint++;
       
    } else {
        ball.image = [UIImage imageNamed:@"red.png"];
    }
    
}

@end
