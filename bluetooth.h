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

QT_FORWARD_DECLARE_CLASS(QBluetoothAddress)
QT_FORWARD_DECLARE_CLASS(QBluetoothServiceInfo)
QT_FORWARD_DECLARE_CLASS(QBluetoothServiceDiscoveryAgent)

QT_USE_NAMESPACE

class Bluetooth : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString mac_address READ getMac_address WRITE setMac_address NOTIFY mac_addressChanged)
    Q_PROPERTY(QString device_name READ getDevice_name WRITE setDevice_name NOTIFY device_nameChanged)
    Q_PROPERTY(bool device_found READ getDevice_found WRITE setDevice_found NOTIFY device_foundChanged)
public:
    Bluetooth();

signals:
    void mac_addressChanged();
    void device_nameChanged();
    void device_foundChanged();

public slots:
    void connectToDevice(const QString &mac);
    void addDevice(const QBluetoothDeviceInfo&);
    void on_power_clicked(bool clicked);
    void on_discoverable_clicked(bool clicked);
    void displayPairingMenu();
    void pairingDone(const QBluetoothAddress&, QBluetoothLocalDevice::Pairing);
    QString getMac_address();
    QString getDevice_name();
    bool getDevice_found();
    void setMac_address(const QString &mac);
    void setDevice_name(const QString &name);
    void setDevice_found(bool &b);

    Q_INVOKABLE void startScan();
    Q_INVOKABLE void sendMessage(const QString &message);
    void readSocket();
    void scanFinished();
    void setGeneralUnlimited(bool unlimited);
    void itemActivated(QString &item);
    void hostModeStateChanged(QBluetoothLocalDevice::HostMode);
    void addService(const QBluetoothServiceInfo&);
    void serviceDiscoveryDialog(const QBluetoothAddress &address);
private:
    QBluetoothDeviceDiscoveryAgent *discoveryAgent;
    QBluetoothServiceDiscoveryAgent* serviceDiscoveryAgent;
    QBluetoothLocalDevice *localDevice;
    QBluetoothSocket *socket;

    QString _mac_address;
    QString _device_name;
    bool _device_found = false;
};

#endif // BLUETOOTH_H
