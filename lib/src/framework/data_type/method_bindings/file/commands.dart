import '../../adapted_types/file.dart';
import '../base.dart';

class FileSetNullCommand implements MethodCommand<AdaptedFile> {
  @override
  void run(AdaptedFile instance, Map<String, Object?> args) {
    instance.setDataFromAdaptedFile(AdaptedFile());
  }
}
