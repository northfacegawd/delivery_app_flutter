import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/product/models/product_model.dart';
import 'package:delivery_app/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider =
    StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>(
  (ref) {
    final repository = ref.watch(productRepositoryProvider);
    return ProductStateNotifier(repository: repository);
  },
);

class ProductStateNotifier
    extends PaginationProvider<ProductModel, ProductRepository> {
  ProductStateNotifier({
    required super.repository,
  });
}
