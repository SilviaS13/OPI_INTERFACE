import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0
import QtQuick.Dialogs 1.0

Page {
    width: 480
    height: 800
    background: Rectangle{
        anchors.fill: parent
        color: _list._background
    }

    header: Label {
        color: _header._color
        font.pixelSize: _header._fontPixelSize
        padding: 10
        text: qsTr("Налаштування")
        font.family: _items._fontFamily
    }


    ScrollView {

        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        width: parent.width
        height: parent.height

        Column {
            id: column
            width: _items._width
            height: 500
            x: _items._x
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                width: _items._width
                Text {
                    padding: 10
                    color: _title._color
                    text: qsTr("Час")
                    width: _items._width
                    font.pixelSize: _title._fontPixelSize

                    font.family: _items._fontFamily
                }
            }

            Row {
                id: row
                anchors.left: parent.left
                anchors.right: parent.right
                height: _configTab._heightOfTime

                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }
                Rectangle{
                    width: 30
                    height: width
                    color: "transparent"
                    TextEdit {
                        id: txtHours
                        color: _configTab._colorOfTime
                        text: qsTr("05")


                        font.pixelSize: _configTab._timePixelSize

                    }
                }
                Rectangle{
                    x: txtHours.width
                    width: txtDot.width
                    height: width
                    color: "transparent"

                    Text {
                        topPadding: 7
                        id: txtDot
                        height: 50
                        width: 35
                        color: _header._color
                        text: qsTr(" : ")
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: _configTab._timePixelSize
                        font.family: _items._fontFamily
                    }
                }
                Rectangle{
                    x: txtDot.width + txtHours.width
                    width: 50
                    height: width
                    color: "transparent"
                    TextEdit {
                        id: txtMinutes
                        color: _configTab._colorOfTime
                        text: qsTr("45")

                        font.pixelSize: _configTab._timePixelSize

                    }
                }

            }

            Row {
                id: row1
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                Text {
                    padding: 10
                    color: _title._color
                    text: qsTr("Колір")
                    anchors.verticalCenter: parent.verticalCenter
                    width: _items._width
                    font.pixelSize: _title._fontPixelSize
                    font.family: _items._fontFamily
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }

                RadioButton {
                    id: rbSunrise
                    height: 40
                    text: qsTr("Світанок")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear("rbSunrise")
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }
                RadioButton {
                    id: rbRainbow
                    height: 40
                    text: qsTr("Веселка")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear("rbRainbow")
                    }
                }
            }

            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }

                RadioButton {
                    id: rbRainbowCycle
                    height: 40
                    text: qsTr("Веселка по колу")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear("rbRainbowCycle")
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }
                RadioButton {
                    id: rbWheel
                    height: parent.height
                    text: qsTr("Колесо")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear("rbWheel")
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size

                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }
                RadioButton {
                    id: rbColor
                    height: parent.height
                    width: _items._width *0.5
                    text: qsTr("Колір")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily

                    onClicked: {
                        rbClear("rbColor")
                    }
                }
                Button{
                    id: btnColorPicker
                    height: 30
                    width: 50
                    x: _items._x_right - width - 10
                    background: Rectangle {
                        id: bgColor
                        color: "#fa0e0e"
                        implicitWidth: parent.width
                        implicitHeight: parent.height
                    }
                    onClicked: {
                        colorDialog.visible = true
                    }
                }
           }

            //Button Demonstrate
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btn._height + 40
                topPadding: 20
                Button {
                    id: btnDemonstrate
                    background: Rectangle{
                        color: _btn._color
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.fill: parent
                    }
                    Label{
                        text: qsTr("Демонстрація")
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
                        //todo
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size
                topPadding: 100
                Rectangle{
                    anchors.fill: parent
                    color: _list._background
                }
                CheckBox {
                    id: chMusic
                    height: parent.height
                    text: qsTr("Музика")
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        //todo
                    }
                }
                Button{
                    padding: 10
                    id: btnConfigMusic
                    height: _btnConf._size
                    width: height
                    x: _items._x_right - width - 10
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
            // Button Save
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btn._height + 40
                topPadding: 20
                Button {
                    id: btnSet
                    background: Rectangle{
                        color: _btn._color
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.fill: parent
                    }
                    Label{
                        text: qsTr("Зберегти")
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
                        //todo
                    }
                }
            }

        }
    }
    function rbClear(rb){
        if (rb !== "rbRainbow")
            rbRainbow.checked = false
        if (rb !== "rbRainbowCycle")
            rbRainbowCycle.checked = false
        if (rb !== "rbSunrise")
            rbSunrise.checked = false
        if (rb !== "rbWheel")
            rbWheel.checked = false
        if (rb !== "rbColor")
            rbColor.checked = false
    }

    ColorDialog {
        id: colorDialog
        title: "Please choose a color"
        onAccepted: {
            console.log("You chose: " + colorDialog.color)
            bgColor.color = colorDialog.color
            //Qt.quit()
            close()
        }
        onRejected: {
            console.log("Canceled")
            //Qt.quit()
            close()
        }
        Component.onCompleted: visible = false
    }
}
