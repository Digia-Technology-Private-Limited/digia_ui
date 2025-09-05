import '../models/types.dart';
import '../utils/functional_util.dart';
import '../utils/types.dart';

class ScaffoldProps {
  final ExprOr<String>? scaffoldBackgroundColor;
  final ExprOr<bool>? enableSafeArea;
  final ExprOr<bool>? resizeToAvoidBottomInset;
  final JsonLike? body;
  final JsonLike? appBar;
  final JsonLike? drawer;
  final JsonLike? endDrawer;
  final JsonLike? bottomNavigationBar;
  final List<JsonLike>? persistentFooterButtons;

  const ScaffoldProps(
      {this.scaffoldBackgroundColor,
      this.enableSafeArea,
      this.body,
      this.appBar,
      this.drawer,
      this.endDrawer,
      this.bottomNavigationBar,
      this.persistentFooterButtons,
      this.resizeToAvoidBottomInset});

  factory ScaffoldProps.fromJson(JsonLike json) {
    return ScaffoldProps(
      scaffoldBackgroundColor:
          ExprOr.fromJson<String>(json['scaffoldBackgroundColor']),
      enableSafeArea: ExprOr.fromJson<bool>(json['enableSafeArea']),
      body: as$<JsonLike>(json['body']),
      appBar: as$<JsonLike>(json['appBar']),
      drawer: as$<JsonLike>(json['drawer']),
      endDrawer: as$<JsonLike>(json['endDrawer']),
      bottomNavigationBar: as$<JsonLike>(json['bottomNavigationBar']),
      persistentFooterButtons:
          as$<List<dynamic>>(json['persistentFooterButtons'])
              ?.map((e) => as$<JsonLike>(e))
              .where((e) => e != null)
              .cast<JsonLike>()
              .toList(),
      resizeToAvoidBottomInset:
          ExprOr.fromJson<bool>(json['resizeToAvoidBottomInset']),
    );
  }
}
