import 'package:untitled/basic/include.dart';
import 'package:untitled/widgets/null_list_widget.dart';

///关注页面
class FocusOnWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FocusOnWidgetState();
  }
}

class _FocusOnWidgetState extends State<FocusOnWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NullListWidget();
  }

  @override
  bool get wantKeepAlive => true;
}
