//
//  IntoYunAPIManager.h
//  IntoYunSDKDemo
//
//  Created by 梁惠源 on 16/8/9.
//  Copyright © 2016年 MOLMC. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class DeviceModel;
@class DatapointModel;

/** 下载进度 */
typedef void (^DownloadProgressBlock)(NSProgress *downloadProgress);

/** 上传进度 */
typedef void (^UploadProgressBlock)(NSProgress *uploadProgress);

/** 成功回调 */
typedef void (^SuccessBlock)(id responseObject);

/** 失败回调 */
typedef void (^ErrorBlock)(NSInteger code, NSString *errorStr);

/** form表单 */
typedef void (^ConstructingBodyBlock)(id <AFMultipartFormData> formData);


@interface IntoYunAPIManager : AFHTTPSessionManager


/**********************************************/
/*************     用户接口     ****************/
/**********************************************/

/**
 * 获取App token 或者 更新用户token
 * 获取验证码， 创建用户等操作都需要先获取app的token
 * token可以控制接口的访问频率，避免恶意访问
 * 通过app的token，我们可以知道这款app对应的uid，可以操作的产品类别。
 * 所以在创建用户，控制设备，获取验证码时都需要X-Intorobot-Application-Token
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getAppToken:(SuccessBlock)successBlock
         errorBlock:(ErrorBlock)errorBlock;


/**
 * 登录
 * @param account       用户账号
 * @param password      用户密码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)userLogin:(NSString *)account
         password:(NSString *)password
     successBlock:(SuccessBlock)successBlock
       errorBlock:(ErrorBlock)errorBlock;


/**
 * 获取短信验证码
 * @param phone         手机号码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getVerifyCode:(NSString *)phone
         successBlock:(SuccessBlock)successBlock
           errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取邮箱验证码
 * @param email 电子邮箱
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getVerifyCodeWithEmail:(NSString *)email successBlock:(SuccessBlock)successBlock
                    errorBlock:(ErrorBlock)errorBlock;

/**
 *  注册用户
 *
 *  创建用户. 根据app选择的用户系统，校验用户信息的格式。
 *  其中的token字段 跟 userId字段可以作为连入emqttd的用户名和密码
 *  noticeId 可以组成token默认控制的topic，用于消息推送
 *  用户的token可以对其名下所有设备进行控制|获取数据
 *
 *  @param phone          手机号码
 *  @param password       密码
 *  @param vldCode        验证码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 *
 */
+ (void)registerAccount:(NSString *)phone
               password:(NSString *)password
                vldCode:(NSString *)vldCode
           successBlock:(SuccessBlock)successBlock
             errorBlock:(ErrorBlock)errorBlock;

/**
 * 邮箱注册账号
 * @param email     电子邮箱
 * @param password  密码
 * @param vldCode   邮箱验证码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)registerAccountWithEmail:(NSString *)email
                        password:(NSString *)password
                         vldCode:(NSString *)vldCode
                    successBlock:(SuccessBlock)successBlock
                      errorBlock:(ErrorBlock)errorBlock;


/**
 *  重置手机号密码
 *
 *  @param phone        手机号
 *  @param password     密码
 *  @param vldCode      验证码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)resetPassword:(NSString *)phone
          password:(NSString *)password
              vldCode:(NSString *)vldCode
         SuccessBlock:(SuccessBlock)successBlock
           errorBlock:(ErrorBlock)errorBlock;

/**
 * 忘记密码时，重置密码
 * @param email         电子邮箱
 * @param password      新密码
 * @param vldCode       邮箱验证码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)resetPasswordWithEmail:(NSString *)email
                      password:(NSString *)password
                       vldCode:(NSString *)vldCode
                  SuccessBlock:(SuccessBlock)successBlock
                    errorBlock:(ErrorBlock)errorBlock;

/**
 *  请求用户信息
 *
 *  @param userId           用户ID
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getUserInfo:(NSString *)userId
       successBlock:(SuccessBlock)successBlock
         errorBlock:(ErrorBlock)errorBlock;


/**
 *  修改用户信息
 *
 *  @param userId       用户ID
 *  @param parameters   修改的值
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 *  
 *  Example:
 *    {
 *        "nickname": "xiao kk",
 *        "desc": "i love sun shine."
 *    }
 */
