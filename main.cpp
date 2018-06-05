#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "bluetooth.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<Bluetooth>("Bluetooth_Module", 1, 0, "Bluetooth");
    qmlRegisterType<Bluetooth>("Clock_settings_Module", 1, 0, "Clocks");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
