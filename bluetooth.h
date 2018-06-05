#ifndef BLUETOOTH_H
#define BLUETOOTH_H

#include <QDebug>
#include <QObject>
#include <QByteArray>
#include <qbluetoothlocaldevice.h>
#include <qbluetoothaddress.h>
#include <qbluetoothdevicediscoveryagent.h>
#include <qbluetoothservicediscoveryagent.h>
#include <qbluetoothserviceinfo.h>
#include <qbluetoothuuid.h>
#include <qbluetoothsocket.h>
#include <QQmlApplicationEngine>
#include <sstream>
#include <unistd.h>

QT_FORWARD_DECLARE_CLASS(QBluetoothAddress)
QT_FORWARD_DECLARE_CLASS(QBluetoothServiceInfo)
QT_FORWARD_DECLARE_CLASS(QBluetoothServiceDiscoveryAgent)

QT_USE_NAMESPACE

class Bluetooth : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString mac_address READ getMac_address
               WRITE setMac_address NOTIFY mac_addressChanged)
    Q_PROPERTY(QString device_name READ getDevice_name
               WRITE setDevice_name NOTIFY device_nameChanged)

public:
    Bluetooth();

    //=====getters================================================================================
    QString getMac_address();
    QString getDevice_name();

    //====setters=================================================================================
    void setMac_address(const QString &mac);
    void setDevice_name(const QString &name);

    //====Q_INVOKABLE=============================================================================
    Q_INVOKABLE void startScan();
    Q_INVOKABLE void connectToDevice(const QString &mac);
    Q_INVOKABLE void login();
    Q_INVOKABLE void getProperties(int type);
    Q_INVOKABLE QString getClockProperty(char index);
    Q_INVOKABLE QString getLightProperty(char index);
    Q_INVOKABLE QStringList getMusicProperty();
    Q_INVOKABLE int hexToInt(QString color, const int part);
    Q_INVOKABLE QString intToHex(QString value);
    Q_INVOKABLE void split_clocks();
    Q_INVOKABLE void split_lights();
    Q_INVOKABLE void sendProperties(QString message, int type);
    Q_INVOKABLE void clearPropFile(int queryType);

signals:
    void mac_addressChanged();
    void device_nameChanged();
    void device_foundChanged();
    void device_connected();
    void nextClock_found();
    void nextLight_found();
    void eofClocks();
    void eofLights();

public slots:
    void addDevice(const QBluetoothDeviceInfo&);
    void scanFinished();
    void pairingDone(QBluetoothAddress, QBluetoothLocalDevice::Pairing);
    void connected();
    void disconnected();
    void readSocket();
    void hostModeStateChanged(QBluetoothLocalDevice::HostMode);

private:
    void sendMessage(const QString &message);

    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothServiceDiscoveryAgent* serviceDiscoveryAgent;
    QBluetoothLocalDevice *localDevice;
    QBluetoothSocket *socket;

    QString _mac_address;
    QString _device_name;
    bool _device_found = false;
    bool _nextClock_found;

};

#endif // BLUETOOTH_H
