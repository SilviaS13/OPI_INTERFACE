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

        /////////////////////////////////////////////////
        //============ FUNCTIONS & SLOTS ==============//
        /////////////////////////////////////////////////

        Bluetooth{
            id: bluetoothctl
            mac_address: devProperties.deviceMac
            device_name: devProperties.deviceName

            onDevice_foundChanged: {
                //ПЛЯШЕМ И ДОБАВЛЯЕМ В ЛИСТ ДЕВАЙСОВ
               _devList._devMac.push(bluetoothctl.mac_address)
               _devList._devName.push(bluetoothctl.device_name)
               _devList._devStateImage.push(_devList.unknown)
                conect_form.devListRefresh()
            }
            onMac_addressChanged: {
                for (var i=_devList.count -1; i>=0; i--) {
                    if(_devList._devMac[i] === devProperties.connectMac){
                        _devList._devStateImage[i] = _devList.connected;
                    }
                    conect_form.devListRefresh();
                }
            }
            onDevice_connected: {
                tabBar.currentIndex = 1;
                console.log("ON DEV CONN-ED AND LOGGED IN....");
                clearList(_message.all_clocks)
                bluetoothctl.getProperties(_message.all_clocks);
            }

            /////////// NEW ITEM FOUND FUNCTIONS
            onNextClock_found: {
                addClock(getClockProperty(_enumC.hrs), getClockProperty(_enumC.mins),
                         getClockProperty(_enumC.mode), getClockProperty(_enumC.r),
                         getClockProperty(_enumC.g), getClockProperty(_enumC.b),
                         getClockProperty(_enumC.music), getClockProperty(_enumC.mus_e),
                         getClockProperty(_enumC.enabled), getClockProperty(_enumC.demo));
            }
            onNextLight_found: {
                addLight(getLightProperty(_enumL.name), getLightProperty(_enumL.mode),
                         getLightProperty(_enumL.r), getLightProperty(_enumL.g), getLightProperty(_enumL.b),
                         getLightProperty(_enumL.enabled), getLightProperty(_enumL.demo))
                time_form.lightsListRefresh();
            }

            //////////////// EOF FUNCTIONS
            onEofClocks: {
                clearList(_message.all_clocks)
                bluetoothctl.split_clocks()
                time_form.clockListRefresh();
                bluetoothctl.getProperties(_message.all_lights);
            }
            onEofLights: {
                console.log("eof lights");
                clearList(_message.all_lights);
                bluetoothctl.split_lights();
                time_form.lightsListRefresh();
            }
        }

        function clearList(type){
            if (type === _message.all_clocks){
                _clockList._hrs.slice(0, _clockList._hrs.length);
                _clockList._mins.slice(0, _clockList._mins.length);
                _clockList.enable.slice(0, _clockList.enable.length);
                _clockList._mode.slice(0, _clockList._mode.length);
                _clockList._r.slice(0, _clockList._r.length);
                _clockList._g.slice(0, _clockList._g.length);
                _clockList._b.slice(0, _clockList._b.length);
                _clockList._music.slice(0, _clockList._music.length);
                _clockList._music_e.slice(0, _clockList._music_e.length);
                _clockList._demo.slice(0, _clockList._demo.length);
            }
            else if (type === _message.all_lights){
                _lightsList._name.slice(0, _lightsList._name.length);
                _lightsList.enable.slice(0, _lightsList.enable.length);
                _lightsList._mode.slice(0, _lightsList._mode.length);
                _lightsList._r.slice(0, _lightsList._r.length);
                _lightsList._g.slice(0, _lightsList._g.length);
                _lightsList._b.slice(0, _lightsList._b.length);
                _lightsList._demo.slice(0, _lightsList._demo.length);
            }
        }

        function addClock(Hrs, Mins, Mode, R,G,B, Music,Mus_e,Enabled, Demo){
            _clockList.enable.push(Enabled === "t" ? _clockList.on : _clockList.off);
            _clockList._hrs.push(Hrs);
            _clockList._mins.push(Mins);
            _clockList._mode.push(Mode);
            _clockList._r.push(R);
            _clockList._g.push(G);
            _clockList._b.push(B);
            _clockList._music.push(Music);
            _clockList._music_e.push(Mus_e);
            _clockList._demo.push(Demo);
        }
        function addLight(Name, Mode, R,G,B,Enabled,Demo){
            _lightsList.enable.push( Enabled === "t" ? _lightsList.on : _lightsList.off);
            _lightsList._name.push(Name);
            _lightsList._mode.push(Mode);
            _lightsList._r.push(R);
            _lightsList._g.push(G);
            _lightsList._b.push(B);
            _lightsList._demo.push(Demo);
        }

        //SEND PROPERTIES TO OPI///////////////////////////////////////////////////////////////////////////////
        function makeSolidStringsAndSend(type){
            var i;
            bluetoothctl.clearPropFile(type);
            _message.propertyString = "";
            if (type === _message.all_clocks){
                for (i=0; i < _clockList._hrs.length; i++){
                    _message.propertyString = _clockList._hrs[i] + ","+_clockList._mins[i]+","+
                           _clockList._mode[i]+","+_clockList._r[i]+","+_clockList._g[i]+","+
                            _clockList._b[i]+","+_clockList._music[i]+","+_clockList._music_e[i]+
                            ","+_clockList._demo[i]+ "," + _clockList.enable[i];
                    bluetoothctl.sendProperties(_message.propertyString, type);
                }
            }
            else{
                for (i=0; i < _lightsList._name.length; i++){
                    _message.propertyString = _lightsList._name[i] + ","+
                           _lightsList._mode[i]+","+_lightsList._r[i]+","+_lightsList._g[i]+ ","+
                           _lightsList._b[i]+","+_lightsList._demo[i]+ "," +_lightsList.enable[i];
                    bluetoothctl.sendProperties(_message.propertyString, type);
                }
            }
            bluetoothctl.sendProperties("end", type);
            console.log("PROPERTIES SENT " + type);
        }

        //////////////////////////////////////////
        //============ PROPERTIES ==============//
        //////////////////////////////////////////

        //ENUM FOR PROPERTIES////////////////////////////////////////////////////////////////////////////////////////////////////////////
        Item{
            id: _enumC
            property int hrs: 0;property int mins: 1; property int mode: 2; property int r: 3;
            property int g: 4;property int b: 5; property int music: 6;
            property int mus_e: 7; property int demo: 8;property int enabled: 9;
        }
        Item{
            id: _enumL
            property int name: 0; property int mode: 1; property int r: 2;
            property int g: 3;property int b: 4; property int demo: 5;property int enabled: 6;
        }
        Item{
            id: _enumM
            property int name: 0; property int path: 1;
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //Q_PROPERTY VARIABLES
        Item {
                id: devProperties
                property string deviceMac: "00:00:00:00:00:00"
                property string deviceName: "Noname"

                property string connectMac: "00:00:00:00:00:00"
                property bool nextClock: false
        }
        ///////////////////////////////////////////////////////////////////////////////////////////////
        //REQUEST MESSAGES
        Item{
            id: _message
            property int empty : -1;
            property int login : 0;
            property int all_clocks : 1;
            property int all_lights : 2;
            property int all_music : 3;
            property string propertyString: ""
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////
        //DEV CLOCK LIGHT MUSIC SETTINGS
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
        Item{
            id: _clockList
            property string on : "t"/*"_btnConf._imgSwitchOn";*/
            property string off : "f"/*_btnConf._imgSwitchOff;*/
            property int _curIndex: 0

            property variant  _hrs: [/*"00", "00","07", "08"*/]
            property variant  _mins: [/*"00", "20","09", "45"*/]
            property variant  _mode: [/*mode[4],mode[2], mode[1], mode[0]*/]
            property variant _r: [/*0, 5, 30, 255*/]
            property variant _g: [/*0, 10, 30, 255*/]
            property variant _b: [/*0, 120, 30, 0*/]
            property variant _music: [/*_musicList._songs[0], _musicList._songs[1],_musicList._songs[2], _musicList._songs[3]*/]
            property variant _music_e: [/*"t", "t", "f", "t"*/];
            property variant enable: [/*on, off, on, on */]
            property variant _demo: [/*"t", "f", "f", "f"*/]
        }
        Item{
            id: _lightsList
            property string on : "t"/*_btnConf._imgSwitchOn;*/
            property string off : "f"/*_btnConf._imgSwitchOff;*/
            property int _curIndex: 0

            property variant  _name: [/*"Режим1", "Режим2", "Режим3"*/]
            property variant  _mode: [/*mode[4],mode[2], mode[1]*/]
            property variant _r: [/*3, 5, 30*/]
            property variant _g: [/*1, 10, 30*/ ]
            property variant _b: [/*8, 120, 30*/]
            property variant enable: [/*on, off, off*/]
            property variant _demo: [/*"t", "f", "f"*/]
        }
        Item{
            id: _musicList
            property variant  _songs: ["Пташки у лісі", "Журчання води", "Вітер в полі", "Шум дощу", "Мелодія світанку", "Затишна домівка"]
            property int _curIndex: 0
        }
        Item{
            id: _configs
            property int index: -1;
            property string mode: modeClock
            property string modeClock: "c"
            property string modeLight: "l"
            property variant _clock: ["07", "00", mode[4], "120", "120", "40", _musicList._songs[3], "t", "f", "t"]
            property variant _light: ["New Mode", mode[4], "120", "120", "40", "f", "f"]
        }

        property variant mode: ["Веселка", "Спалахи", "Світанок", "Колесо", "Колір"]
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //UI ELEMENTS SETTINGS
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

    ///////////////////////////////////////////
    //============ UI ELEMENTS ==============//
    ///////////////////////////////////////////

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

        TabButton {
            id: tabDevices
            text: qsTr("Пристрої")
            font.family: _items._fontFamily            
        }
        TabButton {
            id: tabClocks
            text: qsTr("Будильники")
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
}
