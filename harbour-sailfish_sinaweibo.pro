TEMPLATE = app
# The name of your application
TARGET = harbour-sailfish_sinaweibo

QT += qml quick network

CONFIG += sailfishapp sailfishapp_no_deploy_qml
CONFIG += c++11
CONFIG += WITH_HACKLOGIN WITH_SDK_WRAPPER

QMAKE_CFLAGS_DEBUG += -fPIC
QMAKE_CFLAGS_RELEASE += -fPIC
QMAKE_CXXFLAGS += -fPIC

DEFINES += \
    SAILFISH_OS

LIBS += -lhtmlcxx

INCLUDEPATH += \
    /usr/include/htmlcxx

win32 {
    DEFINES += \
        VERSION_STR="win32_dummy"
}
unix {
    DEFINES += \
        VERSION_STR=\\\"$$system($${PWD}/get_version_str.sh)\\\"
}

include (src/QSinaWeiboApi/QWeiboSDK/QWeiboSDK.pri)

OTHER_FILES += \
    rpm/harbour-sailfish_sinaweibo.changes.in \
    rpm/harbour-sailfish_sinaweibo.spec \
    rpm/harbour-sailfish_sinaweibo.yaml \
    harbour-sailfish_sinaweibo.desktop \
    translations/* \
    qml/pages/*.qml \
    qml/components/*.qml \
    qml/cover/*.qml \
    qml/ui/*.qml \
    qml/requests/*.qml \
    qml/SailfishWeibo.qml \
    qml/js/*.js \
    qml/WeiboFunctions.qml \
    qml/WBSendFunctions.qml

graphics.path = /usr/share/$${TARGET}/qml/graphics
graphics.files += qml/graphics/*
INSTALLS += graphics

emoticons.path = /usr/share/$${TARGET}/qml/emoticons
emoticons.files += qml/emoticons/*
INSTALLS += emoticons

warning.path = /usr/share/$${TARGET}/qml
warning.files += qml/warning.html
INSTALLS += warning



HEADERS += \
    src/app/Emoticons.h \
    src/app/Settings.h \
    src/app/WBNetworkAccessManagerFactory.h \
    src/app/WBNetworkAccessManager.h \
    src/app/Utility.h \
    src/app/WBContentParser.h \
    src/app/WBSender.h

SOURCES += \
    src/app/Emoticons.cpp \
    src/app/SailfishWeibo.cpp \
    src/app/Settings.cpp \
    src/app/WBNetworkAccessManagerFactory.cpp \
    src/app/WBNetworkAccessManager.cpp \
    src/app/Utility.cpp \
    src/app/WBContentParser.cpp \
    src/app/WBSender.cpp

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-sailfish_sinaweibo-de.ts \
                translations/harbour-sailfish_sinaweibo-zh_CN.ts

RESOURCES += \
    qml/resource.qrc

win32 {
    COPY = copy /y
    MKDIR = mkdir
} else {
    COPY = cp
    MKDIR = mkdir -p
}
