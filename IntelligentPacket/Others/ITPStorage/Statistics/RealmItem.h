//
//  RealmItem.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/19.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <Realm/Realm.h>

@interface RealmItem : RLMObject

@property NSString *email;                    // 推送用户
@property NSString *title;                    // 推送名称
@property NSString *content;                  // 推送内容
@property NSString *time;                     // 推送时间
//@property NSString *project;                // 点击填写tourl，PV为空
//@property NSString *ptag;                   // ptag
//@property NSString *prevPageName;           // 上一个页面名称
//@property long long visitPageTime;          // 访问时间
//@property long long leavePageTime;          // 离开时间
//@property NSString *groupID;                // 圈子ID
//@property NSString *topicID;                // 帖子ID
//@property NSString *dap;                    // Dap包含推荐使用的ID、msgID、policyID、sceneID
//@property NSString *pvID;                   // 事件ID
//@property NSString *latitude;               // 纬度
//@property NSString *longtitude;             // 经度

- (void)update:(void (^)(RealmItem *instance))updateBlock;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RealmStatPage>
RLM_ARRAY_TYPE(RealmItem)
