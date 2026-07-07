import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../model/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final Dio dio=Dio(BaseOptions(baseUrl: "https://dummyjson.com",connectTimeout: Duration(seconds: 20))
  );
  ProductCubit() : super(ProductInitial());

  Future<void>fetchAPI()async{
    try{
      emit(ProductLoading());
      final response=await dio.get("/products");
      print("succ ${response.data.toString()}");
      final data=response.data;
      final product=ProductModel.fromJson(data as Map<String,dynamic>);
      emit(ProductSuccess(data: product));

    }catch(e){
      print(e.toString());
      emit(ProductFailure(e.toString()));
    }

}
  void search(String data){

  }
}
