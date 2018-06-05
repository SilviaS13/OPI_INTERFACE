import QtQuick 2.9
import QtQuick.Controls 2.2

import Bluetooth_Module 1.0


//import ClockSettings 1.0
//import LightSettings 1.0
//import MusicSettings 1.0


Page {
    width: 480
    height: 800

    /////////////////////////////////////////
    //============ FUNCTIONS ==============//
    /////////////////////////////////////////

    //REFRESH CLOCKS LIST
    function clockListRefresh(){
        for (var i= clockList.count -1; i>=0; i--) {
            clockList.remove(i);
        }

        for (var j=0; j < _clockList._hrs.length; j++) {
            clockList.append({"name" : (qsTr(_clockList._hrs[j]) + ":"+qsTr(_clockList._mins[j]))})
        }
    }

    //REFRESH LIGHTS LIST
    function lightsListRefresh(){
        for (var i=lightList.count -1; i>=0; i--) {
            lightList.remove(i);
        }

        for (var j=0; j < _lightsList._name.length; j++) {
            lightList.append({"name" : _lightsList._name[j]})
        }
    }

    ///////clock add del buttons/////////////////////////////////////////////////////////////
    function addClockClicked(){

        addClock("07", "00", mode[4], "120", "120", "40", _musicList._songs[0], "t", "f", "t")

        time_form.clockListRefresh();
    }
    function deleteClockClicked(){
        _clockList._switchBtnImage.splice(_clockList._curIndex, 1)
        _clockList._hrs.splice(_clockList._curIndex, 1)
        _clockList._mins.splice(_clockList._curIndex, 1)
        _clockList._mode.splice(_clockList._curIndex, 1)
        _clockList._r.splice(_clockList._curIndex, 1)
        _clockList._g.splice(_clockList._curIndex, 1)
        _clockList._b.splice(_clockList._curIndex, 1)
        _clockList._music.splice(_clockList._curIndex, 1)
        _clockList._music_e.splice(_clockList._curIndex, 1)
        _clockList._demo.splice(_clockList._curIndex, 1)
        clockListRefresh()
    }

    ////////light add del buttons///////////////////////////////////////////////////////////////////////
    function addLightClicked(){
        addLight("New Mode", mode[4], "120", "120", "40", "f", "f")
        lightsListRefresh()
    }
    function deleteLightClicked(){
        _lightsList._switchBtnImage.splice(_lightsList._curIndex, 1)
        _lightsList._name.splice(_lightsList._curIndex, 1)
        _lightsList._mode.splice(_lightsList._curIndex, 1)
        _lightsList._r.splice(_lightsList._curIndex, 1)
        _lightsList._g.splice(_lightsList._curIndex, 1)
        _lightsList._b.splice(_lightsList._curIndex, 1)
        _lightsList._demo.splice(_lightsList._curIndex, 1)
        lightsListRefresh()
    }

    function onBtnClockEnabledClicked(index){
        if (_clockList._switchBtnImage[index] === _clockList.on){
            _clockList._switchBtnImage[index] = _clockList.off
        }
        else{
            _clockList._switchBtnImage[index] = _clockList.on
        }
        clockListRefresh();
    }

    function onBtnLightEnabledClicked(index){
        if (_lightsList._switchBtnImage[index] === _lightsList.on){
            _lightsList._switchBtnImage[index] = _lightsList.off
        }
        else{
            for (var i=0; i <_lightsList._switchBtnImage.count; i++){
                _lightsList._switchBtnImage[i] = _lightsList.off
            }
            _lightsList._switchBtnImage[index] = _lightsList.on
        }
        lightsListRefresh()
    }
    //// FILL THE CONFIG TAB WITH PROPERTIES
    function onConfigClicked(index, mode){
        _configs.mode = mode
        _configs.index = index
        if (_configs.mode === "c"){
            _configs._clock[_enumC.hrs] = _clockList._hrs[_configs.index]
            _configs._clock[_enumC.mins] =  _clockList._mins[_configs.index]
            _configs._clock[_enumC.mode] = _clockList._mode[_configs.index]
            _configs._clock[_enumC.r] =_clockList._r[_configs.index]
            _configs._clock[_enumC.g] =_clockList._g[_configs.index]
            _configs._clock[_enumC.b] = _clockList._b[_configs.index]
            _configs._clock[_enumC.music] = _clockList._music[_configs.index]
            _configs._clock[_enumC.mus_e] =_clockList._music_e[_configs.index]
            _configs._clock[_enumC.demo] =_clockList._demo[_configs.index]
        }
        else{
            _configs._light[_enumL.name] = _lightsList._name[_configs.index]
            _configs._light[_enumL.mode] =_lightsList._mode[_configs.index]
            _configs._light[_enumL.r] =_lightsList._r[_configs.index]
            _configs._light[_enumL.g] =_lightsList._g[_configs.index]
            _configs._light[_enumL.b] =_lightsList._b[_configs.index]
            _configs._light[_enumL.demo] =_lightsList._demo[_configs.index]
        }
        config_form.fillConfigFields();
        tabBar.currentIndex = 2;
    }
    //////////////////////////////////////////
    //============ PROPERTIES ==============//
    //////////////////////////////////////////





    ///////////////////////////////////////////
    //============ UI ELEMENTS ==============//
    ///////////////////////////////////////////
    header: Label {
            color: _header._color
            font.pixelSize: _header._fontPixelSize
            padding: 10
            text: qsTr("Час")
            font.family: _items._fontFamily
    }

    ScrollView {
        clip: true
        width: parent.width
        height: parent.height

        Column {
            id: column1
            width: _items._width
            height: parent.height
            x: _items._x
            //bottomPadding: 100
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                height: _btnConf._size

                Text {
                    padding: 10
                    color: _title._color
                    text: qsTr("Будильники")
                    width: _window._windowWidth * 0.67
                    font.pixelSize: _title._fontPixelSize
                    font.family: _items._fontFamily
                }

                Button {
                    id: btnAddClock
                    x: _window._windowWidth - _items._x - 2 * width - 10
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgAdd
                    }
                    onClicked: {
                        addClockClicked();
                    }
                }

                Button {
                    id: btnDelClock
                    x: _window._windowWidth - _items._x - width
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgDelete
                    }
                    onClicked: {
                        deleteClockClicked();
                    }
                }
            }
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
                    height: 250

                    ScrollView {
                        id: scrollView
                        anchors.topMargin: 30
                        anchors.bottomMargin: 30
                        anchors.fill: parent;

                        ListView {
                            id: clockView
                            anchors.fill: parent;
                            model: ListModel {
                                id: clockList
                            }
                            delegate: Item {
                                anchors {
                                    left: parent.left;
                                    right: parent.right;
                                }
                                height: _list._highOfItem
                                Rectangle{
                                    anchors.fill: parent
                                    color: (index === _clockList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            _clockList._curIndex = index
                                            clockListRefresh()
                                        }
                                    }
                                    Text {
                                        padding: 10
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        color: (index === _clockList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName
                                        font.bold: true
                                        font.pointSize: _list._fontNamePixelSize
                                        font.family: _items._fontFamily

                                    }

                                    Button {
                                        x: rectangle.x + rectangle.width - 2 * width -20
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            fillMode: Image.PreserveAspectFit
                                            sourceSize.height: 0
                                            sourceSize.width: 0
                                            source: encodeURIComponent(_clockList._switchBtnImage[index])
                                        }
                                        onClicked: {
                                              onBtnClockEnabledClicked(index)
                                        }
                                    }
                                    Button {
                                        /// config clock button
                                        x: rectangle.x + rectangle.width - width - 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        text: qsTr("")
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            fillMode: Image.PreserveAspectFit
                                            sourceSize.height: 0
                                            sourceSize.width: 0
                                            source: _btnConf._imgSettings
                                        }
                                        onClicked: {
                                            onConfigClicked(index, "c");
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Component.onCompleted: { clockListRefresh() }
                }
            }

            /////////////////////////////////////////////////////////////
            //==================== LIGHT VIEW =========================//
            /////////////////////////////////////////////////////////////
            Row {
                anchors.left: parent.left
                anchors.right: parent.right

                topPadding: 15
                height: _btnConf._size + topPadding
                Text {
                    id: titleText
                    width: _window._windowWidth * 0.67
                    color: _title._color
                    text: qsTr("Ввімкнути світло")
                    padding: 10
                    font.pixelSize: _title._fontPixelSize
                    font.family: _items._fontFamily
                }

                Button {
                    id: btnAddLight

                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgAdd
                    }
                    onClicked: {
                        addLightClicked();
                    }
                }

                Button {
                    id: btnDelLight
                    width: _btnConf._size
                    height: _btnConf._size
                    text: qsTr("")
                    background: Image {
                        anchors.fill: parent
                        source: _btnConf._imgDelete
                    }
                    onClicked: {
                        deleteLightClicked();
                    }
                }
            }
            Row {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 20
                height: rectangle1.height +topPadding
                topPadding: 10
                Rectangle {
                    id: rectangle1

                    width: _items._width
                    height: rectangle.height
                    color: _list._background
                    ScrollView {
                        id: scrollView1
                        anchors.fill: parent
                        ListView {
                            anchors.fill: parent
                            anchors.topMargin: 30
                            anchors.bottomMargin: 30

                            model: ListModel {
                                id: lightList
                            }
                            delegate: Item {
                                width: parent.width
                                height: _list._highOfItem
                                Rectangle{
                                    anchors.fill: parent
                                    color: (index == _lightsList._curIndex) ? _list._colorOfSelectedItem : _list._colorOfItem
                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                            _lightsList._curIndex = index
                                            lightsListRefresh()
                                        }
                                    }
                                    Text {
                                        padding: 10
                                        text: model.name
                                        anchors.verticalCenter: parent.verticalCenter
                                        font.bold: true
                                        font.pointSize: _list._fontNamePixelSize
                                        font.family: _items._fontFamily
                                        color: (index == _lightsList._curIndex) ? _list._colorOfSelectedName : _list._colorOfName

                                    }
                                    Button {
                                        x: rectangle1.x + rectangle1.width - 2 * width -20
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        text: qsTr("")
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            sourceSize.width: 0
                                            sourceSize.height: 0
                                            fillMode: Image.PreserveAspectFit
                                            source: _lightsList._switchBtnImage[index]
                                        }
                                        onClicked: {
                                            onBtnLightEnabledClicked(index);
                                        }
                                    }

                                    Button {
                                        x: rectangle1.x + rectangle1.width -  width - 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: _btnConf._size
                                        height: _btnConf._size
                                        text: qsTr("")
                                        background: Image {
                                            width: parent.width
                                            height: parent.height
                                            sourceSize.width: 0
                                            sourceSize.height: 0
                                            fillMode: Image.PreserveAspectFit
                                            source: _btnConf._imgSettings
                                        }
                                        onClicked: {
                                            onConfigClicked(index, "l");
                                        }
                                    }
                                }
                            } //end of delegate
                        } //end of ListView
                    } //end of ScrollView
                    Component.onCompleted: { lightsListRefresh() }
                }//end of Rectangle
            }
        }
    }
}
