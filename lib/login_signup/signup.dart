import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiakia_rider/decoration.dart';
import 'package:kiakia_rider/login_signup/login.dart';
import 'package:kiakia_rider/login_signup/verify_number.dart';
import 'package:kiakia_rider/services/authentication.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  FocusNode _passwordFocusNode;
  String name = '', email = '', password = '', error = '';
  bool nameValidate = false,
      passValidate = false,
      emailValidate = false,
      showLoader = false,
      showError = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _hidePassword = true;
      }
    });
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  //formats the rider's name by removing extra spaces
  String formatUserName(String name) {
    List nameList = [];
    for (int i = 0; i < name.split(' ').length; i++) {
      if (name.split(' ')[i] != '') nameList.add(name.split(' ')[i]);
    }
    return nameList.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: LayoutBuilder(
            builder: (context, viewPort) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: viewPort.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(
                          flex: 2,
                        ),
                        Container(
                          alignment: Alignment(0, 0),
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Welcome to',
                                  style: TextStyle(
                                      color: Color.fromRGBO(5, 25, 51, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 32)),
                              Container(
                                  height: 20,
                                  width: 82,
                                  child: Image.asset('assets/gas_logo2.jpg'))
                            ],
                          ),
                        ),
                        Container(
                          height: 70,
                          constraints: BoxConstraints(minHeight: 30),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(
                              'Enter your email to sign up or use the social sign up',
                              textAlign: TextAlign.center,
                              style: TextStyle()),
                        ),
                        Spacer(),
                        //google and facebook login buttons
                        Container(
                          height: 80,
                          child: Row(
                            children: [
                              Expanded(
                                child: FlatButton(
                                  height: 48,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Google',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                  color: Color.fromRGBO(176, 46, 30, 1),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: FlatButton(
                                  height: 48,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(FontAwesomeIcons.facebookF,
                                          color: Colors.white, size: 16),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Facebook',
                                        style:
                                            Theme.of(context).textTheme.button,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {},
                                  color: Color.fromRGBO(59, 89, 152, 1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //text input fields, signUp button
                        Expanded(
                          flex: 8,
                          child: Form(
                            key: _formKey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    onChanged: (val) {
                                      name = val;
                                      setState(() {
                                        if (val.trim().length > 4)
                                          nameValidate = true;
                                        else
                                          nameValidate = false;
                                      });
                                    },
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Color.fromRGBO(5, 54, 90, 1),
                                            height: 1.5),
                                    decoration: decoration.copyWith(
                                        hintText: 'Enter Name',
                                        fillColor: emailValidate &&
                                                nameValidate &&
                                                passValidate
                                            ? Color.fromRGBO(196, 221, 252, 0.5)
                                            : decoration.fillColor),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (val) {
                                      if (val.trim().length < 5)
                                        return '';
                                      else
                                        return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onChanged: (val) {
                                      email = val.trim();
                                      setState(() {
                                        if (EmailValidator.validate(val.trim()))
                                          emailValidate = true;
                                        else
                                          emailValidate = false;
                                      });
                                    },
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Color.fromRGBO(5, 54, 90, 1),
                                            height: 1.5),
                                    decoration: decoration.copyWith(
                                        hintText: 'Enter Email Address',
                                        fillColor: emailValidate &&
                                                nameValidate &&
                                                passValidate
                                            ? Color.fromRGBO(196, 221, 252, 0.5)
                                            : decoration.fillColor),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (val) {
                                      return EmailValidator.validate(
                                              val.trimRight())
                                          ? null
                                          : '';
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    onChanged: (val) {
                                      password = val;
                                      setState(() {
                                        if (val.length > 5)
                                          passValidate = true;
                                        else
                                          passValidate = false;
                                      });
                                    },
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Color.fromRGBO(5, 54, 90, 1),
                                            height: 1.5),
                                    obscureText: _hidePassword,
                                    focusNode: _passwordFocusNode,
                                    toolbarOptions: ToolbarOptions(
                                        copy: false, cut: false, paste: true),
                                    decoration: decoration.copyWith(
                                        hintText: 'Enter your Password',
                                        fillColor: emailValidate &&
                                                nameValidate &&
                                                passValidate
                                            ? Color.fromRGBO(196, 221, 252, 0.5)
                                            : decoration.fillColor,
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _hidePassword
                                                  ? FontAwesomeIcons.eyeSlash
                                                  : FontAwesomeIcons.eye,
                                              size: 16,
                                              color:
                                                  Color.fromRGBO(5, 54, 90, 1),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _hidePassword = !_hidePassword;
                                              });
                                            })),
                                    validator: (val) {
                                      if (val.trim().length < 6)
                                        return '';
                                      else
                                        return null;
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                  SizedBox(height: showError ? 15 : 20),
                                  if (showError)
                                    Container(
                                      height: 30,
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        error,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  FlatButton(
                                    onPressed: showLoader
                                        ? null
                                        : () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              if (!FocusScope.of(context)
                                                      .hasPrimaryFocus &&
                                                  FocusScope.of(context)
                                                          .focusedChild !=
                                                      null) {
                                                FocusScope.of(context)
                                                    .focusedChild
                                                    .unfocus();
                                              }
                                              setState(() {
                                                showError = false;
                                                showLoader = true;
                                                error = '';
                                              });
                                              dynamic result =
                                                  await _auth.createAccount(
                                                      name:
                                                          formatUserName(name),
                                                      email: email,
                                                      password: password);
                                              if (result == null) {
                                                setState(() {
                                                  error = _auth.error;
                                                  showLoader = false;
                                                  showError = true;
                                                });
                                              }
                                              if (result != null) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VerifyNumber()));
                                              }
                                            }
                                          },
                                    disabledColor:
                                        Color.fromRGBO(57, 138, 239, 0.3),
                                    minWidth: double.infinity,
                                    child: showLoader
                                        ? SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator())
                                        : Text('Create Account',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                    color: Color.fromRGBO(57, 138, 239, 1),
                                    height: 48,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  Container(
                                    height: 70,
                                    alignment: Alignment(0, 0.2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Already have an account?'),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Login()));
                                            },
                                            child: Container(
                                                child: Text(
                                              'Login',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                      color: Color.fromRGBO(
                                                          57, 138, 239, 1)),
                                            ))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
