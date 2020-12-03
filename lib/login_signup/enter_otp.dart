import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:kiakia_rider/login_signup/verify_number.dart';
import 'package:kiakia_rider/profile/bank_details.dart';
import 'package:kiakia_rider/services/authentication.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOTP extends StatefulWidget {
  final String number, verId;
  EnterOTP({this.number, this.verId});
  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  Timer _timer;
  int _start = 80;
  String otp = '', error = '';
  bool validated = false, showLoader = false, showError = false;
  final _formKey = GlobalKey<FormState>();

  void startTimer() {
    const time = const Duration(seconds: 1);
    _timer = new Timer.periodic(time, (timer) {
      setState(() {
        if (_start < 1)
          timer.cancel();
        else
          _start = _start - 1;
      });
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 500
        ? 500
        : MediaQuery.of(context).size.width;
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Text(
                            'Enter the OTP Sent to ${widget.number}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Color.fromRGBO(5, 25, 51, 1)),
                          ),
                        ),
                        SizedBox(height: 30),
                        Container(
                          child: Form(
                            key: _formKey,
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              onChanged: (val) {
                                otp = val;
                                setState(() {
                                  if (val.length >= 4)
                                    validated = true;
                                  else
                                    validated = false;
                                });
                              },
                              validator: (val) {
                                return val.length < 4 ? '' : null;
                              },
                              cursorColor: Colors.black,
                              textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                              enableActiveFill: true,
                              animationType: AnimationType.none,
                              backgroundColor: Colors.transparent,
                              keyboardType: TextInputType.number,
                              showCursor: false,
                              pinTheme: PinTheme(
                                  borderRadius: BorderRadius.circular(8),
                                  fieldWidth: (width - 84) / 6,
                                  fieldHeight: (width - 84) / 6,
                                  shape: PinCodeFieldShape.box,
                                  inactiveFillColor:
                                      Color.fromRGBO(5, 54, 90, 0.05),
                                  activeFillColor:
                                      Color.fromRGBO(196, 221, 252, 1),
                                  activeColor: Colors.transparent,
                                  inactiveColor: Colors.transparent,
                                  selectedFillColor:
                                      Color.fromRGBO(196, 221, 252, 1),
                                  selectedColor: Colors.transparent),
                            ),
                          ),
                        ),
                        SizedBox(height: showError ? 30 : 60),
                        if (showError)
                          Container(
                            height: 30,
                            alignment: Alignment.topCenter,
                            child: Text(
                              error,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Didn\'t Receive Code?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff515352),
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: _timer.isActive
                                  ? null
                                  : () async {
                                      setState(() {
                                        _start = 80;
                                        startTimer();
                                      });
                                      await AuthenticationService()
                                          .verifyNumber(
                                              number: widget.number,
                                              context: context,
                                              reload: false);
                                    },
                              child: Container(
                                child: _timer.isActive
                                    ? Text(
                                        _start > 69
                                            ? '01:${_start - 60}'
                                            : _start > 59
                                                ? '01:0${_start - 60}'
                                                : _start > 10
                                                    ? '00:$_start'
                                                    : '00:0$_start',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      )
                                    : Text(
                                        'Resend Code',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        FlatButton(
                          onPressed: !validated || showLoader
                              ? null
                              : () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      showLoader = true;
                                      showError = false;
                                    });
                                    String result =
                                        await verifyOTP(otp, widget.verId);
                                    if (result != '') {
                                      setState(() {
                                        showError = true;
                                        showLoader = false;
                                        error = result;
                                      });
                                    } else
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BankDetails()));
                                  }
                                },
                          disabledColor: Color.fromRGBO(57, 138, 239, 0.3),
                          minWidth: double.infinity,
                          child: showLoader
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator())
                              : Text('Verify',
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
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton(
                                splashColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerifyNumber()));
                                },
                                child: Text(
                                  'Change Number',
                                  style: TextStyle(color: Colors.blue),
                                ))),
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

Future<String> verifyOTP(otp, verId) async {
  String otpError;
  //creates a credential for the user using the otp code inputted
  PhoneAuthCredential credential =
      PhoneAuthProvider.credential(verificationId: verId, smsCode: otp);
  //links the number entered by the user to their current email.
  // it displays an error message if the operation was not successful
  try {
    await FirebaseAuth.instance.currentUser.linkWithCredential(credential);
    await FirebaseDatabase.instance
        .reference()
        .child('riders')
        .child(FirebaseAuth.instance.currentUser.uid)
        .update({'isNumberVerified': true});
    return '';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'credential-already-in-use') {
      otpError = 'This number is already associated with another user account';
    } else if (e.code == 'invalid-verification-code') {
      otpError = 'Invalid verification code';
    } else if (e.message ==
        'com.google.firebase.FirebaseException: User has already been linked to the given provider.') {
      otpError = 'A number has already been linked with this account';
    } else
      otpError = 'An error occurred';

    return otpError;
  }
}
