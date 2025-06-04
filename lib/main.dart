import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:http/http.dart';
import 'package:oauth2_client/oauth2_client.dart';
import 'package:oauth2_client/oauth2_helper.dart';

void main() {
  runApp(MyClient()
  );
}

class MyOAuthClient extends OAuth2Client {
  MyOAuthClient()
    : super(
        authorizeUrl:
            "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/users/o/authorize/",
        tokenUrl:
            "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/token/",
        redirectUri:
            "https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/users/oauth/callback/",
        customUriScheme: '',
       
      );
}

final oauthHelper = OAuth2Helper(
  MyOAuthClient(),
  clientId:'GXrpBe7m1iTxKrrz0GcKnm6UVJngDgtTePlJLchT',
  clientSecret:'wxN3u8YQtytgZFgPrJuMAKhXqMt32kI7lJVJVgSiNcSwStvluaThwlx0EtOK3vt42Z40ZH4Ef14Y5icFLHf3FixNZcJnCz298Gs0CqVG7ybZpySOqIWvTFXgzVS71dsg',
  scopes:['read','write'],

);

class MyClient extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title:'OAuth2 Demo',
    home:LoginPage(),
  
  );
  }

}

// class LoginPage extends StatelessWidget{
//   void login(BuildContext context) async {
//     var token = await oauthHelper.getToken()
// ;
// if(token != null && token.accessToken !=null){
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Login Successful:${token.accessToken}'),
//     )
//   );
// } 
//   else {
//     ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Login Failed')),
//     );
//   }
//  }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(
//         title: Text("Login With OAuth 2"),
//       ),
//       body: Center(
//         child: ElevatedButton(
          
//           onPressed: ()=> login(context), 
//           child:const Text('Login',style: TextStyle(color: Colors.blue),)
//           ),
//       ),
//       );
//   }
// }

class LoginPage extends StatelessWidget {
  void login(BuildContext context) async {
    var token = await oauthHelper.getToken();

    if (token != null && token.accessToken != null) {
      final response = await http.get(
        Uri.parse('https://apisecurity-ahabeuhfaqc6h7e0.centralus-01.azurewebsites.net/api/users/profile/'),
        headers: {
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final role = data['role'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful! Role: $role')),
        );
        // Optional: Navigate to different screen
        // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage(role: role)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login With OAuth 2")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => login(context),
          child: Text('Login', style: TextStyle(color: Colors.blue),),
        ),
      ),
    );
  }
}