import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0

Page {
    width: 480
    height: 800
    header: Label {
        color: _header._color
        font.pixelSize: _header._fontPixelSize
        padding: 10
        text: qsTr("Налаштування")
        font.family: _items._fontFamily
    }



    ScrollView {

        //anchors.fill: parent
        clip: true

        width: parent.width
        height: parent.height


        Column {
            id: column
            //anchors.fill: parent
            width: _window._windowWidth
            height: 500
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 450

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height
                    color: "red"
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 90

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 0.2 * parent.width
                    color: "darkGreen"
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 0.8 * parent.width
                    color: "lightGreen"
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: 100

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 0.4 * parent.width
                    color: "darkBlue"
                }
                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 0.2 * parent.width
                    color: "blue"
                }
                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 30
                    color: "lightBlue"
                }
            }
        }
   // }
    }

}
