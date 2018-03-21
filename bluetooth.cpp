#include "bluetooth.h"


//////////////////////////////////////////////////////
//===================== INIT =======================//
//////////////////////////////////////////////////////

Bluetooth::Bluetooth() : localDevice(new QBluetoothLocalDevice), discoveryAgent(new QBluetoothDeviceDiscoveryAgent),
    _device_found(false), socket(new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol))
{
    connect(discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SLOT(addDevice(QBluetoothDeviceInfo)));
    connect(discoveryAgent, SIGNAL(finished()), this, SLOT(scanFinished()));

    connect(localDevice, SIGNAL(hostModeStateChanged(QBluetoothLocalDevice::HostMode)),
            this, SLOT(hostModeStateChanged(QBluetoothLocalDevice::HostMode)));
    hostModeStateChanged(localDevice->hostMode());

    connect(localDevice, SIGNAL(pairingFinished(QBluetoothAddress,QBluetoothLocalDevice::Pairing))
        , this, SLOT(pairingDone(QBluetoothAddress,QBluetoothLocalDevice::Pairing)));
}


//////////////////////////////////////////////////////
//=============== QML FUNCTIONS ====================//
//////////////////////////////////////////////////////

void Bluetooth::startScan()
{
    if (localDevice->HostPoweredOff)
        localDevice->powerOn();

     discoveryAgent->start();
}

void Bluetooth::connectToDevice(const QString &mac)
{
    //do magic with rfcomm
    static const QString serviceUuid(QStringLiteral("00001101-0000-1000-8000-00805F9B34FB"));
    socket->connectToService(QBluetoothAddress(mac), QBluetoothUuid(serviceUuid), QIODevice::ReadWrite);

    //trying to get bluetooth state
    if (socket->state() == QBluetoothSocket::ConnectedState)
        qDebug() << "CONNECTED TO " << mac;

    socket->write("h");

    connect(socket, SIGNAL(readyRead()), this, SLOT(readSocket()));
    connect(socket, SIGNAL(connected()), this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()), this, SIGNAL(disconnected()));
}

void Bluetooth::sendMessage(const QString &message)
{
    QByteArray text = message.toUtf8() + '\n';

    //foreach (QBluetoothSocket *socket, clientSockets)
    socket->write(text);
}


//////////////////////////////////////////////////////
//================= USED SLOTS =====================//
//////////////////////////////////////////////////////

//SLOT TO deviceDiscovered(QBluetoothDeviceInfo)
void Bluetooth::addDevice(const QBluetoothDeviceInfo &info)
{
    QBluetoothLocalDevice::Pairing pairingStatus = localDevice->pairingStatus(info.address());
    if (pairingStatus == QBluetoothLocalDevice::Paired || pairingStatus == QBluetoothLocalDevice::AuthorizedPaired )
        _device_name = info.name() + "(PAIRED)";
    else
        _device_name = info.name();

    _mac_address = info.address().toString();


    _device_found = true;
    emit device_foundChanged();
}

//SLOT TO discoveryAgent, SIGNAL(finished())
void Bluetooth::scanFinished()
{

}

void Bluetooth::readSocket()
{
    QBluetoothSocket *socket = qobject_cast<QBluetoothSocket *>(sender());
    if (!socket)
        return;
    QByteArray line = "";
    while (socket->canReadLine()) {
        line = socket->readLine().trimmed();
//        emit messageReceived(socket->peerName(),
//                             QString::fromUtf8(line.constData(), line.length()));
    }
    if (line != ""){
        qDebug() << "RECIEVED: " <<line;

    //ПЛЯШЕМ И ПИХАЕМ ПО КЕЙСАМ:
//    БУДИЛЬНИКИ
//    МОДЫ
//    НАСТРОЙКИ
//        ЦВЕТ
//        ПЕСНЯ
//    МУЗЫКА


    }
}


//////////////////////////////////////////////////////
//=============== UNUSED SLOTS =====================//
//////////////////////////////////////////////////////

void Bluetooth::setGeneralUnlimited(bool unlimited)
{
    if (unlimited)
        discoveryAgent->setInquiryType(QBluetoothDeviceDiscoveryAgent::GeneralUnlimitedInquiry);
    else
        discoveryAgent->setInquiryType(QBluetoothDeviceDiscoveryAgent::LimitedInquiry);
}

