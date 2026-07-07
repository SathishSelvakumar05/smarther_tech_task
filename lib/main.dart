import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarther_tech_task/view/product_screen.dart';
import 'package:smarther_tech_task/viewmodel/connectivity_cubit.dart';
import 'package:smarther_tech_task/viewmodel/product_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
BlocProvider(create: (context) => ProductCubit(),),
BlocProvider(create: (context) => ConnectivityCubit()..init(),),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
        
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        builder: (context, child) {
         return ConnectivityScreen(child: child??SizedBox(),);
         },
        home: const ProductScreen(),
      ),
    );
  }
}

class ConnectivityScreen extends StatefulWidget {
  final Widget child;
  const ConnectivityScreen({required this.child ,super.key});

  @override
  State<ConnectivityScreen> createState() => _ConnectivityScreenState();
}

class _ConnectivityScreenState extends State<ConnectivityScreen> {
  String? prvStatus;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityCubit,ConnectivityState>(
      listener: (context, state) {
      if(state.status==true){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Internet connected",style: TextStyle(color: Colors.green),)));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No internet connection",style: TextStyle(color: Colors.red),)));
      }


    },
    child: widget.child,
    );
  }
}

