//
//  DynamicButtonsVC.m
//  Day06
//
//  Created by techmaster on 6/27/14.
//  Copyright (c) 2014 Techmaster. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DynamicButtonsVC.h"
#define START_TAG 100
@interface DynamicButtonsVC ()
{
    //int i ;
    int b1 , b2;
    int row, col;
    float bwidth, bheight;
    NSTimer *timer;
    UIButton* _button1, *_button2; //Hai nút đang đỏ
    BOOL touch1,touch2, endGame,levelUp;
    int point;
    float speed;
    AVAudioPlayer *player;
    //SystemSoundID sound;
}
@end

@implementation DynamicButtonsVC



- (void)viewDidLoad
{
    _button1 = nil;
    _button2 = nil;
    [super viewDidLoad];
    [self createArrayButtons];
    [self startData];
    levelUp=NO;
    }
-(void)startData
{
    [self playMusic];
    endGame=NO;
    point=1;
    speed=2.0;
    timer = [NSTimer scheduledTimerWithTimeInterval:speed  //0.5 giây lặp một lần
                                             target:self
                                           selector:@selector(flashButton) //flasButton là hàm được gọi trong timer
                                           userInfo:nil
                                            repeats:YES];
    [timer fire];  //kịch hoạt timer
  }

-(void)playMusic
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Sound"ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath: path];
  
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1; //infinite
    [player play];
    
}
- (void) flashButton
{
    

    if (endGame) {
        player.volume =0.0;
        return;
    }
    //Xoá 2 nút đỏ ở lần trước
    if (_button1) {
        [_button1 setBackgroundColor:[UIColor grayColor]];
    }
    
    if (_button2) {
        [_button2 setBackgroundColor:[UIColor grayColor]];
    }
    
    
    //Lấy ra 2 vị trí mới để hiện nút đỏ mới
    int ranRow1 = arc4random() % row;
    int ranCol1 = arc4random() % col;
    int ranRow2, ranCol2;
    int id1 = START_TAG + ranRow1 * col + ranCol1;
    UIButton *button1 = (UIButton *)[self.view viewWithTag:id1];
    [button1 setBackgroundColor:[UIColor redColor]];
    _button1 = button1;
    touch1 = NO;
    //Lặp cho đến khi vị trí nút số 2 khác số 1
    if (levelUp) {
        
    
    do {
        ranRow2 = arc4random() % row;
        ranCol2 = arc4random() % col;
    } while (ranRow1 == ranRow2 &&  ranCol1 == ranCol2);
    
    //Tính toán tag của từng nút
    
    int id2 = START_TAG + ranRow2 * col + ranCol2;
    
    //Lấy nút ra nhờ vào số tag
  
    UIButton *button2 = (UIButton *)[self.view viewWithTag:id2];
    [button2 setBackgroundColor:[UIColor redColor]];
    
    //Lưu lại 2 nút đỏ hiện thời
    
    _button2 = button2;
    
    touch2 = NO;
    }
    [self calPoint];
    b1=0;
    b2=0;
    //self.title = [NSString stringWithFormat:@"Score: %d", ranRow1+ ranCol1];
}


-(void)calPoint
{
    
        if ((b1==1&&b2==1)||(levelUp==NO&& b1==1) )
        {
            point++;
            if (point%5==0) {
                
                [timer invalidate];
                speed=speed-(point/15);
                timer = [NSTimer scheduledTimerWithTimeInterval:speed
                                                         target:self
                                                       selector:@selector(flashButton)
                                                       userInfo:nil repeats:YES];
                [timer fire];  //kịch hoạt timer
                point--;
            }
            
        }
        else if((b1==0&&b2==0)||(levelUp==NO&& b1==0) )
        {
            point--;
        }
        if (point==5) {
        levelUp=YES;
        }
        self.title=[NSString stringWithFormat:@"Your Point: %d",point];
        if (point==-3) {
            player.volume=0;
            [timer invalidate];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game over"
                                                            message:@"You lose"
                                                           delegate:self
                                                  cancelButtonTitle:@"Quit"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            endGame=YES;
        }

    }
    
    
    

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[self setImageButton:nil];
    [self startData];
}
-(void)touchOnButton:(UIButton*)sender
{
    if (sender == self->_button1) {
        if (!touch1) {
            touch1=YES;
            b1=1;
            _button1.backgroundColor = [UIColor greenColor ];
        }
        
    }
    else if (sender ==self->_button2)
    {
        if (!touch2){
            touch2=YES;
            b2=1;
            _button2.backgroundColor = [UIColor greenColor ];
        }
        
    }
}
- (void) createArrayButtons
{

    CGSize size = self.view.bounds.size;
    NSLog(@"width = %3.2f - height = %3.2f", size.width, size.height);
    row = (size.height > 480) ? 9 : 8;
    col = 6;
    float d = 11.0;
    float x = d;
    float y = 60.0 + d;
    bwidth = 40.0;
    bheight = 40.0;
    int buttonCount = 0;
    for (int rowIndex = 0; rowIndex < row; rowIndex ++) {
        for (int colIndex = 0; colIndex < col; colIndex ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button addTarget:self
                       action:@selector(touchOnButton:)
             forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor grayColor];
            button.frame = CGRectMake(x, y, bwidth, bheight);  //gán toạ độ và kích thước
            button.tag = START_TAG + buttonCount;
            buttonCount++; //tăng buttonCount để thay đổi tag
            [self.view addSubview:button]; //Thêm nút vào giao diện. self.view là UIView chính của ViewController hiện tại
            x += bwidth + d;
            
        }
        x = d;
        y += bheight + d;
    }

}


@end
