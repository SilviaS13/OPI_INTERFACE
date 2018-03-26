import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0

Page {
    width: 480
    height: 800

    Item{
        id: _musicList
        property variant  _songList: ["Пташки у лісі", "Журчання води", "Вітер в полі", "Шум дощу", "Мелодія світанку", "Затишна домівка"]
        property int _curIndex: 0
    }

    header: Label {
        color: _header._color
        font.pixelSize: _header._fontPixelSize
        padding: 10
        text: qsTr("Вибір музики")
        font.family: _items._fontFamily
    }


    ScrollView {
        clip: true
        width: parent.width
        height: parent.height

        Column {
            width: _items._width
            height: parent.height
            x: _items._x

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
                    height: 400

                    ScrollView {
                        id: scrollView
                        anchors.topMargin: 30
                        anchors.bottomMargin: 30
                        anchors.fill: parent;

                        ListView {
                            id: musicView
                            anchors.fill: parent;
                            model: ListModel {
                                id: musicList
                            }
                            delegate: Item {
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }
                                height: _list._highOfItem
                                Rectangle{
                                    anchors.fill: parent
                                    color: (index === _musicList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            _musicList._curIndex = index
                                            musicListRefresh()
                                        }
                                    }
                                    Text {
                                        padding: 10
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: (index === _musicList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                                        font.bold: true
                                        font.pointSize: _list._fontNamePixelSize
                                        font.family: _items._fontFamily

                                    }


                                }
                                }
                            }
                        }
                    }
                    Component.onCompleted: { musicListRefresh() }
                }
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
                height: _btn._height + 40

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
    function musicListRefresh(){
        for (var i=musicList.count -1; i>=0; i--) {
            musicList.remove(i);
        }

        for (var j=0; j < _musicList._songList.length; j++) {
            musicList.append({"name" : _musicList._songList[j]})
        }
    }
}
