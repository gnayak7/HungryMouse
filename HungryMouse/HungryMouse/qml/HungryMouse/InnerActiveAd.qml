import QtQuick 1.0

Item {
	id: adContainer
	property string appid: ""
	
	//these probably don't need to be specified
	property string channelid: "551"

        property int screenWidth: 0
        property int screenHeight: 0

        //defaults - hopefully overridden
        //width: 100
        //height: 100

	//parent needs to set width and height so that way we can use it to request the correct sized ad

	//private properties
        //property string __adUrl: ""
	property string __clientId: ""
        property string __clickUrl:  ""
        property string __imageUrl: ""

        signal finishedLoading()


	Image {
		id: ad
                //width: parent.width
                //height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width <= sourceSize.width ? parent.width : sourceSize.width
                height: parent.height <= sourceSize.height ? parent.height : sourceSize.height

                fillMode: Image.PreserveAspectFit

		MouseArea {
                        anchors.fill:  parent
			id: adMouse
                        onClicked: {  console.log("you clicked the ad"); adClicked(); }
                }
	}


	Component.onCompleted: { init(); }


	//setup
	function init() {
		if(appid == "")
                        console.log("Warning: no app id specified in inner active ad module");

	}


	//loads a new ad
	function loadAd() {
		var baseUrl = "http://m2m1.inner-active.com/simpleM2M/clientRequestAd?";
		
		var requestUrl = baseUrl + "aid=" + appid + "&po=" + channelid;
		if(__clientId != "")
			requestUrl = requestUrl + "&cid=" + __clientId;
                if(screenWidth > 0 && screenHeight > 0)
                    requestUrl = requestUrl + "&w=" + screenWidth + "&h=" + screenHeight;
		
		
		//request ad

		var adResponse = new XMLHttpRequest();                

		
		adResponse.onreadystatechange = function() {
			if(adResponse.readyState == XMLHttpRequest.DONE) {
				var doc = adResponse.responseXML.documentElement;
                                var haveImage = false;
                                var haveUrl = false
                            //traverse(adResponse.responseXML);
                            //console.log(adResponse.responseText)
				//process xml
				for(var i =0; i< doc.childNodes.length; i++) {
					console.log(doc.childNodes[i].nodeName + "=" + doc.childNodes[i].nodeValue);
                                    if(doc.childNodes[i].nodeName == 'Client')
                                        //assume only attribute is the client id
                                        __clientId = doc.childNodes[i].attributes[0].value;

                                    if(doc.childNodes[i].nodeName == "Ad") {
                                        var adNode = doc.childNodes[i];

                                        console.log("number of ad children " + doc.childNodes[i].length);
                                        for(var x =0; x < adNode.childNodes.length; x++) {
                                            console.log(adNode.childNodes[x].nodeName + "=" + adNode.childNodes[x].nodeValue);
                                            if(adNode.childNodes[x].nodeName == 'URL') {
                                                //Click URL
                                                __clickUrl = adNode.childNodes[x].firstChild.nodeValue;
                                                haveUrl = true;
                                            }

                                            if(adNode.childNodes[x].nodeName == 'Image') {
                                                //Image URL
                                                //console.log("image url " + adNode.childNodes[x].firstChild.nodeValue);
                                                __imageUrl = adNode.childNodes[x].firstChild.nodeValue
                                                haveImage = true;
                                            }

                                            if(adNode.childNodes[x].nodeName == 'Text') {
                                                //Banner text
                                                //not doing text ads right now
                                            }
                                        }
                                    }
				}

                                //assign image url and click url
                                if(haveUrl && haveImage) {
                                    ad.source = __imageUrl;
                                    adContainer.finishedLoading();
                                }
			}


		}
		console.log("requesting: " + requestUrl);

                //pretend to be a Nokia N8

		adResponse.open("GET", requestUrl);
                adResponse.setRequestHeader("User-Agent","Mozilla/5.0 (Symbian/3; Series60/5.2 NokiaN8-00/014.002; Profile/MIDP-2.1 Configuration/CLDC-1.1; en-us) AppleWebKit/525 (KHTML, like Gecko) Version/3.0 BrowserNG/7.2.6.4 3gpp-gba");
		adResponse.send();


	}




	//ad clicked launch browser
	function adClicked() {
		//will probably need custom browser launcher code because of qt bugs with launching browser
		//http://www.developer.nokia.com/Community/Wiki/How_to_launch_other_applications_in_Qt
                if(__clickUrl != "") {
                        console.log("Ad clicked, launching: " + __clickUrl);
                        Qt.openUrlExternally(__clickUrl);
                }
		else
			console.log("Something strange here you clicked an ad but we don't have a URL registered");

	}

}
