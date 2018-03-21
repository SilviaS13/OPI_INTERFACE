import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0

Page {
    width: 480
    height: 800

//    Bluetooth{
//        onDevice_foundChanged: {
//           _devList._devMac.push(bluetoothctl.getMac_address())
//           _devList._devName.push(bluetoothctl.getDevice_name())
//            _devList._devStateImage(_devList.unknown)
//            devListRefresh()
//            console.log("FOUND")
//        }
//    }


    header: Label {
            color: _header._color
            font.pixelSize: _header._fontPixelSize
            padding: 10
            text: qsTr("Пристрої")
            font.family: _items._fontFamily

    }


    //////////////// : REFRESH DEVICE TABLE
    function devListRefresh(){
        for (var i=devList.count -1; i>=0; i--) {
            devList.remove(i);
        }

        for (var j=0; j < _devList._devMac.length; j++) {
            devList.append({"name" : _devList._devName[j], "mac" : _devList._devMac[j]})
        }
    }

    ScrollView{
        clip: true
        width: parent.width
        height: parent.height

        Column {
            id: column1
            width: _items._width
            height: parent.height
            x: _items._x
            bottomPadding: 100

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: rectangle.height
                Rectangle {
                id: rectangle
                x: _items._x
                y: 20
                width: _items._width
                color: _list._background
                height: _window._windowHeight * 0.5


                ScrollView {
                    id: scrollView
                    anchors.topMargin: 30
                    anchors.bottomMargin: 30
                    anchors.fill: parent;
                    anchors.rightMargin: _list._margin
                    anchors.leftMargin: _list._margin
                    ListView {
                        id: devView
                        anchors.fill: parent;

                        model: ListModel {
                            id: devList
                        }
                        delegate: Item {
                            anchors {
                                left: parent.left;
                                right: parent.right;
                            }
                            height: _list._highOfItem
                            Rectangle{
                                id: rectangle1
                                anchors.fill: parent
                                color: (index == _devList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                Text {
                                    font.family: _items._fontFamily
                                    text: model.mac
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: (index == _devList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                                    font.bold: true
                                    font.pointSize: _list._fontNamePixelSize

                                }
                                Text {
                                    font.family: _items._fontFamily
                                    text: model.name
                                    anchors.top: parent.top
                                    anchors.topMargin: 0
                                    color: (index == _devList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                                    font.bold: false
                                    verticalAlignment: Text.AlignTop
                                    font.pointSize: _list._fontNamePixelSize -4

                                }
                                //////////////// : GET DEVICE MAC TO CONNECT
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked:{
                                        _devList._curIndex = index
                                        devProperties.deviceMac = _devList._devMac[index]
                                        btnConnect.enabled = true
                                        devListRefresh()
                                    }
                                }

                                Button {
                                    x: rectangle.x + rectangle.width - 2 * (width + _list._margin)
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: _btnConf._size
                                    height: _btnConf._size
                                    background: Image {
                                        width: parent.width
                                        height: parent.height
                                        fillMode: Image.PreserveAspectFit
                                        sourceSize.height: 0
                                        sourceSize.width: 0
                                        source: _devList._devStateImage[index]
                                    }
                                }
                            }
                        }
                    }
                }
                Component.onCompleted: { devListRefresh() }
            }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btn._height
                topPadding: 50
                Button {
                    id: btnConnect
                    width: _items._width
                    height: _btn._height
                    background: Rectangle{
                        color: (enabled) ? _btn._color : _btn._colorDisabled
                        anchors.fill: parent
                    }
                    highlighted: false
                    enabled: false
                    visible: true
                    Label{
                        text: qsTr("Connect")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: _btn._fontPixelSize
                        color: _btn._fontColor
                        font.family: _items._fontFamily
                    }
                    onClicked: {
                        bluetoothctl.scanFinished()
                        bluetoothctl.connectToDevice(devProperties.deviceMac)
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btn._height
                topPadding: 70
                Button {
                    id: btnSearchDev
                    background: Rectangle{
                        color: _btn._color
                        anchors.fill: parent
                    }
                    Label{
                        text: qsTr("Search devices")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: _btn._fontPixelSize
                        color: _btn._fontColor
                        font.family: _items._fontFamily
                    }
                    width: _items._width
                    height: _btn._height
                    font.pointSize: _btn._fontPixelSize
                    topPadding: 6
                    focusPolicy: Qt.NoFocus
                    onClicked: {
                        btnConnect.enabled = false
                        bluetoothctl.startScan()
                    }
                }
            }

        }
    }
}
