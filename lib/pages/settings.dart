import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info/package_info.dart';
import 'package:travel_hour/models/config.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {


  String appVersion = '0.0';
  String packageName = '';

  void initPackageInfo () async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
      packageName = packageInfo.packageName;
    });
  }

  @override
  void initState() {
    super.initState();
    initPackageInfo();
  }

  

  void openLincenceDialog () async{
    
      showDialog(
      context: context,
      builder: (BuildContext context){
        return AboutDialog(
          applicationName: Config().appName,
          applicationIcon: Image(image: AssetImage(Config().splashIcon), height: 30, width: 30,),
          applicationVersion: appVersion,
        );
      }
      
      );
    }


  void openPrivacyPolicy () async{
    await launch(Config().privacyPolicyUrl);
  }

  void openEmailPopup () async{
    await launch('mailto:${Config().supportEmail}?subject=About ${Config().appName} App&body=');

  }

  void openRatingReview () {
    LaunchReview.launch(androidAppId: packageName, iOSAppId: Config().appleAppId);
  }


  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 1,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
        ListTile(
              leading: Icon(LineIcons.envelope),
              title: Text('Support Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              subtitle: Text(Config().supportEmail, style: TextStyle(fontSize: 16),),
              onTap: ()=> openEmailPopup(),
            ),
        Divider(color: Colors.grey[300],),
        ListTile(
              leading: Icon(LineIcons.star_o),
              title: Text('Rate & Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              onTap: ()=> openRatingReview(),
            ),
        Divider(color: Colors.grey[300],),
        
        ListTile(
              leading: Icon(LineIcons.lock),
              title: Text('Privacy Policy', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              onTap: ()=> openPrivacyPolicy(),
            ),

        Divider(color: Colors.grey[300],),
        ListTile(
              leading: Icon(LineIcons.paper_plane),
              title: Text('Licence', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              onTap: ()=> openLincenceDialog(),
            ),
        Divider(color: Colors.grey[300],),
        
        ListTile(
              leading: Icon(LineIcons.info),
              title: Text('App Version', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              subtitle: Text(appVersion, style: TextStyle(fontSize: 16),),
              
            ),

        
      ],),
    );
  }
}