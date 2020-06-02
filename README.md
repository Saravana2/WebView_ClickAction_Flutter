# Webview click handling by javascript

A new Flutter application.

## Getting Started

In Flutter, touch and click events are not working in webview. so instead of write click event in dart, write click event on Javascript by element tag name, class name or id 


First step is to enable the javascript, javascript is disabled by default in webview. We can able to get each and every data from website by js.

Enable the javascript by Webview widget ``javascriptMode`` property  
```
javascriptMode: JavascriptMode.unrestricted,
```

#### javascriptChannels  : Channel of communication between JS and Flutter
Then implement the ``javascriptChannels`` for getting the data from Web to flutter 

```
JavascriptChannel( channelName , onMessageReceived: (JavascriptMessage result) { }) 
```

Pass the data web using js by channel name, like 
```
channelName.postMessage("data");
```
After posted message from js, the onMessageReceived function for the javascript channel will call with the result 'data'.

`` JavascriptMessage ``  class temporarily has only one message member variable of type String, so if you need to pass complex data, you can solve it by passing a json string.

There is no limit for javascript channels. javascriptChannels property in webview required ``Set``,so we can add many channels.

We are going to load the js click event by webview controller after the webpage is loaded in the webview. 


####  Load the js click event by webview controller
-  Get the element by name of th element and write the click action for that.
-  commit -  is the name of the input element in github page
-  ``element.addEventListener('click',function(){});``  - this addEventListener method will add click action to the element.
-  addEventListener allows two parameters, first param is for action type and second param is a function. when the element     is clicked, the function will call immediately.
-  login_field - is the id of the input field
-  Get the element value by js then send the value to flutter by `` showResult.postMessage(document.getElementById('login_field').value);  ``
-  showResult is the name of the javascript channel of the webview

```
 _myController.evaluateJavascript(
        "document.getElementsByName('commit')[0].addEventListener('click',function(){ try { showResult.postMessage(document.getElementById('login_field').value);  } catch (err) {} });");
```

The below code is to add click event for all the clickable elements in the currently loaded web page.
Get the body element by tag name then add click event to it. so every clickable element is clicked in the web page, the callback function will call

```
_myController.evaluateJavascript(
        "document.getElementsByTagName('body')[0].addEventListener('click',function(){ try { showSnackbar.postMessage(document.getElementById('login_field').value);  } catch (err) {} });");
```


####  Below code snippet is for web view configuration

```
WebView(
    initialUrl: "https://github.com/login",
    onWebViewCreated: (controller) {
    _myController = controller;
    },
    onPageFinished: (url) {
    
    _myController.evaluateJavascript(
        "document.getElementsByName('commit')[0].addEventListener('click',function(){ try { showResult.postMessage(document.getElementById('login_field').value);  } catch (err) {} });");
        
    },
    onPageStarted: (url) {},
    javascriptMode: JavascriptMode.unrestricted,
    javascriptChannels: Set.from([
    JavascriptChannel(
    name: "showResult",
    onMessageReceived: (JavascriptMessage result) {
    if (result.message != null && result.message != "") {
    // The result data will be stored in result.message 
    }}),]),)
```

