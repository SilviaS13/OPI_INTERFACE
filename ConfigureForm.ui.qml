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
            text: qsTr("Налаштування")
            font.family: _items._fontFamily
        }

        Text {
            x: 0
            y: 64
            color: _title._color
            text: qsTr("Будильники")
            padding: 10
            font.pixelSize: _title._fontPixelSize
        }
    }

    Text {
        x: 0
        y: 421
        color: titleColor
        text: qsTr("Ввімкнути світло зараз")
        padding: 10
        font.pixelSize: Qt.application.font.pixelSize +2
    }

    CheckBox {
        id: checkBox
        x: _items._x
        y: 619
        text: qsTr("Check Box")
    }

    RadioButton {
        id: radioButton
        x: _items._x
        y: 469
        text: qsTr("Radio Button")
    }

    RadioButton {
        id: radioButton1
        x: _items._x
        y: 522
        text: qsTr("Radio Button")
    }

    RadioButton {
        id: radioButton2
        x: _items._x
        y: 573
        text: qsTr("Radio Button")
    }

    Rectangle {
        id: rectangle
        x: _items._x
        y: 95
        color: "#fcf0f0"
        width: _items._width
        height: 300


        ScrollView {
            id: scrollView
            x: 0
            y: 0
            width: parent.width
            height: parent.height

            ListView {
                id: listClocks
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

                    Row {
                        id: row1
                        spacing: 10
                        Button {
                            Button {
                                x: rectangle.x + rectangle.width - 2 * width
                                width: 40
                                height: 40
                                text: qsTr("Button")
                                background: Image {
                                        id: image
                                        width: parent.width
                                        height: parent.height
                                        fillMode: Image.PreserveAspectFit
                                        sourceSize.height: 0
                                        sourceSize.width: 0
                                        source: "inons/link.png"
                                    }
                            }
                        }

                        Text {
                            text: name
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                        }
                    }
                }
            }
            //background: _list._background
        }
    }
}