+ (void)updateUserInfo:(NSString *)userId
            parameters:(NSMutableDictionary *)parameters
          successBlock:(SuccessBlock)successBlock
            errorBlock:(ErrorBlock)errorBlock;

/**
 *  退出登录
 *
 *  @param userId         用户userId
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)userLogout:(NSString *)userId
      successBlock:(SuccessBlock)successBlock
        errorBlock:(ErrorBlock)errorBlock;

/**
 *  更改密码
 *
 *  @param userId       用户ID
 *  @param curPassword  当前密码
 *  @param newPassword  新密码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)changePassword:(NSString *)userId
           curPassword:(NSString *)curPassword
           newPassword:(NSString *)newPassword
          successBlock:(SuccessBlock)successBlock
            errorBlock:(ErrorBlock)errorBlock;


/**
 * 提交用户反馈信息
 * @param content       反馈内容
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+(void)feedback:(NSString *)content
   successBlock:(SuccessBlock)successBlock
     errorBlock:(ErrorBlock)errorBlock;

/**********************************************/
/**************    设备接口      ***************/
/**********************************************/

/**
 *  消费者使用产品APP添加设备
 *  我们首先判断deviceId是否存在；
 *  接着判断该款APP是否有权限操作该设备；
 *  再次判断deviceId是否已经与某个帐号绑定了.
 *  如果设备是被恶意绑定的，则可以通过设备的reactivate，强制解除现有绑定关系。
 *
 *  @param deviceId          deviceId
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)bindDevice:(NSString *)deviceId
      successBlock:(SuccessBlock)successBlock
        errorBlock:(ErrorBlock)errorBlock;


/**
 * 获取用户设备列表
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getDevices:(SuccessBlock)successBlock
        errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取设备的board信息
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+(void)getBoardInfo:(SuccessBlock)successBlock
         errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取设备传感器数据点的历史数据
 * 不同产品的历史数据独立存储。
 * 也就是说，设备在不同的时间段里曾经隶属于不同的产品，
 * 那么这些历史数据是分开存储的，所以查询设备的历史数据的一个
 * 隐含前提就是“获取设备当前所隶属的产品”下的传感器数据,
 * 所以不需要前端提供产品id.
 * @param deviceId      设备id
 * @param dpid          传感器数据点id
 * @param startTime     获取历史数据起始时间
 * @param endTime       获取历史数据截止时间
 * @param internal      取值间隔时间，可取值1D, 12h, 6h, 1h, 30m, 10m, 5m, 1m, 30s, 10s, 5s, 1s
 * @param successBlock  成功回调
 * @param errorBlock    失败回调
 */
+(void)getHistoryData:(NSString *)deviceId
          datapointId:(NSString *)dpid
            startTime:(NSString *)startTime
              endTime:(NSString *)endTime
             interval:(NSString *)internal
        successBlock:(SuccessBlock)successBlock
          errorBlock:(ErrorBlock)errorBlock;

/**
 *
 * 获取设备详细信息
 *
 * @param deviceId  设备id
 * @param parameters    设备内容
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 *
 * parameters example:
 * {
 *    "name": "xiao kk",
 *    "description": "室内灯光控制系统"
 * }
 */
+ (void)updateDeviceInfo:(NSString *)deviceId
              parameters:(NSMutableDictionary *)parameters
            successBlock:(SuccessBlock)successBlock
              errorBlock:(ErrorBlock)errorBlock;


/**
 * 删除设备
 * @param deviceId      设备id
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)deleteDeviceById:(NSString *)deviceId
            successBlock:(SuccessBlock)successBlock
              errorBlock:(ErrorBlock)errorBlock;


/**
 * tcp/ws设备控制指令发送接口
 * @param deviceId      设备id
 * @param payload       要发送数据，包括设备deviceId，board
 * @param successBlock  发送成功回调
 * @param errorBlock    发送失败回调
 */
