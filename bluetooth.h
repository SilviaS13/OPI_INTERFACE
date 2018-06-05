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

    //=====enums================================================================================
//    Q_ENUMS(ClockSettings)
//    Q_ENUMS(LightSettings)
//    Q_ENUMS(MusicSettings)

public:
    Bluetooth();
    enum ClockSettings{Hours, Mins, Mode, R, G, B,
                 Music, Mus_e,Enabled,Demo,};
    enum LightSettings{Name, Mode_l, R_l, G_l, B_l,
                       ENABLED_L,DemL};
    enum MusicSettings{SONG_NAME, PATH};


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
    void connectToDevice(const QString &mac);
    void addDevice(const QBluetoothDeviceInfo&);
//    void on_power_clicked(bool clicked);
//    void on_discoverable_clicked(bool clicked);
    void pairingDone(QBluetoothAddress, QBluetoothLocalDevice::Pairing);
    void connected();
    void disconnected();
    //void pairingDone(QBluetoothLocalDevice::Pairing);

    //===helper functions==========================================================================
    void readSocket();
    void scanFinished();
    void setGeneralUnlimited(bool unlimited);
    void itemActivated(QString &item);
    void hostModeStateChanged(QBluetoothLocalDevice::HostMode);
    void addService(const QBluetoothServiceInfo&);
    void serviceDiscoveryDialog(const QBluetoothAddress &address);

public:
    //=====getters================================================================================
    QString getMac_address();
    QString getDevice_name();

    //====setters=================================================================================
    void setMac_address(const QString &mac);
    void setDevice_name(const QString &name);

    //====Q_INVOKABLE=============================================================================
    Q_INVOKABLE void startScan();
    Q_INVOKABLE void login();
    Q_INVOKABLE void getProperties(int type);
    Q_INVOKABLE void sendMessage(const QString &message);
    Q_INVOKABLE QString getClockProperty(char index);
    Q_INVOKABLE QString getLightProperty(char index);
    Q_INVOKABLE QStringList getMusicProperty();
    Q_INVOKABLE int hexToInt(QString color, const int part);
    Q_INVOKABLE QString intToHex(QString value);
//    Q_INVOKABLE void buildClockConfigString();
//    Q_INVOKABLE void buildLightConfigString();
    Q_INVOKABLE void split_clocks();
    Q_INVOKABLE void split_lights();

private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothServiceDiscoveryAgent* serviceDiscoveryAgent;
    QBluetoothLocalDevice *localDevice = new QBluetoothLocalDevice;
    QBluetoothSocket *socket;

    QString _mac_address;
    QString _device_name;
    bool _device_found = false;
    bool _nextClock_found;

};

#endif // BLUETOOTH_H
