import 'package:get_it/get_it.dart';
import 'package:neuconnectz_dynea/src/core/network/client/dio_client.dart';
import 'package:neuconnectz_dynea/src/core/services/app_preferences.dart';
import 'package:neuconnectz_dynea/src/core/theme/cubits/theme_cubit.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/data_sources/remote/auth_remote_datasource_impl.dart';
import 'package:neuconnectz_dynea/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:neuconnectz_dynea/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:neuconnectz_dynea/src/features/auth/presentation/cubits/user_cubit.dart';

import '../../features/auth/domain/usecases/index.dart';
import '../../features/auth/presentation/blocs/auth_bloc.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/data/data_sources/remote/plant_warehouse_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/data/repositories/plant_warehouse_repository_impl.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/repositories/plant_warehouse_repository.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/usecases/get_user_plants_usecase.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/domain/usecases/get_user_warehouses_usecase.dart';
import 'package:neuconnectz_dynea/src/shared/inventory/presentation/blocs/plant_warehouse_bloc.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/datasources/remote/grn_list_remote_data_source.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/data/repositories/grn_list_repository_impl.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/repositories/grn_list_repository.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/domain/usecases/get_grn_list_usecase.dart';
import 'package:neuconnectz_dynea/src/features/core/good_receipt_note/presentation/blocs/grn_bloc.dart';

part 'di_container.dart';
