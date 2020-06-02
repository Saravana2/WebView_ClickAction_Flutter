import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Webview'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url ="https://github.com/login";
  CookieManager _cookieManager = CookieManager();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  WebViewController _myController;
  var isLoading = true;

  @override
  void initState() {
    _cookieManager.clearCookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            WebView(
              onWebViewCreated: (controller) {
                _myController = controller;
              },
              initialUrl: url,
              onPageFinished: (url) {
                _delayed();
                setState(() {
                  isLoading = false;
                });
              },
              onPageStarted: (url) {
                setState(() {
                  isLoading = true;
                });
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: "showSnackbar",
                    onMessageReceived: (JavascriptMessage result) {
                      if (result.message != null && result.message != "") {
                        _scaffoldKey.currentState..showSnackBar(SnackBar(content: Text(result.message)));
                      }
                    }),
              ]),
            ),
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Container()
          ],
        ));
  }

  _delayed() {

    /*_myController.evaluateJavascript(
        "document.getElementsByName('commit')[0].addEventListener('click',function(){ try { showSnackbar.postMessage(document.getElementById('login_field').value);  } catch (err) {} });");*/

     _myController.evaluateJavascript("document.getElementsByTagName('body')[0].addEventListener('click',function(){ try { showSnackbar.postMessage(document.getElementById('login_field').value);  } catch (err) {} });");

  }


}
