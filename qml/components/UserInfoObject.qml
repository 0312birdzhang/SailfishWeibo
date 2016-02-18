import QtQuick 2.0

QtObject {
    id: userInfoObject
    objectName: "UserInfoObject"
    function deleteSelf() {
        console.log("[UserInfoObject] : Destroying...");
//        userInfoObject.deleteLater();
        userInfoObject.destroy();
    }

    property var usrInfo: {
        "id":-1,
        "idstr":"",
        "class":1,
        "screen_name":"",
        "name":"",
        "province":"",
        "city":"",
        "location":"",
        "description":"",
        "url":"",
        "cover_image_phone":"",
        "profile_image_url":"",
        "profile_url":"",
        "domain":"",
        "weihao":"",
        "gender":"",
        "followers_count":0,
        "friends_count":0,
        "pagefriends_count": 0,
        "statuses_count":0,
        "favourites_count":0,
        "created_at":"Sun Jan 22 13:32:37 +0800 1999",
        "following":false,
        "allow_all_act_msg":false,
        "geo_enabled":true,
        "verified":false,
        "verified_type":-1,
        "remark":"",
        "status":{
            "created_at": "Mon Jan 04 23:36:38 +0800 2016",
                    "id": 0,
                    "mid": "",
                    "idstr": "",
                    "text": "",
                    "source_allowclick": 0,
                    "source_type": 1,
                    "source": "",
                    "favorited": false,
                    "truncated": false,
                    "in_reply_to_status_id": "",
                    "in_reply_to_user_id": "",
                    "in_reply_to_screen_name": "",
                    "pic_urls": [],
                    "geo": null,
                    "reposts_count": 0,
                    "comments_count": 0,
                    "attitudes_count": 0,
                    "isLongText": false,
                    "mlevel": 0,
                    "visible": {
                        "type": 0,
                        "list_id": 0
                    },
                    "biz_feature": 0,
                    "darwin_tags": [],
                    "userType": 0
        },
        "ptype":0,
        "allow_all_comment":true,
        "avatar_large":"",
        "avatar_hd":"",
        "verified_reason":"",
        "verified_trade": "",
        "verified_reason_url": "",
        "verified_source": "",
        "verified_source_url": "",
        "follow_me":false,
        "online_status":0,
        "bi_followers_count":0,
        "lang":"zh-cn",
        "star":0,
        "mbtype":0,
        "mbrank":0,
        "block_word":0,
        "block_app": 0,
        "credit_score": 0,
        "user_ability": 0,
        "urank": 0
    }
}
