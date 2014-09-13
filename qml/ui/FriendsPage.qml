import QtQuick 2.0
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.ListItems 0.1 as ListItem
import Ubuntu.Components.Popups 0.1
import "../js/dateutils.js" as DateUtils
import "../js/weiboapi.js" as WB
import "../components"

Page {
    id: friendsPage
    title: i18n.tr("Friends")

    property var uid/*: friendsPage.fuid*/
    property var modelFriend
    property var mode/*: friendsPage.fmode*/

    Component.onCompleted: setMode(mode, uid)

    function setMode(mode, uid) {
//        userGetFollowing(settings.getAccess_token(), uid, 10, 0)
//        friendsPage.uid = uid
//        selectorFriend.selectedIndex = -1
        switch (mode) {
        case "following":
            selectorFriend.selectedIndex = 0
            break
        case "follower":
            selectorFriend.selectedIndex = 1
            break
        case "bilateral":
            selectorFriend.selectedIndex = 2
            break
        }
    }

    // get following
    function userGetFollowing(token, uid, count, cursor)
    {
        function observer() {}
        observer.prototype = {
            update: function(status, result)
            {
                if(status != "error"){
                    if(result.error) {
                        // TODO  error handler
                    }else {
                        // right result
//                        console.log("cursor: ", result.next_cursor, result.previous_cursor)
                        modelFollowing.cursor = result.next_cursor
                        if (result.next_cursor == 0) {
                            lvUsers0.footerItem.visible = false
                        }
                        for (var i=0; i<result.users.length; i++) {
                            modelFollowing.append(result.users[i])
                        }
                    }
                }else{
                    // TODO  empty result
                }
            }
        }

        WB.userGetFollowing(token, uid, count, cursor, new observer())
    }

    function addMoreFollowing() {
//        console.log("modelFollowing.cursor: ", modelFollowing.cursor)
        userGetFollowing(settings.getAccess_token(), uid, 30, modelFollowing.cursor)
    }

    // get follower
    function userGetFollower(token, uid, count, cursor)
    {
        function observer() {}
        observer.prototype = {
            update: function(status, result)
            {
                if(status != "error"){
                    if(result.error) {
                        // TODO  error handler
                    }else {
                        // right result
//                        console.log("cursor: ", result.next_cursor, result.previous_cursor)
                        modelFollower.cursor = result.next_cursor
                        if (result.next_cursor == 0) {
                            lvUsers1.footerItem.visible = false
                        }
                        for (var i=0; i<result.users.length; i++) {
                            modelFollower.append(result.users[i])
                        }
                    }
                }else{
                    // TODO  empty result
                }
            }
        }

        WB.userGetFollower(token, uid, count, cursor, new observer())
    }

    function addMoreFollower() {
//        console.log("modelFollower.cursor: ", modelFollower.cursor)
        userGetFollower(settings.getAccess_token(), uid, 30, modelFollower.cursor)
    }

    // get bilateral
    function userGetBilateral(token, uid, count, page)
    {
        function observer() {}
        observer.prototype = {
            update: function(status, result)
            {
                if(status != "error"){
                    if(result.error) {
                        // TODO  error handler
                    }else {
                        // right result
//                        modelBilateral.cursor = result.next_cursor
                        for (var i=0; i<result.users.length; i++) {
                            modelBilateral.append(result.users[i])
                        }
                        if (modelBilateral.count == result.total_number) {
                            lvUsers2.footerItem.visible = false
                        }
                    }
                }else{
                    // TODO  empty result
                }
            }
        }

        WB.userGetBilateral(token, uid, count, page, new observer())
    }

    function addMoreBilateral() {
        console.log("modelBilateral.cursor: ", modelBilateral.cursor)
        modelBilateral.cursor++
        userGetBilateral(settings.getAccess_token(), uid, 30, modelBilateral.cursor)
    }


    ListModel{
        id: modelFollowing
        property int cursor: 0
    }

    ListModel{
        id: modelFollower
        property int cursor: 0
    }

    ListModel{
        id: modelBilateral
        property int cursor: 1
    }


    Flickable {
        id: scrollArea
        boundsBehavior: (contentHeight > height) ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
        anchors.fill: parent
        contentWidth: width
        contentHeight: innerAreaColumn.height + units.gu(1)

        Column {
            id: innerAreaColumn

            spacing: units.gu(1)
            anchors {
                top: parent.top;
//                topMargin: units.gu(1)
                //                margins: units.gu(1)
                left: parent.left; right: parent.right
                //                leftMargin: units.gu(1); rightMargin: units.gu(1)
            }
            height: childrenRect.height

            ListItem.ValueSelector {
                id: selectorFriend
                text: i18n.tr("Now showing: ")
                values:  [i18n.tr("Following"), i18n.tr("Follower"), i18n.tr("Bilateral")]
                selectedIndex: -1

                onSelectedIndexChanged: {
                    switch(selectorFriend.selectedIndex) {
                    case 0:
                        modelFriend = modelFollowing
                        if (modelFollowing.count == 0) {
                            userGetFollowing(settings.getAccess_token(), uid, 30, modelFollowing.cursor)
                        }
                        break
                    case 1:
                        modelFriend = modelFollower
                        if (modelFollower.count == 0) {
                            userGetFollower(settings.getAccess_token(), uid, 30, modelFollower.cursor)
                        }
                        break
                    case 2:
                        modelFriend = modelBilateral
                        if (modelBilateral.count == 0) {
                            userGetBilateral(settings.getAccess_token(), uid, 30, modelBilateral.cursor)
                        }
                        break
                    }
                }
            }

            ListView {
                id: lvUsers0
                width: parent.width
                height: selectorFriend.selectedIndex == 0 ? contentItem.childrenRect.height : 0
                visible: selectorFriend.selectedIndex == 0
                interactive: false
                spacing: units.gu(1)
                model: modelFollowing
                delegate: delegateUser
                footer: FooterLoadMore{
                    onClicked: addMoreFollowing()
                }
            }

            ListView {
                id: lvUsers1
                width: parent.width
                height: selectorFriend.selectedIndex == 1 ? contentItem.childrenRect.height : 0
                visible: selectorFriend.selectedIndex == 1
                interactive: false
                spacing: units.gu(1)
                model: modelFollower
                delegate: delegateUser
                footer: FooterLoadMore{
                    onClicked: addMoreFollower()
                }
            }

            ListView {
                id: lvUsers2
                width: parent.width
                height: selectorFriend.selectedIndex == 2 ? contentItem.childrenRect.height : 0
                visible: selectorFriend.selectedIndex == 2
                interactive: false
                spacing: units.gu(1)
                model: modelBilateral
                delegate: delegateUser
                footer: FooterLoadMore{
                    onClicked: addMoreBilateral()
                }
            }
        }
    }

    Component {
        id: delegateUser

        Item {
            width: parent.width
            height: childrenRect.height

            Column {
                id: columnWContent
                anchors {
                    top: parent.top; /*topMargin: units.gu(1)*/
                    left: parent.left; right: parent.right

                }
                spacing: units.gu(0.5)
                height: childrenRect.height

                Row {
                    id: rowUser
                    anchors { left: parent.left; right: parent.right; leftMargin: units.gu(1); rightMargin: units.gu(1) }
                    spacing: units.gu(1)
                    height: usAvatar.height

                    UbuntuShape {
                        id: usAvatar
                        width: units.gu(4.5)
                        height: width
                        image: Image {
                            source: model.profile_image_url
                        }
                    }

                    Label {
                        id: labelUserName
                        color: "black"
                        text: model.screen_name
                    }
                }

//                Label {
//                    id: labelWeibo
//                    width: parent.width
//                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
//                    color: "black"
//                    text: model.text
//                }

                ListItem.ThinDivider {
                    width: parent.width
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainView.toUserPage(model.id)
                }
            }
        }
    }
}