+(void)sendCmdToDevice:(NSString *) deviceId
               payload:(NSData *)payload
                  type:(int)type
           successBlock:(SuccessBlock)successBlock
             errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取用户下所有的产品数据点列表
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getProducts:(SuccessBlock)successBlock
         errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取产品详情
 * @param productId         产品Id
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+(void)getProductById:(NSString *)productId successBlock:(SuccessBlock)successBlock errorBlock:(ErrorBlock)errorBlock;

/**
 * 获取通知消息
 * @param page          分页页码
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getMessages:(NSString *)page
       successBlock:(SuccessBlock)successBlock
         errorBlock:(ErrorBlock)errorBlock;


/**
 * 删除id 为 msgId的消息
 * @param msgId         消息id
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)deleteMessageById:(NSString *)msgId
             successBlock:(SuccessBlock)successBlock
               errorBlock:(ErrorBlock)errorBlock;


/**
 * 批量删除时间戳在timestamp(单位:s)以前的消息
 * @param timestamp     时间戳
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)deleteMessages:(long long)timestamp
          successBlock:(SuccessBlock)successBlock
            errorBlock:(ErrorBlock)errorBlock;


/**
 * 创建一个关联控制
 * @param recipeModel   联控model
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)createRecipe:(NSMutableDictionary *)recipeModel
        successBlock:(SuccessBlock)successBlock
          errorBlock:(ErrorBlock)errorBlock;


/**
 *
 * 获取用户的关联控制列表
 *
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)getRecipes:(SuccessBlock)successBlock
        errorBlock:(ErrorBlock)errorBlock;


/**
 * 测试立即执行关联控制，用于测试关联控制设置是否生效
 * @param recipeId      recipe id
 * @param type          recipe type recipe/schedule
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)testRunRecipe:(NSString *)recipeId
                 type:(NSString *)type
         successBlock:(SuccessBlock)successBlock
           errorBlock:(ErrorBlock)errorBlock;


/**
 * 修改关联控制内容，其中recipe中 _id, type是必须的
 * @param recipeId      recipe id
 * @param type          recipe type recipe/schedule
 * @param recipeInfo    recipe 修改内容
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)updateRecipe:(NSString *)recipeId
                type:(NSString *)type
          recipeInfo:(NSMutableDictionary *)recipeInfo
        successBlock:(SuccessBlock)successBlock
          errorBlock:(ErrorBlock)errorBlock;


/**
 * 删除关联控制
 * @param recipeId      recipe id
 * @param type          recipe type recipe/schedule
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)deleteRecipeById:(NSString *)recipeId
                    type:(NSString *)type
            successBlock:(SuccessBlock)successBlock
              errorBlock:(ErrorBlock)errorBlock;


/**
  * 上传头像，在服务器上创建一个新实体，并返回image id
  * @param image    图片数据
  * @param type     头像类型 user/device/product
  * @param _id      上传头像关联id  uid/device_id/product_id
  * @param x        压缩坐标x
  * @param y        压缩坐标y
  * @param h        压缩后高度h
  * @param w        压缩后宽度w
  * @param successBlock successBlock(id) 返回image id
  * @param errorBlock   错误回调
  */
+ (void)uploadAvatar:(UIImage *)image
                type:(NSString *)type
                  ID:(NSString *)_id
                   x:(int)x
                   y:(int)y
                   h:(int)h
                   w:(int)w
        successBlock:(SuccessBlock)successBlock
          errorBlock:(ErrorBlock)errorBlock;


/**
 * 更换头像，替换服务器上原有的图片实体
 * @param image    图片数据
 * @param avatarId      avatarid
 * @param type          头像类型 user/device/product
 * @param successBlock  successBlock
 * @param errorBlock    successBlock
 */
+ (void)updateAvatar:(UIImage *)image
            avatarId:(NSString *)avatarId
                type:(NSString *)type
                   x:(int)x
                   y:(int)y
                   h:(int)h
                   w:(int)w
        successBlock:(SuccessBlock)successBlock
          errorBlock:(ErrorBlock)errorBlock;


+ (void)printLog:(NSString *)msg
        argument:(id)args;

@end
