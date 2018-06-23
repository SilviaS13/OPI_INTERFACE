#include "bluetooth.h"

#define DEBUG  1

enum settings{EMPTY = -1, LOGIN, ALL_CLOCKS, ALL_LIGHTS, ALL_MUSIC};


struct Response
{
    QString line = "-";
    QStringList clock_prop;
    QStringList single_clock_prop;
    QStringList light_prop;
    QStringList single_light_prop;
    QStringList music_list;
    QStringList splitted_music_list;
}response;

struct Request
{
    QString clocksPath = "/root/conf/clocks";     /*"/tmp/conf/clocks"*/
    QString lightsPath = "/root/conf/lights";     /*"/tmp/conf/lights"*/
    QString musicPath = "/root/conf/music";     /*"/tmp/conf/music"*/
    QString clearClocksFile = "> " + clocksPath;
    QString clearLightsFile =  "> " + lightsPath;
    QString getClocks = "cat "+ clocksPath;
    QString getLights = "cat " + lightsPath;
    QString getMusic = "cat " + musicPath;
    QString echo = "echo ";
    QString login = "root";
    QString pass = "12345678";
    int queryType = EMPTY;
    bool ping_start = false;
}request;

//////////////////////////////////////////////////////
//===================== INIT =======================//
//////////////////////////////////////////////////////

Bluetooth::Bluetooth() : localDevice(new QBluetoothLocalDevice),
                        discoveryAgent(new QBluetoothDeviceDiscoveryAgent),
                        socket(new QBluetoothSocket(QBluetoothServiceInfo::RfcommProtocol))
{
    connect(discoveryAgent, SIGNAL(deviceDiscovered(QBluetoothDeviceInfo)),
            this, SLOT(addDevice(QBluetoothDeviceInfo)));
    connect(discoveryAgent, SIGNAL(finished()), this, SLOT(scanFinished()));

    connect(localDevice, SIGNAL(hostModeStateChanged(QBluetoothLocalDevice::HostMode)),
            this, SLOT(hostModeStateChanged(QBluetoothLocalDevice::HostMode)));
    hostModeStateChanged(localDevice->hostMode());

    connect(localDevice, SIGNAL(pairingFinished(QBluetoothAddress,QBluetoothLocalDevice::Pairing)),
            this, SLOT(pairingDone(QBluetoothAddress,QBluetoothLocalDevice::Pairing)));    
}

void Bluetooth::sendMessage(const QString &message)
{
    QByteArray text = message.toUtf8() + '\n';
    if (socket->state() == QBluetoothSocket::ConnectedState){
        socket->write(text);
    }
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
#ifdef DEBUG
    qDebug() << "\n\n trying to get bluetooth state\n";
#endif
    if (socket->state() == QBluetoothSocket::ConnectedState)
#ifdef DEBUG
        qDebug()<< "CONNECTED TO " << mac;
#endif
    connect(socket, SIGNAL(readyRead()), this, SLOT(readSocket()));
    connect(socket, SIGNAL(connected()), this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()), this, SLOT(disconnected()));
}

void Bluetooth::login()
{
    ////////    LOGIN PART //////////
    request.queryType = LOGIN;
    if (request.ping_start){
        for(int i=0; i<10; i++){
            sendMessage("");
        }
        request.ping_start = false;
    }
#ifdef DEBUG
    qDebug() << "\n HELLO FROM LOGIN!\n";
#endif
    sendMessage(request.login);
}

void Bluetooth::sendProperties(QString message, int type)
{
    QString command = request.echo + message + " >> " +
            (type == ALL_CLOCKS ? request.clocksPath : request.lightsPath);
#ifdef DEBUG
    qDebug() << command;
#endif
    request.queryType = EMPTY;
    sendMessage(command);
}

