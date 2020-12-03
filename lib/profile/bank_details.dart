import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:kiakia_rider/decoration.dart';
import 'package:kiakia_rider/drawer/drawer.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class BankDetails extends StatefulWidget {
  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  List<Banks> banks = [
    Banks(name: 'Access Bank', code: '044'),
    Banks(name: 'Afribank', code: '0141'),
    Banks(name: 'BankPhb', code: '082'),
    Banks(name: 'Citibank', code: '023'),
    Banks(name: 'Diamond Bank', code: '063'),
    Banks(name: 'Ecobank', code: '050'),
    Banks(name: 'Equitorial Trust Bank', code: '040'),
    Banks(name: 'First Bank', code: '011'),
    Banks(name: 'FCMB', code: '214'),
    Banks(name: 'Fidelity Bank', code: '070'),
    Banks(name: 'FinBank', code: '085'),
    Banks(name: 'Guaranty Trust Bank', code: '058'),
    Banks(name: 'Intercontinental Bank', code: '069'),
    Banks(name: 'Oceanic Bank', code: '056'),
    Banks(name: 'Sky Bank', code: '076'),
    Banks(name: 'SpringBank', code: '084'),
    Banks(name: 'StanbicIBTC', code: '221'),
    Banks(name: 'Standard Chartered Bank', code: '068'),
    Banks(name: 'Sterling Bank', code: '232'),
    Banks(name: 'United Bank for Africa', code: '033'),
    Banks(name: 'Union Bank', code: '032'),
    Banks(name: 'Unity Bank', code: '215'),
    Banks(name: 'Wema Bank', code: '035'),
    Banks(name: 'Zenith Bank', code: '057')
  ];
  Banks selectedBank;
  TextEditingController _accountNameController;
  TextEditingController _accountNumberController;
  final _formKey = GlobalKey<FormState>();
  FocusNode _accountNumberFocusNode;
  bool verifying = false;
  String verified = '';

  void getAccountName(account, String code) async {
    try {
      Response response = await get(
        'https://api.paystack.co/bank/resolve?account_number=$account&bank_code=$code',
        headers: {
          'Authorization':
              'Bearer sk_test_ebbb8d50536539e37a02f4b9a3aac9356bb5d42f'
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result['status'] == true) {
          setState(() {
            verifying = false;
            verified = 'true';
            _accountNameController.text = result['data']['account_name'];
          });
        } else
          setState(() {
            verified = 'false';
            verifying = false;
          });
      } else
        setState(() {
          verified = 'false';
          verifying = false;
        });
    } catch (e) {
      print('error: $e');
      setState(() {
        verified = 'false';
        verifying = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _accountNameController = new TextEditingController();
    _accountNameController.addListener(() {});
    _accountNumberController = new TextEditingController();
    _accountNumberController.addListener(() {});
    _accountNumberFocusNode = new FocusNode();
    _accountNumberFocusNode.addListener(() {});
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    _accountNumberFocusNode.dispose();
    _accountNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
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
                        Spacer(
                          flex: 2,
                        ),
                        Container(
                          height: 70,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            'Bank Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: Color.fromRGBO(5, 25, 51, 1)),
                          ),
                        ),
                        Container(
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            'Add your bank details to receive payments',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Spacer(),
                        DropdownButtonFormField(
                            hint: Text(
                              'Select Bank Name',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            decoration: decoration.copyWith(
                                fillColor: selectedBank == null
                                    ? decoration.fillColor
                                    : Color.fromRGBO(196, 221, 252, 0.5)),
                            style: Theme.of(context).textTheme.bodyText1,
                            icon: Icon(FontAwesomeIcons.angleDown,
                                color: Color.fromRGBO(5, 54, 90, 0.3)),
                            items: banks.map((bank) {
                              return DropdownMenuItem(
                                child: Text(bank.name),
                                value: bank,
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (selectedBank != val)
                                setState(() {
                                  _accountNumberController.text = '';
                                  _accountNameController.text = '';
                                  verified = '';
                                  verifying = false;
                                });
                              selectedBank = val;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            focusNode: _accountNumberFocusNode,
                            controller: _accountNumberController,
                            decoration: decoration.copyWith(
                                hintText: 'Enter Account Number',
                                enabledBorder: verified == 'false'
                                    ? decoration.errorBorder
                                    : verifying
                                        ? decoration.focusedBorder
                                        : null,
                                focusedBorder: verified == 'false'
                                    ? decoration.errorBorder
                                    : decoration.focusedBorder,
                                fillColor: verified != 'true'
                                    ? decoration.fillColor
                                    : Color.fromRGBO(196, 221, 252, 0.5)),
                            onChanged: (val) {
                              setState(() {
                                _accountNameController.text = '';
                                verifying = false;
                                verified = '';
                              });
                              if (val.length == 10) {
                                _accountNumberFocusNode.unfocus();
                                if (selectedBank != null) {
                                  setState(() {
                                    verifying = true;
                                  });
                                  getAccountName(_accountNumberController.text,
                                      selectedBank.code);
                                }
                              }
                            },
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              return val.length != 10 ? '' : null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10)
                            ],
                          ),
                        ),
                        if (verifying)
                          Row(
                            children: [
                              Spacer(),
                              Text(
                                'Verifying account holder',
                                style: TextStyle(
                                    color: Color.fromRGBO(57, 138, 239, 1)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Loading(
                                indicator: BallPulseIndicator(),
                                size: 20,
                                color: Color.fromRGBO(57, 138, 239, 1),
                              ),
                            ],
                          ),
                        if (verified == 'false')
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Couldn\'t verify account',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        if (_accountNameController.text != null &&
                            _accountNameController.text.isNotEmpty &&
                            verified == 'true')
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              decoration: decoration.copyWith(
                                  fillColor:
                                      Color.fromRGBO(196, 221, 252, 0.5)),
                              readOnly: true,
                              controller: _accountNameController,
                            ),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        FlatButton(
                            height: 48,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Color.fromRGBO(57, 138, 239, 1),
                            disabledColor: Color.fromRGBO(57, 138, 239, 0.3),
                            minWidth: double.infinity,
                            onPressed: _accountNameController.text != null &&
                                    _accountNameController.text.isNotEmpty
                                ? () {}
                                : null,
                            child: Text(
                              'Save',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                            )),
                        Spacer(
                          flex: 2,
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

class Banks {
  String name, code;
  Banks({@required this.name, @required this.code});
}
