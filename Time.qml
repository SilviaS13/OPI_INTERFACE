import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    width: 480
    height: 800

    header: Label {

            color: _header._color
            font.pixelSize: _header._fontPixelSize
            padding: 10
            text: qsTr("Час")
            font.family: _items._fontFamily

    }

    Text {
        x: 0
        y: 20
        color: _title._color
        text: qsTr("Будильники")
        padding: 10
        font.pixelSize: _title._fontPixelSize
        font.family: _items._fontFamily
    }

    Text {
        x: 0
        y: 342
        color: _title._color
        text: qsTr("Ввімкнути світло зараз")
        padding: 10
        font.pixelSize: _title._fontPixelSize
        font.family: _items._fontFamily
    }

    Item{
        id: _clockList
        property string on : _btnConf._imgSwitchOn;
        property string off : _btnConf._imgSwitchOff;
        property variant _switchBtnImage: [on, off, on, on ]
        property variant  _clockTime: ["00:00", "00:97","07:32", "08:30"]
        property int _curIndex: 0
    }

    Item{
        id: _lightsList
        property string on : _btnConf._imgSwitchOn;
        property string off : _btnConf._imgSwitchOff;
        property variant _switchBtnImage: [on, off, off]
        property variant  _lightName: ["Mode1", "Mode2", "Mode3"]
        property int _curIndex: 0
    }

    Rectangle {
        id: rectangle
        x: _items._x
        y: 65
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

                            text: model.name
                            anchors.verticalCenter: parent.verticalCenter
                            color: (index == _clockList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                            font.bold: true
                            font.pointSize: _list._fontNamePixelSize
                            font.family: _items._fontFamily

                        }

                        Button {
                            x: rectangle.x + rectangle.width - 3 * width -10
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
                        x: rectangle.x + rectangle.width - 2 * width
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

    Button {
        id: btnAddClock
        y: 20
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
        y: btnAddClock.y
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

    function clockListRefresh(){
        for (var i=clockList.count -1; i>=0; i--) {
            clockList.remove(i);
        }

        for (var j=0; j < _clockList._clockTime.length; j++) {
            clockList.append({"name" : _clockList._clockTime[j]})
        }
    }


    /////////////////////////////////////////////////////////////
    //==================== LIGHT VIEW =========================//
    /////////////////////////////////////////////////////////////

    function lightsListRefresh(){
        for (var i=lightList.count -1; i>=0; i--) {
            lightList.remove(i);
        }

        for (var j=0; j < _lightsList._lightName.length; j++) {
            lightList.append({"name" :  _lightsList._lightName[j]})
        }
    }

    Rectangle {
        id: rectangle1
        x: _items._x
        y: 394
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
                            text: model.name
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                            font.pointSize: _list._fontNamePixelSize
                            font.family: _items._fontFamily
                            color: (index == _lightsList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName

                        }
                        Button {
                            x: rectangle1.x + rectangle1.width - 3 * width -10
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
                            x: rectangle1.x + rectangle1.width - 2 * width
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

    Button {
        id: btnAddLight
        y: 349
        x: _window._windowWidth - _items._x - 2 * width - 10
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
        y: btnAddLight.y
        x: _window._windowWidth - _items._x -  width
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