void Bluetooth::clearPropFile(int queryType)
{
    request.queryType = EMPTY;
    switch (queryType) {
    case ALL_CLOCKS:{
#ifdef DEBUG
    qDebug() << "CLEAR PROP ALL_CLOCKS";
#endif
        sendMessage(request.clearClocksFile);
        break;
    }
    case ALL_LIGHTS:{
#ifdef DEBUG
        qDebug() << "CLEAR PROP ALL_LIGHTS";
#endif
        sendMessage(request.clearLightsFile);
        break;
    }
    case ALL_MUSIC:{
#ifdef DEBUG
        qDebug() << "CLEAR PROP ALL_MUSIC";
#endif
        //////// DO SOMETHING /////////////
        break;
    }
    default:
#ifdef DEBUG
        qDebug() << "CLEAR PROP DEFAULT CASE";
#endif
        break;
    }
}

void Bluetooth::setPingStart()
{
    request.ping_start = true;
}

void Bluetooth::getProperties(int type)
{
    if (type == ALL_CLOCKS){
        response.clock_prop.clear();
        request.queryType = ALL_CLOCKS;
        sendMessage(request.getClocks);
    }
    else if (type == ALL_LIGHTS){
        response.light_prop.clear();
        request.queryType = ALL_LIGHTS;
        sendMessage(request.getLights);

    }
    else if (type == ALL_MUSIC){
        response.music_list.clear();
        request.queryType = ALL_MUSIC;
        sendMessage(request.getMusic);
    }
}

QString Bluetooth::getClockProperty(char index)
{
    return response.single_clock_prop[index];
}

QString Bluetooth::getLightProperty(char index)
{
    return response.single_light_prop[index];
}

QStringList Bluetooth::getMusicProperty()
{
    return response.music_list;
}

void Bluetooth::split_clocks(){

    foreach (QString str, response.clock_prop) {
        response.single_clock_prop = str.split(",", QString::SkipEmptyParts);
#ifdef DEBUG
        qDebug() << "Clocks length = " << response.single_clock_prop.length();
#endif
        if (response.single_clock_prop.length() == 10){
            emit nextClock_found();
        }
    }
}

void Bluetooth::split_lights(){
    foreach (QString str, response.light_prop) {
        response.single_light_prop = str.split(",", QString::SkipEmptyParts);
    #ifdef DEBUG
            qDebug() << "Lights length = " << response.single_light_prop.length();
    #endif
        if (response.single_light_prop.length() == 7){
            emit nextLight_found();
        }
    }
}

int Bluetooth::hexToInt( QString color, const int part)
{
    unsigned int intPart = 0;
    unsigned int koef = 16;
    int iter = 0;
    foreach (QChar cc, color) {
        if (iter == part || iter == part+1){
            int c = cc.toLatin1();
            intPart += (c - (( c > 57 )? 87 : '0'))*koef;
            koef = 1;
        }
        iter++;
    }
    return intPart;
}

