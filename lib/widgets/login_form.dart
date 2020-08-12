import 'dart:io';

import 'package:firebasechatapp/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String password, String username,
      File image, bool isLogin, BuildContext context) submitFn;

  const LoginForm({Key key, this.submitFn, this.isLoading}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email, _username, _password;
  File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please, pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _email,
        _password,
        _username,
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (!_isLogin) UserImagePicker(imagePickFn: _pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                    ),
                    validator: (value) => value.isEmpty || !value.contains('@')
                        ? 'Please enter a valid email address'
                        : null,
                    onSaved: (value) => _email = value,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) => value.isEmpty || value.length < 4
                          ? 'Please enter at least 4 characters.'
                          : null,
                      onSaved: (value) => _username = value,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) => value.isEmpty || value.length < 7
                        ? 'Password must be at least 7 characters long.'
                        : null,
                    obscureText: true,
                    onSaved: (value) => _password = value,
                  ),
                  SizedBox(height: 12),
                  if (widget.isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!widget.isLoading)
                    RaisedButton(
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'I already have an account',
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
