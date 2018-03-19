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
            text: qsTr("Пристрої")
            font.family: _items._fontFamily
        }
    }

    Rectangle {
        id: rectangle
        x: _items._x
        y: 95
        color: "#fcf0f0"
        width: _items._width
        height: 250


        ScrollView {
            id: scrollView
            x: 0
            y: 0
            width: parent.width
            height: parent.height

            ListView {
                id: listDevices
                x: 0
                y: 0
                width: parent.width
                model: ListModel {

                    ListElement {
                        name: "Dev1"
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
                        x: rectangle.x + rectangle.width - 3 * width -10
                        width: _btnConf._size
                        height: _btnConf._size
                        text: qsTr("")
                        background: Image {
                            width: parent.width
                            height: parent.height
                            fillMode: Image.PreserveAspectFit
                            sourceSize.height: 0
                            sourceSize.width: 0
                            source: _btnConf._imgSwitchOff
                        }
                        onClicked: {

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
    }
}
