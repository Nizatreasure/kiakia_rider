import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:kiakia_rider/decoration.dart';
import 'package:kiakia_rider/services/authentication.dart';

class VerifyNumber extends StatefulWidget {
  @override
  _VerifyNumberState createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  final _formKey = GlobalKey<FormState>();
  String number = '', error = '';
  bool showLoader = false, showError = false, validate = false;
  AuthenticationService _auth = AuthenticationService();

  //queries the database to ensure that a number can also be used to sign up once.
  //returns false if the number exists and true if it doesn't exist in the database
  Future<String> _numberNotUsedByAnotherClient(String num) async {
    List userNumbers = new List();
    try {
      final response = await get('https://www.google.com');
      if (response.statusCode == 200) {
        DataSnapshot snapshot =
        await FirebaseDatabase.instance.reference().child('riders').once();
        DataSnapshot snapshot2 =
        await FirebaseDatabase.instance.reference().child('users').once();
        if (snapshot != null) {
          Map data = snapshot.value;
          data.forEach((key, value) {
            userNumbers.add(value['number']);
          });
        }
        if (snapshot2 != null) {
          Map data = snapshot2.value;
          data.forEach((key, value) {
            userNumbers.add(value['number']);
          });
        }
      }
      return userNumbers.contains('+234' + num) ? 'exists' : 'notExist';
    } catch (e) {
      return 'network-error';
    }
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
                        Spacer(),
                        Container(
                          height: 70,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Enter your Mobile Number',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Color.fromRGBO(5, 25, 51, 1)),
                          ),
                        ),
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            'We will send a code to verify your mobile number',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 60),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            onChanged: (val) {
                              number = val;
                              setState(() {
                                error = '';
                                showError = false;
                                showLoader = false;
                              });
                              if (val.trim().length == 10)
                                FocusScope.of(context).focusedChild.unfocus();
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                            validator: (val) {
                              if (val.trim().length == 10)
                                validate = true;
                              else
                                validate = false;
                              return val.trim().length != 10 ? '' : null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: Color.fromRGBO(5, 54, 90, 1),
                                    letterSpacing: 1,
                                    height: 1.5),
                            decoration: decoration.copyWith(
                              hintText: '9012345678',
                              enabledBorder: error == 'Number already used'
                                  ? decoration.errorBorder
                                  : null,
                              prefixIcon: Container(
                                padding: EdgeInsets.only(top: 17, left: 12),
                                child: Text(
                                  '+234',
                                  style: TextStyle(
                                      color: Color.fromRGBO(5, 54, 90, 1),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ),
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
                          disabledColor: Color.fromRGBO(57, 138, 239, 0.3),
                          onPressed: showLoader || !validate
                              ? null
                              : () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      error = '';
                                      showLoader = true;
                                      showError = false;
                                    });
                                    if (await _numberNotUsedByAnotherClient(
                                            number) ==
                                        'exists') {
                                      setState(() {
                                        showLoader = false;
                                        showError = true;
                                        error = 'Number already used';
                                      });
                                    } else if (await _numberNotUsedByAnotherClient(
                                            number) ==
                                        'notExist') {
                                      await FirebaseDatabase.instance
                                          .reference()
                                          .child('riders')
                                          .child(FirebaseAuth
                                              .instance.currentUser.uid)
                                          .update({'number': '+234$number'});
                                      dynamic result = await _auth.verifyNumber(
                                          number: '+234$number',
                                          context: context,
                                          reload: true);
                                      if (result == null)
                                        setState(() {
                                          showLoader = false;
                                          showError = true;
                                          error = _auth.error;
                                        });
                                      else {
                                        if (mounted) setState(() {
                                          showError = true;
                                          error = _auth.error;
                                          showLoader = false;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        showLoader = false;
                                        showError = true;
                                        error = 'Network error';
                                      });
                                    }
                                  }
                                },
                          minWidth: double.infinity,
                          child: showLoader
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator())
                              : Text('Get OTP',
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
                        Spacer()
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