QString Bluetooth::intToHex(QString value)
{
    int val = value.toInt();
    std::stringstream ss;
    ss << std::hex << val;
    QString res = QString::fromStdString(ss.str());
    if (res.count() == 1)
        res = "0" + res;
    return res;
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

void Bluetooth::readSocket()
{
    QBluetoothSocket *read_socket = qobject_cast<QBluetoothSocket *>(sender());
    if (!read_socket)
        return;
    response.line = "-";

    ///READ ALL AVALIABLE STRINGS IN BLUETOOTH BUFFER
    while (read_socket->canReadLine()) {
        response.line = read_socket->readLine().trimmed();

        if (response.line == "-" ||request.queryType == EMPTY) return;

#ifdef DEBUG
        qDebug() << response.line;
#endif

        switch (request.queryType) {
            case LOGIN:{
                ///logged in case
                if (response.line == "root@orangepizero:~# root"
                        || response.line == "root: command not found"){
#ifdef DEBUG
                        qDebug() << "\n ALREADY LOGGED IN\n";
#endif
                        request.queryType = EMPTY;
                        emit device_connected();
                    }
                    ///send password case
                    else if (response.line == ("orangepizero login: "+ request.login) ||
                             response.line == request.login)
                    {
                        sendMessage(request.pass);
#ifdef DEBUG
                        qDebug() << "\n send password case\n";
#endif
                    }
                    ///send login case
                    else if (response.line == "Login incorrect" ||
                             response.line =="Password:" ||
                             response.line =="Password:" + request.login ||
                             response.line =="orangepizero login:"||
                             response.line =="Debian GNU/Linux 9 orangepizero ttyS0")
                    {
                        login();
#ifdef DEBUG
                        qDebug() << "send login case";
#endif
                    }
                    else{
                        //login();
#ifdef DEBUG
                        qDebug() << "else CASE";
#endif
                    }
                    break;
                }
            case ALL_CLOCKS: {
#ifdef DEBUG
                qDebug() << "ALL_CLOCKS CASE: " << response.line;
#endif
                response.clock_prop.append(response.line);
                if (response.clock_prop.last() == "end"){
#ifdef DEBUG
                    qDebug() << "\n EOF \n";
#endif
                    request.queryType = EMPTY;
                    emit eofClocks();
                }
                break;
            }
            case ALL_LIGHTS: {
    #ifdef DEBUG
                    qDebug() << "ALL_LIGHTS CASE";
    #endif
                    response.light_prop.append(response.line);
                    if (response.light_prop.last() == "end"){
    #ifdef DEBUG
                        qDebug() << "\n EOF \n";
    #endif
                        emit eofLights();
                        request.queryType = EMPTY;
                    }
                break;
            }
            case ALL_MUSIC: {
#ifdef DEBUG
                        qDebug() << "ALL_MUSIC CASE";
#endif
                        QString str = response.line;
                        response.music_list = str.split(",", QString::SkipEmptyParts);
                        break;
                    }
            default: {
#ifdef DEBUG
                qDebug() << "EMPTY CASE in response read";
#endif
            break;
            }
        }
    }///END OF READ ALL AVALIABLE STRINGS
}

void Bluetooth::connected(){
#ifdef DEBUG
    qDebug() << "\nCONNECTED SLOT!!!!\n";
#endif
    login();
}

// !!!!!!!!!!! do smth with this. inform user about disconnected
void Bluetooth::disconnected(){
#ifdef DEBUG
    qDebug() << "DISCONNECTED SLOT!";
#endif
}

//SLOT TO discoveryAgent, SIGNAL(finished())
void Bluetooth::scanFinished(){
#ifdef DEBUG
    qDebug() << "SCANNING FINISHED, OK";
#endif
}

//////////////////////////////////////////////////////
//=============== UNUSED SLOTS =====================//
//////////////////////////////////////////////////////

void Bluetooth::hostModeStateChanged(QBluetoothLocalDevice::HostMode mode)
{
    if (mode != QBluetoothLocalDevice::HostPoweredOff) return;

    if (mode == QBluetoothLocalDevice::HostDiscoverable) return;

    if (mode == QBluetoothLocalDevice::HostPoweredOff) return;
}

void Bluetooth::pairingDone(QBluetoothAddress addr,QBluetoothLocalDevice::Pairing pairing)
{

    if (pairing == QBluetoothLocalDevice::Paired || pairing == QBluetoothLocalDevice::AuthorizedPaired ) {
        //DO SMTH WHEN PAIRED
#ifdef DEBUG
        qDebug() << "Paired!!" << addr.toString();
#endif
    }
    else {
        //IF PAIRING FAILED
#ifdef DEBUG
        qDebug() << "Not Paired!!";
#endif
    }
}

//////////////////////////////////////////////////////
//=========== GETTERS AND SETTERS ==================//
//////////////////////////////////////////////////////

QString Bluetooth::getMac_address(){
    return _mac_address;
}

QString Bluetooth::getDevice_name(){
    return _device_name;
}

void Bluetooth::setMac_address(const QString &mac){
    _mac_address = mac;
}

void Bluetooth::setDevice_name(const QString &name){
    _device_name = name;
}
