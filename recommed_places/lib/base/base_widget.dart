import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recommed_places/base/base_model.dart';

class BaseWidget<T extends BaseModel> extends StatefulWidget {
  final T model;
  final  Widget Function(BuildContext, T, Widget) builder;
  final Function(T) onModelReady;
  final Widget child;

  const BaseWidget(
      {Key key, this.model, this.builder, this.onModelReady, this.child})
      : super(key: key);

  @override
  State<BaseWidget<T>> createState() {
    return _BaseWidgetState<T>();
  }
}

class _BaseWidgetState<T extends BaseModel> extends State<BaseWidget<T>> {
  T model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    if (model != null) {
      widget.onModelReady(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
