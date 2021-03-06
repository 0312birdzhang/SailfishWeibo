/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.
  
  You may use this file under the terms of BSD license as follows:
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
      
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR 
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QtQuick>
#include <QtQml>
#include <QUrl>
#include <QQmlEngine>
#include <sailfishapp.h>
#include <QGuiApplication>
#include "Utility.h"
#include "Settings.h"

#include "WBNetworkAccessManagerFactory.h"
#include "WBContentParser.h"

#include "PluginRegister.h"
#include "TokenProvider.h"

QQmlEngine *g_QQmlEngine;
int main(int argc, char *argv[])
{
    //QWeiboSDK
    QWeiboSDK::registerPlugins ("harbour.sailfish_sinaweibo.sunrain");

//    qmlRegisterType<MyType>("harbour.sailfish_sinaweibo.sunrain", 1, 0, "MyType");
//    qmlRegisterType<NetworkHelper>("harbour.sailfish_sinaweibo.sunrain", 1, 0, "NetworkHelper");

    QScopedPointer<QGuiApplication> app (SailfishApp::application(argc, argv));
    app.data()->setOrganizationName("harbour-sailfish_sinaweibo");
    app.data()->setApplicationName("harbour-sailfish_sinaweibo");
    
    QScopedPointer<QQuickView> view (SailfishApp::createView());
    
    QScopedPointer<WBNetworkAccessManagerFactory> factory (new WBNetworkAccessManagerFactory());
    view.data ()->engine ()->setNetworkAccessManagerFactory (factory.data ());
    g_QQmlEngine = view.data ()->engine ();

    Utility *util = Utility::instance ();
//    util->setEngine(view->engine());
    view.data ()->rootContext()->setContextProperty("appUtility", util);

    WBContentParser *contentParser = WBContentParser::instance ();
    view.data ()->rootContext ()->setContextProperty ("wbParser", contentParser);

    Settings *settings = Settings::instance ();
    view.data ()->rootContext ()->setContextProperty ("settings", settings);
    //Dirty hack for fix SilicaWebView, it seems that SilicaWebView has a own settings property
    view.data ()->rootContext ()->setContextProperty ("weiboSettings", settings);

    QWeiboSDK::TokenProvider *provider = QWeiboSDK::TokenProvider::instance ();
    view.data ()->rootContext ()->setContextProperty ("tokenProvider", provider);
    //Dirty hack for fix SilicaWebView, it seems that SilicaWebView has a own settings property
    view.data ()->rootContext ()->setContextProperty ("webTokenProvider", provider);

    view.data ()->setSource(QUrl(QStringLiteral("qrc:/SailfishWeibo.qml")));
    view.data ()->show();
    QObject::connect (view.data ()->engine (), &QQmlEngine::quit,
                      app.data (), &QGuiApplication::quit);
    return app->exec();
}

