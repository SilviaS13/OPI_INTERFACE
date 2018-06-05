import QtQuick 2.9
import QtQuick.Controls 2.2
import Bluetooth_Module 1.0
import QtQuick.Dialogs 1.0

Page {
    // EXTERNAL CALLING FCNS -------------------------------------------------------------------------

    //from music form and changes music field
    function fillConfigMusic(){
        chMusic.text = _configs._clock[_enumC.music]
    }
    //CALLS FROM TIME FORM AND FILLS LOCAL FIELDS
    function fillConfigFields(){
        //console.log("in fcn set configs")
        if (_configs.mode === _configs.modeClock){
            lblTime.text = "Час"
            txtMinutes.visible = true;
            txtDot.visible = true;
            musicRow.visible = true;
            txtHours.text = _configs._clock[_enumC.hrs]
            txtMinutes.text = _configs._clock[_enumC.mins]
            rb0.checked = (_configs._clock[_enumC.mode] === mode[0]) ? true : false
            rb1.checked = (_configs._clock[_enumC.mode] === mode[1]) ? true : false
            rb2.checked = (_configs._clock[_enumC.mode] === mode[2]) ? true : false
            rb3.checked = (_configs._clock[_enumC.mode] === mode[3]) ? true : false
            rb4.checked = (_configs._clock[_enumC.mode] === mode[4]) ? true : false
            chMusic.checked = (_configs._clock[_enumC.mus_e] === "t") ? true : false

            bgColor.color = "#"+bluetoothctl.intToHex(_configs._clock[_enumC.r])+
                            bluetoothctl.intToHex(_configs._clock[_enumC.g])+
                            bluetoothctl.intToHex(_configs._clock[_enumC.b]);
            fillConfigMusic();
        }
        else{
            lblTime.text = "Назва"
            txtMinutes.visible = false;
            txtDot.visible = false;
            musicRow.visible = false;
            txtHours.text = _configs._light[_enumL.name]
            rb0.checked = (_configs._light[_enumL.mode] === mode[0]) ? true : false
            rb1.checked = (_configs._light[_enumL.mode] === mode[1]) ? true : false
            rb2.checked = (_configs._light[_enumL.mode] === mode[2]) ? true : false
            rb3.checked = (_configs._light[_enumL.mode] === mode[3]) ? true : false
            rb4.checked = (_configs._light[_enumL.mode] === mode[4]) ? true : false

            bgColor.color = "#"+bluetoothctl.intToHex(_configs._light[_enumL.r])+
                    bluetoothctl.intToHex(_configs._light[_enumL.g])+
                    bluetoothctl.intToHex(_configs._light[_enumL.b]);
        }
    }

    // LOCAL FUNCTIONS -------------------------------------------------------------------------

    // GET INT RGB COLOR FROM HEX STRING COLOR
    function getColor(color, part){
        return bluetoothctl.hexToInt(qsTr(color), part);
    }

    //SET FIELDS TO _CONFIGS - SINGLE PROPERTIES ITEM
    function changeConfiguration(conf, whatconfig){
        if (_configs.mode === 'c'){
            switch (whatconfig){
            case ("hrs"):
                _configs._clock[_enumC.hrs] = conf;
                break;
            case ("mins"):
                _configs._clock[_enumC.mins] = conf;
                break;
            case ("mode"):
                _configs._clock[_enumC.mode] = conf;
                break;
            case ("r"):
                _configs._clock[_enumC.r] = conf;
                break;
            case ("g"):
                _configs._clock[_enumC.g] = conf;
                break;
            case ("b"):
                _configs._clock[_enumC.b] = conf;
                break;
            case ("music"):
                _configs._clock[_enumC.music] = conf;
                break;
            case ("mus_e"):
                _configs._clock[_enumC.mus_e] = conf;
                break;
            case ("demo"):
                _configs._clock[_enumC.demo] = conf;
                break;
            }
        }
        else{
            switch (whatconfig){
            case ("hrs"):
                _configs._light[_enumL.name] = conf;
                break;
            case ("mode"):
                _configs._light[_enumL.mode] = conf;
                break;
            case ("r"):
                _configs._light[_enumL.r] = conf;
                break;
            case ("g"):
                _configs._light[_enumL.g] = conf;
                break;
            case ("b"):
                _configs._light[_enumL.b] = conf;
                break;
            case ("demo"):
                _configs._light[_enumL.demo] = conf;
                break;
            }
        }
    }

    // CLEAR ALL RADIOBUTTONS
    function rbClear(){
        rb0.checked = false
        rb1.checked = false
        rb2.checked = false
        rb3.checked = false
        rb4.checked = false
    }

    // ON CLICKED FUNCTIONS-------------------------------------------------------------------------

    function onAcceptedColor(){
        bgColor.color = colorDialog.color
        changeConfiguration(getColor(""+bgColor.color, 1), "r");
        changeConfiguration(getColor(""+bgColor.color, 3), "g");
        changeConfiguration(getColor(""+bgColor.color, 5), "b");
    }
    function onMusicConfClicked(){
        music_form.musicListRefresh()
        tabBar.currentIndex = 3
    }
    // SAVE CONFIGS TO LIST OF CLOCKS/LIGHTS
    function onSaveConfigClicked(){
        var type = -1;
        if (_configs.mode === _configs.modeClock){
            _clockList._hrs[_configs.index] = _configs._clock[_enumC.hrs]
            _clockList._mins[_configs.index] = _configs._clock[_enumC.mins]
            _clockList._mode[_configs.index] = _configs._clock[_enumC.mode]
            _clockList._r[_configs.index] = _configs._clock[_enumC.r]
            _clockList._g[_configs.index] = _configs._clock[_enumC.g]
            _clockList._b[_configs.index] = _configs._clock[_enumC.b]
            _clockList._music[_configs.index] = _configs._clock[_enumC.music]
            _clockList._music_e[_configs.index] = _configs._clock[_enumC.mus_e]
            _clockList._demo[_configs.index] = _configs._clock[_enumC.demo]

            time_form.clockListRefresh()
            type = _message.all_clocks
        }
        else{
            _lightsList._name[_configs.index] = _configs._light[_enumL.name]
            _lightsList._mode[_configs.index] = _configs._light[_enumL.mode]
            _lightsList._r[_configs.index] = _configs._light[_enumL.r]
            _lightsList._g[_configs.index] = _configs._light[_enumL.g]
            _lightsList._b[_configs.index] = _configs._light[_enumL.b]
            _lightsList._demo[_configs.index] = _configs._light[_enumL.demo]

            time_form.lightsListRefresh()

            type = _message.all_lights;
        }
        makeSolidStringsAndSend(type)
        tabBar.currentIndex = 1;
    }

    //----------------------------------------------------------------------------------------------

    ///////////////////////////////////////////
    //============ UI ELEMENTS ==============//
    ///////////////////////////////////////////
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

    ColorDialog {
        id: colorDialog
        title: "Please, choose a color..."
        onAccepted: {
            onAcceptedColor();
            close()
        }
        onRejected: {
            close()
        }
        Component.onCompleted: visible = false
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
                    id: lblTime
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
                        text: qsTr("07")
                        font.pixelSize: _configTab._timePixelSize
                        onTextChanged: {
                            changeConfiguration(txtHours.text, "hrs")
                        }
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
                        onTextChanged: {
                           changeConfiguration(txtMinutes.text, "mins")
                        }
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
                    id: rb0
                    height: 40
                    text: qsTr(mode[0])
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear();
                        changeConfiguration(mode[0], "mode")
                        rb0.checked= true
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
                    id: rb1
                    height: 40
                    text: qsTr(mode[1])
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear()
                        changeConfiguration(mode[1], "mode")
                        rb1.checked = true
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
                    id: rb2
                    height: 40
                    text: qsTr(mode[2])
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {
                        rbClear()
                        changeConfiguration(mode[2], "mode")
                        rb2.checked= true
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
                    id: rb3
                    height: parent.height
                    text: qsTr(mode[3])
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily
                    onClicked: {                        
                        rbClear()
                        changeConfiguration(mode[3], "mode")
                        rb3.checked= true
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
                    id: rb4
                    height: parent.height
                    width: _items._width *0.5
                    text: qsTr(mode[4])
                    font.pixelSize: _configTab._rbPixelSize
                    font.family: _items._fontFamily

                    onClicked: {
                        rbClear()
                        changeConfiguration(mode[4], "mode")
                        rb4.checked = true
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
                id: musicRow
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
                        changeConfiguration(chMusic.enabled, "mus_e")
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
                        onMusicConfClicked();
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
                        onSaveConfigClicked();
                    }
                }
            }

        }
    }
}
