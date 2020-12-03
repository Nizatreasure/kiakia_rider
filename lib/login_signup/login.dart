import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiakia_rider/decoration.dart';
import 'package:kiakia_rider/login_signup/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String password = '';
  FocusNode _passwordFocusNode;
  bool _hidePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) _hidePassword = true;
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: LayoutBuilder(
            builder: (context, viewPort) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewPort.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()));
                            },
                            child: Container(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Color.fromRGBO(5, 54, 90, 0.5),
                                    fontSize: 20),
                              ),
                              margin: EdgeInsets.only(top: 20),
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 70,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Hello Ebenezer',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                color: Color.fromRGBO(5, 25, 51, 1)),
                          ),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'Use fingerprint to login to your account',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Container(
                            height: 150,
                            alignment: Alignment(-0.2, 0),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.fingerprint,
                                color: Color.fromRGBO(57, 138, 239, 1),
                                size: 84,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          alignment: Alignment(0, 0.7),
                          child: Text(
                            'Or use your password instead',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (val) {
                              password = val;
                            },
                            validator: (val) {
                              return val.trim().isEmpty ? '' : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: _hidePassword,
                            focusNode: _passwordFocusNode,
                            toolbarOptions: ToolbarOptions(
                                copy: false, cut: false, paste: true),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: Color.fromRGBO(5, 54, 90, 1),
                                    height: 1.5),
                            decoration: decoration.copyWith(
                                hintText: 'Enter your password',
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _hidePassword
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      size: 16,
                                      color: Color.fromRGBO(5, 54, 90, 1),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    })),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              height: 20,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    color: Color.fromRGBO(57, 138, 239, 1)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        FlatButton(
                          onPressed: () {},
                          minWidth: double.infinity,
                          child: Text('Login',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700)),
                          color: Color.fromRGBO(57, 138, 239, 1),
                          height: 48,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
