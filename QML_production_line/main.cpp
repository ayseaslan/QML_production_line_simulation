#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "SystemState.h"




int main(int argc, char *argv[])
{

    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;


    //SystemState state;

    qmlRegisterType<SystemState>("Pack", 1, 0, "SystemState");

   // engine.rootContext()->setContextProperty("state", &state);

    engine.load(QUrl(QStringLiteral("main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