void Bluetooth::itemActivated(QString &item)
{
    QString text = item;

    //IF NOT PAIRED
        //PAIR
    int index = text.indexOf(' ');

    if (index == -1)
        return;
    //PAIR OR CONNECT HERE

    QBluetoothAddress address(text.left(index));
    QString name(text.mid(index + 1));

    serviceDiscoveryDialog(address);

}

void Bluetooth::on_discoverable_clicked(bool clicked)
{
    if (clicked)
        localDevice->setHostMode(QBluetoothLocalDevice::HostDiscoverable);
    else
        localDevice->setHostMode(QBluetoothLocalDevice::HostConnectable);
}

void Bluetooth::on_power_clicked(bool clicked)
{
    if (clicked)
        localDevice->powerOn();
    else
        localDevice->setHostMode(QBluetoothLocalDevice::HostPoweredOff);
}

void Bluetooth::hostModeStateChanged(QBluetoothLocalDevice::HostMode mode)
{
    if (mode != QBluetoothLocalDevice::HostPoweredOff);

    if (mode == QBluetoothLocalDevice::HostDiscoverable);

    //bool on = !(mode == QBluetoothLocalDevice::HostPoweredOff);
}

void Bluetooth::displayPairingMenu()
{
    QBluetoothAddress address (_mac_address);
    if (true) {
        localDevice->requestPairing(address, QBluetoothLocalDevice::Paired);
    }
    else{
        localDevice->requestPairing(address, QBluetoothLocalDevice::Unpaired);
    }
}

void Bluetooth::pairingDone(const QBluetoothAddress &address, QBluetoothLocalDevice::Pairing pairing)
{

    if (pairing == QBluetoothLocalDevice::Paired || pairing == QBluetoothLocalDevice::AuthorizedPaired ) {
        //DO SMTH WHEN PAIRED
    }
    else {
        //IF PAIRING FAILED
    }
}

//////////////////////////////////////////////////////
//=========== SERVICE DISCOVERING ==================//
//////////////////////////////////////////////////////

void Bluetooth::serviceDiscoveryDialog( const QBluetoothAddress &address)
{
    //Using default Bluetooth adapter
    QBluetoothLocalDevice localDevice;
    QBluetoothAddress adapterAddress = localDevice.address();

    /*
     * In case of multiple Bluetooth adapters it is possible to
     * set which adapter will be used by providing MAC Address.
     * Example code:
     *
     * QBluetoothAddress adapterAddress("XX:XX:XX:XX:XX:XX");
     * discoveryAgent = new QBluetoothServiceDiscoveryAgent(adapterAddress);
     */

    serviceDiscoveryAgent = new QBluetoothServiceDiscoveryAgent(adapterAddress);

    serviceDiscoveryAgent->setRemoteAddress(address);

    //setWindowTitle(name);

    connect(discoveryAgent, SIGNAL(serviceDiscovered(QBluetoothServiceInfo)),
            this, SLOT(addService(QBluetoothServiceInfo)));
    //connect(discoveryAgent, SIGNAL(finished()), ui->status, SLOT(hide()));

    serviceDiscoveryAgent->start();
}

void Bluetooth::addService(const QBluetoothServiceInfo &info)
{
    if (info.serviceName().isEmpty())
        return;

    QString line = info.serviceName();
    if (!info.serviceDescription().isEmpty())
        line.append("\n\t" + info.serviceDescription());
    if (!info.serviceProvider().isEmpty())
        line.append("\n\t" + info.serviceProvider());

    qDebug() << line;
    //RETURN SERVICES HERE

}


//////////////////////////////////////////////////////
//=========== GETTERS AND SETTERS ==================//
//////////////////////////////////////////////////////

QString Bluetooth::getMac_address()
{
    return _mac_address;
}

QString Bluetooth::getDevice_name()
{
    return _device_name;
}

bool Bluetooth::getDevice_found()
{
    return _device_found;
}

void Bluetooth::setMac_address(const QString &mac)
{
    _mac_address = mac;
}

void Bluetooth::setDevice_name(const QString &name)
{
    _device_name = name;
}

void Bluetooth::setDevice_found(bool &b)
{
    _device_found = b;
}
