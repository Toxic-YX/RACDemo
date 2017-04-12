//
//  ViewController.m
//  RAC基础操作第一篇
//
//  Created by YuXiang on 2017/4/10.
//  Copyright © 2017年 Rookie.YXiang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *flags1;
@property (nonatomic, strong) RACCommand *command;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
    RACSignal 使用步骤:
    
    1 . 创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    2 . 订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    3 . 发送信号 - (void)sendNext:(id)value
    
    
    RACSignal底层实现：
    
    1 .创建信号，首先把didSubscribe保存到信号中，还不会触发。
    2 .当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    2.1 subscribeNext内部会调用siganl的didSubscribe
    2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    3 . siganl的didSubscribe中调用[subscriber sendNext:@1];
    3.1 sendNext底层其实就是执行subscriber的nextBlock
    */
    
    // 1 ,创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // block调用时刻: 每当有订阅信号,  就会调用block.
        
        // 2. 发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
        }];
    }];
    
    // 3. 订阅信号, 才回激活信号
    [siganl subscribeNext:^(id x) {
        //  block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据: %@",x);
    }];
    
    
    /* 
     解释:
     RACSubscriber 表示订阅者的意思, 用于发送信号, 这是一个协议, 不是一个类, 只要遵守这个协议
     并且实现方法才能成为订阅者. 通过create创建的信号,都有一个订阅者,帮助它发送数据
     
     RACDisposable 用于取消订阅或者清理资源, 当信号发送完成或者发送错误的时候,就会自动触发它,  -----> 使用场景:不想监听某个信号时，可以通过它主动取消订阅信号。
     
     
     RACSubject:信号提供者,自己可以充当信号, 又能发送信号. ----> 使用场景:通常用来代替代理，有了它，就不必要定义代理了。
     
     RACReplaySubject:重复提供信号类，RACSubject的子类。
     
     RACReplaySubject与RACSubject区别:  RACReplaySubject可以先发送信号，在订阅信号，RACSubject就不可以。---> 使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
     */
    
/* -------------------------------------------------------------------------------- */
   // RACSubject和RACReplaySubject简单使用:
    
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
    // 1 创建信号
    RACSubject *subject = [RACSubject subject];
    
    // 2 订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者: %@",x);
    }];
    
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者: %@",x);
    }];
   
    [subject sendNext:@"2"];
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1 创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2 发送信号
    [replaySubject sendNext:@3];
    [replaySubject sendNext:@4];
    
    // 3 订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一个第一次订阅者接收到的数据: %@",x);
    }];
    
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二个第二次订阅者接收到的数据: %@",x);
    }];
    /* -------------------------------------------------------------------------------- */
    
    // RACSubject替换代理
    // 需求:
    // 1.给当前控制器添加一个按钮，modal到另一个控制器界面
    // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
    // 例子如 oneVC和 twoVC
    
    /* -------------------------------------------------------------------------------- */
    
    //  RACTuple 元祖类, 类似NSArray, 用来包装值
    // RACSequence:RAC中的集合类，用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。--- > 使用场景 : 字典转模型
    
    //  RACSequence和RACTuple简单使用
    
    // 1 遍历数组
    NSArray *numbers= @[@1,@2,@3,@4];
    
    // 实现步骤:
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    // 2 遍历字典, 遍历出来的键值对包装成RACTuple(元祖对象)
    NSDictionary *dict = @{@"name":@"YX",@"age":@"18"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 解包元祖, 会把元祖的值, 按照顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key, NSString *value) = x;
        
        // 相当于下面写法
       // NSString *key = x[0];
      //  NSString *value = x[1];
        
        NSLog(@"key --> %@,value --> %@",key, value);
    }];
    
    // 3 字典转模型
    // 3.1 OC写法
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Test.plist" ofType:nil];
    NSArray *dicArr = [NSArray arrayWithContentsOfFile:filePath];
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *dict in dicArr) {
        TestItem *item = [TestItem testWithDict:dict];
        [items addObject:item];
    }
    NSLog(@"OC字典转模型 items -> %@",items);
    
    // 3.2 RAC 写法
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"Test.plist" ofType:nil];
    
    NSArray *dictArr1 = [NSArray arrayWithContentsOfFile:filePath1];
    NSMutableArray *flags1 = [NSMutableArray array];
    _flags1 = flags1;
    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
    [dictArr1.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
        NSLog(@"%@",x[@"name"]);
        // 运用RAC遍历字典, x: 字典
        TestItem *items1 = [TestItem testWithDict:x];
        [flags1 addObject:items1];
    }];
    NSLog(@"%@",_flags1);
    
    // 3.3 RAC高级写法:
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:@"Test.plist" ofType:nil];
    
    NSArray *dictArr2 = [NSArray arrayWithContentsOfFile:filePath2];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
    NSArray *flags2 = [[dictArr2.rac_sequence map:^id(id value) {
        
        return [TestItem testWithDict:value];
        
    }] array];
    NSLog(@"RAC高级写法 字典转模型 %@",flags2);
    /* -------------------------------------------------------------------------------- */
    
    // RACCommand:RAC中用于处理事件的类，可以把事件如何处理,事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程。---> 使用场景 监听按钮点击, 网络请求
    
    // RACCommand简单使用 步骤
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        
        // 创建空信号, 必须返回信号
        // return [RACSignal empty];
        
        // 2 创建信号, 用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"请求数据"];
            // 注意: 数据传递完毕, 调用sendCompleted, 这时命令才执行完毕
            [subscriber sendCompleted];
                 return nil;
        }];
    }];
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    
    // 3 订阅RACCommand中的信号
    [command.executionSignals subscribeNext:^(id x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    // 5.执行命令
    [self.command execute:@1];
}



@end
