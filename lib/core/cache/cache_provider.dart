import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'cache_service.dart';

part 'cache_provider.g.dart';

@Riverpod(keepAlive: true)
CacheService cacheService(Ref ref) {
  return CacheService();
}
