import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0

Page {
    width: 480
    height: 800

    Item{
        id: _clockList
        property string on : _btnConf._imgSwitchOn;
        property string off : _btnConf._imgSwitchOff;
        property variant _switchBtnImage: [on, off, on, on ]
        property variant  _clockTime: ["00:00", "00:50","07:32", "08:30"]
        property int _curIndex: 0
    }

    Item{
        id: _lightsList
        property string on : _btnConf._imgSwitchOn;
        property string off : _btnConf._imgSwitchOff;
        property variant _switchBtnImage: [on, off, off]
        property variant  _lightName: ["Режим1", "Режим2", "Режим3"]
        property int _curIndex: 0
    }

    header: Label {

            color: _header._color
            font.pixelSize: _header._fontPixelSize
            padding: 10
            text: qsTr("Час")
            font.family: _items._fontFamily

    }

    ScrollView {
        //flickableDirection: Flickable.VerticalFlick
       // Flickable.flickableDirection: Flickable.VerticalFlick
        clip: true
        width: parent.width
        height: parent.height

        Column {
            //Flickable.flickableDirection: Flickable.VerticalFlick

            id: column1
            width: _items._width
            height: parent.height
            x: _items._x
            //bottomPadding: 100
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size

                Text {
                    padding: 10
                    color: _title._color
                    text: qsTr("Будильники")
                    width: _window._windowWidth * 0.67
                    font.pixelSize: _title._fontPixelSize
                    font.family: _items._fontFamily
                }

                Button {
                    id: btnAddClock

                    x: _window._windowWidth - _items._x - 2 * width - 10
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgAdd
                    }
                    onClicked: {
                        _clockList._switchBtnImage.push(_clockList.off)
                        _clockList._clockTime.push("00:00")
                        clockListRefresh()
                    }
                }

                Button {
                    id: btnDelClock
                    x: _window._windowWidth - _items._x - width
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgDelete
                    }
                    onClicked: {
                        _clockList._switchBtnImage.splice(_clockList._curIndex, 1)
                        _clockList._clockTime.splice(_clockList._curIndex, 1)
                        clockListRefresh()
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: rectangle.height +topPadding
                topPadding: 10

                Rectangle {
                    id: rectangle
                    x: _items._x
                    width: _items._width
                    color: _list._background
                    height: 250

                    ScrollView {
                        id: scrollView
                        anchors.topMargin: 30
                        anchors.bottomMargin: 30
                        anchors.fill: parent;

                        ListView {
                            id: clockView
                            anchors.fill: parent;
                            model: ListModel {
                                id: clockList
                            }
                            delegate: Item {
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }
                                height: _list._highOfItem
                                Rectangle{
                                    anchors.fill: parent
                                    color: (index == _clockList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            _clockList._curIndex = index
                                            clockListRefresh()
                                        }
                                    }
                                    Text {
                                        padding: 10
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: (index == _clockList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                                        font.bold: true
                                        font.pointSize: _list._fontNamePixelSize
                                        font.family: _items._fontFamily

                                    }

                                    Button {
                                        x: rectangle.x + rectangle.width - 2 * width -20
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            fillMode: Image.PreserveAspectFit
                                            sourceSize.height: 0
                                            sourceSize.width: 0
                                            source: _clockList._switchBtnImage[index]
                                        }
                                        onClicked: {
                                              if (_clockList._switchBtnImage[index] === _clockList.on){
                                                  _clockList._switchBtnImage[index] = _clockList.off
                                              }
                                              else{
                                                  _clockList._switchBtnImage[index] = _clockList.on
                                              }

                                              clockListRefresh()
                                        }
                                    }
                                    Button {
                                    x: rectangle.x + rectangle.width - width - 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: _btnConf._size
                                    height: _btnConf._size
                                    text: qsTr("")
                                    background: Image {
                                        width: parent.width
                                        height: parent.height
                                        fillMode: Image.PreserveAspectFit
                                        sourceSize.height: 0
                                        sourceSize.width: 0
                                        source: _btnConf._imgSettings
                                    }
                                    onClicked: {

                                    }
                                }
                                }
                            }
                        }
                    }
                    Component.onCompleted: { clockListRefresh() }
                }
            }

            /////////////////////////////////////////////////////////////
            //==================== LIGHT VIEW =========================//
            /////////////////////////////////////////////////////////////
            Row {
                anchors.left: parent.left
                anchors.right: parent.right

                topPadding: 15
                height: _btnConf._size + topPadding
                Text {
                    width: _window._windowWidth * 0.67
                    color: _title._color
                    text: qsTr("Ввімкнути світло")
                    padding: 10
                    font.pixelSize: _title._fontPixelSize
                    font.family: _items._fontFamily
                }

                Button {
                    id: btnAddLight

                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgAdd
                    }
                    onClicked: {
                        _lightsList._switchBtnImage.push(_lightsList.off)
                        _lightsList._lightName.push("New Mode")
                        lightsListRefresh()
                    }
                }

                Button {
                    id: btnDelLight
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgDelete
                    }
                    onClicked: {
                        _lightsList._switchBtnImage.splice(_lightsList._curIndex, 1)
                        _lightsList._lightName.splice(_lightsList._curIndex, 1)
                        lightsListRefresh()
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 20
                height: rectangle1.height +topPadding
                topPadding: 10
                Rectangle {
                    id: rectangle1

                    width: _items._width
                    height: rectangle.height
                    color: _list._background
                    ScrollView {
                        id: scrollView1
                        anchors.fill: parent
                        ListView {
                            anchors.fill: parent
                            anchors.topMargin: 30
                            anchors.bottomMargin: 30

                            model: ListModel {
                                id: lightList
                            }
                            delegate: Item {
                                width: parent.width
                                height: _list._highOfItem
                                Rectangle{
                                    anchors.fill: parent
                                    color: (index == _lightsList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            _lightsList._curIndex = index
                                            lightsListRefresh()
                                        }
                                    }
                                    Text {
                                        padding: 10
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.bold: true
                                        font.pointSize: _list._fontNamePixelSize
                                        font.family: _items._fontFamily
                                        color: (index == _lightsList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName

                                    }
                                    Button {
                                        x: rectangle1.x + rectangle1.width - 2 * width -20
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        text: qsTr("")
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            sourceSize.width: 0
                                            sourceSize.height: 0
                                            fillMode: Image.PreserveAspectFit
                                            source: _lightsList._switchBtnImage[index]
                                        }
                                        onClicked: {
                                              if (_lightsList._switchBtnImage[index] === _lightsList.on){
                                                  _lightsList._switchBtnImage[index] = _lightsList.off
                                              }
                                              else{
                                                  _lightsList._switchBtnImage[index] = _lightsList.on
                                              }
                                              lightsListRefresh()
                                        }
                                    }

                                    Button {
                                        x: rectangle1.x + rectangle1.width -  width - 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        text: qsTr("")
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            sourceSize.width: 0
                                            sourceSize.height: 0
                                            fillMode: Image.PreserveAspectFit
                                            source: _btnConf._imgSettings
                                        }
                                        onClicked: {

                                        }
                                    }
                                }
                            } //end of delegate
                        } //end of ListView
                    } //end of ScrollView
                    Component.onCompleted: { lightsListRefresh() }
                }//end of Rectangle
            }
        }


    }

    function clockListRefresh(){
        for (var i=clockList.count -1; i>=0; i--) {
            clockList.remove(i);
        }

        for (var j=0; j < _clockList._clockTime.length; j++) {
            clockList.append({"name" : _clockList._clockTime[j]})
        }
    }




    function lightsListRefresh(){
        for (var i=lightList.count -1; i>=0; i--) {
            lightList.remove(i);
        }

        for (var j=0; j < _lightsList._lightName.length; j++) {
            lightList.append({"name" :  _lightsList._lightName[j]})
        }
    }

}
