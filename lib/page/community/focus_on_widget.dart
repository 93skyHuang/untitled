import 'package:untitled/basic/include.dart';
import 'package:untitled/widgets/null_list_widget.dart';

///关注页面
class FocusOnPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusOnPageState();
  }
}

class _FocusOnPageState extends State<FocusOnPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NullListWidget();
  }

  @override
  bool get wantKeepAlive => true;
}
