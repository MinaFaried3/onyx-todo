import 'core/contracts/platform_file_ops_contract.dart';
import 'core/platform_file_ops_stub.dart'
    if (dart.library.js_interop) 'web/platform_file_ops_web.dart';

PlatformFileOpsContract createPlatformFileOps() => getPlatformFileOps();
