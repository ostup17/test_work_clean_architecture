import 'package:architecture/core/platform/network_info.dart';
import 'package:architecture/features/data/datasources/best_seller_local_data_sources.dart';
import 'package:architecture/features/data/datasources/best_seller_remote_data_sources.dart';
import 'package:architecture/features/data/datasources/cart_local_data_sources.dart';
import 'package:architecture/features/data/datasources/cart_remote_data_sources.dart';
import 'package:architecture/features/data/datasources/details_local_data_sources.dart';
import 'package:architecture/features/data/datasources/details_remote_data_sources.dart';
import 'package:architecture/features/data/datasources/hot_sales_local_data_sources.dart';
import 'package:architecture/features/data/datasources/hot_sales_remote_data_sources.dart';
import 'package:architecture/features/data/repositories/best_seller_repository_impl.dart';
import 'package:architecture/features/data/repositories/cart_repository.dart';
import 'package:architecture/features/data/repositories/details_repository.dart';
import 'package:architecture/features/data/repositories/hot_sales_repostory_impl.dart';
import 'package:architecture/features/domain/repositories/best_seller_repository.dart';
import 'package:architecture/features/domain/repositories/cart_repository.dart';
import 'package:architecture/features/domain/repositories/details_repository.dart';
import 'package:architecture/features/domain/repositories/hot_sales_repository.dart';
import 'package:architecture/features/domain/usecases/get_all_cart.dart';
import 'package:architecture/features/domain/usecases/get_all_details.dart';
import 'package:architecture/features/domain/usecases/get_all_hot_sales.dart';
import 'package:architecture/features/domain/usecases/get_best_seller.dart';
import 'package:architecture/features/presentation/cubit/cart_list_cubit.dart';
import 'package:architecture/features/presentation/cubit/details_list_cubit.dart';
import 'package:architecture/features/presentation/cubit/hot_sales_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/presentation/cubit/best_seller_list_cubit.dart';

final sl = GetIt.instance;

//registration
Future<void> init() async {
  //Cubit
  
  sl.registerFactory(() => HotSalesCubit(getAllHotSales: sl()));
  sl.registerFactory(() => BestSellerCubit(getBestSeller: sl()));
  sl.registerFactory(() => DetailsCubit(getAllDetails: sl()));
  sl.registerFactory(() => CartCubit(getAllCart: sl()));


  //UseCases
  
  sl.registerLazySingleton(() => GetAllHotSales(sl()));
  sl.registerLazySingleton(() => GetAllBestSeller(sl()));
  sl.registerLazySingleton(() => GetAllDetails(sl()));
  sl.registerLazySingleton(() => GetAllCart(sl()));

  //Repository
  sl.registerLazySingleton<HotSalesRepository>(() => HotSalesRepositoryImpl(
      networkInfo: sl(),
      localDataSources: sl(),
      remoteDataSource: sl()
  ));
  sl.registerLazySingleton<BestSellerRepository>(() => BestSellerRepositoryImpl(
      networkInfo: sl(),
      localDataSources: sl(),
      remoteDataSources: sl()
  ));
  sl.registerLazySingleton<DetailsRepository>(() => DetailsRepositoryImpl(
      networkInfo: sl(),
      detailsLocalDataSources: sl(),
      detailsRemoteDataSource: sl()

  ));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(
      networkInfo: sl(),
      localDataSources: sl(),
      remoteDataSource: sl()

  ));
  
  sl.registerLazySingleton<HotSalesRemoteDataSurce>(() => HotSalesRemoteDataSourceImpl(
      client: http.Client(),
  ));
  sl.registerLazySingleton<BestSellerRemoteDataSources>(() => BestSellerRemoteDataSourcesImpl(
    client: http.Client(),
  ));
  sl.registerLazySingleton<DetailsRemoteDataSorce>(() => DetailsRemoteDataSorceImpl(
    client: http.Client(),
  ));
  sl.registerLazySingleton<CartRemoteDataSource>(() => CartRemoteDataSourceImpl(
    client: http.Client(),
  ));
  
  sl.registerLazySingleton<HotSalesLocalDataSources>(() => HotSalesLocalDataSourceImpl(
      sharedPreferences: sl()
  ));
  sl.registerLazySingleton<BestSellerLocalDataSources>(() => BestSellerLocalDataSourceImpl(
      sharedPreferences: sl()
  ));
  sl.registerLazySingleton<DetailsLocalDataSources>(() => DetailsLocalDataSourcesImpl(
      sharedPreferences: sl()
  ));
  sl.registerLazySingleton<CartLocalDataSources>(() => CartLocalDataSourceImpl(
      sharedPreferences: sl()
  ));
  
  //Core
  
  sl.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(connectionChecker: sl())
  );
  
  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}