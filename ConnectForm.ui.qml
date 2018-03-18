import QtQuick 2.9
import QtQuick.Controls 2.2

Page {
    width: 480
    height: 800

    header: Label {
        Text{
            color: _header._color
            font.pixelSize: Qt.application.font.pixelSize * 2
            padding: 10
            text: qsTr("Пристрої")
        }
    }

    Button {
        id: button
        x: 138
        y: 177
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
