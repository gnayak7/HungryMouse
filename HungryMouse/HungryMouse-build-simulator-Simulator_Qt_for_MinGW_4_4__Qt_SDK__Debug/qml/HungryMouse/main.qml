import QtQuick 1.0
import QtMultimediaKit 1.1
import "logicCatchMe.js" as CM

Rectangle {
    id:rect
    width: 640
    height: 360

    Audio {
        id: playMusicEat
        source: "button-20.mp3"
    }
    Audio {
        id: playMusiceStart
        source: "startMusic.mp3"
    }
    Audio {
        id: playMusiceClick
        source: "button-11.mp3"
    }
    MouseArea {
         id: playArea
         anchors.fill: parent
         opacity:1
     }
    InnerActiveAd {
        id: ad
        width: 640
        height: 360
        x: 0
        y: 0
        appid: "SND_HungryMice_OVI";
    }


    Timer{
        id:splashScreenTimer
        running:true
        interval:1000
        onTriggered: {
            rect.state="splashScreen"
            playMusiceStart.play()
            addTimer.running=true
        }
    }

    Timer{
        id:addTimer
        interval:2000
        running:false
        onTriggered: {
            ad.loadAd();
            rect.state="inAds";
            gamePlayScreenTimer.running=true
        }
    }

    Timer{
        id:gamePlayScreenTimer
        interval:5000
        running:false
        onTriggered: {
            gamePlayTimer.running=true
        }
    }
    Timer{
        id:gamePlayTimer
        running:true
        interval:1000
        onTriggered: {
            //foodTimer.running=true
            console.log("here i come")
            rect.state="mainMenuScreen"
        }
    }

    Image {
        id: upButton
        x: 203
        y: 272
        source: "images/upClick.png"
        opacity: 0

        MouseArea {
            id: maUp
            anchors.fill: parent
            opacity: 0
        }
    }

    Image {
        id: rightButton
        x: 36
        y: 270
        source: "images/rightClick.png"
        opacity: 0

        MouseArea {
            id: maRight
            anchors.fill: parent
            opacity: 0
        }
    }

    Image {
        id: leftButton
        x: 22
        y: 270
        source: "images/leftClick.png"
        opacity: 0

        MouseArea {
            id: maLeft
            anchors.fill: parent
            opacity: 0
        }
    }

    Image {
        id: food
        x: 249
        y: 106
        source: "images/gameBall.png"
        opacity: 0
    }

    Image {
        id: downButton
        x: 571
        y: 220
        source: "images/downClick.png"
        opacity: 0

        MouseArea {
            id: maDown
            anchors.fill: parent
            opacity: 0
        }
    }

    Image {
        id: eater
        x: 400
        y: 95
        source: "images/eaterDown.png"
        opacity: 0
    }

    Timer{
        id:foodTimer
        running: false
        interval:5000
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            CM.counter=0
            food.opacity=1
            counterTimer.running=true
            counterTimer.restart()
            console.log("triggered")
            console.log("cm flag = " + CM.flag)
            if(CM.flag>=5)
            {
                rect.state="gameOverScreen"
                foodTimer.running=false
                counterTimer.running=false
                foodCheck.running=false
                console.log("gameover")
                food.opacity=0
            }

            var x=(Math.round((Math.random()*1000))%640)
            var y=(Math.round((Math.random()*1000))%360)
            if((x+food.width)>=640)
                food.x=x-food.width
            else
                food.x=x
            if((y+food.height>=360))
               food.y=y-food.height
            else
                food.y=y
        }
    }

    Timer{
        id:delayTimer
        interval: 500
        running:false
        repeat:false
        onTriggered: {
            foodTimer.restart()
            CM.score=CM.score+10
            textScore.text=CM.score
        }
    }

    Timer{
        id:counterTimer
        running:false
        interval:500
        repeat:true
        onTriggered: {
            CM.counter=CM.counter+1
            console.log(CM.counter)

            if(CM.counter>=9) {
                CM.flag=CM.flag+1
            }
        }
    }

    Timer{
        id:foodCheck
        running: true
        interval: 100
        repeat: true
        onTriggered: {
            if((eater.x>food.x && eater.x<(food.x+food.width)) || (food.x>eater.x && food.x<(eater.x+eater.width)))
               if((eater.y>food.y && eater.y<(food.y+food.height)) || (food.y>eater.y && food.y<(eater.y+eater.height)))
                  {
                    food.opacity=0
                    playMusicEat.play()
                    delayTimer.running=true
                    console.log("here")
                }
        }
    }

    Timer{
        id:upTimer
        running:false
        interval: 10
        repeat: true
        onTriggered: {
            if(eater.y>=0)
                eater.y=eater.y-2
            else
                eater.y=360-eater.height
        }
    }

    Timer{
        id:leftTimer
        running:false
        interval: 10
        repeat: true
        onTriggered: {
            if(eater.x>=0)
                eater.x=eater.x-2
            else
                eater.x=640-eater.width
        }
    }

    Timer{
        id:downTimer
        running:false
        interval: 10
        repeat: true
        onTriggered:{
            if(eater.y+eater.height<=360)
                eater.y=eater.y+2
            else
                eater.y=0
        }
    }

    Timer{
        id:rightTimer
        running:false
        interval: 10
        repeat: true
        onTriggered: {
            if(eater.x+eater.width<=640)
                eater.x=eater.x+2
            else
                eater.x=0
        }
    }

    Image {
        id: imageBackground
        x: -1
        y: -16
        source: "images/background.png"
        opacity: 0

        Text {
            id: labelScore
            x: 489
            y: 12
            text: qsTr("text")
            font.pixelSize: 12
            opacity: 0
        }

        Text {
            id: textScore
            x: 554
            y: 12
            text: qsTr("text")
            font.pixelSize: 12
            opacity: 0
        }
    }

    Image {
        id: image1
        x: 0
        y: 0
        source: "images/splashscreen-landscape2.jpg"
        opacity: 0
    }

    Image {
        id: imageMainMenu
        x: 0
        y: -1
        source: "images/mainMenuImage.png"
        opacity: 0

        MouseArea {
            id: maPlay
            x: 403
            y: 179
            width: 100
            height: 100
            opacity: 0
        }

        MouseArea {
            id: maInstructions
            x: 360
            y: 236
            width: 100
            height: 100
            opacity: 0
        }

        MouseArea {
            id: maExit
            x: 419
            y: 283
            width: 100
            height: 100
            opacity: 0
        }
    }

    Image {
        id: image2
        x: 0
        y: -1
        source: "images/instructions.png"
        opacity: 0
    }

    Image {
        id: imageBackButton
        x: 0
        y: 0
        source: "images/backButton.png"
        opacity: 0

        MouseArea {
            id: maBack
            anchors.fill: parent
            opacity: 0
        }
    }

    Image {
        id: imageGameOver
        x: 0
        y: 0
        source: "images/gameOver.png"
        opacity: 0
    }

    states: [
        State {
            name: "gamePlayScreen"

            PropertyChanges {
                target: upButton
                x: 5
                y: 82
                width: 52
                height: 68
                z: 10
                opacity: 1
            }

            PropertyChanges {
                target: rightButton
                x: 589
                y: 270
                width: 51
                height: 54
                z: 4
                opacity: 1
            }

            PropertyChanges {
                target: leftButton
                x: 0
                y: 270
                width: 57
                height: 54
                z: 5
                opacity: 1
           }

            PropertyChanges {
                target: downButton
                x: 580
                y: 82
                width: 49
                height: 68
                z: 7
                opacity: 1
            }

            PropertyChanges {
                target: food
                x: 304
                y: 107
                width: 50
                height: 26
                z: 2
                opacity: 1
            }

            PropertyChanges {
                target: eater
                z: 3
                opacity: 1
            }

            PropertyChanges {
                target: maLeft
                anchors.fill:parent
                opacity: 1

                onPressed: {
                    eater.source="images/eaterLeft.png"
                    leftTimer.running=true
                }
                onReleased: {
                    leftTimer.running=false
                }
            }

            PropertyChanges {
                target: maRight
                x: -7
                y: 0
                width: 58
                height: 54
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: -7
                anchors.topMargin: 0
                anchors.fill:parent
                opacity: 1

                onPressed: {
                    eater.source="images/eaterRight.png"
                    rightTimer.running=true
                }
                onReleased: {
                    rightTimer.running=false
                }
            }

            PropertyChanges {
                target: maUp
                x: 0
                y: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.leftMargin: 0
                anchors.topMargin: 0
                opacity: 1

                onPressed: {
                    eater.source="images/eaterUp.png"
                    upTimer.running=true
                }

                onReleased: {
                    upTimer.running=false
                }
            }
            PropertyChanges {
                target: maDown
                width: 50
                height: 72
                anchors.rightMargin: 0
                anchors.bottomMargin: 0
                anchors.fill: parent
                opacity: 1
                onPressed: {
                    eater.source="images/eaterDown.png"
                    downTimer.running=true
                }
                onReleased: {
                    downTimer.running=false
                }
            }

            PropertyChanges {
                target: imageBackground
                x: 0
                y: -1
                opacity: 1
            }

            PropertyChanges {
                target: labelScore
                x: 494
                y: 25
                width: 56
                height: 26
                text: qsTr("Score")
                horizontalAlignment: "AlignHCenter"
                font.pixelSize: 20
                opacity: 1
            }

            PropertyChanges {
                target: textScore
                x: 555
                y: 25
                width: 80
                height: 26
                text: qsTr("00")
                horizontalAlignment: "AlignLeft"
                font.pixelSize: 20
                verticalAlignment: "AlignVCenter"
                opacity: 1
            }

            PropertyChanges {
                target: imageBackButton
                x: 0
                y: 0
                opacity: 1
            }

            PropertyChanges {
                target:maBack
                opacity: 1
                onClicked:{
                    rect.state="mainMenuScreen"
                    foodTimer.running=false
                    counterTimer.running=false
                    foodCheck.running=falses
                    food.opacity=0
                }
            }

        },
        State {
            name: "splashScreen"

            PropertyChanges {
                target: image1
                opacity: 1
            }
        },
        State {
            name: "mainMenuScreen"

            PropertyChanges {
                target: imageMainMenu
                x: 0
                y: 0
                opacity: 1
            }

            PropertyChanges {
                target: maPlay
                x: 367
                y: 179
                width: 206
                height: 44
                opacity: 1

                onClicked:{
                    rect.state="gamePlayScreen"
                    CM.counter=0
                    CM.flag=0
                    CM.score=0
                    foodTimer.running=true
                    playMusiceClick.play()
                }
            }

            PropertyChanges {
                target: maInstructions
                width: 222
                height: 34
                opacity: 1
                onClicked:{
                    rect.state="instructionsScreen"
                    playMusiceClick.play()
                }
            }

            PropertyChanges {
                target: maExit
                x: 384
                y: 283
                width: 179
                height: 45
                opacity: 1

                onClicked:{
                    Qt.quit();
                }
            }
        },
        State {
            name: "instructionsScreen"

            PropertyChanges {
                target: image2
                opacity: 1
            }

            PropertyChanges {
                target: imageBackButton
                opacity: 1
            }

            PropertyChanges {
                target: maBack
                opacity: 1
                onClicked:{
                    rect.state="mainMenuScreen"
                    foodTimer.running=false
                    counterTimer.running=false
                    foodCheck.running=falses
                    food.opacity=0
                }
            }
        },
        State {
            name: "inAdsScreen"
        },
        State {
            name: "gameOverScreen"

            PropertyChanges {
                target: image2
                opacity: 0
            }

            PropertyChanges {
                target: imageBackButton
                z: 1
                opacity: 1
            }

            PropertyChanges {
                target: imageGameOver
                opacity: 1
            }

            PropertyChanges {
                target: maBack
                opacity: 1
                onClicked:{
                    rect.state="mainMenuScreen"
                    foodTimer.running=false
                    counterTimer.running=false
                    foodCheck.running=falses
                    food.opacity=0
                }
            }
        }
    ]
}
