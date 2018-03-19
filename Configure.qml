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
}
