import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    width: 480
    height: 800
    background: bg


    header: Label {
        Text{
            color: _header._color
            //color: titleColor
            font.pixelSize: Qt.application.font.pixelSize * 2
            padding: 10
            text: qsTr("Вибір музики")

        }
    }

}
