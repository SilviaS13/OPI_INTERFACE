import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    width: 480
    height: 800

    header: Label {
        Text{
            color: _header._color
            font.pixelSize: _header._fontPixelSize
            padding: 10
            text: qsTr("Час")
        }
    }

    Text {
        x: 0
        y: 29
        color: _title._color
        text: qsTr("Будильники")
        padding: 10
        font.pixelSize: _title._fontPixelSize
    }

    Text {
        x: 0
        y: 351
        color: _title._color
        text: qsTr("Ввімкнути світло зараз")
        padding: 10
        font.pixelSize: _title._fontPixelSize
    }

    Item{
        id: _clockList
        property string on : _btnConf._imgSwitchOn;
        property string off : _btnConf._imgSwitchOff;
        property variant _switchBtnImage: [on, off, on, on ]
        property variant  _clockTime: ["00:00", "00:97","07:32", "08:30"]
        property int _curIndex: 0
    }

    Rectangle {
        id: rectangle
        x: _items._x
        y: 85
        width: _items._width
        color: "#fcf0f0"
        height: 250


        ScrollView {
            id: scrollView
            anchors.fill: parent;

            ListView {
                id: listClocks
                anchors.fill: parent;
                model: ListModel {
                    id: clockModel
                }
                delegate: Item {
                    anchors {
                        left: parent.left;
                        right: parent.right;
                    }
                    height: 40

                    Text {
                        text: model.name
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                    }

                    Button {
                        x: rectangle.x + rectangle.width - 3 * width -10
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

                              refreshClockListItems()
                        }
                    }
                    Button {
                        x: rectangle.x + rectangle.width - 2 * width
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
        Component.onCompleted: { refreshClockListItems() }
    }

    function refreshClockListItems(){
        for (var i=clockModel.count -1; i>=0; i--) {
            clockModel.remove(i);
        }

        for (var j=0; j < _clockList._clockTime.length; j++) {
            clockModel.append({"name" : _clockList._clockTime[j]})
        }
    }

    Rectangle {
        id: listModes
        x: 40
        y: 394
        width: _items._width
        height: 250
        color: "#fcf0f0"
        ScrollView {
            id: scrollView1
            x: 0
            y: 0
            width: parent.width
            height: parent.height
            ListView {
                id: listClocks1
                x: 0
                y: 0
                width: parent.width
                model: ListModel {
                    ListElement {
                        name: "Grey"
                        colorCode: "grey"
                    }

                    ListElement {
                        name: "Red"
                        colorCode: "red"
                    }

                    ListElement {
                        name: "Blue"
                        colorCode: "blue"
                    }

                    ListElement {
                        name: "Green"
                        colorCode: "green"
                    }
                }
                delegate: Item {
                    width: parent.width
                    height: 40
                    Text {
                        text: name
                        anchors.verticalCenter: parent.verticalCenter
                        font.bold: true
                    }

                    Button {
                        x: rectangle1.x + rectangle1.width - 3 * width -10
                        width: _btnConf._size
                        height: _btnConf._size
                        text: qsTr("")
                        background: Image {
                            width: parent.width
                            height: parent.height
                            sourceSize.width: 0
                            sourceSize.height: 0
                            fillMode: Image.PreserveAspectFit
                            source: _btnConf._imgSwitchOff
                        }
                    }

                    Button {
                        x: rectangle1.x + rectangle1.width - 2 * width
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
                    }
                }
            }
        }
    }

    Button {
        id: btnAddClock
        x: 359
        y: 27
        width: 40
        height: 40
        text: qsTr("Button")
        onClicked: {
            _clockList._switchBtnImage.push(_clockList.off)
            _clockList._clockTime.push("00:00")
            refreshClockListItems()
        }
    }

    Button {
        id: btnDelClock
        x: 412
        y: 27
        width: 40
        height: 40
        text: qsTr("Button")
        onClicked: {
            _clockList._switchBtnImage.splice(curIndex, 1)
            _clockList._clockTime.splice(curIndex, 1)
            refreshClockListItems()
        }

    }
}
