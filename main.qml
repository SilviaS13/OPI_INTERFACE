import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0


ApplicationWindow {
    visible: true
    width: _window._windowWidth
    height: _window._windowHeight
    title: qsTr("Tabs")
        background: Image {
            source: _window._bgImage
        }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Connect {
            id: conect_form
            background: Rectangle{
                color: _window._background
            }

        }

        Time{
            id: time_form
            background: Rectangle{
                color: _window._background
            }
        }

        Configure{
            id: config_form
            background: Rectangle{
                color: _window._background
            }
        }

        Music{
            id: music_form
            background: Rectangle{
                color: _window._background
            }
        }

    }



    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {/*
            x: 0
            y: 0*/
            text: qsTr("Пристрої")
//            font.weight: Font.Normal
//            font.capitalization: Font.Capitalize
            font.family: _items._fontFamily
            //spacing: 0
            //focusPolicy: Qt.NoFocus
        }
        TabButton {
            text: qsTr("Будильники")
           // focusPolicy: Qt.ClickFocus
            font.family: _items._fontFamily
        }

        TabButton {
            text: qsTr("Налаштування")
            font.family: _items._fontFamily
        }
        TabButton {
            text: qsTr("Музика")
            font.family: _items._fontFamily
        }

    }


    //////////////////////////////////////////
    //============ PROPERTIES ==============//
    //////////////////////////////////////////
    Item {
            id: devProperties
//            property int aNumber: 100
//            property bool aBool: false
            property string deviceMac: "00:00:00:00:00:00"
            property string deviceName: "Noname"

            property string connectMac: "00:00:00:00:00:00"
        }

    Bluetooth{
        id: bluetoothctl
        mac_address: devProperties.deviceMac
        device_name: devProperties.deviceName

        onDevice_foundChanged: {
            //ПЛЯШЕМ И ДОБАВЛЯЕМ В ЛИСТ ДЕВАЙСОВ

           _devList._devMac.push(bluetoothctl.getMac_address())
           _devList._devName.push(bluetoothctl.getDevice_name())
           _devList._devStateImage.push(_devList.unknown)

            conect_form.devListRefresh()
        }
    }

    Item{
        id: _message
        property string login: "root"
        property string password: "12345678"
        property string getClocks: ""
        property string getLights: ""
        property string getSettings: ""
    }

    Item{
        id: _devList
        property string paired : _btnConf._imgPaired;
        property string connected : _btnConf._imgLinked;
        property string unknown : _btnConf._imgUnknown;
        property variant _devStateImage: []
        property variant  _devName: []
        property variant  _devMac: []
        property int _curIndex: 0
    }


    Item {
        id: _window
        property string _background: "transparent"

        property string _bgImage: "img_lights.jpg"
        property int _windowWidth: 480
        property int _windowHeight: 780
    }

    Item{
        id: _items
        property int _x: (_window._windowWidth - _items._width) /2
        property int _x_right: (_window._windowWidth - 2* _x)
        property string _fontFamily: "Dejavu Sans"
        property int _width: 400
    }

    Item {
        id: _header
        property string _color: "lime"
        property int _fontPixelSize: Qt.application.font.pixelSize *2 +10
    }

    Item {
        id: _title
        property string _color: "lime"
        property int _fontPixelSize: Qt.application.font.pixelSize +8
    }

    Item {
        id: _btn
        property int _height: 50
        property string _color: "dimgray"
        property string _fontColor: "white"
        property int _fontPixelSize: Qt.application.font.pixelSize +3
        property string _colorDisabled : "silver"
    }

    Item{
        id: _list

        property int _fontNamePixelSize: Qt.application.font.pixelSize +3
        property int _fontMacPixelSize: Qt.application.font.pixelSize +3
        property int _fontTimePixelSize: Qt.application.font.pixelSize +3
        property int _fontMusicPixelSize: Qt.application.font.pixelSize +3
        property string _background: "#66bababa"
        property string _colorOfItem: "transparent"
        property string _colorOfSelectedItem: "black"
        property string _colorOfName: "black"
        property string _colorOfSelectedName: "lime"
        property int _highOfItem: 50
        property int _margin: 10

    }

    Item{
        id: _configTab
        property string _colorOfTime: "white"
        property string _colorOfRadio: "black"
        property int _timePixelSize: 40
        property int _rbPixelSize: Qt.application.font.pixelSize + 8
        property bool _bold: true
        property int _heightOfTime : 50
    }

//    Item{
//        id: _checkBox
//    }

    Item{
        id: _btnConf
        property int _size: 40
        property string _imgLinked: "inons/link.png"
        property string _imgPaired: "inons/unlink.png"
        property string _imgUnknown: "inons/locked.png"
        property string _imgDelete: "inons/error.png"
        property string _imgAdd: "inons/plus.png"
        property string _imgSettings: "inons/settings-5.png"
        property string _imgSwitchOn: "inons/switch-7.png"
        property string _imgSwitchOff: "inons/switch-6.png"
    }
}
