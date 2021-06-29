import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject1/application.dart';
import 'package:flutterproject1/features/network_finding_page/search.dart';
//import 'application.dart';
import 'features/login_page/login.dart';
import 'features/login_page/sign_up.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helper/authenticate.dart';
// Copyright (c) 2017, 2020 rinukkusu, hayribakici. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: Authenticate(),
    ),
  );
}

//MyStatefulWidget()