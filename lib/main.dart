import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/router/task_router.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/tasks/repository/task_repository.dart';
import 'package:task_manager/features/tasks/task_cubit.dart';
import 'package:task_manager/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now().hour;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => TaskCubit(TaskRepository(
            auth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          )),
        ),
      ],
      child: DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? dark) {
        ColorScheme lightColorSchem;
        ColorScheme darkColorSchem;
        const baseColor = Color.fromARGB(181, 5, 173, 56);
        if (lightDynamic != null && dark != null) {
          lightColorSchem = lightDynamic.harmonized()..copyWith();
          lightColorSchem = lightColorSchem.copyWith(secondary: baseColor);
          darkColorSchem = dark.harmonized();
        } else {
          lightColorSchem = ColorScheme.fromSeed(seedColor: baseColor);
          darkColorSchem = ColorScheme.fromSeed(seedColor: baseColor, brightness: Brightness.dark);
        }

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: TaskRouter.goRouter,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: 8 <= now && now <= 20 ? lightColorSchem : darkColorSchem,
          ),
        );
      }),
    );
  }
}
