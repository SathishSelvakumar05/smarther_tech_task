part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}
final class ProductSuccess extends ProductState {
final ProductModel data;
ProductSuccess({required this.data});
}
final class ProductLoading extends ProductState {}
final class ProductFailure extends ProductState {
  final String err;
  ProductFailure(this.err);
}
