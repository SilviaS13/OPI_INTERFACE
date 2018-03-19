import QtQuick 2.9
import QtQuick.Controls 2.2
//import QtQuick.Controls.Styles 1.4


ApplicationWindow {
    visible: true
    width: _window._windowWidth
    height: _window._windowHeight
    title: qsTr("Tabs")
    //    background: Image {
    //        visible: false
    //        source: _window._bgImage
    //    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Connect {
            id: conect_form
            background: _window._background
        }

        Time{
            id: time_form
            background: _window._background
        }

        Configure{
            id: config_form
            background: _window._background
        }

        Music{
            id: music_form
            background: _window._background
        }

    }



    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {/*
            x: 0
            y: 0*/
            text: qsTr("Пристрої")
            font.weight: Font.Normal
            font.capitalization: Font.Capitalize
            spacing: 0
            focusPolicy: Qt.NoFocus
        }
        TabButton {
            //            x: -52
            //            y: 0
            text: qsTr("Будильники")
            focusPolicy: Qt.ClickFocus
        }

        TabButton {
            text: qsTr("Налаштування")
        }
        TabButton {
            text: qsTr("Музика")
        }

    }


    //////////////////////////////////////////
    //============ PROPERTIES ==============//
    //////////////////////////////////////////

    Item {
        id: _window
        property Rectangle _background: {
            //color: "transparent"
            color: "white"
        }
        property string _bgImage: "img_lights.jpg"
        property int _windowWidth: 480
        property int _windowHeight: 780
    }

    Item{
        id: _items
        property int _x: (_window._windowWidth - _items._width) /2
        property string _fontFamily: "Century Schoolbook L"
        property int _width: 400
    }

    Item {
        id: _header
        property string _color: "#00ff00"
        property int _fontPixelSize: Qt.application.font.pixelSize *2
    }

    Item {
        id: _title
        property string _color: "#00ff00"
        property int _fontPixelSize: Qt.application.font.pixelSize +4
    }

    Item {
        id: _btn
        property int _height: 40
        property Rectangle _background: {
            color: "#fa0e0e"
            implicitWidth: parent.width
            implicitHeight: parent.height
        }
        property int _fontPixelSize: Qt.application.font.pixelSize +3
    }

    Item{
        id: _list

        property int _fontNamePixelSize: Qt.application.font.pixelSize +3
        property int _fontMacPixelSize: Qt.application.font.pixelSize +3
        property int _fontTimePixelSize: Qt.application.font.pixelSize +3
        property int _fontMusicPixelSize: Qt.application.font.pixelSize +3
        property string _background: "#3bffd4"
        property string _colorOfItem: "transparent"
        property string _colorOfSelectedItem: "black"
        property string _colorOfName: "black"
        property string _colorOfSelectedName: "red"
        property int _highOfItem: 50
        property int _HeightOfClocksLists: 300
    }

    Item{
        id: _radioButton
    }

    Item{
        id: _checkBox
    }

    Item{
        id: _btnConf
        property int _size: 40
        property string _imgLinked: "inons/link.png"
        property string _imgPaired: "inons/unlink.png"
        property string _imgDelete: "inons/error.png"
        property string _imgAdd: "inons/plus.png"
        property string _imgSettings: "inons/settings-5.png"
        property string _imgSwitchOn: "inons/switch-7.png"
        property string _imgSwitchOff: "inons/switch-6.png"
    }
}
