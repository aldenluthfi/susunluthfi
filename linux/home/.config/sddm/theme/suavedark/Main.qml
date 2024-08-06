import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import SddmComponents 2.0
import "."

Rectangle {
    id: container
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    property int sessionIndex: session.index
    property date dateTime: new Date()


    TextConstants {
        id: textConstants
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#ff3333"
            errorMessage.text = textConstants.loginFailed
        }
    }

    FontLoader {
        id: myFontNormal
        source: "./assets/Inter-Regular.ttf"
    }

    FontLoader {
        id: myFontBold
        source: "./assets/Inter-Bold.ttf"
    }

    Rectangle {
	id: behind
	anchors.fill: parent
	color: "#09090b"

    }

//    Image {
//        id: behind
//        anchors.fill: parent
//         source: config.background
//         fillMode: Image.Stretch
//         onStatusChanged: {
//             if (config.type === "color") {
//                 source = config.defaultBackground
//             }
//         }
//    }

    MultiEffect {
        source: behind
        anchors.fill: behind
        brightness: -0.2
        contrast: -0.45
        blurEnabled: true
        blurMax: 32
        blur: 0.5
    }

    ColumnLayout{
        id: centerBox
        anchors.centerIn: parent
	spacing: 24
			
	Image {
		
		id: ava
    		width: 80
		height: 80
		sourceSize.width: 120
		sourceSize.height: 120
		visible: true
    		fillMode: Image.PreserveAspectFit
		anchors.horizontalCenter: parent.horizontalCenter

		layer.enabled: true
		layer.effect: {
    			maskSource: mask
		}

		source: "assets/.face.icon"
	}

        Rectangle {
                color: "#18181b"
                radius: 5
                width: 360
                height: 38

                TextField {
                    id: nameinput
                    focus: true
                    anchors.fill: parent
                    text: userModel.lastUser
                    font.family: myFontBold.name
                    font.bold: true
                    font.pointSize: 10
                    leftPadding: 16
                    color: "#fafafa"
                    placeholderText: "Username"
                    placeholderTextColor: "#a1a1aa"
                    selectionColor: "#52525b"

                    background: Rectangle {
                        id: textback
                        color: "#18181b"
                        radius: 5

                        states: [
                            State {
                                name: "yay"
                                PropertyChanges {
                                    target: textback
                                    opacity: 1
                                }
                            },
                            State {
                                name: "nay"
                                PropertyChanges {
                                    target: textback
                                    opacity: 0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "yay"
                                NumberAnimation {
                                    target: textback
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: 200
                                }
                            },

                            Transition {
                                to: "nay"
                                NumberAnimation {
                                    target: textback
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: 200
                                }
                            }
                        ]
                    }

                    KeyNavigation.tab: password
                    KeyNavigation.backtab: password

                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            password.focus = true
                        }
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            textback.state = "yay"
                        } else {
                            textback.state = "nay"
                        }
                    }
                }
            }

            Rectangle {
                color: "#18181b"
                radius: 5
                width: 360
                height: 38

                TextField {
                    id: password
		    anchors.fill: parent
		    font.family: myFontBold.name
                    font.bold: true
                    font.pointSize: 10
                    leftPadding: 16
                    echoMode: TextInput.Password
                    color: "#fafafa"
                    selectionColor: "#52525b"
                    placeholderText: "Password"
                    placeholderTextColor: "#a1a1aa"

                    background: Rectangle {
                        id: textback1
                        color: "#18181b"
                        radius: 5

                        states: [
                            State {
                                name: "yay1"
                                PropertyChanges {
                                    target: textback1
                                    opacity: 1
                                }
                            },
                            State {
                                name: "nay1"
                                PropertyChanges {
                                    target: textback1
                                    opacity: 0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "yay1"
                                NumberAnimation {
                                    target: textback1
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: 200
                                }
                            },

                            Transition {
                                to: "nay1"
                                NumberAnimation {
                                    target: textback1
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: 200
                                }
                            }
                        ]
                    }

                    KeyNavigation.tab: nameinput
                    KeyNavigation.backtab: nameinput

                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameinput.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            textback1.state = "yay1"
                        } else {
                            textback1.state = "nay1"
                        }
                    }
                }
            }

        Image {
            id: loginButton
            source: "assets/buttonup.svg"
            Layout.alignment: Qt.AlignRight

            property string toolTipText3: textConstants.login

            MouseArea {
                id: ma3
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/buttonhover.svg"
                }
                onExited: {
                    parent.source = "assets/buttonup.svg"
                }
                onPressed: {
                    parent.source = "assets/buttondown.svg"
                    sddm.login(nameinput.text, password.text, sessionIndex)
                }
                onReleased: {
                    parent.source = "assets/buttonup.svg"
                }
            }
        }
    } //columnlayout

    Row {
        spacing: 16
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 16
        anchors.bottomMargin: 16

        Image {
            id: rebootButton
            source: "assets/reboot.svg"
            Layout.alignment: Qt.AlignCenter
            width: 24
            height: 24

            property string toolTipText2: textConstants.reboot

            MouseArea {
                id: ma2
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/reboothover.svg"
                }
                onExited: {
                    parent.source = "assets/reboot.svg"
                }
                onPressed: {
                    parent.source = "assets/rebootpressed.svg"
                    sddm.reboot()
                }
                onReleased: {
                    parent.source = "assets/reboot.svg"
                }
            }
        }

        Image {
            id: shutdownButton
            source: "assets/shutdown.svg"
            Layout.alignment: Qt.AlignCenter
            width: 24
            height: 24

            property string toolTipText1: textConstants.shutdown

            MouseArea {
                id: ma1
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/shutdownhover.svg"
                }
                onExited: {
                    parent.source = "assets/shutdown.svg"
                }
                onPressed: {
                    parent.source = "assets/shutdownpressed.svg"
                    sddm.powerOff()
                }
                onReleased: {
                    parent.source = "assets/shutdown.svg"
                }
            }
        }
    }

    Component.onCompleted: {
        nameinput.focus = true
        textback1.state = "nay1" //dunno why both inputs get focused
    }
}
