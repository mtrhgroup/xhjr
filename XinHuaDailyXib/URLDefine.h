//
//  URLDefine.h
//  XinHuaDailyXib
//
//  Created by apple on 14/10/8.
//
//


/*---------------------
 绑定设备URL
 参数个数 4
 参数列表 imei（设备唯一标示）       model（硬件型号）      osversion（软件型号）  appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OLD:iphone55（已经绑定）  NEW(注册成功)  INVALID(参数无效)  XXX(直接显示)
 备注
 ---------------------*/
#define kBindleDeviceURL @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_bindphone.ashx?imei=%@&model=%@&osversion=iOS%@&appid=%@"


/*---------------------
 绑定授权码URL
 参数个数 6
 参数列表 imei（设备唯一标示） phone(手机号码)  code（短信验证码）  model（手机型号）    osversion（软件型号）  appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 此终端未注册或授权码不存在（已经绑定） OK（绑定成功）
 备注
 ---------------------*/
#define kBindleSNURL @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/common_bindsn.ashx?phone=%@&imei=%@&code=%@&model=%@&osversion=%@&appid=%@"


/*---------------------
 频道列表URL
 参数个数 2
 参数列表 imei（设备唯一标示）  appid(软件ID)
 请求类型 GET
 返回类型 XML
 返回示例 periodicallist@sn_state｜periodical｜id:name:description:iconurl:homenum:level:generatetype:subscribe:sort:parent:showtype:type
 备注
 ---------------------*/
#define kChannelsURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_periodicallist.ashx?imei=%@&appid=%@"


/*---------------------
 文章列表URL
 参数个数 5
 参数列表 imei（设备唯一标示）       n（最新N条）      pid（频道ID）   time(格式:20140923081232)   appid(软件ID)
 请求类型 GET
 返回类型 XML
 返回示例 periodicallist|periodical@id@name|item|id:title:pageurl:zipurl:attachments:date:inserttime:pn:summary:thumbnail:pid:coverimg:visit:video
 备注
 ---------------------*/
#define kLatestArticlesURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_newperiodicals.ashx?imei=%@n=%@&order=asc&pid=%@&time=%@&appid=%@"


/*---------------------
 封面信息URL
 参数个数 2
 参数列表 imei（设备唯一标示） appid (软件ID)
 请求类型 GET
 返回类型 XML
 返回示例 config|sn_sate:sn_msg:group_title:group_sub_title:startimage:gid
 备注
 ---------------------*/
#define kAppInfoURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_config.ashx?appid=%@&imei=%@"


/*---------------------
 点赞数量URL
 参数个数 3
 参数列表 imei（设备唯一标示）       literid（文章ID）  appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 123（点赞数量）
 备注
 ---------------------*/
#define kLikeURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_litercommend.ashx?imei=%@&literid=%@&appid=%@"


/*---------------------
 应用反馈URL
 参数个数 6
 参数列表 imei（设备唯一标示）       sn（授权码）      email（电子邮件）      content(反馈内容)  type(feedback=软件反馈，question=点题)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kAppFeedBack @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/common_feedback.ashx?imei=%@&sn=%@&email=%@&content=%@&appid=%@&type=%@"


/*---------------------
 文章反馈URL
 参数个数 6
 参数列表 imei（设备唯一标示）       sn（授权码）      literid（文章ID）     content(反馈内容)    appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kArticleFeedBack @"http://mis.xinhuanet.com/sxtv2/Mobile/interface/common_literfeedback.ashx?imei=%@&sn=%@&literid=%@&content=%@&appid=%@"


/*---------------------
 上传推送TokenURL
 参数个数 3
 参数列表 imei（设备唯一标示）       token（推送令牌）   appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kTokenURL @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_Token_ios.asp?imei=%@&token=%@&appname=lnfb&appid=%@"


/*---------------------
 接收报告URL
 参数个数 5
 参数列表 imei（设备唯一标示）       pid（频道ID）      gid（文章ID）      osversion（软件型号）   appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kReceivedReportURL @"http://mis.xinhuanet.com/sxtv2/Mobile/Interface/sjb_zipgeted.ashx?imei=%@&pid=%@&gid=%@&osversion=iOS%@"


/*---------------------
 Badge清零URL
 参数个数 2
 参数列表 imei（设备唯一标示）   appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kClearBadgeURL @"http://mis.xinhuanet.com/sxtv2/mobile/Interface/nsjb_ClearBadge_ios.asp?imei=%@&appid=%@"


/*---------------------
 命令URL
 参数个数 4
 参数列表 imei（设备唯一标示）       n（最新命令数）    appid(软件ID)    pid（频道ID）
 请求类型 GET
 返回类型 XML
 返回示例 periodicalitems@sn_state|item|F_ID:F_InsertTime:F_State
 备注
 ---------------------*/
#define kCommandsURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_statedperiodicalitem.ashx?imei=%@&pid=%@&n=%@&appid=%@"


/*---------------------
 单个文章URL
 参数个数 2
 参数列表 imei（设备唯一标示）       gid（文章ID）
 请求类型 GET
 返回类型 XML
 返回示例 item|id:title:pageurl:zipurl:attachments:date:inserttime:pn:pid:summary:thumbnail
 备注
 ---------------------*/
#define kOneArticleURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/sjb_periodicalitem.ashx?gid=%@&imei=%@"



/*---------------------
 用户行为URL
 参数个数 0
 参数列表 json={"os":"iPhone OS8.0","items":[],"imei":"A6677859-8570-4427-8903-981C0293BE1C"}
 请求类型 POST
 返回类型 TEXT
 返回示例 OK（操作成功）
 备注
 ---------------------*/
#define kUserActionsURL @"http://mis.xinhuanet.com/sxtv2/mobile/interface/sjb_literread.ashx"



/*---------------------
 短信验证码URL
 参数个数 3
 参数列表 imei（设备唯一标示）  phone (手机号码) appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 OK（操作成功）ERROR:XXX(错误原因)
 备注
 ---------------------*/
#define kMMSVeriyCodeURL @"http://mis.xinhuanet.com/SXTV2/mobile/interface/common_mmscode.ashx?imei=%@&phone=%@&appid=%@"




/*---------------------
 获取产品下某天的文章列表URL
 参数个数 4
 参数列表 imei（设备唯一标示）  pid（频道ID） date (日期：20141103) appid(软件ID)
 请求类型 GET
 返回类型 XML
 返回示例 XML
 备注
 ---------------------*/
#define kDailyArticlesURL @"http://mis.xinhuanet.com/SXTV2/Mobile/interface/common_articles_daily.ashx?imei=%@&order=asc&pid=%@&date=%@&appid=%@"





/*---------------------
 文章评论URL
 参数个数 5
 参数列表 imei（设备唯一标示）  sn（授权码）  literid(稿件ID)  content(评论内容)    appid(软件ID)
 请求类型 GET
 返回类型 TEXT
 返回示例 XML
 备注
 ---------------------*/
#define kCommentURL @"http://mis.xinhuanet.com/sxtv2/Mobile/interface/common_litercomment.ashx?imei=%@&sn=%@&literid=%@&content=%@&appid=%@"




/*---------------------
 获取评论列表URL
 参数个数 2
 参数列表 imei（设备唯一标示）  sn（授权码）   appid(软件ID)
 请求类型 GET
 返回类型 XML
 返回示例 XML
 备注
 ---------------------*/
#define kCommentListURL @"http://mis.xinhuanet.com/sxtv2/Mobile/interface/common_comment_list.ashx?imei=%@&sn=%@&appid=%@"
