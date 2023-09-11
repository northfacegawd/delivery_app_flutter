import 'package:delivery_app/common/models/cursor_pagination_model.dart';
import 'package:delivery_app/common/models/model_with_id.dart';
import 'package:delivery_app/common/models/pagination_params.dart';

abstract class IBasePaginationRepository<T extends IModelWithId> {
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}
