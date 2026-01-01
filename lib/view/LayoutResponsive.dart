import 'package:flutter/cupertino.dart';

class LayoutResponsive extends StatelessWidget {
  final Widget mobileWidget;
  final Widget webWidget;
  const LayoutResponsive({super.key,required this.mobileWidget,required this.webWidget});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth<600){
        return mobileWidget;
      }
      else{
        return webWidget;
      }


    });
  }
}